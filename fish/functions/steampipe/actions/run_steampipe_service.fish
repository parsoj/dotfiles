function run_steampipe_service
    steampipe service stop
    steampipe service start --database-password pwd
end
