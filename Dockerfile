FROM pihole/pihole:latest

# Tailscale, bash এবং curl ইন্সটল করা
RUN apk add --no-cache tailscale bash curl

# স্টার্টআপ স্ক্রিপ্ট তৈরি করা
COPY <<EOF /start.sh
#!/bin/bash

# Tailscale ব্যাকগ্রাউন্ডে চালু করা
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &

# Auth Key থাকলে লগইন করা
if [ -n "\$TS_AUTHKEY" ]; then
    echo "Connecting to Tailscale..."
    tailscale up --authkey=\$TS_AUTHKEY --hostname=render-pihole
else
    echo "TS_AUTHKEY not found, skipping Tailscale setup."
fi

# Pi-hole এর মেইন এন্ট্রি পয়েন্ট চালু করা
# Alpine ভিত্তিক ইমেজে এটি সাধারণত /s6-init অথবা /init হয়
if [ -f "/s6-init" ]; then
    exec /s6-init
else
    exec /init
fi
EOF

# স্ক্রিপ্টটি এক্সিকিউটেবল করা
RUN chmod +x /start.sh

# Render এর জন্য ডিফল্ট এন্ট্রি পয়েন্ট সেট করা
ENTRYPOINT ["/start.sh"]
