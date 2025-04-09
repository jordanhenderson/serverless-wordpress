#!/bin/bash

set -euo pipefail

# Install bref runtimes, needed for lambda
composer install

# Fetch wordpress
curl -O https://wordpress.org/latest.zip
unzip latest.zip

# Start compiling
mkdir -p dist
rm -f dist/lambda.zip

# Move into wordpress/ to flatten contents into root of zip
(cd wordpress && zip -r ../dist/lambda.zip .)

# Add vendor folder (preserves as vendor/)
zip -r dist/lambda.zip vendor

# Add composer files to root
zip dist/lambda.zip composer.json composer.lock