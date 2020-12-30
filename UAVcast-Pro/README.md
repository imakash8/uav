# UAVcast

### See [UAVcast docs](http://uavcast.uavmatrix.com) for detailed information
Complete Drone casting software for Raspberry PI in conjuction with 3G / 4G or WiFi. Can be used with Ardupilot based board, APM, Pixhawk, Navio (Emlid.com)

Discussion forum thread
[UAVcast](http://uavmatrix.com/d/5110-UAVcast-Casting-software-for-Raspberry-PI-Supports-3G-4G-WiFi)


### Installation

```
sudo apt-get update
sudo apt-get install git -y
sudo git clone https://github.com/UAVmatrix/UAVcast.git
cd UAVcast/install
sudo ./install.sh web
```

Open UAVcast in your favorite web browser and start casting. http://ip-to-your-raspberry
![UAVcast Web](http://uavmatrix.com/assets/files/2017-10-17/1508203664-0-2017-10-17-03-25-35.png)

 
### Video
If you are using UAVcast with camera, its highly recommended to use gstreamer on the receiver end to achieve minimal latency.
Download [gstreamer](https://gstreamer.freedesktop.org/download/)

Use this client pipeline to receive video feed from UAVcast.

``` 
gst-launch-1.0.exe -e -v udpsrc port=5000 ! application/x-rtp, payload=96 ! rtpjitterbuffer ! rtph264depay ! avdec_h264 ! fpsdisplaysink sync=false text-overlay=false 
```

If you are using PiCam, remember to enable the camera in ```Raspi-Config```

## Authors

* **Bernt Christian Egeland** - *creator and founder of UAVmatrix.com* - (http://uavmatrix.com)
