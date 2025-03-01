control 'SV-204399' do
  title 'The Red Hat Enterprise Linux operating system must prevent a user from overriding the screensaver
    lock-delay setting for the graphical user interface.'
  desc "A session time-out lock is a temporary action taken when a user stops work and moves away from the immediate
    physical vicinity of the information system but does not log out because of the temporary nature of the absence.
    Rather than relying on the user to manually lock their operating system session prior to vacating the vicinity,
    operating systems need to be able to identify when a user's session has idled and take action to initiate the
    session lock.
    The session lock is implemented at the point where session activity can be determined and/or controlled."
  desc 'check', "Verify the operating system prevents a user from overriding a screensaver lock after a #{input('system_activity_timeout')/60}-minute period of inactivity for graphical user interfaces.

Note: If the system does not have GNOME installed, this requirement is Not Applicable.

Determine which profile the system database is using with the following command:
     # grep system-db /etc/dconf/profile/user
     system-db:local

Check for the lock delay setting with the following command:

Note: The example below is using the database \"local\" for the system, so the path is \"/etc/dconf/db/local.d\". This path must be modified if a database other than \"local\" is being used.

     # grep -i lock-delay /etc/dconf/db/local.d/locks/*
     /org/gnome/desktop/screensaver/lock-delay

If the command does not return a result, this is a finding."
  desc 'fix', "Configure the operating system to prevent a user from overriding a screensaver lock after a #{input('system_activity_timeout')/60}-minute
    period of inactivity for graphical user interfaces.
    Create a database to contain the system-wide screensaver settings (if it does not already exist) with the following
    command:
    Note: The example below is using the database \"local\" for the system, so if the system is using another database in
    \"/etc/dconf/profile/user\", the file should be created under the appropriate subdirectory.
    # touch /etc/dconf/db/local.d/locks/session
    Add the setting to lock the screensaver lock delay:
    /org/gnome/desktop/screensaver/lock-delay"
  impact 0.5
  tag legacy: ['V-73155', 'SV-87807']
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000029-GPOS-00010'
  tag gid: 'V-204399'
  tag rid: 'SV-204399r880773_rule'
  tag stig_id: 'RHEL-07-010081'
  tag fix_id: 'F-4523r880772_fix'
  tag cci: ['CCI-000057']
  tag nist: ['AC-11 a']
  tag subsystems: ['gui']
  tag 'host'

  if virtualization.system.eql?('docker')
    impact 0.0
    describe 'Control not applicable within a container' do
      skip 'Control not applicable within a container'
    end
  elsif package('gnome-desktop3').installed?

    describe command('gsettings writable org.gnome.desktop.screensaver lock-delay') do
      its('stdout.strip') { should cmp 'false' }
    end
  else
    impact 0.0
    describe 'The GNOME desktop is not installed' do
      skip 'The GNOME desktop is not installed, this control is Not Applicable.'
    end
  end
end
