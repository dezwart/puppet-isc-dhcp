require 'spec_helper'
require 'Isc_dhcp'

describe 'isc_dhcp' do
  context 'default' do
    it {
      should contain_package(Isc_dhcp::PACKAGE)
    }

    it {
      should contain_service(Isc_dhcp::SERVICE)
    }

    it {
      should contain_file(Isc_dhcp::CONF_DIR).with({
        'ensure' => 'directory',
      })
    }

    it {
      should contain_file(Isc_dhcp::DEFAULT_CONF).with({
        'ensure' => 'file',
      })

      should contain_file(Isc_dhcp::DAEMON_CONF).with({
        'ensure' => 'file',
      })
    }

    it {
      should contain_file(Isc_dhcp::DCL).with({
        'ensure' => 'file',
      })

      should contain_file(Isc_dhcp::DCL_FFD).with({
        'ensure' => 'directory',
      })

      should contain_file(Isc_dhcp::DCL_PREAMBLE).with({
        'ensure' => 'file',
      })

      should contain_exec(Isc_dhcp::DCL_FA)
    }
  end

  context 'ddns_update' do
    let(:params) {
      {
        :ddns_update_style => 'gungnam',
      }
    }

    it {
      should contain_file("#{Isc_dhcp::CONF_DIR}/dynamic-dns.key").with({
        'ensure' => 'file',
      })

      should contain_file("#{Isc_dhcp::CONF_DIR}/dhcpd.conf.ddns").with({
        'ensure' => 'file',
      })
    }
  end
end
