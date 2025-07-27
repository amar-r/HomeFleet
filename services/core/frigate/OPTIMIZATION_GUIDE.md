# Frigate Optimization Guide

## 🚨 Current Issues Identified

### **Critical Storage Problem**
- **Frigate Storage**: 100% full (1.8TB)
- **System Impact**: High CPU usage (129%), high memory usage (7.5GB)
- **Performance**: System under significant load

### **Performance Bottlenecks**
- **CPU**: 129% usage (overloaded)
- **Memory**: 7.5GB/15GB (50% of system memory)
- **Storage**: Completely full, causing performance degradation
- **Detection**: Running at full resolution without optimization

## ✅ Optimizations Applied

### **1. Docker Compose Optimizations**

#### **Resource Management**
```yaml
# Added resource limits for stability
deploy:
  resources:
    limits:
      memory: 8G
      cpus: '4.0'
    reservations:
      memory: 4G
      cpus: '2.0'
```

#### **Performance Improvements**
- **Shared Memory**: Increased from 225MB to 512MB
- **Cache Size**: Increased from 1GB to 2GB tmpfs
- **Environment Variables**: Added Python optimizations

### **2. Configuration Optimizations**

#### **Detection Performance**
```yaml
detect:
  width: 640   # Reduced from full resolution
  height: 480  # Optimized for detection
  fps: 5       # Reduced FPS for CPU savings
```

#### **Storage Management**
```yaml
record:
  retain:
    days: 7    # Reduced from 15 days
  events:
    retain:
      default: 10  # Reduced from 20
```

#### **Detection Thresholds**
- **Person**: Lowered to 0.65 (better detection)
- **Animals**: Added specific thresholds (0.60)
- **Motion**: Increased threshold to reduce false positives

### **3. Storage Cleanup Script**
- **Automated cleanup** of old recordings
- **Flexible retention** policies
- **Storage analysis** and reporting

### **4. Performance Monitoring**
- **Real-time monitoring** of resource usage
- **Hardware detection** (Coral TPU, GPU)
- **Network connectivity** checks
- **Performance recommendations**

## 🔧 Immediate Actions Required

### **1. Emergency Storage Cleanup**
```bash
# Run the cleanup script
cd /home/amar/code/Personal/docker
./frigate/cleanup_storage.sh

# Choose option 4: Remove all recordings older than 3 days
# This will free up significant space immediately
```

### **2. Restart Frigate with New Configuration**
```bash
# Stop current Frigate
./compose.sh frigate stop

# Start with optimized configuration
./compose.sh frigate up -d

# Monitor performance
./frigate/monitor_performance.sh
```

### **3. Verify Hardware Acceleration**
```bash
# Check Coral TPU
lsusb | grep "Google Inc"
lspci | grep "apex"

# Check GPU
lspci | grep VGA
```

## 📊 Expected Performance Improvements

### **CPU Usage**
- **Before**: 129% (overloaded)
- **After**: ~60-80% (manageable)
- **Improvement**: 40-50% reduction

### **Memory Usage**
- **Before**: 7.5GB (50% of system)
- **After**: 4-6GB (30-40% of system)
- **Improvement**: 20-30% reduction

### **Storage Usage**
- **Before**: 100% full
- **After**: ~60-70% after cleanup
- **Improvement**: Immediate 30-40% space freed

### **Detection Performance**
- **Before**: Full resolution processing
- **After**: Optimized 640x480 detection
- **Improvement**: 4-5x faster detection

## 🎯 Long-term Optimization Strategy

### **1. Storage Management**
```bash
# Set up automated cleanup (add to crontab)
# Daily cleanup of old recordings
0 2 * * * /home/amar/code/Personal/docker/frigate/cleanup_storage.sh

# Weekly performance monitoring
0 8 * * 0 /home/amar/code/Personal/docker/frigate/monitor_performance.sh
```

### **2. Hardware Upgrades (Recommended)**
- **RAM**: Add 8-16GB more RAM (currently 15GB)
- **Storage**: Add dedicated Frigate storage drive
- **CPU**: Consider more cores for better performance

### **3. Network Optimization**
- **Camera Placement**: Ensure stable network connections
- **Bandwidth**: Monitor network usage
- **Quality**: Balance between quality and performance

### **4. Advanced Optimizations**

#### **Camera-Specific Tuning**
```yaml
# Example for high-traffic camera
Front:
  detect:
    width: 480   # Even lower for high-traffic areas
    height: 360
  motion:
    threshold: 30  # Higher threshold for busy areas
```

#### **Time-Based Optimization**
```yaml
# Reduce detection during low-activity hours
detect:
  fps: 2  # Lower FPS at night
  width: 480
  height: 360
```

## 🔍 Monitoring and Maintenance

### **Daily Checks**
- [ ] Storage usage monitoring
- [ ] CPU and memory usage
- [ ] Detection performance
- [ ] Camera connectivity

### **Weekly Tasks**
- [ ] Run performance monitoring script
- [ ] Review detection accuracy
- [ ] Check for false positives
- [ ] Update retention policies

### **Monthly Tasks**
- [ ] Full system performance review
- [ ] Storage cleanup and optimization
- [ ] Configuration tuning
- [ ] Hardware health check

## 🚀 Performance Tuning Tips

### **1. Detection Resolution**
- **High-traffic areas**: 480x360
- **Medium-traffic areas**: 640x480
- **Low-traffic areas**: 800x600

### **2. FPS Optimization**
- **Daytime**: 5-10 FPS
- **Nighttime**: 2-5 FPS
- **Motion-only**: 1-3 FPS

### **3. Retention Policies**
- **Recordings**: 7-14 days
- **Events**: 10-20 events
- **Snapshots**: 5-10 snapshots

### **4. Motion Detection**
- **Threshold**: 25-35 (higher = fewer false positives)
- **Contour Area**: 100-200 (minimum object size)
- **Masking**: Use motion masks for busy areas

## 📈 Success Metrics

### **Performance Targets**
- **CPU Usage**: <80% average
- **Memory Usage**: <6GB
- **Storage Usage**: <85%
- **Detection FPS**: >3 FPS per camera
- **False Positives**: <10% of detections

### **Monitoring Commands**
```bash
# Quick performance check
sudo docker stats frigate --no-stream

# Storage check
df -h /media/other/frigate/

# Performance monitoring
./frigate/monitor_performance.sh

# Storage cleanup
./frigate/cleanup_storage.sh
```

## 🔧 Troubleshooting

### **High CPU Usage**
1. Reduce detection FPS
2. Lower detection resolution
3. Add more CPU cores
4. Optimize motion detection

### **High Memory Usage**
1. Increase container memory limits
2. Reduce number of cameras
3. Add more RAM
4. Optimize detection settings

### **Storage Issues**
1. Run cleanup script
2. Reduce retention periods
3. Add more storage
4. Optimize recording quality

### **Detection Issues**
1. Check Coral TPU connectivity
2. Verify camera streams
3. Adjust detection thresholds
4. Review motion masks

---

*This optimization guide provides a comprehensive approach to improving your Frigate performance. Start with the immediate actions and gradually implement the long-term strategies for optimal results.* 