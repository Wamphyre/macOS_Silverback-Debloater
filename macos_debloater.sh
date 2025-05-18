#!/bin/bash

# macOS Silverback Debloater by Wamphyre
# maintenance by huybik
# v1.1

# Disabling SIP is required  ("csrutil disable" from Terminal in Recovery)
# Modifications are written in /private/var/db/com.apple.xpc.launchd/ disabled.plist, disabled.501.plist
# To revert, delete /private/var/db/com.apple.xpc.launchd/ disabled.plist and disabled.501.plist and reboot; sudo rm -r /private/var/db/com.apple.xpc.launchd/*

# Show user agents 
# launchctl list

# Show system agents
# sudo launchctl list

# Enable to run file
# chmod +x ./macOS_Debloater.sh

# **System Optimization**
read -e -p "(y/N) Do you want to perform system optimizations? " yn
if [ "$yn" = "y" ]; then
    echo "Performing system optimizations"
    # Disable animations and heavy desktop effects
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
else
    echo "Skipping system optimizations."
fi

# **Disable application state on shutdown**
read -e -p "(y/N) Do you want to disable application state on shutdown? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling application state on shutdown"
    defaults write com.apple.loginwindow TALLogoutSavesState -bool false
    echo "Done"
else
    echo "Skipping disabling application state on shutdown."
fi

# **Disable Spotlight**
read -e -p "(y/N) Do you want to disable Spotlight? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Spotlight"
    sudo mdutil -i off -a
    echo "Done"
else
    echo "Skipping disabling Spotlight."
fi

# **Disable automatic updates**
read -e -p "(y/N) Do you want to disable automatic updates? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling automatic updates"
    UPDATES="AutomaticDownload
    AutomaticCheckEnabled
    CriticalUpdateInstall
    ConfigDataInstall"
    for val in $UPDATES; do
        sudo defaults write com.apple.SoftwareUpdate $val -int 0
    done
    echo "Done"
else
    echo "Skipping disabling automatic updates."
fi

# **Disabling User Agents (gui/502)**
echo "Disabling User Agents"

# Diagnostics, Telemetry, and Reporting
read -e -p "(y/N) Do you want to disable Diagnostics, Telemetry, and Reporting services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Diagnostics, Telemetry, and Reporting services"
    TODISABLE="
    com.apple.ReportPanic
    com.apple.ReportCrash
    com.apple.ReportCrash.Self
    com.apple.DiagnosticReportCleanup.plist
    com.apple.appleseed.seedusaged
    com.apple.UsageTrackingAgent
    com.apple.BiomeAgent
    com.apple.biomesyncd
    com.apple.dataaccess.dataaccessd
    com.apple.intelligenceplatformd
    "
    for agent in $TODISABLE; do
        sudo launchctl disable gui/502/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Diagnostics, Telemetry, and Reporting services."
fi

# Communication and Collaboration
read -e -p "(y/N) Do you want to disable Communication and Collaboration services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Communication and Collaboration services"
    TODISABLE="
    com.apple.AddressBook.abd
    com.apple.AddressBook.SourceSync
    com.apple.AddressBook.AssistantService
    com.apple.AddressBook.ContactsAccountsService
    com.apple.ContactsAgent
    com.apple.avconferenced
    com.apple.CommCenter-osx
    com.apple.imagent
    com.apple.imtransferagent
    com.apple.telephonyutilities.callservicesd
    com.apple.CallHistoryPluginHelper
    com.apple.screensharing.MessagesAgent
    com.apple.screensharing.agent
    com.apple.screensharing.menuextra
    com.apple.familycircled
    com.apple.familycontrols.useragent
    com.apple.familynotificationd
    com.apple.ScreenTimeAgent
    com.apple.homed
    com.apple.sharingd
    "
    for agent in $TODISABLE; do
        sudo launchctl disable gui/502/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Communication and Collaboration services."
fi

