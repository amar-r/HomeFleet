#!/bin/bash

# Frigate Performance Monitoring Script
# This script monitors Frigate performance and resource usage

LOG_FILE="/tmp/frigate_performance.log"
FRIGATE_CONTAINER="frigate"

echo "=== Frigate Performance Monitor ===" | tee $LOG_FILE
echo "Started at: $(date)" | tee -a $LOG_FILE

# Function to get container stats
get_container_stats() {
    sudo docker stats $FRIGATE_CONTAINER --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}"
}

# Function to get storage usage
get_storage_usage() {
    df -h /media/other/frigate/ | tail -1
}

# Function to get system resources
get_system_resources() {
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
    echo "Memory Usage: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')"
    echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
}

# Function to check Frigate logs for errors
check_frigate_logs() {
    echo "=== Recent Frigate Logs (last 10 lines) ===" | tee -a $LOG_FILE
    sudo docker logs --tail 10 $FRIGATE_CONTAINER 2>&1 | tee -a $LOG_FILE
}

# Function to check detection performance
check_detection_performance() {
    echo "=== Detection Performance ===" | tee -a $LOG_FILE
    # Check if Frigate API is accessible
    if curl -s http://localhost:5000/api/stats > /dev/null 2>&1; then
        echo "Frigate API is accessible" | tee -a $LOG_FILE
        # Get detection stats if available
        curl -s http://localhost:5000/api/stats 2>/dev/null | jq '.detection_fps // "N/A"' 2>/dev/null | tee -a $LOG_FILE
    else
        echo "Frigate API not accessible" | tee -a $LOG_FILE
    fi
}

# Main monitoring loop
echo -e "\n=== Initial System State ===" | tee -a $LOG_FILE
get_system_resources | tee -a $LOG_FILE

echo -e "\n=== Initial Storage State ===" | tee -a $LOG_FILE
get_storage_usage | tee -a $LOG_FILE

echo -e "\n=== Initial Container State ===" | tee -a $LOG_FILE
get_container_stats | tee -a $LOG_FILE

# Check Frigate logs
check_frigate_logs

# Check detection performance
check_detection_performance

# Performance recommendations
echo -e "\n=== Performance Recommendations ===" | tee -a $LOG_FILE

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "⚠️  High CPU usage detected ($CPU_USAGE%). Consider:" | tee -a $LOG_FILE
    echo "   - Reducing detection FPS" | tee -a $LOG_FILE
    echo "   - Lowering detection resolution" | tee -a $LOG_FILE
    echo "   - Adding more CPU cores" | tee -a $LOG_FILE
fi

# Check memory usage
MEM_USAGE=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
if (( $(echo "$MEM_USAGE > 85" | bc -l) )); then
    echo "⚠️  High memory usage detected ($MEM_USAGE%). Consider:" | tee -a $LOG_FILE
    echo "   - Increasing container memory limits" | tee -a $LOG_FILE
    echo "   - Reducing number of cameras" | tee -a $LOG_FILE
    echo "   - Adding more RAM" | tee -a $LOG_FILE
fi

# Check storage usage
STORAGE_USAGE=$(df /media/other/frigate/ | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$STORAGE_USAGE" -gt 90 ]; then
    echo "⚠️  High storage usage detected ($STORAGE_USAGE%). Consider:" | tee -a $LOG_FILE
    echo "   - Running cleanup script: ./frigate/cleanup_storage.sh" | tee -a $LOG_FILE
    echo "   - Reducing retention periods" | tee -a $LOG_FILE
    echo "   - Adding more storage" | tee -a $LOG_FILE
fi

# Check if Coral TPU is being used
echo -e "\n=== Hardware Acceleration Check ===" | tee -a $LOG_FILE
if lsusb | grep -q "Google Inc"; then
    echo "✅ USB Coral TPU detected" | tee -a $LOG_FILE
else
    echo "⚠️  USB Coral TPU not detected" | tee -a $LOG_FILE
fi

if lspci | grep -q "apex"; then
    echo "✅ PCIe Coral TPU detected" | tee -a $LOG_FILE
else
    echo "⚠️  PCIe Coral TPU not detected" | tee -a $LOG_FILE
fi

# Check GPU acceleration
if lspci | grep -q "VGA"; then
    echo "✅ GPU detected" | tee -a $LOG_FILE
    lspci | grep VGA | tee -a $LOG_FILE
else
    echo "⚠️  No GPU detected" | tee -a $LOG_FILE
fi

# Network performance check
echo -e "\n=== Network Performance ===" | tee -a $LOG_FILE
for camera in "10.27.27.23" "10.27.27.20" "10.27.27.21" "10.27.27.22" "10.27.27.24" "10.27.27.59"; do
    if ping -c 1 -W 1 $camera > /dev/null 2>&1; then
        echo "✅ Camera $camera is reachable" | tee -a $LOG_FILE
    else
        echo "❌ Camera $camera is not reachable" | tee -a $LOG_FILE
    fi
done

echo -e "\n=== Monitoring Complete ===" | tee -a $LOG_FILE
echo "Finished at: $(date)" | tee -a $LOG_FILE
echo "Log saved to: $LOG_FILE" | tee -a $LOG_FILE

# Optional: Continuous monitoring
read -p "Enable continuous monitoring (every 30 seconds for 5 minutes)? (y/n): " continuous
if [ "$continuous" = "y" ] || [ "$continuous" = "Y" ]; then
    echo "Starting continuous monitoring..." | tee -a $LOG_FILE
    for i in {1..10}; do
        echo -e "\n--- Monitoring Cycle $i ---" | tee -a $LOG_FILE
        echo "Time: $(date)" | tee -a $LOG_FILE
        get_container_stats | tee -a $LOG_FILE
        sleep 30
    done
    echo "Continuous monitoring complete." | tee -a $LOG_FILE
fi 