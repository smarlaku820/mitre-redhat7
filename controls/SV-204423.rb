control 'SV-204423' do
  title "The Red Hat Enterprise Linux operating system must be configured so that passwords are a minimum of #{input('min_len')}
    characters in length."
  desc "The shorter the password, the lower the number of possible combinations that need to be tested before the
    password is compromised.
    Password complexity, or strength, is a measure of the effectiveness of a password in resisting attempts at guessing
    and brute-force attacks. Password length is one factor of several that helps to determine strength and how long it
    takes to crack a password. Use of more characters in a password helps to exponentially increase the time and/or
    resources required to compromise the password."
  desc 'check', "Verify the operating system enforces a minimum #{input('min_len')}-character password length. The \"minlen\" option
    sets the minimum number of characters in a new password.
    Check for the value of the \"minlen\" option in \"/etc/security/pwquality.conf\" with the following command:
    # grep minlen /etc/security/pwquality.conf
    minlen = #{input('min_len')}
    If the command does not return a \"minlen\" value of #{input('min_len')} or greater, this is a finding."
  desc 'fix', "Configure operating system to enforce a minimum #{input('min_len')}-character password length.
    Add the following line to \"/etc/security/pwquality.conf\" (or modify the line to have the required value):
    minlen = #{input('min_len')}"
  impact 0.5
  tag legacy: ['V-71935', 'SV-86559']
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000078-GPOS-00046'
  tag gid: 'V-204423'
  tag rid: 'SV-204423r603261_rule'
  tag stig_id: 'RHEL-07-010280'
  tag fix_id: 'F-4547r88462_fix'
  tag cci: ['CCI-000205']
  tag nist: ['IA-5 (1) (a)']
  tag subsystems: ['pwquality', 'password']
  tag 'host'
  tag 'container'

  describe parse_config_file('/etc/security/pwquality.conf') do
    its('minlen') { should cmp >= input('min_len') }
  end
end
