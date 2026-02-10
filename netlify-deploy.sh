#!/bin/bash

# Direct Netlify Deployment for aivideobuddy.com
# This bypasses GitHub Pages entirely

echo "🚀 DEPLOYING AI VIDEO BUDDY TO NETLIFY"
echo "======================================"

# Create deployment package
mkdir -p netlify-deploy
cp index.html netlify-deploy/
cp -r css netlify-deploy/ 2>/dev/null || echo "CSS dir not found, using inline styles"
cp -r js netlify-deploy/ 2>/dev/null || echo "JS dir not found, using inline scripts"
cp -r images netlify-deploy/ 2>/dev/null || echo "Images dir not found"

cd netlify-deploy

echo "📁 Files ready for deployment:"
ls -la

echo ""
echo "🌐 NETLIFY DEPLOYMENT INSTRUCTIONS:"
echo ""
echo "1. Go to https://app.netlify.com/drop"
echo "2. Drag and drop the netlify-deploy folder"
echo "3. Once deployed, configure custom domain:"
echo "   - Go to Domain settings"
echo "   - Add custom domain: aivideobuddy.com"
echo "   - Update DNS records as instructed"
echo ""
echo "✅ This will bypass GitHub Pages caching issues!"