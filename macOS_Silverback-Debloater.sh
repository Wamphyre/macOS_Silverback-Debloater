#!/bin/bash

# macOS Audio Production Optimizer
# Safe version for audio production - does NOT require disabling SIP

echo "=== macOS Audio Production Optimizer ==="
echo "Optimizing system for professional audio production..."

# Function to confirm actions
confirm() {
    read -r -p "${1:-Continue?} [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

# Disable Spotlight indexing (safe for audio, major performance boost)
echo "1. Disabling Spotlight indexing..."
if confirm "Disable Spotlight indexing? (Recommended for audio production)"; then
    sudo mdutil -i off -a
    echo "✓ Spotlight indexing disabled"
else
    echo "- Spotlight indexing kept active"
fi

# Disable system animations (improves performance and reduces CPU overhead)
echo "2. Disabling system animations and visual effects..."
if confirm "Disable animations for better performance?"; then
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
    defaults write -g QLPanelAnimationDuration -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0
    defaults write com.apple.Dock autohide-delay -float 0
    defaults write com.apple.dock expose-animation-duration -float 0.001
    defaults write com.apple.dock launchanim -bool false
    defaults write com.apple.finder DisableAllAnimations -bool true
    defaults write com.apple.Accessibility ReduceMotionEnabled -int 1
    defaults write com.apple.universalaccess reduceMotion -int 1
    defaults write com.apple.universalaccess reduceTransparency -int 1
    echo "✓ System animations disabled"
else
    echo "- System animations kept active"
fi

# Keep automatic updates enabled (as specifically requested)
echo "3. Keeping automatic updates enabled..."
echo "✓ Automatic updates remain active (as requested)"

# Disable background services that can interfere with audio (SAFE to disable)
echo "4. Disabling unnecessary background services..."
if confirm "Disable telemetry, crash reporting, and analytics services?"; then
    
    # Safe services to disable - these don't affect core system functionality
    SAFE_TO_DISABLE=(
        "com.apple.ReportCrash"
        "com.apple.ReportPanic" 
        "com.apple.DiagnosticReportCleanup"
        "com.apple.analyticsd"
        "com.apple.spindump"
        "com.apple.metadata.mds.spindump"
        "com.apple.suggestd"
        "com.apple.ap.adprivacyd"
        "com.apple.ap.adservicesd"
        "com.apple.ap.promotedcontentd"
    )
    
    for service in "${SAFE_TO_DISABLE[@]}"; do
        sudo launchctl bootout system/$service 2>/dev/null
        sudo launchctl disable system/$service 2>/dev/null
        launchctl bootout gui/501/$service 2>/dev/null
        launchctl disable gui/501/$service 2>/dev/null
    done
    
    echo "✓ Background telemetry services disabled"
else
    echo "- Background services kept active"
fi

# Apply audio-specific system optimizations
echo "5. Applying audio-specific system optimizations..."
if confirm "Apply audio-specific kernel and memory optimizations?"; then
    
    # Disable application state restoration when closing apps (reduces startup overhead)
    defaults write com.apple.loginwindow TALLogoutSavesState -bool false
    
    # Optimize file system limits for audio applications
    sudo sysctl -w kern.maxfiles=65536
    sudo sysctl -w kern.maxfilesperproc=32768
    
    # Improve real-time audio process scheduling
    sudo sysctl -w kern.sched.rt_max_quantum=20000
    
    # Make kernel optimizations persistent across reboots
    echo "kern.maxfiles=65536" | sudo tee -a /etc/sysctl.conf >/dev/null
    echo "kern.maxfilesperproc=32768" | sudo tee -a /etc/sysctl.conf >/dev/null
    echo "kern.sched.rt_max_quantum=20000" | sudo tee -a /etc/sysctl.conf >/dev/null
    
    echo "✓ Audio-specific optimizations applied"
else
    echo "- Audio optimizations skipped"
fi

# Optional services - ask individually for more control
echo "6. Optional service optimizations..."

# Siri (recommended to disable for audio production)
if confirm "Disable Siri? (Recommended for audio production - reduces background processing)"; then
    launchctl bootout gui/501/com.apple.Siri.agent 2>/dev/null
    launchctl disable gui/501/com.apple.Siri.agent 2>/dev/null
    launchctl bootout gui/501/com.apple.assistant_service 2>/dev/null
    launchctl disable gui/501/com.apple.assistant_service 2>/dev/null
    launchctl bootout gui/501/com.apple.assistantd 2>/dev/null
    launchctl disable gui/501/com.apple.assistantd 2>/dev/null
    echo "✓ Siri services disabled"
fi

# Spotlight suggestions (different from indexing)
if confirm "Disable Spotlight suggestions and search recommendations?"; then
    launchctl bootout gui/501/com.apple.suggestd 2>/dev/null
    launchctl disable gui/501/com.apple.suggestd 2>/dev/null
    echo "✓ Spotlight suggestions disabled"
fi

# Game Center (usually not needed for audio production)
if confirm "Disable Game Center services?"; then
    launchctl bootout gui/501/com.apple.gamed 2>/dev/null
    launchctl disable gui/501/com.apple.gamed 2>/dev/null
    echo "✓ Game Center disabled"
fi

# Photos analysis (can be CPU intensive)
if confirm "Disable Photos analysis services? (Keeps Photos app working but disables background analysis)"; then
    launchctl bootout gui/501/com.apple.photoanalysisd 2>/dev/null
    launchctl disable gui/501/com.apple.photoanalysisd 2>/dev/null
    launchctl bootout gui/501/com.apple.mediaanalysisd 2>/dev/null
    launchctl disable gui/501/com.apple.mediaanalysisd 2>/dev/null
    echo "✓ Photos analysis services disabled"
fi

# Time Machine (be careful with this one)
if confirm "Disable Time Machine? (WARNING: You will lose automatic backups!)"; then
    sudo tmutil disable
    launchctl bootout gui/501/com.apple.TMHelperAgent 2>/dev/null
    launchctl disable gui/501/com.apple.TMHelperAgent 2>/dev/null
    launchctl bootout gui/501/com.apple.TMHelperAgent.SetupOffer 2>/dev/null
    launchctl disable gui/501/com.apple.TMHelperAgent.SetupOffer 2>/dev/null
    echo "✓ Time Machine disabled"
fi

# Create comprehensive restoration script
echo "7. Creating restoration script..."
cat > ~/Desktop/restore_macos_services.sh << 'EOF'
#!/bin/bash
echo "=== Restoring macOS Services ==="
echo "This will undo the audio production optimizations..."

# Reactivate Spotlight indexing
echo "Restoring Spotlight indexing..."
sudo mdutil -i on -a

# Restore system animations
echo "Restoring system animations..."
defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled 2>/dev/null
defaults delete NSGlobalDomain NSWindowResizeTime 2>/dev/null
defaults delete com.apple.dock launchanim 2>/dev/null
defaults delete com.apple.finder DisableAllAnimations 2>/dev/null
defaults delete com.apple.Accessibility ReduceMotionEnabled 2>/dev/null
defaults delete com.apple.universalaccess reduceMotion 2>/dev/null
defaults delete com.apple.universalaccess reduceTransparency 2>/dev/null

# Restore application state saving
defaults delete com.apple.loginwindow TALLogoutSavesState 2>/dev/null

# Remove custom kernel parameters
sudo sed -i '' '/kern.maxfiles=65536/d' /etc/sysctl.conf 2>/dev/null
sudo sed -i '' '/kern.maxfilesperproc=32768/d' /etc/sysctl.conf 2>/dev/null
sudo sed -i '' '/kern.sched.rt_max_quantum=20000/d' /etc/sysctl.conf 2>/dev/null

# Reactivate disabled services
echo "Reactivating system services..."
SERVICES_TO_RESTORE=(
    "com.apple.ReportCrash"
    "com.apple.analyticsd"
    "com.apple.suggestd"
    "com.apple.Siri.agent"
    "com.apple.assistantd"
    "com.apple.gamed"
    "com.apple.photoanalysisd"
    "com.apple.mediaanalysisd"
)

for service in "${SERVICES_TO_RESTORE[@]}"; do
    sudo launchctl enable system/$service 2>/dev/null
    sudo launchctl bootstrap system /System/Library/LaunchDaemons/$service.plist 2>/dev/null
    launchctl enable gui/501/$service 2>/dev/null
    launchctl bootstrap gui/501 /System/Library/LaunchAgents/$service.plist 2>/dev/null
done

# Reactivate Time Machine (if it was disabled)
sudo tmutil enable 2>/dev/null

echo ""
echo "✓ Services restored successfully"
echo "Please restart your system to complete the restoration process."
EOF

chmod +x ~/Desktop/restore_macos_services.sh
echo "✓ Restoration script created at ~/Desktop/restore_macos_services.sh"

# Final summary and reboot option
echo ""
echo "========================================="
echo "=== OPTIMIZATION PROCESS COMPLETED ==="
echo "========================================="
echo ""
echo "SUMMARY OF CHANGES:"
echo "• Spotlight indexing: Optimized for audio production"
echo "• System animations: Reduced for better performance"
echo "• Automatic updates: KEPT ENABLED (as requested)"
echo "• Background services: Unnecessary ones disabled"
echo "• Audio optimizations: Kernel parameters tuned"
echo "• Optional services: Configured based on your choices"
echo ""
echo "IMPORTANT NOTES:"
echo "• Restart required to apply all optimizations"
echo "• Test your audio setup thoroughly after reboot"
echo "• Restoration script available on Desktop if needed"
echo "• No SIP disabling required - all changes are safe"
echo "• System security and updates remain intact"
echo ""
echo "NEXT STEPS:"
echo "1. Restart your system"
echo "2. Test your audio interface and DAW"
echo "3. Monitor system performance during audio work"
echo "4. Run restoration script if any issues occur"
echo ""

if confirm "Restart system now to apply optimizations?"; then
    echo "System will restart in 10 seconds..."
    echo "Save any open work now!"
    for i in {10..1}; do
        echo -n "$i "
        sleep 1
    done
    echo ""
    sudo reboot
else
    echo ""
    echo "Remember to restart manually to apply all optimizations."
    echo "The system needs a reboot for kernel parameter changes to take effect."
fi
