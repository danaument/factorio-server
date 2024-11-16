#!/bin/bash -e

# Define the locations of your files
FACTORIO_DIR="/opt/factorio"
TMP_DIR="/tmp/factorio"

# Get the current date
DATE=$(date +%Y-%m-%d)

# Check if a version argument is provided
if [ -z "$1" ]; then
  echo "Error: No version specified."
  echo "Usage: $0 <version>"
  echo "Example: $0 1.1.110"
  exit 1
fi

VERSION=$1

# Validate the provided version by checking the download URL
DOWNLOAD_URL="https://factorio.com/get-download/${VERSION}/headless/linux64"
echo "Validating version ${VERSION}..."

if ! wget --spider --quiet "$DOWNLOAD_URL"; then
  echo "Error: Version ${VERSION} is invalid or not available."
  exit 1
fi

echo "Version ${VERSION} is valid. Proceeding with the update..."

# Rename the old Factorio directory with date appended
OLD_FACTORIO_DIR="${FACTORIO_DIR}_$DATE"
echo "Moving $FACTORIO_DIR to $OLD_FACTORIO_DIR"
mv $FACTORIO_DIR $OLD_FACTORIO_DIR

# Download the new version of Factorio
echo "Downloading Factorio version $VERSION to $TMP_DIR"
mkdir -p $TMP_DIR
cd $TMP_DIR
wget $DOWNLOAD_URL -O factorio.tar.xz

# Extract the downloaded file
echo "Extracting Factorio"
tar xf factorio.tar.xz

# Move the extracted files to the Factorio directory
echo "Moving Factorio to $FACTORIO_DIR"
mv $TMP_DIR/factorio $FACTORIO_DIR

# Copy your server files, saves, and mods to the new Factorio directory
echo "Copying old server files, saves, and mods to $FACTORIO_DIR"
cp $OLD_FACTORIO_DIR/data/server-settings.json $FACTORIO_DIR/data/
cp $OLD_FACTORIO_DIR/data/server-whitelist.json $FACTORIO_DIR/data/
cp -r $OLD_FACTORIO_DIR/saves $FACTORIO_DIR/
cp -r $OLD_FACTORIO_DIR/mods $FACTORIO_DIR/
cp $OLD_FACTORIO_DIR/server-id.json $FACTORIO_DIR/
mkdir $FACTORIO_DIR/config
cp $OLD_FACTORIO_DIR/config/config.ini $FACTORIO_DIR/config/

# Set the owner of the Factorio directory to the "factorio" user
echo "Changing owner of $FACTORIO_DIR to factorio:factorio"
chown -R factorio:factorio $FACTORIO_DIR

# Remove the temporary directory
echo "Cleaning up $TMP_DIR"
rm -rf $TMP_DIR

echo "Reloading systemd daemon and restarting Factorio service"
systemctl daemon-reload
systemctl restart factorio.service

echo "Update complete! Old version moved to $OLD_FACTORIO_DIR"
