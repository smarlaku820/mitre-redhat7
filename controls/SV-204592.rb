control 'SV-204592' do
  title 'The Red Hat Enterprise Linux operating system must not permit direct logons to the root account using
    remote access via SSH.'
  desc 'Even though the communications channel may be encrypted, an additional layer of security is gained by
    extending the policy of not logging on directly as root. In addition, logging on with a user-specific account
    provides individual accountability of actions performed on the system.'
  desc 'check', 'Verify remote access using SSH prevents users from logging on directly as root.
    Check that SSH prevents users from logging on directly as root with the following command:
    # grep -i permitrootlogin /etc/ssh/sshd_config
    PermitRootLogin no
    If the "PermitRootLogin" keyword is set to "yes", is missing, or is commented out, this is a finding.'
  desc 'fix', 'Configure SSH to stop users from logging on remotely as the root user.
    Edit the appropriate  "/etc/ssh/sshd_config" file to uncomment or add the line for the "PermitRootLogin" keyword and
    set its value to "no" (this file may be named differently or be in a different location if using a version of SSH
    that is provided by a third-party vendor):
    PermitRootLogin no
    The SSH service must be restarted for changes to take effect.'
  impact 0.5
  tag legacy: ['V-72247', 'SV-86871']
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-204592'
  tag rid: 'SV-204592r603261_rule'
  tag stig_id: 'RHEL-07-040370'
  tag fix_id: 'F-4716r88969_fix'
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
      its('PermitRootLogin') { should cmp 'no' }
    end
  end
end
