#!/bin/bash

# Quick Fix Deployment for aivideobuddy.com
# Fixes the DirectoryIndex issue causing directory listing

set -e

echo "🔧 QUICK FIX DEPLOYMENT FOR AIVIDEOBUDDY.COM"
echo "==============================================="
echo "🎯 Issue: Directory listing instead of website"
echo "✅ Fix: Updated .htaccess with DirectoryIndex"
echo ""

DEPLOY_DIR="aivideobuddy-domain-package"

# Check if deployment package exists
if [ ! -d "$DEPLOY_DIR" ]; then
    echo "❌ Deployment package not found. Running deploy script first..."
    ./deploy-to-aivideobuddy.sh
fi

echo "📁 Deployment package ready: $DEPLOY_DIR/"
echo ""
echo "🔍 Verifying .htaccess fix..."
if grep -q "DirectoryIndex index.html" "$DEPLOY_DIR/.htaccess"; then
    echo "✅ DirectoryIndex directive found in .htaccess"
else
    echo "❌ DirectoryIndex directive missing! Adding it now..."
    # Add DirectoryIndex to the top of .htaccess
    sed -i '1i DirectoryIndex index.html index.php index.htm' "$DEPLOY_DIR/.htaccess"
    echo "✅ DirectoryIndex directive added"
fi

echo ""
echo "📋 MANUAL DEPLOYMENT STEPS FOR HOSTINGER:"
echo ""
echo "1. 📥 Download these files to your local machine:"
echo "   - All files from: $PWD/$DEPLOY_DIR/"
echo ""
echo "2. 🌐 Login to Hostinger hPanel:"
echo "   - Go to hpanel.hostinger.com"
echo "   - Select aivideobuddy.com domain"
echo "   - Click 'File Manager'"
echo ""
echo "3. 🗑️ Clear public_html directory:"
echo "   - Navigate to public_html/"
echo "   - Select ALL files (Ctrl+A)"
echo "   - Click 'Delete' and confirm"
echo ""
echo "4. ⬆️ Upload fixed files:"
echo "   - Click 'Upload Files'"
echo "   - Select all files from $DEPLOY_DIR/"
echo "   - Wait for upload to complete"
echo ""
echo "5. 🔐 Set permissions:"
echo "   - Select all files"
echo "   - Right-click → 'Change Permissions'"
echo "   - Files: 644, Folders: 755"
echo ""
echo "6. 🎯 Test the fix:"
echo "   - Visit https://aivideobuddy.com"
echo "   - Should now show the AI Video Buddy platform"
echo "   - No more directory listing!"
echo ""
echo "📦 Alternative: Upload the pre-built archive:"
echo "   - Upload: aivideobuddy-com-deployment.tar.gz"
echo "   - Extract in public_html/"
echo "   - Set permissions as above"
echo ""
echo "🎥 EXPECTED RESULT AFTER FIX:"
echo "• ⚡ Dark cyberpunk theme with electric blue accents"
echo "• 🎭 6 AI Video Companions (Nova, Zoe, Luna, Aria, Rex, Maya)"
echo "• 💰 Pricing tiers from FREE to \$249/month"
echo "• 🔮 Interactive personality quiz"
echo "• 📱 Mobile-optimized responsive design"
echo "• ✨ Smooth animations and neon glow effects"
echo ""
echo "🎆 DEPLOYMENT PACKAGE READY FOR UPLOAD!"
echo "The DirectoryIndex issue will be fixed once uploaded."

# Create a quick-upload package
echo ""
echo "📦 Creating quick-upload package..."
tar -czf aivideobuddy-FIXED-deployment.tar.gz -C "$DEPLOY_DIR" .
echo "✅ Created: aivideobuddy-FIXED-deployment.tar.gz"
echo ""
echo "🚀 UPLOAD THIS FILE TO HOSTINGER:"
echo "   1. Upload aivideobuddy-FIXED-deployment.tar.gz to public_html/"
echo "   2. Right-click → Extract"
echo "   3. Delete the .tar.gz file"
echo "   4. Visit https://aivideobuddy.com"
echo ""
echo "🎯 SITE WILL BE FIXED AND OPERATIONAL!"