FROM pihole/pihole:latest

# Tailscale এবং প্রয়োজনীয় টুলস ইন্সটল করা
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
# লেটেস্ট ইমেজে এটি সাধারণত /s6-init অথবা সরাসরি মূল কমান্ড হয়
if [ -f "/s6-init" ]; then
    exec /s6-init
elif [ -f "/init" ]; then
    exec /init
else
    # যদি কোনোটিই না পাওয়া যায়, তবে সরাসরী মূল এন্ট্রি পয়েন্ট কল করা
    exec /usr/local/bin/docker-pi-hole
fi
EOF

# স্ক্রিপ্টটি এক্সিকিউটেবল করা
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
