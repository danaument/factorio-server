#!/bin/bash -e

# Define the locations of your files
FACTORIO_DIR="/opt/factorio"
DOWNLOAD_URL="https://factorio.com/get-download/stable/headless/linux64"
TMP_DIR="/tmp/factorio"

# Get the current date
DATE=$(date +%Y-%m-%d)

# Rename the old Factorio directory with date appended
OLD_FACTORIO_DIR="${FACTORIO_DIR}_$DATE"
echo "Moving $FACTORIO_DIR to $OLD_FACTORIO_DIR"
mv $FACTORIO_DIR $OLD_FACTORIO_DIR

# Download the new version of Factorio
echo "Downloading Factorio to $TMP_DIR"
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
cp $OLD_FACTORIO_DIR/config/config.ini $FACTORIO_DIR/config/

# Remove the temporary directory
echo "Cleaning up $TMP_DIR"
rm -rf $TMP_DIR

echo "Reloading systemd daemon and restarting Factorio service"
systemctl daemon-reload
systemctl restart factorio.service

echo "Update complete! Old version moved to $OLD_FACTORIO_DIR"
