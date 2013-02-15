# isc_dhcp service - params class
class isc_dhcp::params {
  $package = 'isc-dhcp-server'
  $service = 'isc-dhcp-server'
  $conf_dir = '/etc/dhcp'
  $dcl = "${conf_dir}/dhcpd.conf.local"
  $dcl_ffd = "${dcl}.d"
  $dcl_file_assemble = 'dcl_file_assemble'
  $dcl_preamble = "${dcl_ffd}/00_dhcpd.conf.local_preamble"
}

# vim: set ts=2 sw=2 sts=2 tw=0 et:
