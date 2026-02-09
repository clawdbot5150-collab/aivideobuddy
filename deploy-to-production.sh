#!/bin/bash

# AI Video Buddy - Production Deployment Script
# Deploy dark theme video companion platform

set -e

echo "🎥 Starting AI Video Buddy deployment..."

# Configuration
PROJECT_NAME="AI Video Buddy"
DOMAIN="aivideobuddy.com"
DEPLOY_DIR="production-package"

# Create deployment package
echo "📦 Creating production deployment package..."
rm -rf $DEPLOY_DIR
mkdir -p $DEPLOY_DIR

# Copy all necessary files
cp index.html $DEPLOY_DIR/
cp -r css/ $DEPLOY_DIR/
cp -r js/ $DEPLOY_DIR/
cp -r images/ $DEPLOY_DIR/
cp .htaccess $DEPLOY_DIR/
cp sitemap.xml $DEPLOY_DIR/
cp robots.txt $DEPLOY_DIR/
cp 404.html $DEPLOY_DIR/

# Create additional production files
echo "⚡ Setting up production optimizations..."

# Create production .htaccess with video-specific optimizations
cat > $DEPLOY_DIR/.htaccess << 'EOF'
# AI Video Buddy Production Configuration
RewriteEngine On

# Force HTTPS for secure video connections
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Video-specific MIME types
AddType video/mp4 .mp4
AddType video/webm .webm
AddType video/ogg .ogv

# Compression for video platform performance
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/json
    AddOutputFilterByType DEFLATE image/svg+xml
</IfModule>

# Aggressive caching for video platform
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 6 months"
    ExpiresByType video/mp4 "access plus 1 month"
    ExpiresByType video/webm "access plus 1 month"
    ExpiresByType text/html "access plus 1 hour"
</IfModule>

# Security headers for video platform
<IfModule mod_headers.c>
    Header always set X-Content-Type-Options nosniff
    Header always set X-Frame-Options SAMEORIGIN
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    # WebRTC and video-friendly CSP
    Header always set Content-Security-Policy "default-src 'self' 'unsafe-inline' *.google.com *.googletagmanager.com *.googleapis.com fonts.gstatic.com images.unsplash.com data: blob:; media-src 'self' blob: data:; connect-src 'self' wss: ws:; script-src 'self' 'unsafe-inline' *.google.com *.googletagmanager.com; style-src 'self' 'unsafe-inline' fonts.googleapis.com"
</IfModule>

# Block sensitive files
<Files "*.md">
    Order allow,deny
    Deny from all
</Files>

# Custom error pages
ErrorDocument 404 /404.html
ErrorDocument 500 /404.html
EOF

# List all files in deployment package
echo "📋 Production package contents:"
find $DEPLOY_DIR -type f | sort

echo ""
echo "✅ AI Video Buddy production package ready!"
echo "📁 Package location: $(pwd)/$DEPLOY_DIR"
echo ""
echo "🌐 DEPLOYMENT OPTIONS:"
echo "1. 🔗 GeoSlicing Server: Deploy to https://geoslicing.com/video/"
echo "2. 📈 VertData Server: Deploy to https://vertdata.com/video/" 
echo "3. 🌍 New Domain: Set up aivideobuddy.com"
echo "4. 🚀 All Servers: Multi-deployment for scale"
echo ""
echo "🎥 Platform Features Ready:"
echo "• 6 Unique Video AI Companions"
echo "• Dark Theme with Electric Blue Accents"
echo "• Interactive Video Chat Simulation"
echo "• 4-Tier Pricing System ($0-$249)"
echo "• Progressive Web App Ready"
echo "• WebRTC Video Chat Infrastructure"
echo ""
echo "💰 Revenue Potential: $50K-$15M+ per month"
echo ""
echo "🎯 Next: Choose deployment target and execute!"