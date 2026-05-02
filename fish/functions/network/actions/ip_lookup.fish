function ip_lookup --description "Look up origin of an IP address (AWS, WHOIS, geo)"
    if test (count $argv) -eq 0; or test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
        echo "Usage: ip_lookup <IP>"
        echo ""
        echo "Looks up an IP address across three sources:"
        echo "  1. AWS ENI (network interface match)"
        echo "  2. WHOIS (ownership / netblock info)"
        echo "  3. Geolocation via ip-api.com"
        return 0
    end

    set -l ip $argv[1]

    # Validate IP format (basic IPv4 check)
    if not string match -qr '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' $ip
        echo "Error: '$ip' does not look like a valid IPv4 address"
        return 1
    end

    # Determine if private IP
    set -l is_private 0
    if string match -qr '^10\.' $ip
        set is_private 1
    else if string match -qr '^172\.(1[6-9]|2[0-9]|3[01])\.' $ip
        set is_private 1
    else if string match -qr '^192\.168\.' $ip
        set is_private 1
    end

    # --- AWS ENI Lookup ---
    echo "--- aws ---"
    if command -q aws
        set -l filter_name
        if test $is_private -eq 1
            set filter_name "addresses.private-ip-address"
        else
            set filter_name "addresses.association.public-ip"
        end

        set -l aws_err (mktemp)
        set -l result (aws ec2 describe-network-interfaces \
            --filters "Name=$filter_name,Values=$ip" \
            --query 'NetworkInterfaces[0]' \
            --output json 2>$aws_err)
        set -l aws_status $status
        set -l err_msg (cat $aws_err)
        rm -f $aws_err

        if test $aws_status -ne 0
            if string match -q '*expired*' "$err_msg"; or string match -q '*credential*' "$err_msg"; or string match -q '*token*' "$err_msg"
                echo "AWS auth error — run 'aws sso login' and retry"
            else if test -n "$err_msg"
                echo "AWS error: $err_msg"
            else
                echo "AWS CLI failed (exit $aws_status)"
            end
        else if test -z "$result"; or test "$result" = "null"
            echo "No matching ENI found"
        else
            set -l eni_id (echo $result | jq -r '.NetworkInterfaceId // "n/a"')
            set -l description (echo $result | jq -r '.Description // "n/a"')
            set -l vpc (echo $result | jq -r '.VpcId // "n/a"')
            set -l subnet (echo $result | jq -r '.SubnetId // "n/a"')
            set -l sg (echo $result | jq -r '[.Groups[].GroupId] | join(", ") // "n/a"')
            set -l instance (echo $result | jq -r '.Attachment.InstanceId // "none"')
            set -l private_ip (echo $result | jq -r '.PrivateIpAddress // "n/a"')

            echo "ENI:         $eni_id"
            echo "Description: $description"
            echo "VPC:         $vpc"
            echo "Subnet:      $subnet"
            echo "Private IP:  $private_ip"
            echo "Instance:    $instance"
            echo "SGs:         $sg"
        end
    else
        echo "(aws CLI not installed, skipping)"
    end

    echo ""

    # --- WHOIS ---
    echo "--- whois ---"
    set -l whois_out (whois $ip 2>/dev/null)
    if test $status -eq 0; and test -n "$whois_out"
        set -l found 0
        set -l fields NetName OrgName OrgId Country NetRange CIDR
        for field in $fields
            set -l val (printf '%s\n' $whois_out | grep -i "^$field:" | head -1 | sed "s/^[^:]*:[[:space:]]*//" | string trim)
            if test -n "$val"
                printf "%-10s %s\n" "$field:" "$val"
                set found 1
            end
        end
        # Fallback: RIPE/APNIC use different field names
        if test $found -eq 0
            set -l alt_fields netname org-name country inetnum descr
            for field in $alt_fields
                set -l val (printf '%s\n' $whois_out | grep -i "^$field:" | head -1 | sed "s/^[^:]*:[[:space:]]*//" | string trim)
                if test -n "$val"
                    printf "%-10s %s\n" "$field:" "$val"
                end
            end
        end
    else
        echo "WHOIS lookup failed"
    end

    echo ""

    # --- Geolocation ---
    echo "--- geo ---"
    if test $is_private -eq 1
        echo "(private IP — skipping geolocation)"
    else
        set -l geo (curl -s "http://ip-api.com/json/$ip" 2>/dev/null)
        if test $status -eq 0; and test -n "$geo"
            set -l status_val (echo $geo | jq -r '.status')
            if test "$status_val" = "success"
                set -l fields country regionName city isp org as reverse
                set -l labels Country Region City ISP Org AS Reverse
                for i in (seq (count $fields))
                    set -l val (echo $geo | jq -r ".$fields[$i] // empty")
                    if test -n "$val"
                        printf "%-10s %s\n" "$labels[$i]:" "$val"
                    end
                end
            else
                set -l msg (echo $geo | jq -r '.message // "unknown error"')
                echo "Geo lookup failed: $msg"
            end
        else
            echo "Geo lookup failed (curl error)"
        end
    end
end
