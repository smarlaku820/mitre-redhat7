control 'SV-204615' do
  title 'The Red Hat Enterprise Linux operating system must ignore Internet Protocol version 4 (IPv4) Internet
    Control Message Protocol (ICMP) redirect messages.'
  desc "ICMP redirect messages are used by routers to inform hosts that a more direct route exists for a particular
    destination. These messages modify the host's route table and are unauthenticated. An illicit ICMP redirect message
    could result in a man-in-the-middle attack."
  desc 'check', 'Verify the system ignores IPv4 ICMP redirect messages.

     # grep -r net.ipv4.conf.all.accept_redirects /run/sysctl.d/* /etc/sysctl.d/* /usr/local/lib/sysctl.d/* /usr/lib/sysctl.d/* /lib/sysctl.d/* /etc/sysctl.conf 2> /dev/null

If "net.ipv4.conf.all.accept_redirects" is not configured in the /etc/sysctl.conf file or in any of the other sysctl.d directories, is commented out, or does not have a value of "0", this is a finding.

Check that the operating system implements the "accept_redirects" variables with the following command:

     # /sbin/sysctl -a | grep net.ipv4.conf.all.accept_redirects
     net.ipv4.conf.all.accept_redirects = 0

If the returned line does not have a value of "0", this is a finding.

If conflicting results are returned, this is a finding.'
  desc 'fix', 'Set the system to ignore IPv4 ICMP redirect messages by adding the
following line to "/etc/sysctl.conf" or a configuration file in the
/etc/sysctl.d/ directory (or modify the line to have the required value):

    net.ipv4.conf.all.accept_redirects = 0

    Issue the following command to make the changes take effect:

    # sysctl --system'
  impact 0.5
  tag legacy: ['SV-87827', 'V-73175']
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-204615'
  tag rid: 'SV-204615r880815_rule'
  tag stig_id: 'RHEL-07-040641'
  tag fix_id: 'F-4739r880814_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']
  tag subsystems: ['kernel_parameter', 'ipv4']
  tag 'host'

  if virtualization.system.eql?('docker')
    impact 0.0
    describe 'Control not applicable - Kernel config must be done on the host' do
      skip 'Control not applicable - Kernel config must be done on the host'
    end
  else
    results_in_files = command('grep -r net.ipv4.conf.all.accept_redirects /run/sysctl.d/* /etc/sysctl.d/* /usr/local/lib/sysctl.d/* /usr/lib/sysctl.d/* /lib/sysctl.d/* /etc/sysctl.conf 2> /dev/null').stdout.strip.split("\n")

    values = []
    results_in_files.each { |result| values.append(parse_config(result).params.values) }

    accept_redirects = 0
    unique_values = values.uniq.flatten
    describe 'net.ipv4.conf.all.accept_redirects' do
      it "should be set to #{accept_redirects} in the configuration files" do
        conflicting_values_fail_message = "net.ipv4.conf.all.accept_redirects is set to conflicting values as follows: #{unique_values}"
        incorrect_value_fail_message = "The net.ipv4.conf.all.accept_redirects value is set to #{unique_values[0]} and should be set to #{accept_redirects}"
        unless unique_values.empty?
          expect(unique_values.length).to cmp(1), conflicting_values_fail_message
          expect(unique_values[0]).to cmp(accept_redirects), incorrect_value_fail_message
        end
      end
    end

    describe kernel_parameter('net.ipv4.conf.all.accept_redirects') do
      its('value') { should eq accept_redirects }
    end
  end
end
