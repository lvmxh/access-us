#!/bin/bash
# run once
sudo apt-get install git 
git clone https://github.com/ssrbackup/shadowsocksr
 
TOP_PATH=$(pwd)
SSR_PATH=$(pwd)/shadowsocksr
cd $SSR_PATH
CONF=/etc/shadowsocks.json
sudo cp $SSR_PATH/config.json $CONF
 
SERVER=${SERVER:-0.0.0.0}
PORT=${PORT:-2333}
PASS=${PASS:-123456}
PROTOCOL=${PROTOCOL:-auth_sha1_v4}
OBFS=${OBFS:-plain}
METHOD=${METHOD:-aes-128-ctr}
 
sudo sed -i -e "s/^\(.*\"password\"\):.*$/\1: \"$PASS\",/g" $CONF
sudo sed -i -e "s/^\(.*\"method\"\):.*$/\1: \"$METHOD\",/g" $CONF
sudo sed -i -e "s/^\(.*\"protocol\"\):.*$/\1: \"$PROTOCOL\",/g" $CONF
sudo sed -i -e "s/^\(.*\"obfs\"\):.*$/\1: \"$OBFS\",/g" $CONF
sudo sed -i -e "s/^\(.*\"server_port\"\):.*$/\1: \"$PORT\",/g" $CONF
sudo sed -i -e "s/^\(.*\"server\"\):.*$/\1: \"$SERVER\",/g" $CONF
 
SCRYPT=/usr/bin/ssr-proxy
sudo tee -a  $SCRYPT > /dev/null <<EOT
#!/bin/bash
cd $SSR_PATH/shadowsocks/
python local.py -c$CONF -d \$@
EOT
 
sudo chmod a+x $SCRYPT
sudo cat $SCRYPT
 
 
# install proxychains
sudo apt install proxychains
echo "socks5 127.0.0.1 1080" | sudo tee -a /etc/proxychains.conf > /dev/null
sudo sed -i -e "s/^\(socks4.*\)/# \1/g" /etc/proxychains.conf
proxychains wget https://www.google.com
# proxychains bash
