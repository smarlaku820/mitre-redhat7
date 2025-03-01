control 'SV-204605' do
  title 'The Red Hat Enterprise Linux operating system must display the date and time of the last successful account
    logon upon logon.'
  desc 'Providing users with feedback on when account accesses last occurred facilitates user recognition and
    reporting of unauthorized account use.'
  desc 'check', 'Verify users are provided with feedback on when account accesses last occurred.
    Check that "pam_lastlog" is used and not silent with the following command:
    # grep pam_lastlog /etc/pam.d/postlogin
    session required pam_lastlog.so showfailed
    If "pam_lastlog" is missing from "/etc/pam.d/postlogin" file, or the silent option is present, this is a finding.'
  desc 'fix', 'Configure the operating system to provide users with feedback on when account accesses last occurred
    by setting the required configuration options in "/etc/pam.d/postlogin".
    Add the following line to the top of "/etc/pam.d/postlogin":
    session required pam_lastlog.so showfailed'
  impact 0.3
  tag legacy: ['SV-86899', 'V-72275']
  tag severity: 'low'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-204605'
  tag rid: 'SV-204605r858478_rule'
  tag stig_id: 'RHEL-07-040530'
  tag fix_id: 'F-4729r89008_fix'
  tag cci: ['CCI-000366', 'CCI-000052']
  tag nist: ['CM-6 b', 'AC-9']
  tag subsystems: ['pam', 'lastlog', 'ssh']
  tag 'host'
  tag 'container'

  describe pam('/etc/pam.d/postlogin') do
    its('lines') do
      should match_pam_rule('session .* pam_lastlog.so showfailed')
    end
  end

  unless virtualization.system.eql?('docker') && !file('/etc/sysconfig/sshd').exist?
    describe.one do
      describe sshd_config do
        its('PrintLastLog') { should cmp 'yes' }
      end
      describe pam('/etc/pam.d/postlogin') do
        its('lines') do
          should_not match_pam_rule('session .* pam_lastlog.so showfailed silent')
        end
      end
    end
  end
end
