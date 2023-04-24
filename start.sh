#!/bin/bash

# Check if the url and jwt are provided as arguments
if [ $# -ne 2 ]; then
  echo "Usage: $0 <url> <jwt>"
  exit 1
fi

# Set variables for url and jwt
url=$1
jwt=$2

# Create a new lighthouse.config.js file with the provided url and jwt
cat > lighthouse.config.js << EOF
module.exports = {
  extends: 'lighthouse:default',
  audits: [
    {
      path: 'custom-audit.js',
      options: {
        url: '$url',
        jwt: '$jwt'
      }
    }
  ]
};
EOF

# Set up the Lighthouse report server
lighthouse --server --port=8080 &

# Wait for the server to start
sleep 2

# Generate the Lighthouse report
lighthouse $url --config-path=lighthouse.config.js --quiet --chrome-flags="--headless --disable-gpu" --output=json --output-path=report.json

# Stop the Lighthouse report server
kill $(lsof -t -i :8080)

# Remove the lighthouse.config.js file
rm lighthouse.config.js
