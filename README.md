
# osqueryr

‘osquery’ ‘DBI’ and ‘dbplyr’ Interface for R

## WIP WIP WIP

Not everything works.

NOTE: You need to install `osquery` for this to work.

Read <https://osquery.readthedocs.io/en/stable/> before proceeding.

## Description

‘osquery’ <https://osquery.readthedocs.io/en/stable/> is an operating
system instrumentation framework for ‘Windows’, ‘OS X (macOS)’, ‘Linux’,
and ‘FreeBSD’. The tools make low-level operating system analytics and
monitoring both performant and intuitive. A full ‘dbplyr’-compliant
‘DBI’-driver interface is provided facilitating intuitive and tidy
analytic idioms.

## What’s Inside The Tin

The following functions are implemented:

## Installation

``` r
devtools::install_github("hrbrmstr/osqueryr")
```

## Usage

``` r
library(osqueryr)
library(tidyverse)

# current verison
packageVersion("osqueryr")
```

    ## [1] '0.1.0'

``` r
osqdb <- src_dbi(osqueryr::dbConnect(Osquery()))

osqdb
```

    ## src:  OsqueryConnection
    ## tbls: account_policy_data, acpi_tables, ad_config, alf, alf_exceptions, alf_explicit_auths, alf_services, app_schemes,
    ##   apps, apt_sources, arp_cache, asl, augeas, authorization_mechanisms, authorizations, authorized_keys, block_devices,
    ##   browser_plugins, carbon_black_info, carves, certificates, chrome_extensions, cpu_time, cpuid, crashes, crontab, curl,
    ##   curl_certificate, device_file, device_firmware, device_hash, device_partitions, disk_encryption, disk_events,
    ##   dns_resolvers, docker_container_labels, docker_container_mounts, docker_container_networks, docker_container_ports,
    ##   docker_container_processes, docker_container_stats, docker_containers, docker_image_labels, docker_images,
    ##   docker_info, docker_network_labels, docker_networks, docker_version, docker_volume_labels, docker_volumes, etc_hosts,
    ##   etc_protocols, etc_services, event_taps, extended_attributes, fan_speed_sensors, file, file_events, firefox_addons,
    ##   gatekeeper, gatekeeper_approved_apps, groups, hardware_events, hash, homebrew_packages, interface_addresses,
    ##   interface_details, iokit_devicetree, iokit_registry, kernel_extensions, kernel_info, kernel_panics, keychain_acls,
    ##   keychain_items, known_hosts, last, launchd, launchd_overrides, listening_ports, lldp_neighbors, load_average,
    ##   logged_in_users, magic, managed_policies, mounts, nfs_shares, nvram, opera_extensions, os_version, osquery_events,
    ##   osquery_extensions, osquery_flags, osquery_info, osquery_packs, osquery_registry, osquery_schedule, package_bom,
    ##   package_install_history, package_receipts, pci_devices, platform_info, plist, power_sensors, preferences,
    ##   process_envs, process_events, process_memory_map, process_open_files, process_open_sockets, processes,
    ##   prometheus_metrics, python_packages, quicklook_cache, routes, safari_extensions, sandboxes, shared_folders,
    ##   sharing_preferences, shell_history, signature, sip_config, smbios_tables, smc_keys, startup_items, sudoers, suid_bin,
    ##   system_controls, system_info, temperature_sensors, time, time_machine_backups, time_machine_destinations, uptime,
    ##   usb_devices, user_events, user_groups, user_interaction_events, user_ssh_keys, users, virtual_memory_info,
    ##   wifi_networks, wifi_status, wifi_survey, xprotect_entries, xprotect_meta, xprotect_reports, yara, yara_events,
    ##   yum_sources

``` r
tbl(osqdb, "dns_resolvers")
```

    ## # Source:   table<dns_resolvers> [?? x 5]
    ## # Database: OsqueryConnection
    ##   address id    netmask options type      
    ##   <chr>   <chr> <chr>   <chr>   <chr>     
    ## 1 9.9.9.9 0     32      1729    nameserver
    ## 2 1.1.1.1 1     32      1729    nameserver
    ## 3 rud.is  0     ""      1729    search

``` r
glimpse(tbl(osqdb, "osquery_info"))
```

    ## Observations: ??
    ## Variables: 11
    ## $ build_distro   <chr> "10.12"
    ## $ build_platform <chr> "darwin"
    ## $ config_hash    <chr> ""
    ## $ config_valid   <chr> "0"
    ## $ extensions     <chr> "inactive"
    ## $ instance_id    <chr> "11aa67c3-ab12-4e8d-aa2f-93d366cc7c1e"
    ## $ pid            <chr> "66142"
    ## $ start_time     <chr> "1527281377"
    ## $ uuid           <chr> "3A087DAC-6414-5FA9-9E10-42EE9CED7C25"
    ## $ version        <chr> "3.2.4"
    ## $ watcher        <chr> "-1"

``` r
tbl(osqdb, "processes") %>% 
  filter(name %like% '%fire%') %>% 
  glimpse()
```

    ## Observations: ??
    ## Variables: 26
    ## $ cmdline            <chr> "/Applications/FirefoxDeveloperEdition.app/Contents/MacOS/firefox -foreground"
    ## $ cwd                <chr> "/"
    ## $ disk_bytes_read    <chr> "531906560"
    ## $ disk_bytes_written <chr> "7964819456"
    ## $ egid               <chr> "20"
    ## $ euid               <chr> "502"
    ## $ gid                <chr> "20"
    ## $ name               <chr> "firefox"
    ## $ nice               <chr> "0"
    ## $ on_disk            <chr> "1"
    ## $ parent             <chr> "1"
    ## $ path               <chr> "/Applications/FirefoxDeveloperEdition.app/Contents/MacOS/firefox"
    ## $ pgroup             <chr> "72338"
    ## $ pid                <chr> "72338"
    ## $ resident_size      <chr> "1341915136"
    ## $ root               <chr> ""
    ## $ sgid               <chr> "20"
    ## $ start_time         <chr> "355188"
    ## $ state              <chr> "R"
    ## $ suid               <chr> "502"
    ## $ system_time        <chr> "838119"
    ## $ threads            <chr> "85"
    ## $ total_size         <chr> "998281216"
    ## $ uid                <chr> "502"
    ## $ user_time          <chr> "1978636"
    ## $ wired_size         <chr> "0"
