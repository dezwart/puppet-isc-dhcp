# ISC DHCP Server- Host type
#
# == Parameters
#
# [*mac*]
#   Machine Address Code of the host.
#
# [*routers*]
#   Array of optional routers.
#
# == Variables
#
# == Examples
#
#    isc-dhcp::host { 'bar.foo.com':
#        mac        => '0:0:c0:5d:bd:95',
#        routers    => [ '192.168.0.1', '192.168.0.2' ],
#    }
#
define isc-dhcp::host($mac = undef,
    $routers = undef) {

    file { "$isc-dhcp::dhcpd_conf_local_file_fragments_directory/01_dhcpd.conf.local_host_fragment_$name":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('isc-dhcp/dhcpd.conf.local_host_fragment.erb'),
        require => File[$isc-dhcp::dhcpd_conf_local_file_fragments_directory],
        notify  => Exec[$isc-dhcp::dhcpd_conf_local_file_assemble],
    }
}
