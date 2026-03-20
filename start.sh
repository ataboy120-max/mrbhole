#!/bin/bash

# Tailscale ডিমন ব্যাকগ্রাউন্ডে স্টার্ট করা (Userspace নেটওয়ার্কিং মোডে)
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &

echo "Connecting to Tailscale..."

# Tailscale কানেক্ট করা (রেন্ডারের Environment Variable থেকে TS_AUTHKEY ব্যবহার করবে)
until tailscale up --authkey=${TS_AUTHKEY} --hostname=pihole-render
do
    echo "Waiting for Tailscale to connect..."
    sleep 2
done

echo "Tailscale is connected!"

# পি-হোল স্টার্ট করার আসল কমান্ড (এটি দিলে আর এরর আসবে না)
exec /s6-init
