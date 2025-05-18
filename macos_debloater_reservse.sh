#!/bin/bash

# macOS Silverback Re-enabler (Reverse for Debloater)
# v1.1

# This script attempts to revert changes made by macOS_Debloater.sh
# It re-enables launch agents and daemons and restores default settings.

# No need to disable SIP for re-enabling most services.
# Changes made by 'launchctl enable' will modify/remove entries in
# /private/var/db/com.apple.xpc.launchd/disabled.plist and disabled.<UID>.plist

# Enable to run file
# chmod +x ./macOS_Reenabler.sh

echo "macOS Re-enabler Script"
echo "This script will attempt to revert changes made by the Debloater."
echo "-----------------------------------------------------------------"

# **System Optimization Reversal**
read -e -p "(y/N) Do you want to restore default system visual settings? " yn
if [ "$yn" = "y" ]; then
    echo "Restoring default system visual settings..."
    # Restore animations and default desktop effects
    defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled # Default is true
    defaults delete NSGlobalDomain NSWindowResizeTime                 # Default is around 0.2
    defaults delete -g QLPanelAnimationDuration                      # Default is around 0.2
    defaults delete com.apple.dock autohide-time-modifier            # Default is 0
    defaults delete com.apple.Dock autohide-delay                    # Default is 0
    defaults delete com.apple.dock expose-animation-duration         # Default is around 0.15
    defaults write com.apple.dock launchanim -bool true
    defaults write com.apple.finder DisableAllAnimations -bool false
    defaults write com.apple.Accessibility DifferentiateWithoutColor -int 0
    defaults write com.apple.Accessibility ReduceMotionEnabled -int 0
    defaults write com.apple.universalaccess reduceMotion -int 0
    defaults write com.apple.universalaccess reduceTransparency -int 0
    # The original script had ReduceMotionEnabled twice, once is enough for reversal
    echo "Done"
else
    echo "Skipping system visual settings restoration."
fi

# **Enable application state on shutdown**
read -e -p "(y/N) Do you want to re-enable application state saving on shutdown? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling application state saving on shutdown..."
    defaults write com.apple.loginwindow TALLogoutSavesState -bool true # Or `defaults delete com.apple.loginwindow TALLogoutSavesState`
    echo "Done"
else
    echo "Skipping re-enabling application state on shutdown."
fi

# **Enable Spotlight**
read -e -p "(y/N) Do you want to re-enable Spotlight? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Spotlight..."
    sudo mdutil -i on -a
    echo "Spotlight indexing will resume. This may take some time."
    echo "Done"
else
    echo "Skipping re-enabling Spotlight."
fi

# **Enable automatic updates**
read -e -p "(y/N) Do you want to re-enable automatic updates? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling automatic updates..."
    UPDATES_TO_ENABLE="AutomaticDownload
    AutomaticCheckEnabled
    CriticalUpdateInstall
    ConfigDataInstall"
    for val in $UPDATES_TO_ENABLE; do
        # Setting to 1 enables them. Alternatively, `sudo defaults delete` could be used.
        sudo defaults write com.apple.SoftwareUpdate $val -int 1
    done
    echo "Done"
else
    echo "Skipping re-enabling automatic updates."
fi

CURRENT_UID=$(id -u)
echo "Targeting User Agents for UID: $CURRENT_UID"

# **Re-enabling User Agents (gui/<UID>)**
echo "Re-enabling User Agents"

# Diagnostics, Telemetry, and Reporting
read -e -p "(y/N) Do you want to re-enable Diagnostics, Telemetry, and Reporting services? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Diagnostics, Telemetry, and Reporting services..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable gui/${CURRENT_UID}/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable user agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Diagnostics, Telemetry, and Reporting services."
fi

# Communication and Collaboration
read -e -p "(y/N) Do you want to re-enable Communication and Collaboration services? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Communication and Collaboration services..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable gui/${CURRENT_UID}/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable user agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Communication and Collaboration services."
fi

# Media and Entertainment
read -e -p "(y/N) Do you want to re-enable Media and Entertainment services? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Media and Entertainment services..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable gui/${CURRENT_UID}/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable user agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Media and Entertainment services."
fi

# Assistant, Siri, and Automation
read -e -p "(y/N) Do you want to re-enable Assistant, Siri, and Automation services? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Assistant, Siri, and Automation services..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable gui/${CURRENT_UID}/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable user agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Assistant, Siri, and Automation services."
fi

