
# osqueryr

‘osquery’ ‘DBI’ and ‘dbplyr’ Interface for R

## WIP WIP WIP

But, so far it seems to work pretty well.

NOTE: You need to install `osquery` for this to work.

Read <https://osquery.readthedocs.io/en/stable/> before proceeding.

## HEY\!

One of the super cool things abt `osquery` is that it works on every
major platform so you can use this package to normalize OS-level queries
for anything that you may have wanted to do before but didn’t feel like
doing b/c you had to handle so many OS foibles.

## Description

‘osquery’ <https://osquery.readthedocs.io/en/stable/> is an operating
system instrumentation framework for ‘Windows’, ‘OS X (macOS)’, ‘Linux’,
and ‘FreeBSD’. The tools make low-level operating system analytics and
monitoring both performant and intuitive. A full ‘dbplyr’-compliant
‘DBI’-driver interface is provided facilitating intuitive and tidy
analytic idioms.

## What's Inside The Tin

_Pretty much what you'd expect for `DBI` and `dbplyr`_ plus:

The following functions are implemented:

- `osq_fs_logs`:	List all the logs on our local system
- `osq_expose_tables`:	Return all (or selected) local or remote osquery tables as a named list of `dbplyr` tibbles
- `osq_load_tables`:	Return all (or selected) local or remote osquery tables as a named list of `dbplyr` tibbles

## TODO (y'all are encouraged to contribute)

- <strike>finish DBI driver</strike>
- smart(er) type conversion
- tests
- vignette(s)

## Installation

``` r
devtools::install_github("hrbrmstr/osqueryr")
```

## Usage

``` r
library(osqueryr)
library(tidyverse)
library(knitr)

# current verison
packageVersion("osqueryr")
```

    ## [1] '0.1.0'

### osquery info

``` r
osqdb <- src_dbi(osqueryr::dbConnect(Osquery()))

glimpse(tbl(osqdb, "osquery_info"))
```

    ## Observations: ??
    ## Variables: 11
    ## $ build_distro   <chr> "10.12"
    ## $ build_platform <chr> "darwin"
    ## $ config_hash    <chr> ""
    ## $ config_valid   <chr> "0"
    ## $ extensions     <chr> "inactive"
    ## $ instance_id    <chr> "0bda930c-43ad-48cc-a324-23ca614aaa00"
    ## $ pid            <chr> "45863"
    ## $ start_time     <chr> "1527364673"
    ## $ uuid           <chr> "709F311C-B34D-5CF4-A111-91C8AA4E079B"
    ## $ version        <chr> "3.2.4"
    ## $ watcher        <chr> "-1"

This can work with remote hosts, too:

``` r
con <- osqueryr::dbConnect(Osquery())
con
```

    ## <OsqueryConnection>

``` r
local_db <- src_dbi(con)
local_db
```

    ## NULL
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
osq1_con <- osqueryr::dbConnect(Osquery(), host = "hrbrmstr@osq1")
osq1_con
```

    ## <OsqueryConnection>
    ## <ssh session>
    ## connected: hrbrmstr@osq1:22
    ## server: 37:92:1c:e3:a5:4a:e8:6f:dc:e7:86:00:16:3a:46:5b:b4:9f:df:f1

``` r
osq1_db <- src_dbi(osq1_con)
osq1_db
```

    ## <ssh session>
    ## connected: hrbrmstr@osq1:22
    ## server: 37:92:1c:e3:a5:4a:e8:6f:dc:e7:86:00:16:3a:46:5b:b4:9f:df:f1
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
osq2_con <- osqueryr::dbConnect(Osquery(), host = "bob@osq2", osquery_remote_path = "/usr/bin")
osq2_con
```

    ## <OsqueryConnection>
    ## <ssh session>
    ## connected: bob@osq2:22
    ## server: f4:b6:c1:28:28:7d:d0:03:92:a3:a5:fe:c3:40:e3:7d:8c:db:71:1a

