control 'SV-204593' do
  title 'The Red Hat Enterprise Linux operating system must be configured so that the SSH daemon does not allow
    authentication using known hosts authentication.'
  desc 'Configuring this setting for the SSH daemon provides additional assurance that remote logon via SSH will
    require a password, even in the event of misconfiguration elsewhere.'
  desc 'check', %q(Verify the SSH daemon does not allow authentication using known hosts authentication.
    To determine how the SSH daemon's "IgnoreUserKnownHosts" option is set, run the following command:
    # grep -i IgnoreUserKnownHosts /etc/ssh/sshd_config
    IgnoreUserKnownHosts yes
    If the value is returned as "no", the returned line is commented out, or no output is returned, this is a finding.)
  desc 'fix', 'Configure the SSH daemon to not allow authentication using known hosts authentication.
    Add the following line in "/etc/ssh/sshd_config", or uncomment the line and set the value to "yes":
    IgnoreUserKnownHosts yes
    The SSH service must be restarted for changes to take effect.'
  impact 0.5
  tag legacy: ['V-72249', 'SV-86873']
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-204593'
  tag rid: 'SV-204593r603261_rule'
  tag stig_id: 'RHEL-07-040380'
  tag fix_id: 'F-4717r88972_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']
  tag subsystems: ['ssh']
  tag 'host'

  if virtualization.system.eql?('docker') && !file('/etc/sysconfig/sshd').exist?
    impact 0.0
    describe 'Control not applicable - SSH is not installed within containerized RHEL' do
      skip 'Control not applicable - SSH is not installed within containerized RHEL'
    end
  else
    describe sshd_config do
      its('IgnoreUserKnownHosts') { should cmp 'yes' }
    end
  end
end
