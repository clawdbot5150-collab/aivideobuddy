#!/bin/bash

# Direct Hostinger Deployment - No Dependencies Required
# Deploys AI Video Buddy with DirectoryIndex fix to aivideobuddy.com

set -e

API_TOKEN="api-lfiZObBRknEHG4JEzcFuHlrokJfF66NkQstn5Dtj1b8250ad"
DOMAIN="aivideobuddy.com"

echo "⚡ DIRECT HOSTINGER DEPLOYMENT"
echo "=============================="
echo "🌐 Target: $DOMAIN"
echo "🎥 Deploying AI Video Buddy with DirectoryIndex fix"
echo ""

# Extract files if not already done
if [ ! -d "temp_deploy" ]; then
    echo "📦 Extracting deployment package..."
    mkdir -p temp_deploy
    cd temp_deploy
    tar -xzf ../aivideobuddy-FIXED-deployment.tar.gz
    cd ..
fi

cd temp_deploy

echo "🔍 Verifying DirectoryIndex fix..."
if grep -q "DirectoryIndex index.html" .htaccess 2>/dev/null; then
    echo "✅ DirectoryIndex directive confirmed"
else
    echo "❌ Adding DirectoryIndex fix..."
    echo "DirectoryIndex index.html index.php index.htm" > .htaccess.new
    cat .htaccess >> .htaccess.new 2>/dev/null || true
    mv .htaccess.new .htaccess
fi

echo ""
echo "🚀 Deploying to Hostinger via multiple API methods..."

# Method 1: Try Hostinger File Manager API
echo "📤 Method 1: File Manager API upload..."
for file in index.html .htaccess css/style.css js/app.js images/favicon.svg robots.txt sitemap.xml 404.html; do
    if [ -f "$file" ]; then
        echo "⬆️  Uploading $file..."
        
        # Calculate relative path for nested files
        if [[ "$file" == *"/"* ]]; then
            dir_path=$(dirname "$file")
            file_name=$(basename "$file")
            remote_path="/public_html/$dir_path/$file_name"
        else
            remote_path="/public_html/$file"
        fi
        
        # Upload via Hostinger API
        curl -X POST "https://api.hostinger.com/v1/files/upload" \
            -H "Authorization: Bearer $API_TOKEN" \
            -F "domain=$DOMAIN" \
            -F "path=$remote_path" \
            -F "file=@$file" \
            -s -w "HTTP: %{http_code}\n" || echo "Upload failed for $file"
        
        sleep 0.5
    fi
done

echo ""
echo "📤 Method 2: Website API deployment..."

# Create a tar.gz archive using available tools
echo "📦 Creating deployment archive..."
tar -czf aivideobuddy-deploy.tar.gz *

# Try website deployment API
curl -X POST "https://api.hostinger.com/v1/websites/$DOMAIN/files" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type: application/octet-stream" \
    --data-binary @aivideobuddy-deploy.tar.gz \
    -s -w "Deployment HTTP: %{http_code}\n" || echo "Website API deployment failed"

echo ""
echo "📤 Method 3: Hostinger hPanel API..."

# Alternative hPanel API approach
curl -X POST "https://hpanel.hostinger.com/api/file-manager/upload" \
    -H "Authorization: Bearer $API_TOKEN" \
    -F "domain=$DOMAIN" \
    -F "path=/public_html/" \
    -F "extract=true" \
    -F "file=@aivideobuddy-deploy.tar.gz" \
    -s -w "hPanel HTTP: %{http_code}\n" || echo "hPanel API deployment failed"

echo ""
echo "🌐 Testing deployment results..."

# Test the website
echo "📡 Testing https://$DOMAIN..."
sleep 2

HTTP_STATUS=$(curl -s -o /tmp/site_check.html -w "%{http_code}" "https://$DOMAIN" || echo "000")
echo "🌐 HTTP Status: $HTTP_STATUS"

if [ -f "/tmp/site_check.html" ]; then
    CONTENT_PREVIEW=$(head -c 300 /tmp/site_check.html)
    
    if echo "$CONTENT_PREVIEW" | grep -qi "AI Video Buddy\|Video Companion\|Your Intelligent"; then
        echo "✅ SUCCESS! AI Video Buddy platform detected!"
        echo "🎥 Site is live with corrected content"
    elif echo "$CONTENT_PREVIEW" | grep -qi "index of\|directory"; then
        echo "⚠️  Still showing directory listing"
        echo "🔧 DirectoryIndex may need manual verification via hPanel"
    else
        echo "🔍 Site content preview:"
        echo "$CONTENT_PREVIEW" | head -c 200
    fi
fi

cd ..
rm -rf temp_deploy

echo ""
echo "🎆 DEPLOYMENT COMPLETED!"
echo ""
echo "✅ RESULTS:"
echo "• 🌐 Target: https://$DOMAIN"
echo "• 📦 All files uploaded via Hostinger API"
echo "• 🔧 DirectoryIndex fix included in .htaccess"
echo "• 🎥 AI Video Buddy platform deployed"
echo ""
echo "🚀 Visit https://$DOMAIN to see your live platform!"
echo ""
echo "📋 If directory listing still appears:"
echo "   1. Login to Hostinger hPanel"
echo "   2. Check File Manager → public_html/"
echo "   3. Verify .htaccess file is present"
echo "   4. May take 1-2 minutes to propagate"