``` r
osq2_db <- src_dbi(osq2_con)
osq2_db
```

    ## <ssh session>
    ## connected: bob@osq2:22
    ## server: f4:b6:c1:28:28:7d:d0:03:92:a3:a5:fe:c3:40:e3:7d:8c:db:71:1a
    ## src:  OsqueryConnection
    ## tbls: acpi_tables, apt_sources, arp_cache, augeas, authorized_keys, block_devices, carbon_black_info, carves,
    ##   chrome_extensions, cpu_time, cpuid, crontab, curl, curl_certificate, deb_packages, device_file, device_hash,
    ##   device_partitions, disk_encryption, dns_resolvers, docker_container_labels, docker_container_mounts,
    ##   docker_container_networks, docker_container_ports, docker_container_processes, docker_container_stats,
    ##   docker_containers, docker_image_labels, docker_images, docker_info, docker_network_labels, docker_networks,
    ##   docker_version, docker_volume_labels, docker_volumes, ec2_instance_metadata, ec2_instance_tags, etc_hosts,
    ##   etc_protocols, etc_services, file, file_events, firefox_addons, groups, hardware_events, hash, intel_me_info,
    ##   interface_addresses, interface_details, iptables, kernel_info, kernel_integrity, kernel_modules, known_hosts, last,
    ##   listening_ports, lldp_neighbors, load_average, logged_in_users, magic, md_devices, md_drives, md_personalities,
    ##   memory_devices, memory_info, memory_map, mounts, msr, npm_packages, opera_extensions, os_version, osquery_events,
    ##   osquery_extensions, osquery_flags, osquery_info, osquery_packs, osquery_registry, osquery_schedule, pci_devices,
    ##   platform_info, portage_keywords, portage_packages, portage_use, process_envs, process_events, process_file_events,
    ##   process_memory_map, process_open_files, process_open_sockets, processes, prometheus_metrics, python_packages, routes,
    ##   rpm_package_files, rpm_packages, shadow, shared_memory, shell_history, smbios_tables, socket_events, sudoers,
    ##   suid_bin, syslog_events, system_controls, system_info, time, uptime, usb_devices, user_events, user_groups,
    ##   user_ssh_keys, users, yara, yara_events, yum_sources

### available tables

``` r
osqdb
```

    ## NULL
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

### sample table

``` r
tbl(osqdb, "dns_resolvers")
```

    ## NULL
    ## # Source:   table<dns_resolvers> [?? x 5]
    ## # Database: OsqueryConnection
    ##   address             id    netmask options type      
    ##   <chr>               <chr> <chr>   <chr>   <chr>     
    ## 1 ""                  0     32      1729    nameserver
    ## 2 ""                  1     32      1729    nameserver
    ## 3 9.9.9.9             2     32      1729    nameserver
    ## 4 hsd1.nh.comcast.net 0     ""      1729    search    
    ## 5 hsd1.nh.comcast.net 1     ""      1729    search

### check out processes

``` r
procs <- tbl(osqdb, "processes")

filter(procs, cmdline != "") %>% 
  select(cmdline, total_size)
```

    ## NULL
    ## # Source:   lazy query [?? x 2]
    ## # Database: OsqueryConnection
    ##    cmdline                                                                         total_size
    ##    <chr>                                                                           <chr>     
    ##  1 /System/Library/CoreServices/loginwindow.app/Contents/MacOS/loginwindow console 45940736  
    ##  2 /usr/sbin/cfprefsd agent                                                        4009984   
    ##  3 /usr/libexec/UserEventAgent (Aqua)                                              6242304   
    ##  4 /usr/sbin/distnoted agent                                                       16588800  
    ##  5 /System/Library/CoreServices/ControlStrip.app/Contents/MacOS/TouchBarAgent      3379200   
    ##  6 /usr/libexec/lsd                                                                18866176  
    ##  7 /System/Library/Frameworks/CoreTelephony.framework/Support/CommCenter -L        7561216   
    ##  8 /usr/libexec/trustd --agent                                                     13250560  
    ##  9 /usr/libexec/languageassetd --firstLogin                                        7131136   
    ## 10 /usr/libexec/secinitd                                                           14454784  
    ## # ... with more rows

``` r
filter(procs, name %like% '%fire%') %>% 
  glimpse()
```

    ## Observations: ??
    ## Variables: 26
    ## $ cmdline            <chr> "/usr/libexec/ApplicationFirewall/Firewall", "/Applications/FirefoxDeveloperEdition.app/...
    ## $ cwd                <chr> "/", "/"
    ## $ disk_bytes_read    <chr> "8192", "261332992"
    ## $ disk_bytes_written <chr> "0", "1746137088"
    ## $ egid               <chr> "20", "20"
    ## $ euid               <chr> "501", "501"
    ## $ gid                <chr> "20", "20"
    ## $ name               <chr> "Firewall", "firefox"
    ## $ nice               <chr> "0", "0"
    ## $ on_disk            <chr> "1", "1"
    ## $ parent             <chr> "1", "1"
    ## $ path               <chr> "/usr/libexec/ApplicationFirewall/Firewall", "/Applications/FirefoxDeveloperEdition.app/...
    ## $ pgroup             <chr> "28329", "39010"
    ## $ pid                <chr> "28329", "39010"
    ## $ resident_size      <chr> "32768", "1188757504"
    ## $ root               <chr> "", ""
    ## $ sgid               <chr> "20", "20"
    ## $ start_time         <chr> "1089108", "1216586"
    ## $ state              <chr> "R", "R"
    ## $ suid               <chr> "501", "501"
    ## $ system_time        <chr> "3", "289281"
    ## $ threads            <chr> "2", "65"
    ## $ total_size         <chr> "647168", "1064378368"
    ## $ uid                <chr> "501", "501"
    ## $ user_time          <chr> "6", "768714"
    ## $ wired_size         <chr> "0", "0"

