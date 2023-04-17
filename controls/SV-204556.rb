control 'SV-204556' do
  title 'The Red Hat Enterprise Linux operating system must audit all uses of the ssh-keysign command.'
  desc 'Reconstruction of harmful events or forensic analysis is not possible if audit records do not contain enough
    information.
    At a minimum, the organization must audit the full-text recording of privileged ssh commands. The organization must
    maintain audit trails in sufficient detail to reconstruct events to determine the cause and impact of compromise.
    When a user logs on, the auid is set to the uid of the account that is being authenticated. Daemons are not user
    sessions and have the loginuid set to -1. The auid representation is an unsigned 32-bit integer, which equals
    4294967295. The audit system interprets -1, 4294967295, and "unset" in the same way.'
  desc 'check', 'Verify the operating system generates audit records when successful/unsuccessful attempts to use the
    "ssh-keysign" command occur.
    Check that the following system call is being audited by performing the following command to check the file system
    rules in "/etc/audit/audit.rules":
    # grep -iw /usr/libexec/openssh/ssh-keysign /etc/audit/audit.rules
    -a always,exit -F path=/usr/libexec/openssh/ssh-keysign -F auid>=1000 -F auid!=unset -k privileged-ssh
    If the command does not return any output, this is a finding.'
  desc 'fix', 'Configure the operating system to generate audit records when successful/unsuccessful attempts to use
    the "ssh-keysign" command occur.
    Add or update the following rule in "/etc/audit/rules.d/audit.rules":
    -a always,exit -F path=/usr/libexec/openssh/ssh-keysign -F auid>=1000 -F auid!=unset -k privileged-ssh
    The audit daemon must be restarted for the changes to take effect.'
  impact 0.5
  tag legacy: ['SV-86803', 'V-72179']
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000042-GPOS-00020'
  tag satisfies: ['SRG-OS-000042-GPOS-00020', 'SRG-OS-000392-GPOS-00172', 'SRG-OS-000471-GPOS-00215']
  tag gid: 'V-204556'
  tag rid: 'SV-204556r603261_rule'
  tag stig_id: 'RHEL-07-030780'
  tag fix_id: 'F-4680r462664_fix'
  tag cci: ['CCI-000135', 'CCI-000172', 'CCI-002884']
  tag nist: ['AU-3 (1)', 'AU-12 c', 'MA-4 (1) (a)']
  tag subsystems: ['audit', 'auditd', 'audit_rule']
  tag 'host'

  audit_command = '/usr/libexec/openssh/ssh-keysign'

  if virtualization.system.eql?('docker')
    impact 0.0
    describe 'Control not applicable - audit config must be done on the host' do
      skip 'Control not applicable - audit config must be done on the host'
    end
  else
    describe 'Command' do
      it "#{audit_command} is audited properly" do
        audit_rule = auditd.file(audit_command)
        expect(audit_rule).to exist
        expect(audit_rule.action.uniq).to cmp 'always'
        expect(audit_rule.list.uniq).to cmp 'exit'
        expect(audit_rule.fields.flatten).to include('auid>=1000', 'auid!=-1')
        expect(audit_rule.key.uniq).to cmp 'privileged-ssh'
      end
    end
  end
end
