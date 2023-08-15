#!/bin/bash

# macOS Silverback Debloater
# v1.0 by Wamphyre

# Disabling SIP is required  ("csrutil disable" from Terminal in Recovery)
# Modifications are written in /private/var/db/com.apple.xpc.launchd/ disabled.plist, disabled.501.plist
# To revert, delete /private/var/db/com.apple.xpc.launchd/ disabled.plist and disabled.501.plist and reboot; sudo rm -r /private/var/db/com.apple.xpc.launchd/*

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

# user
TODISABLE=()

TODISABLE+=('com.apple.accessibility.MotionTrackingAgent' \
'com.apple.AddressBook.ContactsAccountsService' \
'com.apple.AMPArtworkAgent' \
'com.apple.AMPDeviceDiscoveryAgent' \
'com.apple.AMPLibraryAgent' \
'com.apple.ap.adprivacyd' \
'com.apple.ap.adservicesd' \
'com.apple.ap.promotedcontentd' \
'com.apple.assistant_service' \
'com.apple.assistantd' \
'com.apple.avconferenced' \
'com.apple.BiomeAgent' \
'com.apple.biomesyncd' \
'com.apple.CalendarAgent' \
'com.apple.calaccessd' \
'com.apple.CallHistoryPluginHelper' \
'com.apple.cloudd' \
'com.apple.cloudpaird' \
'com.apple.cloudphotod' \
'com.apple.CloudPhotosConfiguration' \
'com.apple.CloudSettingsSyncAgent' \
'com.apple.CommCenter-osx' \
'com.apple.ContactsAgent' \
'com.apple.CoreLocationAgent' \
'com.apple.dataaccess.dataaccessd' \
'com.apple.ensemble' \
'com.apple.familycircled' \
'com.apple.familycontrols.useragent' \
'com.apple.familynotificationd' \
'com.apple.financed' \
'com.apple.followupd' \
'com.apple.gamed' \
'com.apple.geod' \
'com.apple.geodMachServiceBridge' \
'com.apple.homed' \
'com.apple.icloud.fmfd' \
'com.apple.iCloudNotificationAgent' \
'com.apple.iCloudUserNotifications' \
'com.apple.icloud.searchpartyuseragent' \
'com.apple.imagent' \
'com.apple.imautomatichistorydeletionagent' \
'com.apple.imtransferagent' \
'com.apple.intelligenceplatformd' \
'com.apple.itunescloudd' \
'com.apple.knowledge-agent' \
'com.apple.ManagedClient.cloudconfigurationd' \
'com.apple.ManagedClientAgent.enrollagent' \
'com.apple.Maps.mapspushd' \
'com.apple.Maps.pushdaemon' \
'com.apple.mediaanalysisd' \
'com.apple.networkserviceproxy' \
'com.apple.networkserviceproxy-osx' \
'com.apple.mediastream.mstreamd' \
'com.apple.newsd' \
'com.apple.nsurlsessiond' \
'com.apple.parsec-fbf' \
'com.apple.parsecd' \
'com.apple.passd' \
'com.apple.photoanalysisd' \
'com.apple.photolibraryd' \
'com.apple.progressd' \
'com.apple.protectedcloudstorage.protectedcloudkeysyncing' \
'com.apple.quicklook' \
'com.apple.quicklook.ui.helper' \
'com.apple.quicklook.ThumbnailsAgent' \
'com.apple.rapportd-user' \
'com.apple.remindd' \
'com.apple.routined' \
'com.apple.SafariCloudHistoryPushAgent' \
'com.apple.screensharing.agent' \
'com.apple.screensharing.menuextra' \
'com.apple.screensharing.MessagesAgent' \
'com.apple.ScreenTimeAgent' \
'com.apple.security.cloudkeychainproxy3' \
'com.apple.sharingd' \
'com.apple.sidecar-hid-relay' \
'com.apple.sidecar-relay' \
'com.apple.Siri.agent' \
'com.apple.siri.context.service' \
'com.apple.macos.studentd' \
'com.apple.siriknowledged' \
'com.apple.suggestd' \
'com.apple.tipsd' \
'com.apple.telephonyutilities.callservicesd' \
'com.apple.TMHelperAgent' \
'com.apple.TMHelperAgent.SetupOffer' \
'com.apple.triald' \
'com.apple.universalaccessd' \
'com.apple.UsageTrackingAgent' \
'com.apple.videosubscriptionsd' \
'com.apple.WiFiVelocityAgent' \
'com.apple.weatherd')

for agent in "${TODISABLE[@]}"
do
	launchctl bootout gui/501/${agent}
	launchctl disable gui/501/${agent}
done

launchctl unload -w /System/Library/LaunchAgents/com.apple.cloudpaird.plist

# system
TODISABLE=()

TODISABLE+=('com.apple.bootpd' \
'com.apple.backupd' \
'com.apple.backupd-helper' \
'com.apple.cloudd' \
'com.apple.cloudpaird' \
'com.apple.cloudphotod' \
'com.apple.CloudPhotosConfiguration' \
'com.apple.CoreLocationAgent' \
'com.apple.coreduetd' \
'com.apple.dhcp6d' \
'com.apple.familycontrols' \
'com.apple.findmymacmessenger' \
'com.apple.followupd' \
'com.apple.FollowUpUI' \
'com.apple.ftp-proxy' \
'com.apple.ftpd' \
'com.apple.GameController.gamecontrollerd' \
'com.apple.icloud.fmfd' \
'com.apple.icloud.searchpartyd' \
'com.apple.itunescloudd' \
'com.apple.locationd' \
'com.apple.ManagedClient.cloudconfigurationd' \
'com.apple.networkserviceproxy' \
'com.apple.netbiosd' \
'com.apple.nsurlsessiond' \
'com.apple.protectedcloudstorage.protectedcloudkeysyncing' \
'com.apple.rapportd' \
'com.apple.screensharing' \
'com.apple.security.cloudkeychainproxy3' \
'com.apple.siri.morphunassetsupdaterd' \
'com.apple.siriinferenced' \
'com.apple.triald.system' \
'com.apple.wifianalyticsd')

for daemon in "${TODISABLE[@]}"
do
	sudo launchctl bootout system/${daemon}
	sudo launchctl disable system/${daemon}
done

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