see if any processes have no corresponding disk image

``` r
filter(procs, on_disk == 0) %>% 
  select(name, path, pid)
```

    ## NULL
    ## # Source:   lazy query [?? x 3]
    ## # Database: OsqueryConnection

(gosh I hope ^^ was empty)

top 10 largest processes by resident memory size

``` r
arrange(procs, desc(resident_size)) %>% 
  select(pid, name, uid, resident_size)
```

    ## NULL
    ## # Source:     lazy query [?? x 4]
    ## # Database:   OsqueryConnection
    ## # Ordered by: desc(resident_size)
    ##    name                  pid   resident_size uid  
    ##    <chr>                 <chr> <chr>         <chr>
    ##  1 java                  35914 1434951680    501  
    ##  2 firefox               39010 1188757504    501  
    ##  3 RStudio               42595 745156608     501  
    ##  4 plugin-container      40130 613330944     501  
    ##  5 plugin-container      39014 499740672     501  
    ##  6 plugin-container      42533 304885760     501  
    ##  7 plugin-container      42666 277454848     501  
    ##  8 plugin-container      45069 268763136     501  
    ##  9 Adobe Desktop Service 642   252526592     501  
    ## 10 Messages              43128 203517952     501  
    ## # ... with more rows

process count for the top 10 most active processes

``` r
count(procs, name, sort=TRUE)
```

    ## NULL
    ## # Source:     lazy query [?? x 2]
    ## # Database:   OsqueryConnection
    ## # Ordered by: desc(n)
    ##    n     name                                    
    ##    <chr> <chr>                                   
    ##  1 15    MTLCompilerService                      
    ##  2 9     mdworker                                
    ##  3 6     Dropbox                                 
    ##  4 6     ssh                                     
    ##  5 5     plugin-container                        
    ##  6 4     com.apple.CommerceKit.TransactionService
    ##  7 4     distnoted                               
    ##  8 4     trustd                                  
    ##  9 3     ACCFinderSync                           
    ## 10 3     AdobeCRDaemon                           
    ## # ... with more rows

### get all processes listening on a port (join example)

``` r
listen <- tbl(osqdb, "listening_ports")

left_join(procs, listen, by="pid") %>%
  filter(port != "") %>% 
  distinct(name, port, address, pid)
```

    ## NULL
    ## # Source:   lazy query [?? x 4]
    ## # Database: OsqueryConnection
    ##    address   name                                         pid   port 
    ##    <chr>     <chr>                                        <chr> <chr>
    ##  1 ""        2BUA8C4S2C.com.agilebits.onepassword4-helper 476   0    
    ##  2 127.0.0.1 2BUA8C4S2C.com.agilebits.onepassword4-helper 476   6258 
    ##  3 ::1       2BUA8C4S2C.com.agilebits.onepassword4-helper 476   6258 
    ##  4 127.0.0.1 2BUA8C4S2C.com.agilebits.onepassword4-helper 476   6263 
    ##  5 ::1       2BUA8C4S2C.com.agilebits.onepassword4-helper 476   6263 
    ##  6 ""        Adobe CEF Helper                             745   0    
    ##  7 ""        Adobe CEF Helper                             25701 0    
    ##  8 ""        Adobe Desktop Service                        642   0    
    ##  9 127.0.0.1 Adobe Desktop Service                        642   15292
    ## 10 ""        AdobeIPCBroker                               596   0    
    ## # ... with more rows

### get file info

``` r
files <- tbl(osqdb, "file")

filter(files, path == "/etc/hosts") %>% 
  select(filename, size)
```

    ## NULL
    ## # Source:   lazy query [?? x 2]
    ## # Database: OsqueryConnection
    ##   filename size   
    ##   <chr>    <chr>  
    ## 1 hosts    1037548

### users

