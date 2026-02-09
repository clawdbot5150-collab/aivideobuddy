#!/bin/bash

# AI Video Buddy - Deploy to GeoSlicing Server
# Deploy to https://geoslicing.com/video/

set -e

echo "🎥 DEPLOYING AI VIDEO BUDDY TO GEOSLICING SERVER!"
echo "═══════════════════════════════════════════════"
echo "🎯 Target: https://geoslicing.com/video/"
echo "🌐 Server: 31.220.31.142 (GeoSlicing VPS)"
echo ""

# Check if production package exists
if [ ! -d "production-package" ]; then
    echo "❌ Production package not found. Run ./deploy-to-production.sh first"
    exit 1
fi

# Create video directory structure locally
echo "📁 Setting up video deployment structure..."
mkdir -p geoslicing-deployment/video
cp -r production-package/* geoslicing-deployment/video/

# Package for easy transfer
echo "📦 Creating deployment archive..."
tar -czf aivideobuddy-geoslicing.tar.gz geoslicing-deployment/

echo ""
echo "✅ AI Video Buddy ready for GeoSlicing deployment!"
echo ""
echo "🚀 MANUAL DEPLOYMENT STEPS:"
echo "1. Transfer files to GeoSlicing server:"
echo "   scp -r geoslicing-deployment/video root@31.220.31.142:/var/www/geoslicing/"
echo ""
echo "2. Configure Nginx route (add to nginx config):"
echo "   location /video/ {"
echo "       try_files \$uri \$uri/ /video/index.html;"
echo "       expires 1h;"
echo "   }"
echo ""
echo "3. Restart Nginx:"
echo "   systemctl reload nginx"
echo ""
echo "4. Test deployment:"
echo "   https://geoslicing.com/video/"
echo ""
echo "🎥 AI Video Buddy will be live at: https://geoslicing.com/video/"
echo ""
echo "💎 Features Ready:"
echo "• Dark Theme Video Companion Platform"
echo "• 6 Unique AI Companions with Video Chat"
echo "• Electric Blue Design with Neon Effects"
echo "• 4-Tier Pricing System ($0-$249)"
echo "• Mobile-Optimized Progressive Web App"
echo ""
echo "📦 Package: aivideobuddy-geoslicing.tar.gz (ready for upload)"