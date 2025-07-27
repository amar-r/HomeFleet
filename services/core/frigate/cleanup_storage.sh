#!/bin/bash

# Frigate Storage Cleanup Script
# This script helps manage disk space for Frigate recordings

FRIGATE_DIR="/media/other/frigate"
LOG_FILE="/tmp/frigate_cleanup.log"

echo "=== Frigate Storage Cleanup Script ===" | tee $LOG_FILE
echo "Started at: $(date)" | tee -a $LOG_FILE
echo "Storage directory: $FRIGATE_DIR" | tee -a $LOG_FILE

# Check current storage usage
echo -e "\n=== Current Storage Usage ===" | tee -a $LOG_FILE
df -h $FRIGATE_DIR | tee -a $LOG_FILE

# Function to calculate directory size
get_dir_size() {
    du -sh "$1" 2>/dev/null | cut -f1
}

# Function to count files
count_files() {
    find "$1" -type f 2>/dev/null | wc -l
}

echo -e "\n=== Frigate Directory Analysis ===" | tee -a $LOG_FILE

# Analyze main directories
for dir in "recordings" "clips" "snapshots"; do
    if [ -d "$FRIGATE_DIR/$dir" ]; then
        size=$(get_dir_size "$FRIGATE_DIR/$dir")
        count=$(count_files "$FRIGATE_DIR/$dir")
        echo "$dir: $size ($count files)" | tee -a $LOG_FILE
    fi
done

# Analyze camera-specific directories
echo -e "\n=== Camera Directory Analysis ===" | tee -a $LOG_FILE
for camera_dir in "$FRIGATE_DIR/recordings"/*; do
    if [ -d "$camera_dir" ]; then
        camera_name=$(basename "$camera_dir")
        size=$(get_dir_size "$camera_dir")
        count=$(count_files "$camera_dir")
        echo "$camera_name: $size ($count files)" | tee -a $LOG_FILE
    fi
done

# Cleanup options
echo -e "\n=== Cleanup Options ===" | tee -a $LOG_FILE
echo "1. Remove recordings older than 7 days"
echo "2. Remove clips older than 3 days"
echo "3. Remove snapshots older than 5 days"
echo "4. Remove all recordings older than 3 days"
echo "5. Remove all clips and snapshots"
echo "6. Custom cleanup (interactive)"

read -p "Select cleanup option (1-6): " choice

case $choice in
    1)
        echo "Removing recordings older than 7 days..." | tee -a $LOG_FILE
        find "$FRIGATE_DIR/recordings" -type f -mtime +7 -delete 2>/dev/null
        ;;
    2)
        echo "Removing clips older than 3 days..." | tee -a $LOG_FILE
        find "$FRIGATE_DIR/clips" -type f -mtime +3 -delete 2>/dev/null
        ;;
    3)
        echo "Removing snapshots older than 5 days..." | tee -a $LOG_FILE
        find "$FRIGATE_DIR/snapshots" -type f -mtime +5 -delete 2>/dev/null
        ;;
    4)
        echo "Removing all recordings older than 3 days..." | tee -a $LOG_FILE
        find "$FRIGATE_DIR/recordings" -type f -mtime +3 -delete 2>/dev/null
        ;;
    5)
        echo "Removing all clips and snapshots..." | tee -a $LOG_FILE
        rm -rf "$FRIGATE_DIR/clips"/* 2>/dev/null
        rm -rf "$FRIGATE_DIR/snapshots"/* 2>/dev/null
        ;;
    6)
        read -p "Enter number of days to keep: " days
        echo "Removing files older than $days days..." | tee -a $LOG_FILE
        find "$FRIGATE_DIR" -type f -mtime +$days -delete 2>/dev/null
        ;;
    *)
        echo "Invalid option. Exiting." | tee -a $LOG_FILE
        exit 1
        ;;
esac

# Show cleanup results
echo -e "\n=== Cleanup Results ===" | tee -a $LOG_FILE
echo "Storage after cleanup:" | tee -a $LOG_FILE
df -h $FRIGATE_DIR | tee -a $LOG_FILE

# Show remaining files
echo -e "\n=== Remaining Files ===" | tee -a $LOG_FILE
for dir in "recordings" "clips" "snapshots"; do
    if [ -d "$FRIGATE_DIR/$dir" ]; then
        size=$(get_dir_size "$FRIGATE_DIR/$dir")
        count=$(count_files "$FRIGATE_DIR/$dir")
        echo "$dir: $size ($count files)" | tee -a $LOG_FILE
    fi
done

echo -e "\n=== Cleanup Complete ===" | tee -a $LOG_FILE
echo "Finished at: $(date)" | tee -a $LOG_FILE
echo "Log saved to: $LOG_FILE" | tee -a $LOG_FILE

# Optional: Restart Frigate to free up memory
read -p "Restart Frigate container to free up memory? (y/n): " restart
if [ "$restart" = "y" ] || [ "$restart" = "Y" ]; then
    echo "Restarting Frigate container..." | tee -a $LOG_FILE
    cd /home/amar/code/Personal/docker
    ./compose.sh frigate restart
    echo "Frigate restarted successfully." | tee -a $LOG_FILE
fi 