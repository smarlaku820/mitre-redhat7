control 'SV-204398' do
  title "The Red Hat Enterprise Linux operating system must initiate a screensaver after a #{input('system_activity_timeout')/60}-minute period of
    inactivity for graphical user interfaces."
  desc "A session time-out lock is a temporary action taken when a user stops work and moves away from the immediate
    physical vicinity of the information system but does not log out because of the temporary nature of the absence.
    Rather than relying on the user to manually lock their operating system session prior to vacating the vicinity,
    operating systems need to be able to identify when a user's session has idled and take action to initiate the
    session lock.
    The session lock is implemented at the point where session activity can be determined and/or controlled."
  desc 'check', "Verify the operating system initiates a screensaver after a #{input('system_activity_timeout')/60}-minute period of inactivity for graphical user interfaces.

Note: If the system does not have GNOME installed, this requirement is Not Applicable.

Check to see if GNOME is configured to display a screensaver after a #{input('system_activity_timeout')/60} minute delay with the following command:

     # grep -i idle-delay /etc/dconf/db/local.d/*
     idle-delay=uint32 #{input('system_activity_timeout')}

If the \"idle-delay\" setting is missing or is not set to \"#{input('system_activity_timeout')}\" or less, this is a finding."
  desc 'fix', "Configure the operating system to initiate a screensaver after a #{input('system_activity_timeout')/60}-minute period of inactivity for
    graphical user interfaces.
    Create a database to contain the system-wide screensaver settings (if it does not already exist) with the following
    command:
    # touch /etc/dconf/db/local.d/00-screensaver
    Edit /etc/dconf/db/local.d/00-screensaver and add or update the following lines:
    [org/gnome/desktop/session]
    # Set the lock time out to #{input('system_activity_timeout')} seconds before the session is considered idle
    idle-delay=uint32 #{input('system_activity_timeout')}
    You must include the \"uint32\" along with the integer key values as shown.
    Update the system databases:
    # dconf update
    Users must log out and back in again before the system-wide settings take effect."
  impact 0.5
  tag legacy: ['V-71893', 'SV-86517']
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000029-GPOS-00010'
  tag gid: 'V-204398'
  tag rid: 'SV-204398r880770_rule'
  tag stig_id: 'RHEL-07-010070'
  tag fix_id: 'F-4522r880769_fix'
  tag cci: ['CCI-000057']
  tag nist: ['AC-11 a']
  tag subsystems: ['gui', 'screensaver', 'session', 'lock']
  tag 'host'

  if virtualization.system.eql?('docker')
    impact 0.0
    describe 'Control not applicable within a container' do
      skip 'Control not applicable within a container'
    end
  elsif package('gnome-desktop3').installed?

    describe command("gsettings get org.gnome.desktop.session idle-delay | cut -d ' ' -f2") do
      its('stdout.strip') { should cmp <= input('system_activity_timeout') }
    end
  else
    impact 0.0
    describe 'The system does not have GNOME installed' do
      skip "The system does not have GNOME installed, this requirement is Not
        Applicable."
    end
  end
end
