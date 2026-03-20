#!/bin/bash

# Tailscale ডিমন স্টার্ট করা
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &

echo "Connecting to Tailscale..."

# Tailscale কানেক্ট করা
until tailscale up --authkey=${TS_AUTHKEY} --hostname=pihole-render
do
    echo "Waiting for Tailscale to connect..."
    sleep 2
done

echo "Tailscale is connected!"

# Pi-hole স্টার্ট করার জন্য নিচের কমান্ডটি ব্যবহার করুন (এটিই আসল সমাধান)
exec /init
