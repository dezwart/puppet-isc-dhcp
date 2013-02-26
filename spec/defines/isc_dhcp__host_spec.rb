require 'spec_helper'
require 'Isc_dhcp'

describe 'isc_dhcp::host' do
  context 'default' do
    name = 'default'
    let(:title) { name }

    it {
      should contain_file("#{Isc_dhcp::DCL_FFD}/01_dhcpd.conf.local_host_fragment_#{name}").with({
        'ensure' => 'file',
      })
    }
  end
end