# Media and Entertainment
read -e -p "(y/N) Do you want to disable Media and Entertainment services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Media and Entertainment services"
    TODISABLE="
    com.apple.AMPArtworkAgent
    com.apple.AMPDeviceDiscoveryAgent
    com.apple.AMPLibraryAgent
    com.apple.cloudphotod
    com.apple.CloudPhotosConfiguration
    com.apple.photoanalysisd
    com.apple.photolibraryd
    com.apple.mediaanalysisd
    com.apple.mediastream.mstreamd
    com.apple.mediaremoteagent
    com.apple.amp.mediasharingd
    com.apple.AMPSystemPlayerAgent
    com.apple.AMPDevicesAgent
    com.apple.iTunesHelper.launcher
    com.apple.itunescloudd
    com.apple.appstoreagent
    com.apple.videosubscriptionsd
    com.apple.newsd
    "
    for agent in $TODISABLE; do
        sudo launchctl disable gui/502/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Media and Entertainment services."
fi

# Assistant, Siri, and Automation
read -e -p "(y/N) Do you want to disable Assistant, Siri, and Automation services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Assistant, Siri, and Automation services"
    TODISABLE="
    com.apple.assistant_service
    com.apple.assistantd
    com.apple.siri.context.service
    com.apple.siriinferenced
    com.apple.sirittsd
    com.apple.SiriTTSTrainingAgent
    com.apple.siri-distributed-evaluation
    com.apple.speech.speechsynthesisd.x86_64
    com.apple.speech.speechsynthesisd.arm64
    com.apple.speech.synthesisserver
    com.apple.corespeechd
    com.apple.suggestd
    com.apple.parsecd
    com.apple.knowledge-agent
    com.apple.imautomatichistorydeletionagent
    "
    for agent in $TODISABLE; do
        sudo launchctl disable gui/502/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Assistant, Siri, and Automation services."
fi

# Cloud, Sync, and Backup
read -e -p "(y/N) Do you want to disable Cloud, Sync, and Backup services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Cloud, Sync, and Backup services"
    TODISABLE="
    com.apple.cloudpaird
    com.apple.icloud.fmfd
    com.apple.iCloudNotificationAgent
    com.apple.iCloudUserNotifications
    com.apple.icloud.searchpartyuseragent
    com.apple.protectedcloudstorage.protectedcloudkeysyncing
    com.apple.CloudSettingsSyncAgent
    com.apple.icloud.findmydeviced.findmydevice-user-agent
    com.apple.iCloudHelper
    com.apple.TMHelperAgent
    com.apple.TMHelperAgent.SetupOffer
    "
    for agent in $TODISABLE; do
        sudo launchctl disable gui/502/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Cloud, Sync, and Backup services."
fi

# Privacy and Security
read -e -p "(y/N) Do you want to disable Privacy and Security services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Privacy and Security services"
    TODISABLE="
    com.apple.ap.adprivacyd
    com.apple.ap.adservicesd
    com.apple.ap.promotedcontentd
    com.apple.TrustEvaluationAgent
    com.apple.security.cloudkeychainproxy3
    "
    for agent in $TODISABLE; do
        sudo launchctl disable gui/502/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Privacy and Security services."
fi

# Safari Services
read -e -p "(y/N) Do you want to disable Safari services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Safari services"
    TODISABLE="
    com.apple.SafariBookmarksSyncAgent
    com.apple.SafariHistoryServiceAgent
    com.apple.Safari.PasswordBreachAgent
    com.apple.Safari.SafeBrowsing.Service
    com.apple.SafariNotificationAgent
    com.apple.SafariLaunchAgent
    com.apple.Safari.History
    com.apple.SafariCloudHistoryPushAgent
    "
    for agent in $TODISABLE; do
        sudo launchctl disable gui/502/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Safari services."
fi

# Productivity and Utilities
read -e -p "(y/N) Do you want to disable Productivity and Utilities services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Productivity and Utilities services"
    TODISABLE="
    com.apple.CalendarAgent
    com.apple.calaccessd
    com.apple.helpd
    com.apple.mobiledeviceupdater
    com.apple.softwareupdate_notify_agent
    com.apple.quicklook
    com.apple.quicklook.ui.helper
    com.apple.quicklook.ThumbnailsAgent
    com.apple.remindd
    com.apple.routined
    com.apple.passd
    com.apple.networkserviceproxy-osx
    com.apple.tipsd
    com.apple.weatherd
    com.apple.financed
    "
    for agent in $TODISABLE; do
        sudo launchctl disable gui/502/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Productivity and Utilities services."
fi

