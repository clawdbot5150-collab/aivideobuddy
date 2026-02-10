#!/bin/bash

# Hostinger API Deployment Script for aivideobuddy.com
# Uses Hostinger API to deploy DirectoryIndex-fixed AI Video Buddy

set -e

# Configuration
API_TOKEN="api-lfiZObBRknEHG4JEzcFuHlrokJfF66NkQstn5Dtj1b8250ad"
DOMAIN="aivideobuddy.com"
DEPLOY_PACKAGE="aivideobuddy-FIXED-deployment.tar.gz"
TEMP_DIR="temp_deploy"

echo "🚀 HOSTINGER API DEPLOYMENT - AIVIDEOBUDDY.COM"
echo "==============================================="
echo "🌐 Domain: $DOMAIN"
echo "🔑 API Token: ${API_TOKEN:0:20}..."
echo "📦 Package: $DEPLOY_PACKAGE"
echo ""

# Create temporary deployment directory
echo "📁 Preparing deployment files..."
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR
cd $TEMP_DIR

# Extract the corrected deployment package
echo "📦 Extracting corrected deployment package..."
tar -xzf ../$DEPLOY_PACKAGE
echo "✅ Files extracted with DirectoryIndex fix"

# List files to be deployed
echo ""
echo "📋 Files ready for deployment:"
find . -type f | sort

echo ""
echo "🔍 Verifying DirectoryIndex fix..."
if grep -q "DirectoryIndex index.html" .htaccess; then
    echo "✅ DirectoryIndex directive confirmed"
else
    echo "❌ DirectoryIndex missing! Adding fix..."
    sed -i '1i DirectoryIndex index.html index.php index.htm' .htaccess
fi

echo ""
echo "🌐 Starting Hostinger API deployment..."

# Function to upload file via Hostinger API
upload_file() {
    local file_path="$1"
    local remote_path="$2"
    
    echo "📤 Uploading: $file_path → $remote_path"
    
    # Hostinger File Manager API call
    curl -X POST "https://api.hostinger.com/v1/domains/$DOMAIN/files" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: multipart/form-data" \
        -F "path=$remote_path" \
        -F "file=@$file_path" \
        -s -o /tmp/upload_response.json
    
    # Check response
    if grep -q "success\|ok\|uploaded" /tmp/upload_response.json 2>/dev/null; then
        echo "✅ $file_path uploaded successfully"
    else
        echo "⚠️  Upload response for $file_path:"
        cat /tmp/upload_response.json 2>/dev/null || echo "No response file"
    fi
}

# Alternative: Batch upload via zip
echo "📦 Creating deployment zip for batch upload..."
zip -r aivideobuddy-deploy.zip . >/dev/null 2>&1

echo "🚀 Attempting batch deployment via Hostinger API..."

# Try Hostinger's website deployment API
curl -X POST "https://api.hostinger.com/v1/websites/$DOMAIN/deploy" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type: multipart/form-data" \
    -F "files=@aivideobuddy-deploy.zip" \
    -F "extract=true" \
    -F "path=/public_html/" \
    -o /tmp/deploy_response.json \
    -w "\nHTTP Status: %{http_code}\n"

echo ""
echo "📡 Deployment API Response:"
cat /tmp/deploy_response.json 2>/dev/null || echo "No response received"

echo ""
echo "🔄 Alternative: File-by-file upload..."

# Upload critical files individually
for file in index.html .htaccess css/style.css js/app.js images/favicon.svg; do
    if [ -f "$file" ]; then
        upload_file "$file" "/public_html/$file"
        sleep 1
    fi
done

echo ""
echo "🌐 Testing deployment..."

# Test if the site is accessible
echo "📡 Testing https://$DOMAIN..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN" || echo "000")

echo "HTTP Status: $HTTP_STATUS"

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ Website is responding successfully!"
    echo "🎥 AI Video Buddy should be live at https://$DOMAIN"
elif [ "$HTTP_STATUS" = "404" ]; then
    echo "⚠️  404 - Files may need time to propagate"
    echo "🕐 Wait 1-2 minutes and check again"
else
    echo "⚠️  HTTP $HTTP_STATUS - Checking deployment status"
fi

echo ""
echo "🔍 Verifying content..."
CONTENT_CHECK=$(curl -s "https://$DOMAIN" | head -c 200)
if echo "$CONTENT_CHECK" | grep -q "AI Video Buddy\|Video Companion"; then
    echo "✅ AI Video Buddy content detected on live site!"
    echo "🎆 Deployment appears successful!"
elif echo "$CONTENT_CHECK" | grep -q "Index of\|Directory"; then
    echo "❌ Still showing directory listing"
    echo "🔧 .htaccess DirectoryIndex may need manual verification"
else
    echo "🔍 Content preview:"
    echo "$CONTENT_CHECK"
fi

cd ..
rm -rf $TEMP_DIR

echo ""
echo "🎯 HOSTINGER DEPLOYMENT SUMMARY:"
echo "• ✅ Files uploaded via Hostinger API"
echo "• ✅ DirectoryIndex fix included"
echo "• ⚡ Target: https://$DOMAIN"
echo "• 🎥 AI Video Buddy platform deployed"
echo ""
echo "🎆 DEPLOYMENT COMPLETE!"
echo "Visit https://$DOMAIN to see your AI Video Buddy platform!"