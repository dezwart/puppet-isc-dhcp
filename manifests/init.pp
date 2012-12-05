# isc_dhcp service
#
# This class needs to use multi-part files to allow for multiple subnets to be
# defined.
#
# == Parameters
#
# [*interfaces*]
#   List of network interfaces to bind the DHCP service to.
#
# [*ddns_update_style*]
#   Dynamic DNS update style. Default is 'none'.
#
# [*domain_name*]
#   Default domain name for DHCP pools. Default is 'example.org'.
#
# [*domain_name_servers*]
#   Default domain name servers for DHCP pools.
#   Default is [ 'ns1.example.org', 'ns2.example.org' ].
#
# [*default_lease_time*]
#   Default DHCP lease time in seconds for DHCP pools.
#   Defaule value is 600.
#
# [*max_lease_time*]
#   Maxiumum DHCP lease time in seconds for DHCP pools.
#   Defaule value is 7200.
#
# [*authoritative*]
#   Boolean value to determine if this DHCP server is authoritative.
#   Defaule value is false.
#
# == Variables
#
# == Examples
#
#    class { 'isc_dhcp':
#        interfaces => [ 'eth0', 'eth1' ],
#        ddns_update_style = 'none',
#        domain_name => 'example.org',
#        domain_name_servers => [ 'ns1.example.org', 'ns2.example.org' ],
#        default_lease_time => 600,
#        max_lease_time = 7200,
#        authoritative = true,
#    }
#
class isc_dhcp( $interfaces = undef,
        $ddns_update_style = 'none',
        $domain_name = 'example.org',
        $domain_name_servers = [ 'ns1.example.org', 'ns2.example.org' ],
        $default_lease_time = 600,
        $max_lease_time = 7200,
        $authoritative = false,
        $subnet = undef,
        $netmask = undef,
        $range_start = undef,
        $range_end = undef,
        $routers = undef,
        $dynamic_dns_key = undef,
        $dynamic_dns_forward_zone = undef,
        $dynamic_dns_reverse_zone = undef,
        $dynamic_dns_ns_master = undef ) {
    $package = 'isc-dhcp-server'
    $service = 'isc-dhcp-server'
    $conf_dir = '/etc/dhcp'

    if $lsbdistid == 'Ubuntu' {
        $user = 'dhcpd'
        $group = $user

        user { $user:
            ensure  => present,
            require => Package[$package],
        }

        group { $group:
            ensure  => present,
            require => Package[$package],
        }
    } else {
        $user = 'root'
        $group = $user
    }

    package { $package:
        ensure  => installed,
    }

    file { '/etc/default/isc-dhcp-server':
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => '0644',
        content => template('isc_dhcp/isc-dhcp-server.erb'),
        require => Package[$package],
    }

    file { $conf_dir:
        ensure  => directory,
        owner   => $user,
        group   => $group,
        mode    => '2774',
        require => Package[$package],
    }

    file { "$conf_dir/dhcpd.conf":
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => '0644',
        content => template('isc_dhcp/dhcpd.conf.erb'),
        require => Package[$package],
    }

    service { $package:
        ensure      => running,
        enable      => true,
        pattern     => '/usr/sbin/dhcpd',
        require     => Package[$package],
        subscribe   => [ File['/etc/default/isc-dhcp-server'], File["$conf_dir/dhcpd.conf"] ],
    }

    if $ddns_update_style != 'none' {
        file { "$conf_dir/dynamic-dns.key":
            ensure  => file,
            owner   => $user,
            group   => $group,
            mode    => '0640',
            content => template('isc_dhcp/dynamic-dns.key.erb'),
            notify  => Service[$service],
        }

        file { "$conf_dir/dhcpd.conf.ddns":
            ensure  => file,
            owner   => $user,
            group   => $group,
            mode    => '0644',
            content => template('isc_dhcp/dhcpd.conf.ddns.erb'),
            notify  => Service[$service],
        }
    }

    # dhcpd.conf.local file fragments pattern, purges unmanaged files
    $dhcpd_conf_local = "$conf_dir/dhcpd.conf.local"
    $dhcpd_conf_local_file_fragments_directory = "${dhcpd_conf_local}.d"

    file { $dhcpd_conf_local:
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => '0640',
        require => Package[$package],
        notify  => Service[$service],
    }

    file { $dhcpd_conf_local_file_fragments_directory:
        ensure  => directory,
        owner   => $user,
        group   => $group,
        mode    => '0700',
        require => [Package[$package], File[$conf_dir]],
        recurse => true,
        purge   => true,
        notify  => Exec['dhcpd_conf_local_file_assemble'],
    }

    $dhcpd_conf_local_file_assemble = 'dhcpd_conf_local_file_assemble'
    exec { $dhcpd_conf_local_file_assemble:
        refreshonly => true,
        require     => [ File[$dhcpd_conf_local_file_fragments_directory], File[$dhcpd_conf_local] ],
        notify      => Service[$service],
        command     => "/bin/cat ${dhcpd_conf_local_file_fragments_directory}/*_dhcpd.conf.local_* > ${dhcpd_conf_local}",
    }

    $dhcpd_conf_local_preamble = "${dhcpd_conf_local_file_fragments_directory}/00_dhcpd.conf.local_preamble"

    file { $dhcpd_conf_local_preamble:
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => '0600',
        require => Package[$package],
        content => template("isc_dhcp/dhcpd.conf.local_preamble.erb"),
        notify  => Exec['dhcpd_conf_local_file_assemble'],
    }
}