# Miscellaneous User Services
read -e -p "(y/N) Do you want to disable Miscellaneous User Services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Miscellaneous User Services"
    TODISABLE="
    com.apple.accessibility.MotionTrackingAgent
    com.apple.accessibility.heard
    com.apple.universalaccessd
    com.apple.accessibility.dfrhud
    com.apple.accessibility.LiveTranscriptionAgent
    com.apple.ManagedClient.cloudconfigurationd
    com.apple.ManagedClientAgent.enrollagent
    com.apple.rapportd-user
    com.apple.sidecar-hid-relay
    com.apple.sidecar-relay
    com.apple.macos.studentd
    com.apple.triald
    com.apple.followupd
    com.apple.ensemble
    com.apple.parsec-fbf
    com.apple.nsurlsessiond
    "
    for agent in $TODISABLE; do
        sudo launchctl disable gui/502/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Miscellaneous User Services."
fi

echo "Done disabling User Agents"

# **Disabling System Agents (system)**
echo "Disabling System Agents"

# Networking and Connectivity
read -e -p "(y/N) Do you want to disable Networking and Connectivity services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Networking and Connectivity services"
    TODISABLE="
    com.apple.telnetd
    com.apple.tftpd
    com.apple.ftp-proxy
    com.apple.netbiosd
    com.apple.bootpd
    com.apple.dhcp6d
    com.apple.ftpd
    com.apple.networkserviceproxy
    com.apple.screensharing
    "
    for agent in $TODISABLE; do
        sudo launchctl disable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Networking and Connectivity services."
fi

# Cloud, Sync, and Backup
read -e -p "(y/N) Do you want to disable Cloud, Sync, and Backup services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Cloud, Sync, and Backup services"
    TODISABLE="
    com.apple.cloudd
    com.apple.cloudpaird
    com.apple.cloudphotod
    com.apple.CloudPhotosConfiguration
    com.apple.icloud.fmfd
    com.apple.icloud.searchpartyd
    com.apple.protectedcloudstorage.protectedcloudkeysyncing
    com.apple.icloud.findmydeviced
    com.apple.backupd
    com.apple.backupd-helper
    "
    for agent in $TODISABLE; do
        sudo launchctl disable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Cloud, Sync, and Backup services."
fi

# Diagnostics and Telemetry
read -e -p "(y/N) Do you want to disable Diagnostics and Telemetry services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Diagnostics and Telemetry services"
    TODISABLE="
    com.apple.analyticsd
    com.apple.osanalytics.osanalyticshelper
    com.apple.diagnosticd
    com.apple.symptomsd
    com.apple.spindump
    com.apple.metadata.mds.spindump
    com.apple.ReportPanic
    com.apple.ReportCrash
    com.apple.ReportCrash.Self
    com.apple.DiagnosticReportCleanup
    "
    for agent in $TODISABLE; do
        sudo launchctl disable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Diagnostics and Telemetry services."
fi

# Media and Location Services
read -e -p "(y/N) Do you want to disable Media and Location services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Media and Location services"
    TODISABLE="
    com.apple.amp.mediasharingd
    com.apple.mediaanalysisd
    com.apple.mediaremoteagent
    com.apple.photoanalysisd
    com.apple.voicememod
    com.apple.geod
    com.apple.locate
    com.apple.locationd
    com.apple.CoreLocationAgent
    com.apple.recentsd
    com.apple.suggestd
    "
    for agent in $TODISABLE; do
        sudo launchctl disable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Media and Location services."
fi

# Miscellaneous System Services
read -e -p "(y/N) Do you want to disable Miscellaneous System Services? " yn
if [ "$yn" = "y" ]; then
    echo "Disabling Miscellaneous System Services"
    TODISABLE="
    com.apple.java.InstallOnDemand
    com.apple.coreduetd
    com.apple.familycontrols
    com.apple.findmymacmessenger
    com.apple.followupd
    com.apple.FollowUpUI
    com.apple.GameController.gamecontrollerd
    com.apple.itunescloudd
    com.apple.ManagedClient.cloudconfigurationd
    com.apple.rapportd
    com.apple.triald.system
    com.apple.siri.acousticsignature
    com.apple.nsurlsessiond
    "
    for agent in $TODISABLE; do
        sudo launchctl disable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Failed to disable: ${agent}"
        fi
    done
    echo "Done"
else
    echo "Skipping Miscellaneous System Services."
fi

echo "Done disabling System Agents"

# **Reboot**
echo "Debloat done"
read -e -p "(y/N) Do you want to reboot now? " yn
if [ "$yn" = "y" ]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Defaulting to no."
    exit
fi