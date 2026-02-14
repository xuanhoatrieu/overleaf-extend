// Git Bridge settings patch for Extended CE
// Append to /etc/overleaf/settings.js

if (process.env.GIT_BRIDGE_ENABLED === 'true') {
    settings.enableGitBridge = true
    settings.gitBridgePublicBaseUrl =
        (process.env.OVERLEAF_SITE_URL || 'http://localhost') + '/git'
}
