FROM pihole/pihole:latest

USER root

# প্রয়োজনীয় প্যাকেজ ইন্সটল
RUN apk add --no-cache tailscale bash curl

# স্টার্টআপ স্ক্রিপ্ট সরাসরি তৈরি করা
COPY <<EOF /start.sh
#!/bin/bash

# Tailscale ব্যাকগ্রাউন্ডে চালু করা
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &

# Tailscale কানেক্ট করার জন্য অপেক্ষা
sleep 5

# Tailscale আপ করা
if [ -n "$TS_AUTHKEY" ]; then
    tailscale up --authkey=${TS_AUTHKEY} --hostname=render-pihole --accept-dns=false
fi

# Pi-hole এর মেইন এন্ট্রি পয়েন্ট রান করা
# সিলো মোডে যাতে কন্টেইনার এক্সিট না করে
/s6-init
EOF

RUN chmod +x /start.sh

# পোর্ট এক্সপোজ করা (রেণ্ডারের জন্য)
EXPOSE 80/tcp
EXPOSE 53/tcp
EXPOSE 53/udp

ENTRYPOINT ["/bin/bash", "/start.sh"]
