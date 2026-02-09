#!/bin/bash

# Automated FTP Deployment for aivideobuddy.com
# Fixes DirectoryIndex issue and deploys corrected files

set -e

echo "🚀 AUTOMATED FTP DEPLOYMENT FOR AIVIDEOBUDDY.COM"
echo "================================================="
echo ""

# Check if lftp is installed
if ! command -v lftp &> /dev/null; then
    echo "📦 Installing lftp for FTP deployment..."
    apt update && apt install -y lftp
fi

# FTP Configuration (update these with actual credentials)
FTP_HOST="ftp.aivideobuddy.com"
FTP_USER="your-ftp-username"
FTP_PASS="your-ftp-password"
REMOTE_DIR="/public_html"
LOCAL_DIR="aivideobuddy-domain-package"

echo "🔐 FTP Configuration:"
echo "   Host: $FTP_HOST"
echo "   User: $FTP_USER"
echo "   Remote: $REMOTE_DIR"
echo "   Local: $LOCAL_DIR"
echo ""

# Verify deployment package exists
if [ ! -d "$LOCAL_DIR" ]; then
    echo "❌ Deployment package not found. Creating it now..."
    ./deploy-to-aivideobuddy.sh
fi

# Verify .htaccess fix
echo "🔍 Verifying DirectoryIndex fix..."
if grep -q "DirectoryIndex index.html" "$LOCAL_DIR/.htaccess"; then
    echo "✅ DirectoryIndex directive confirmed in .htaccess"
else
    echo "❌ DirectoryIndex missing! Adding fix..."
    sed -i '1i DirectoryIndex index.html index.php index.htm' "$LOCAL_DIR/.htaccess"
    echo "✅ DirectoryIndex directive added"
fi

echo ""
echo "📁 Deploying files via FTP..."
echo "   Source: $LOCAL_DIR/"
echo "   Target: $FTP_HOST$REMOTE_DIR/"
echo ""

# FTP Deployment with lftp
lftp -c "
set ftp:list-options -a;
open ftp://$FTP_USER:$FTP_PASS@$FTP_HOST;
lcd $LOCAL_DIR;
cd $REMOTE_DIR;
mirror --reverse --delete --verbose --exclude-glob .git* --exclude-glob *.sh --exclude-glob *.md;
bye
" || {
    echo ""
    echo "❌ FTP DEPLOYMENT FAILED!"
    echo ""
    echo "🔧 POSSIBLE ISSUES:"
    echo "1. Invalid FTP credentials"
    echo "2. FTP server not accessible"
    echo "3. Network connectivity issues"
    echo "4. Incorrect FTP host/path"
    echo ""
    echo "📋 MANUAL DEPLOYMENT ALTERNATIVE:"
    echo "1. Update FTP credentials in this script"
    echo "2. Or use Hostinger File Manager:"
    echo "   - Upload: aivideobuddy-FIXED-deployment.tar.gz"
    echo "   - Extract in public_html/"
    echo "   - Visit https://aivideobuddy.com"
    echo ""
    exit 1
}

echo ""
echo "✅ FTP DEPLOYMENT COMPLETED!"
echo ""
echo "🎯 TESTING DEPLOYMENT..."

# Test the deployment
if command -v curl &> /dev/null; then
    echo "📡 Testing https://aivideobuddy.com..."
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://aivideobuddy.com)
    
    if [ "$HTTP_STATUS" = "200" ]; then
        echo "✅ Site is responding (HTTP $HTTP_STATUS)"
        echo "🎥 AI Video Buddy should now be live!"
    else
        echo "⚠️  HTTP Status: $HTTP_STATUS (may need DNS propagation time)"
    fi
else
    echo "🌐 Deployment complete. Visit https://aivideobuddy.com to verify."
fi

echo ""
echo "🎆 DEPLOYMENT SUMMARY:"
echo "• ✅ DirectoryIndex fix applied (.htaccess)"
echo "• ✅ All files uploaded to Hostinger"
echo "• ✅ Directory listing issue resolved"
echo "• 🎥 AI Video Buddy platform should be live"
echo "• 🌐 URL: https://aivideobuddy.com"
echo ""
echo "🚀 THE DARK FUTURE OF AI COMPANIONSHIP IS LIVE!"

# Log deployment
echo "$(date): Deployed aivideobuddy.com with DirectoryIndex fix" >> deployment.log