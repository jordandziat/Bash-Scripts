#!/bin/sh
#
# Lock Xprotect from modifications
chflags uchg /System/Library/CoreServices/Coretypes.bundle/Contents/Resources/Xprotect.meta.plist

# disable the xprotectupdater job
LAUNCHD_JOB_PLIST="$3/System/Library/LaunchDaemons/com.apple.xprotectupdater.plist"
/bin/launchctl unload -w "$LAUNCHD_JOB_PLIST"