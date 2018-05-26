
# osqueryr

‘osquery’ ‘DBI’ and ‘dbplyr’ Interface for R

## WIP WIP WIP

But, so far it seems to work pretty well.

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
    ## $ instance_id    <chr> "8893b98b-75e4-4a41-8e1c-76a49a907431"
    ## $ pid            <chr> "77146"
    ## $ start_time     <chr> "1527338257"
    ## $ uuid           <chr> "3A087DAC-6414-5FA9-9E10-42EE9CED7C25"
    ## $ version        <chr> "3.2.4"
    ## $ watcher        <chr> "-1"

### available tables

``` r
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

### sample table

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

### check out processes

``` r
procs <- tbl(osqdb, "processes")

filter(procs, cmdline != "") %>% 
  select(cmdline, total_size)
```

    ## # Source:   lazy query [?? x 2]
    ## # Database: OsqueryConnection
    ##    cmdline                                                                                                   total_size
    ##    <chr>                                                                                                     <chr>     
    ##  1 /System/Library/CoreServices/loginwindow.app/Contents/MacOS/loginwindow console                           74514432  
    ##  2 /System/Library/Frameworks/CoreServices.framework/Frameworks/Metadata.framework/Versions/A/Support/mdwor… 17145856  
    ##  3 /usr/sbin/cfprefsd agent                                                                                  8843264   
    ##  4 /usr/libexec/lsd                                                                                          26931200  
    ##  5 /usr/libexec/trustd --agent                                                                               40603648  
    ##  6 /usr/sbin/distnoted agent                                                                                 13660160  
    ##  7 /usr/libexec/secd                                                                                         26746880  
    ##  8 /usr/libexec/UserEventAgent (Aqua)                                                                        9281536   
    ##  9 /System/Library/Frameworks/CoreTelephony.framework/Support/CommCenter -L                                  8933376   
    ## 10 /usr/libexec/languageassetd --firstLogin                                                                  8474624   
    ## # ... with more rows

``` r
filter(procs, name %like% '%fire%') %>% 
  glimpse()
```

    ## Observations: ??
    ## Variables: 26
    ## $ cmdline            <chr> "/Applications/FirefoxDeveloperEdition.app/Contents/MacOS/firefox -foreground"
    ## $ cwd                <chr> "/"
    ## $ disk_bytes_read    <chr> "658833408"
    ## $ disk_bytes_written <chr> "9126772736"
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
    ## $ resident_size      <chr> "1530167296"
    ## $ root               <chr> ""
    ## $ sgid               <chr> "20"
    ## $ start_time         <chr> "355185"
    ## $ state              <chr> "R"
    ## $ suid               <chr> "502"
    ## $ system_time        <chr> "1007217"
    ## $ threads            <chr> "82"
    ## $ total_size         <chr> "1139310592"
    ## $ uid                <chr> "502"
    ## $ user_time          <chr> "2350535"
    ## $ wired_size         <chr> "0"

see if any processes have no corresponding disk image

``` r
filter(procs, on_disk == 0) %>% 
  select(name, path, pid)
```

    ## # Source:   lazy query [?? x 3]
    ## # Database: OsqueryConnection

(gosh I hope ^^ was empty)

top 10 largest processes by resident memory size

``` r
arrange(procs, desc(resident_size)) %>% 
  select(pid, name, uid, resident_size)
```

    ## # Source:     lazy query [?? x 4]
    ## # Database:   OsqueryConnection
    ## # Ordered by: desc(resident_size)
    ##    name                  pid   resident_size uid  
    ##    <chr>                 <chr> <chr>         <chr>
    ##  1 java                  54764 4001574912    502  
    ##  2 com.docker.hyperkit   28543 2868310016    502  
    ##  3 firefox               72338 1530167296    502  
    ##  4 plugin-container      58603 714211328     502  
    ##  5 plugin-container      58699 663666688     502  
    ##  6 Adobe Desktop Service 1242  609406976     502  
    ##  7 RStudio               54892 516149248     502  
    ##  8 plugin-container      72343 515313664     502  
    ##  9 plugin-container      58708 511750144     502  
    ## 10 Finder                1073  469741568     502  
    ## # ... with more rows

process count for the top 10 most active processes

``` r
count(procs, name, sort=TRUE)
```

    ## # Source:     lazy query [?? x 2]
    ## # Database:   OsqueryConnection
    ## # Ordered by: desc(n)
    ##    n     name                
    ##    <chr> <chr>               
    ##  1 17    MTLCompilerService  
    ##  2 11    mdworker            
    ##  3 6     Dropbox             
    ##  4 6     Google Chrome Helper
    ##  5 6     bash                
    ##  6 5     QtWebEngineProcess  
    ##  7 5     RStudio             
    ##  8 5     distnoted           
    ##  9 5     garcon              
    ## 10 5     iTerm2              
    ## # ... with more rows

### get all processes listening on a port (join example)

``` r
listen <- tbl(osqdb, "listening_ports")

left_join(procs, listen, by="pid") %>%
  filter(port != "") %>% 
  distinct(name, port, address, pid)
