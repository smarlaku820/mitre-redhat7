control 'SV-204428' do
  title "The Red Hat Enterprise Linux operating system must lock the associated account after #{input('unsuccessful_attempts')} unsuccessful
    root logon attempts are made within a #{input('fail_interval')/60}-minute period."
  desc 'By limiting the number of failed logon attempts, the risk of unauthorized system access via user password
    guessing, otherwise known as brute forcing, is reduced. Limits are imposed by locking the account.'
  desc 'check', "Verify the operating system automatically locks the root account, for a minimum of #{input('lockout_time')/60} minutes, when
    #{input('unsuccessful_attempts')} unsuccessful logon attempts in #{input('fail_interval')/60} minutes are made.
    # grep pam_faillock.so /etc/pam.d/password-auth
    auth required pam_faillock.so preauth silent audit deny=#{input('unsuccessful_attempts')} even_deny_root fail_interval=#{input('fail_interval')} unlock_time=#{input('lockout_time')}
    auth [default=die] pam_faillock.so authfail audit deny=#{input('unsuccessful_attempts')} even_deny_root fail_interval=#{input('fail_interval')} unlock_time=#{input('lockout_time')}
    account required pam_faillock.so
    If the \"even_deny_root\" setting is not defined on both lines with the \"pam_faillock.so\" module, is commented out, or
    is missing from a line, this is a finding.
    # grep pam_faillock.so /etc/pam.d/system-auth
    auth required pam_faillock.so preauth silent audit deny=#{input('unsuccessful_attempts')} even_deny_root fail_interval=#{input('fail_interval')} unlock_time=#{input('lockout_time')}
    auth [default=die] pam_faillock.so authfail audit deny=#{input('unsuccessful_attempts')} even_deny_root fail_interval=#{input('fail_interval')} unlock_time=#{input('lockout_time')}
    account required pam_faillock.so
    If the \"even_deny_root\" setting is not defined on both lines with the \"pam_faillock.so\" module, is commented out, or
    is missing from a line, this is a finding."
  desc 'fix', "Configure the operating system to automatically lock the root account, for a minimum of #{input('lockout_time')/60} minutes, when #{input('unsuccessful_attempts')} unsuccessful logon attempts in #{input('fail_interval')/60} minutes are made.

Modify the first #{input('unsuccessful_attempts')} lines of the auth section and the first line of the account section of the \"/etc/pam.d/system-auth\" and \"/etc/pam.d/password-auth\" files to match the following lines:

auth        required      pam_faillock.so preauth silent audit deny=#{input('unsuccessful_attempts')} even_deny_root fail_interval=#{input('fail_interval')} unlock_time=#{input('lockout_time')}
auth        sufficient    pam_unix.so try_first_pass
auth        [default=die] pam_faillock.so authfail audit deny=#{input('unsuccessful_attempts')} even_deny_root fail_interval=#{input('fail_interval')} unlock_time=#{input('lockout_time')}
account     required      pam_faillock.so

Note: Per requirement RHEL-07-010199, RHEL 7 must be configured to not overwrite custom authentication configuration settings while using the authconfig utility, otherwise manual changes to the listed files will be overwritten whenever the authconfig utility is used."
  impact 0.5
  tag legacy: ['V-71945', 'SV-86569']
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000329-GPOS-00128'
  tag satisfies: ['SRG-OS-000329-GPOS-00128', 'SRG-OS-000021-GPOS-00005']
  tag gid: 'V-204428'
  tag rid: 'SV-204428r880845_rule'
  tag stig_id: 'RHEL-07-010330'
  tag fix_id: 'F-4552r880844_fix'
  tag cci: ['CCI-002238']
  tag nist: ['AC-7 b']
  tag subsystems: ['pam']
  tag 'host'
  tag 'container'

  describe pam('/etc/pam.d/password-auth') do
    its('lines') do
      should match_pam_rule('auth .* pam_faillock.so preauth even_deny_root')
    end
    its('lines') do
      should match_pam_rule('auth .* pam_faillock.so authfail even_deny_root')
    end
  end
  describe pam('/etc/pam.d/system-auth') do
    its('lines') do
      should match_pam_rule('auth .* pam_faillock.so preauth even_deny_root')
    end
    its('lines') do
      should match_pam_rule('auth .* pam_faillock.so authfail even_deny_root')
    end
  end
end
