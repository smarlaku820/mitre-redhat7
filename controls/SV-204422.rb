control 'SV-204422' do
  title "The Red Hat Enterprise Linux operating system must be configured so that passwords are prohibited from
    reuse for a minimum of #{input('min_reuse_generations')} generations."
  desc 'Password complexity, or strength, is a measure of the effectiveness of a password in resisting attempts at
    guessing and brute-force attacks. If the information system or application allows the user to consecutively reuse
    their password when that password has exceeded its defined lifetime, the end result is a password that is not
    changed per policy requirements.'
  desc 'check', "Verify the operating system prohibits password reuse for a minimum of #{input('min_reuse_generations')} generations.
    Check for the value of the \"remember\" argument in \"/etc/pam.d/system-auth\" and \"/etc/pam.d/password-auth\" with the
    following command:
    # grep -i remember /etc/pam.d/system-auth /etc/pam.d/password-auth
    password    requisite     pam_pwhistory.so use_authtok remember=#{input('min_reuse_generations')} retry=#{input('retry')}
    If the line containing the \"pam_pwhistory.so\" line does not have the \"remember\" module argument set, is commented
    out, or the value of the \"remember\" module argument is set to less than \"#{input('min_reuse_generations')}\", this is a finding."
  desc 'fix', "Configure the operating system to prohibit password reuse for a minimum of #{input('min_reuse_generations')} generations.

Add the following line in \"/etc/pam.d/system-auth\" and \"/etc/pam.d/password-auth\" (or modify the line to have the required value):

     password     requisite     pam_pwhistory.so use_authtok remember=#{input('min_reuse_generations')} retry=#{input('retry')}

Note: Per requirement RHEL-07-010199, RHEL 7 must be configured to not overwrite custom authentication configuration settings while using the authconfig utility, otherwise manual changes to the listed files will be overwritten whenever the authconfig utility is used."
  impact 0.5
  tag legacy: ['V-71933', 'SV-86557']
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000077-GPOS-00045'
  tag gid: 'V-204422'
  tag rid: 'SV-204422r880836_rule'
  tag stig_id: 'RHEL-07-010270'
  tag fix_id: 'F-4546r880835_fix'
  tag cci: ['CCI-000200']
  tag nist: ['IA-5 (1) (e)']
  tag subsystems: ['pam', 'password']
  tag 'host'
  tag 'container'

  min_reuse_generations = input('min_reuse_generations')

  describe pam('/etc/pam.d/system-auth') do
    its('lines') { should match_pam_rule("password (required|requisite|sufficient) pam_(unix|pwhistory).so use_authtok remember=#{min_reuse_generations}") }
  end
  describe pam('/etc/pam.d/password-auth') do
    its('lines') { should match_pam_rule("password (required|requisite|sufficient) pam_(unix|pwhistory).so use_authtok remember=#{min_reuse_generations}") }
  end
end
