#' @include daemon.R
# sudo cp /var/osquery/com.facebook.osqueryd.plist /Library/LaunchDaemons/
# sudo launchctl load /Library/LaunchDaemons/com.facebook.osqueryd.plist
# sudo launchctl start /Library/LaunchDaemons/com.facebook.osqueryd.plist
# sudo dscl . append /Groups/wheel GroupMembership username