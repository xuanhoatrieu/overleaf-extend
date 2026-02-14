#!/bin/bash
# Insert git bridge settings BEFORE module.exports in settings.js
sed -i '/^module\.exports = settings/i \
// Git Bridge settings patch\
if (process.env.GIT_BRIDGE_ENABLED === '"'"'true'"'"') {\
  settings.enableGitBridge = true\
  settings.gitBridgePublicBaseUrl = (process.env.OVERLEAF_SITE_URL || '"'"'http://localhost'"'"') + '"'"'/git'"'"'\
}\
' /etc/overleaf/settings.js