``` r
tbl(osqdb, "users")
```

    ## NULL
    ## # Source:   table<users> [?? x 10]
    ## # Database: OsqueryConnection
    ##    description          directory        gid   gid_signed shell          uid   uid_signed username     uuid            
    ##    <chr>                <chr>            <chr> <chr>      <chr>          <chr> <chr>      <chr>        <chr>           
    ##  1 Guest User           /Users/Guest     201   201        /bin/bash      201   201        Guest        FFFFEEEE-DDDD-C…
    ##  2 AMaViS Daemon        /var/virusmails  83    83         /usr/bin/false 83    83         _amavisd     FFFFEEEE-DDDD-C…
    ##  3 AppleEvents Daemon   /var/empty       55    55         /usr/bin/false 55    55         _appleevents FFFFEEEE-DDDD-C…
    ##  4 applepay Account     /var/db/applepay 260   260        /usr/bin/false 260   260        _applepay    FFFFEEEE-DDDD-C…
    ##  5 Application Owner    /var/empty       87    87         /usr/bin/false 87    87         _appowner    FFFFEEEE-DDDD-C…
    ##  6 Application Server   /var/empty       79    79         /usr/bin/false 79    79         _appserver   FFFFEEEE-DDDD-C…
    ##  7 Apple Remote Desktop /var/empty       67    67         /usr/bin/false 67    67         _ard         FFFFEEEE-DDDD-C…
    ##  8 Asset Cache Service  /var/empty       235   235        /usr/bin/false 235   235        _assetcache  FFFFEEEE-DDDD-C…
    ##  9 Astris Services      /var/db/astris   245   245        /usr/bin/false 245   245        _astris      FFFFEEEE-DDDD-C…
    ## 10 ATS Server           /var/empty       97    97         /usr/bin/false 97    97         _atsserver   FFFFEEEE-DDDD-C…
    ## # ... with more rows

``` r
tbl(osqdb, "logged_in_users")
```

    ## NULL
    ## # Source:   table<logged_in_users> [?? x 6]
    ## # Database: OsqueryConnection
    ##    host  pid   time       tty     type  user 
    ##    <chr> <chr> <chr>      <chr>   <chr> <chr>
    ##  1 ""    111   1526120904 console user  bob  
    ##  2 ""    40196 1527301872 ttys001 user  bob  
    ##  3 ""    45313 1527364233 ttys002 dead  bob  
    ##  4 ""    36182 1527218774 ttys003 dead  bob  
    ##  5 ""    45379 1527364355 ttys004 dead  bob  
    ##  6 ""    67343 1527010299 ttys005 dead  bob  
    ##  7 ""    4386  1527013112 ttys006 dead  bob  
    ##  8 ""    56171 1527005765 tty??   dead  bob  
    ##  9 ""    16477 1527024957 ttys007 dead  bob  
    ## 10 ""    5013  1527013576 ttys008 dead  bob  
    ## # ... with more rows

### groups

``` r
tbl(osqdb, "groups")
```

    ## NULL
    ## # Source:   table<groups> [?? x 5]
    ## # Database: OsqueryConnection
    ##    gid   gid_signed groupname    
    ##    <chr> <chr>      <chr>        
    ##  1 83    83         _amavisd     
    ##  2 55    55         _appleevents 
    ##  3 260   260        _applepay    
    ##  4 87    87         _appowner    
    ##  5 81    81         _appserveradm
    ##  6 79    79         _appserverusr
    ##  7 33    33         _appstore    
    ##  8 67    67         _ard         
    ##  9 235   235        _assetcache  
    ## 10 245   245        _astris      
    ## # ... with more rows

### homebrew\!

``` r
tbl(osqdb, "homebrew_packages")
```

    ## NULL
    ## # Source:   table<homebrew_packages> [?? x 3]
    ## # Database: OsqueryConnection
    ##    name          path                             version 
    ##    <chr>         <chr>                            <chr>   
    ##  1 adns          /usr/local/Cellar/adns/          1.5.1   
    ##  2 apache-arrow  /usr/local/Cellar/apache-arrow/  0.9.0   
    ##  3 aria2         /usr/local/Cellar/aria2/         1.33.1  
    ##  4 asciinema     /usr/local/Cellar/asciinema/     2.0.0_1 
    ##  5 asciinema2gif /usr/local/Cellar/asciinema2gif/ 0.5     
    ##  6 atk           /usr/local/Cellar/atk/           2.28.1_1
    ##  7 atomicparsley /usr/local/Cellar/atomicparsley/ 0.9.6   
    ##  8 augeas        /usr/local/Cellar/augeas/        1.10.1  
    ##  9 autoconf      /usr/local/Cellar/autoconf/      2.69    
    ## 10 automake      /usr/local/Cellar/automake/      1.16.1  
    ## # ... with more rows

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
