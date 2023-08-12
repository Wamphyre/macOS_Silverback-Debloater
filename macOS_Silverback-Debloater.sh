#!/bin/bash

# macOS Silverback Debloater
# v1.0 by Wamphyre

# Disabling Spotlight
echo "Disabling Spotlight"
sudo mdutil -i off -a
echo "Done"

# Disable animations, and heavy desktop effects
echo "Disabing animations and desktop effects"
sudo defaults write /Library/Preferences/com.apple.loginwindow DesktopPicture ""
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write -g QLPanelAnimationDuration -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.Dock autohide-delay -float 0
defaults write com.apple.dock expose-animation-duration -float 0.001
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.Accessibility DifferentiateWithoutColor -int 1
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1
defaults write com.apple.universalaccess reduceMotion -int 1
defaults write com.apple.universalaccess reduceTransparency -int 1
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1
echo "Done"

# Disable useless Apple services
echo "Disabling useless and slow Apple services"
sudo launchctl remove com.apple.CallHistoryPluginHelper
sudo launchctl remove com.apple.AddressBook.abd
sudo launchctl remove com.apple.ap.adprivacyd
sudo launchctl remove com.apple.ReportPanic
sudo launchctl remove com.apple.ReportCrash
sudo launchctl remove com.apple.ReportCrash.Self
sudo launchctl remove com.apple.DiagnosticReportCleanup.plist
sudo launchctl remove com.apple.ap.adprivacyd
sudo launchctl remove com.apple.siriknowledged
sudo launchctl remove com.apple.helpd
sudo launchctl remove com.apple.mobiledeviceupdater
sudo launchctl remove com.apple.screensharing.MessagesAgent
sudo launchctl remove com.apple.TrustEvaluationAgent
sudo launchctl remove com.apple.iTunesHelper.launcher
sudo launchctl remove com.apple.softwareupdate_notify_agent
sudo launchctl remove com.apple.appstoreagent
sudo launchctl remove com.apple.familycircled
echo "Done"

# Disable and remove Safari services
echo "Disabling and removing Safari services"
sudo launchctl remove com.apple.SafariCloudHistoryPushAgent
sudo launchctl remove com.apple.Safari.SafeBrowsing.Service
sudo launchctl remove com.apple.SafariNotificationAgent
sudo launchctl remove com.apple.SafariPlugInUpdateNotifier
sudo launchctl remove com.apple.SafariHistoryServiceAgent
sudo launchctl remove com.apple.SafariLaunchAgent
sudo launchctl remove com.apple.SafariPlugInUpdateNotifier
sudo launchctl remove com.apple.safaridavclient
echo "Done"

# Disable application state on shutdown
echo "Disabling application state on shutdown"
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
echo "Done"

# Disable facial recognition in media, telemetry, location services, java installation on demand, telnet, ftp, and netbios.
echo "Disabling facial recognition, telemetry, location services and other invasive and insecure stuff"
DAE="com.apple.telnetd com.apple.tftpd com.apple.ftp-proxy com.apple.analyticsd com.apple.amp.mediasharingd com.apple.mediaanalysisd com.apple.mediaremoteagent com.apple.photoanalysisd com.apple.java.InstallOnDemand com.apple.voicememod com.apple.geod com.apple.locate com.apple.locationd com.apple.netbiosd com.apple.recentsd com.apple.suggestd com.apple.spindump com.apple.metadata.mds.spindump com.apple.ReportPanic com.apple.ReportCrash com.apple.ReportCrash.Self com.apple.DiagnosticReportCleanup"
for val in $DAE; do
  sudo launchctl disable system/$val
done
echo "Done"

# Disable automatic updates using defaults write.
echo "Disabling automatic updates"
UPDATES="AutomaticDownload AutomaticCheckEnabled CriticalUpdateInstall ConfigDataInstall"
for val in $UPDATES; do
  sudo defaults write com.apple.SoftwareUpdate $val -int 0
done
echo "Done"

# Reboot
echo "Debloat done"
read -e -p "(y/N) Do you want to reboot now? " yn
if [ "$yn" = "y" ]; then
  sleep 3
  echo "Rebooting..."
  sudo reboot
else
  sleep 3
  echo "Defaulting to no."
  exit
fi