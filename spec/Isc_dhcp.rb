module Isc_dhcp
  CN = 'dhcp'
  PACKAGE = "isc-#{CN}-server"
  SERVICE = PACKAGE
  CONF_DIR = "/etc/#{CN}"
  DEFAULT_CONF = "/etc/default/#{SERVICE}"
  DAEMON_CONF = "#{CONF_DIR}/#{CN}d.conf"
  DCL = "#{CONF_DIR}/#{CN}d.conf.local"
  DCL_FFD = "#{DCL}.d"
  DCL_FA = 'dcl_file_assemble'
  DCL_PREAMBLE = "#{DCL_FFD}/00_#{CN}d.conf.local_preamble"
end
