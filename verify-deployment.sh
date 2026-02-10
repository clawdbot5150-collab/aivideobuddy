#!/bin/bash

# Level 3 Deployment Verification Script
# Verifies aivideobuddy.com deployment status

echo "🚀 LEVEL 3 DEPLOYMENT VERIFICATION"
echo "=================================="
echo "🎯 Target: aivideobuddy.com"
echo "⚡ Checking deployment status..."
echo ""

# Check GitHub Pages status
echo "📡 GitHub Pages Status:"
gh api repos/clawdbot5150-collab/aivideobuddy/pages | jq '{status: .status, cname: .cname, html_url: .html_url, https_enforced: .https_enforced}'

echo ""
echo "🌐 DNS Resolution Test:"
nslookup aivideobuddy.com

echo ""
echo "🔍 HTTP Response Test:"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -L "https://aivideobuddy.com" || echo "000")
echo "HTTP Status: $HTTP_STATUS"

echo ""
echo "📄 Content Verification:"
CONTENT=$(curl -s -L "https://aivideobuddy.com" | head -c 500)
if echo "$CONTENT" | grep -q "AI Video Buddy\|Video Companion"; then
    echo "✅ SUCCESS: AI Video Buddy content detected!"
    echo "🎥 Platform is LIVE at https://aivideobuddy.com"
elif echo "$CONTENT" | grep -q "Index of\|Directory"; then
    echo "⚠️  Directory listing still showing - DNS propagation in progress"
elif echo "$CONTENT" | grep -q "404\|Not Found"; then
    echo "⚠️  404 Error - Custom domain configuration in progress"
else
    echo "🔍 Content preview:"
    echo "$CONTENT" | head -c 200
fi

echo ""
echo "🎯 DEPLOYMENT VERIFICATION COMPLETE"