# Cloud, Sync, and Backup
read -e -p "(y/N) Do you want to re-enable Cloud, Sync, and Backup services (User Agents)? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Cloud, Sync, and Backup services (User Agents)..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable gui/${CURRENT_UID}/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable user agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Cloud, Sync, and Backup services (User Agents)."
fi

# Privacy and Security
read -e -p "(y/N) Do you want to re-enable Privacy and Security services (User Agents)? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Privacy and Security services (User Agents)..."
    TOENABLE="
    com.apple.ap.adprivacyd
    com.apple.ap.adservicesd
    com.apple.ap.promotedcontentd
    com.apple.TrustEvaluationAgent
    com.apple.security.cloudkeychainproxy3
    "
    for agent in $TOENABLE; do
        sudo launchctl enable gui/${CURRENT_UID}/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable user agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Privacy and Security services (User Agents)."
fi

# Safari Services
read -e -p "(y/N) Do you want to re-enable Safari services (User Agents)? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Safari services (User Agents)..."
    TOENABLE="
    com.apple.SafariBookmarksSyncAgent
    com.apple.SafariHistoryServiceAgent
    com.apple.Safari.PasswordBreachAgent
    com.apple.Safari.SafeBrowsing.Service
    com.apple.SafariNotificationAgent
    com.apple.SafariLaunchAgent
    com.apple.Safari.History
    com.apple.SafariCloudHistoryPushAgent
    "
    for agent in $TOENABLE; do
        sudo launchctl enable gui/${CURRENT_UID}/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable user agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Safari services (User Agents)."
fi

# Productivity and Utilities
read -e -p "(y/N) Do you want to re-enable Productivity and Utilities services (User Agents)? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Productivity and Utilities services (User Agents)..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable gui/${CURRENT_UID}/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable user agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Productivity and Utilities services (User Agents)."
fi

# Miscellaneous User Services
read -e -p "(y/N) Do you want to re-enable Miscellaneous User Services? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Miscellaneous User Services..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable gui/${CURRENT_UID}/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable user agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Miscellaneous User Services."
fi

echo "Done re-enabling User Agents"

# **Re-enabling System Agents (system)**
echo "Re-enabling System Agents"

# Networking and Connectivity
read -e -p "(y/N) Do you want to re-enable Networking and Connectivity services (System Agents)? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Networking and Connectivity services (System Agents)..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable system agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Networking and Connectivity services (System Agents)."
fi

# Cloud, Sync, and Backup (System)
read -e -p "(y/N) Do you want to re-enable Cloud, Sync, and Backup services (System Agents)? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Cloud, Sync, and Backup services (System Agents)..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable system agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Cloud, Sync, and Backup services (System Agents)."
fi

# Diagnostics and Telemetry (System)
read -e -p "(y/N) Do you want to re-enable Diagnostics and Telemetry services (System Agents)? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Diagnostics and Telemetry services (System Agents)..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable system agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Diagnostics and Telemetry services (System Agents)."
fi

# Media and Location Services (System)
read -e -p "(y/N) Do you want to re-enable Media and Location services (System Agents)? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Media and Location services (System Agents)..."
    TOENABLE="
    com.apple.amp.mediasharingd
    com.apple.mediaanalysisd
    com.apple.mediaremoteagent
    com.apple.photoanalysisd
    com.apple.voicememod
    com.apple.audiomxd
    com.apple.geod
    com.apple.locate
    com.apple.locationd
    com.apple.CoreLocationAgent
    com.apple.recentsd
    com.apple.suggestd
    "
    for agent in $TOENABLE; do
        sudo launchctl enable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable system agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Media and Location services (System Agents)."
fi

# Miscellaneous System Services
read -e -p "(y/N) Do you want to re-enable Miscellaneous System Services? " yn
if [ "$yn" = "y" ]; then
    echo "Re-enabling Miscellaneous System Services..."
    TOENABLE="
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
    for agent in $TOENABLE; do
        sudo launchctl enable system/${agent}
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable system agent: ${agent} (it might not have been disabled or may not exist)"
        fi
    done
    echo "Done"
else
    echo "Skipping Miscellaneous System Services."
fi

echo "Done re-enabling System Agents"

# **Reboot**
echo "Re-enabling process complete."
read -e -p "(y/N) It is recommended to reboot for all changes to take full effect. Do you want to reboot now? " yn
if [ "$yn" = "y" ]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Please reboot your Mac manually at your convenience."
    exit
fi
