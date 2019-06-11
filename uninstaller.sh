#!/bin/bash

UnloadPlistForAllUsers() {
  plistFile="$1"
  localAccountNameList=$(/usr/bin/dscl . list /Users UniqueID | /usr/bin/awk '$2 > 500 && $2 < 999 {print $1}')
  # Unload as each user
  for localAccountName in $localAccountNameList;do
    /usr/bin/sudo -u "$localAccountName" /bin/launchctl unload "$plistFile" &> /dev/null
  done
  # Unload as root
  /bin/launchctl unload "$plistFile" &> /dev/null
}

# Remove agent
UnloadPlistForAllUsers /Library/LaunchAgents/jp.co.motex.LspCatMac.plugin.OperationLogU.plist
/bin/rm -f /Library/LaunchAgents/jp.co.motex.LspCatMac.plugin.OperationLogU.plist

# Remove daemon
UnloadPlistForAllUsers /Library/LaunchDaemons/jp.co.motex.LspCatMac.Agent.plist
/bin/rm -f /Library/LaunchDaemons/jp.co.motex.LspCatMac.Agent.plist

# Remove CWS case pattern settings
cwsAgentPlist="/Library/LaunchDaemons/com.iw.cws.agent.plist"
if [ -e "$cwsAgentPlist" ];then
  UnloadPlistForAllUsers "$cwsAgentPlist"
  UnloadPlistForAllUsers /Library/LaunchDaemons/com.iw.cws.preventer.plist
  UnloadPlistForAllUsers /Library/LaunchDaemons/com.jx.dxt.dxtpreventd.plist

  /usr/bin/killall cwsFrontWindowX &> /dev/null
  /usr/bin/killall nsws2 &> /dev/null
  /usr/bin/killall cwsFileLogX39 &> /dev/null

  /bin/rm -rf /etc/.b
  /bin/rm -rf /etc/bvr
  /bin/rm -rf /var/log/cwsAgent
  /bin/rm -rf /var/spool/.cws
  /bin/rm -rf /usr/sbin/dxtpreventd
  /bin/rm -rf /Library/Receipts/cwsx*.pkg

  # Reset device control
  /usr/local/cwsAgent/bin/cwsDeviceControl -0 &> /dev/null

  /bin/rm -rf /usr/local/cwsAgent
  /bin/rm -rf /usr/local/cwsPreventer

  /usr/bin/defaults delete com.apple.loginwindow LoginHook &> /dev/null
  /usr/bin/defaults delete com.apple.loginwindow LogoutHook &> /dev/null

  /bin/rm -f "$cwsAgentPlist"
  /bin/rm -f /Library/LaunchDaemons/com.iw.cws.preventer.plist
  /bin/rm -f /Library/LaunchDaemons/com.jx.dxt.dxtpreventd.plist
fi

# Remove Logs
/bin/rm -rf /var/log/LspCatMacAgent

# Remove Spools
/bin/rm -rf /var/spool/LspCatMacAgent

# Remove Agent Binaries
/bin/rm -rf /usr/local/LspCatMacAgent

exit 0
