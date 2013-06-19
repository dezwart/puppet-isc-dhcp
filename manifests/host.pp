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
# [*filename*]
#   Initial boot file for a client host.
#
# == Variables
#
# == Examples
#
#    isc_dhcp::host { 'bar.foo.com':
#        mac        => '0:0:c0:5d:bd:95',
#        routers    => [ '192.168.0.1', '192.168.0.2' ],
#        filename   => '/debian-netboot/pxelinux.0',
#    }
#
define isc_dhcp::host(
  $mac = undef,
  $routers = undef,
  $filename = undef,
  $next_server = undef,
  $hostname = undef
) {
  require isc_dhcp::params

  $fragment_name="01_dhcpd.conf.local_host_fragment_${name}"

  if ( ! $hostname ) {
    $host_name = regsubst($name, '^([^.]+).+$', '\1')
  } else {
    $host_name = $hostname
  }

  file { "${isc_dhcp::params::dcl_ffd}/${fragment_name}":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('isc_dhcp/dhcpd.conf.local_host_fragment.erb'),
    require => File[$isc_dhcp::params::dcl_ffd],
    notify  => Exec[$isc_dhcp::params::dcl_file_assemble],
  }
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
