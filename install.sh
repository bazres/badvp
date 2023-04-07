apt update && apt install cmake -y && apt upgrade -y

apt install curl -y
apt install git -y 

git clone https://github.com/ambrop72/badvpn.git

cd badvpn
mkdir badvpn-build
cd badvpn-build
cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
make
cp udpgw/badvpn-udpgw /usr/local/bin


cat >  /etc/systemd/system/videocall.service << ENDOFFILE
[Unit]
Description=UDP forwarding for badvpn-tun2socks
After=nss-lookup.target

[Service]
ExecStart=/usr/local/bin/badvpn-udpgw --loglevel none --listen-addr 127.0.0.1:7300 --max-clients 999
User=videocall

[Install]
WantedBy=multi-user.target
ENDOFFILE




useradd -m videocall
systemctl enable videocall
systemctl start videocall

sudo lsof -i -P -n | grep LISTEN