```

    ## # Source:   lazy query [?? x 4]
    ## # Database: OsqueryConnection
    ##    address   name                                         pid   port 
    ##    <chr>     <chr>                                        <chr> <chr>
    ##  1 127.0.0.1 2BUA8C4S2C.com.agilebits.onepassword4-helper 67094 6258 
    ##  2 ::1       2BUA8C4S2C.com.agilebits.onepassword4-helper 67094 6258 
    ##  3 127.0.0.1 2BUA8C4S2C.com.agilebits.onepassword4-helper 67094 6263 
    ##  4 ::1       2BUA8C4S2C.com.agilebits.onepassword4-helper 67094 6263 
    ##  5 ""        ARDAgent                                     494   0    
    ##  6 0.0.0.0   ARDAgent                                     494   3283 
    ##  7 ""        Adobe CEF Helper                             1234  0    
    ##  8 ""        Adobe CEF Helper                             1294  0    
    ##  9 ""        Adobe Desktop Service                        1242  0    
    ## 10 127.0.0.1 Adobe Desktop Service                        1242  15292
    ## # ... with more rows

### get file info

``` r
files <- tbl(osqdb, "file")

filter(files, path == "/etc/hosts") %>% 
  select(filename, size)
```

    ## # Source:   lazy query [?? x 2]
    ## # Database: OsqueryConnection
    ##   filename size   
    ##   <chr>    <chr>  
    ## 1 hosts    1425149

### users

``` r
tbl(osqdb, "users")
```

    ## # Source:   table<users> [?? x 10]
    ## # Database: OsqueryConnection
    ##    description           directory          gid   gid_signed shell          uid   uid_signed username     uuid         
    ##    <chr>                 <chr>              <chr> <chr>      <chr>          <chr> <chr>      <chr>        <chr>        
    ##  1 AMaViS Daemon         /var/virusmails    83    83         /usr/bin/false 83    83         _amavisd     FFFFEEEE-DDD…
    ##  2 Analytics Daemon      /var/db/analyticsd 263   263        /usr/bin/false 263   263        _analyticsd  FFFFEEEE-DDD…
    ##  3 AppleEvents Daemon    /var/empty         55    55         /usr/bin/false 55    55         _appleevents FFFFEEEE-DDD…
    ##  4 applepay Account      /var/db/applepay   260   260        /usr/bin/false 260   260        _applepay    FFFFEEEE-DDD…
    ##  5 Application Owner     /var/empty         87    87         /usr/bin/false 87    87         _appowner    FFFFEEEE-DDD…
    ##  6 Application Server    /var/empty         79    79         /usr/bin/false 79    79         _appserver   FFFFEEEE-DDD…
    ##  7 Mac App Store Service /var/empty         33    33         /usr/bin/false 33    33         _appstore    FFFFEEEE-DDD…
    ##  8 Apple Remote Desktop  /var/empty         67    67         /usr/bin/false 67    67         _ard         FFFFEEEE-DDD…
    ##  9 Asset Cache Service   /var/empty         235   235        /usr/bin/false 235   235        _assetcache  FFFFEEEE-DDD…
    ## 10 Astris Services       /var/db/astris     245   245        /usr/bin/false 245   245        _astris      FFFFEEEE-DDD…
    ## # ... with more rows

``` r
tbl(osqdb, "logged_in_users")
```

    ## # Source:   table<logged_in_users> [?? x 6]
    ## # Database: OsqueryConnection
    ##    host  pid   time       tty     type  user    
    ##    <chr> <chr> <chr>      <chr>   <chr> <chr>   
    ##  1 ""    128   1526421243 console user  hrbrmstr
    ##  2 ""    38551 1527182768 ttys001 user  hrbrmstr
    ##  3 ""    38811 1527183574 ttys002 user  hrbrmstr
    ##  4 ""    58254 1527270314 ttys003 user  hrbrmstr
    ##  5 ""    61685 1527275702 ttys004 user  hrbrmstr
    ##  6 ""    61495 1527275058 ttys005 dead  hrbrmstr
    ##  7 ""    52333 1526658865 ttys006 dead  hrbrmstr
    ##  8 ""    54350 1526670699 ttys007 dead  hrbrmstr
    ##  9 ""    55922 1526675872 ttys008 dead  hrbrmstr
    ## 10 ""    63892 1526725572 ttys009 dead  hrbrmstr
    ## # ... with more rows

### groups

``` r
tbl(osqdb, "groups")
```

    ## # Source:   table<groups> [?? x 5]
    ## # Database: OsqueryConnection
    ##    gid   gid_signed groupname      
    ##    <chr> <chr>      <chr>          
    ##  1 701   701        1              
    ##  2 83    83         _amavisd       
    ##  3 263   263        _analyticsd    
    ##  4 250   250        _analyticsusers
    ##  5 55    55         _appleevents   
    ##  6 260   260        _applepay      
    ##  7 87    87         _appowner      
    ##  8 81    81         _appserveradm  
    ##  9 79    79         _appserverusr  
    ## 10 33    33         _appstore      
    ## # ... with more rows

### homebrew\!

``` r
tbl(osqdb, "homebrew_packages")
```

    ## # Source:   table<homebrew_packages> [?? x 3]
    ## # Database: OsqueryConnection
    ##    name         path                            version  
    ##    <chr>        <chr>                           <chr>    
    ##  1 adns         /usr/local/Cellar/adns/         1.5.1    
    ##  2 alpine       /usr/local/Cellar/alpine/       2.21     
    ##  3 ant          /usr/local/Cellar/ant/          1.10.3   
    ##  4 apache-arrow /usr/local/Cellar/apache-arrow/ 0.9.0    
    ##  5 apache-arrow /usr/local/Cellar/apache-arrow/ 0.9.0_1  
    ##  6 aria2        /usr/local/Cellar/aria2/        1.33.1   
    ##  7 armadillo    /usr/local/Cellar/armadillo/    8.400.0  
    ##  8 armadillo    /usr/local/Cellar/armadillo/    8.400.1  
    ##  9 armadillo    /usr/local/Cellar/armadillo/    8.500.0_1
    ## 10 arpack       /usr/local/Cellar/arpack/       3.5.0_1  
    ## # ... with more rows
