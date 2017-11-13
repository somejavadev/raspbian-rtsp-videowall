# Raspbian RTSP Video Wall

A simple project to help create a video wall of RTSP feeds running on a RaspberryPi.

## Getting Started

This project was created on a RaspberryPi Zero W but should work on most RaspberryPi's with network capabilities.

### Prerequisites

This project assumes you already have Rasbian installed and configured on a RaspberryPi.

```
- A RaspberryPi running raspbian.
- The RaspberryPi should have a working network interface.
- Access to some RTSP video feeds.
- omxplayer (sudo apt install omxplayer).
- screen (sudo apt install screen).
- bc (sudo apt install bc).
```

### Installing and Running

In short you only have to clone this project to your RaspberryPi, update the feed file and set the amount of screens for your wall.

```
# ssh into your RaspberryPi

# Change to the home directory
cd ~

# Install all the prerequisites 
sudo apt install omxplayer && sudo apt install screen && sudo apt install bc && sudo apt install git

# Clone the project.
git clone https://github.com/somejavadev/raspbian-rtsp-videowall.git

# Change to the project directory
cd raspbian-rtsp-videowall

# Edit the feed file with your favourite editor and add your RTSP feeds including username and password if required.
nano rtsp.feed
# add your own rtsp feeds:
rtsp://username:userpass@192.168.0.5:10554/PSIA/streaming/channels/102
rtsp://username:userpass@192.168.0.5:10554/PSIA/streaming/channels/202
save the file and exit.

# Update the amount of screens for the video wall:
nano rtsp-video-wall.sh
# Change the value of the SIZE variable:
# Note this number should be a perfect square (1, 4, 9, 16, 25)
SIZE=4;
save the file and exit.

# Ensure the .sh file is executable
chmod +x rtsp-video-wall.sh

# To launch the video wall:
./rtsp-video-wall.sh

# To close the video wall, kill all screen sessions
killall screen

```

## Authors

* **Hein Smith** - *Initial git project* - [raspbian-rtsp-videowall](https://github.com/somejavadev/raspbian-rtsp-videowall)

See also the list of [contributors](https://github.com/somejavadev/raspbian-rtsp-videowall/graphs/contributors) who participated in this project.

Initial credit goes to the [masondb](https://community.ubnt.com/t5/user/viewprofilepage/user-id/240970) for his [Wall Matrix](https://community.ubnt.com/t5/UniFi-Video/Tutorial-RTSP-Raspberry-Pi-B-Viewer-6-Cam-4-Cam/td-p/1536448) on the ubnt forums.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

