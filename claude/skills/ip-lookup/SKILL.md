---
disable-model-invocation: true
---

# IP Lookup

Look up the origin and ownership of an IP address.

## Instructions

Run the following command via Bash:

```
ip_lookup $ARGUMENTS
```

Present the output to the user in a readable format. Summarize the key findings:
- **AWS**: Whether the IP belongs to an AWS ENI, and if so which instance/VPC
- **WHOIS**: Who owns the IP block (org name, net name, country)
- **Geo**: Physical location and ISP/AS info

If the IP is private (10.x, 172.16-31.x, 192.168.x), note that geolocation is skipped and focus on the AWS lookup results.
