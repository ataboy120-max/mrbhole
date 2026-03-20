FROM adguard/adguardhome:latest

# প্রয়োজনীয় পোর্টগুলো ওপেন করা
EXPOSE 3000 53/tcp 53/udp 80 443

# সরাসরি ক্লাউডফ্লেয়ার টানেল এবং অ্যাডগার্ড হোম রান করার কমান্ড
# (আপনার আগের টোকেনটি এখানে ব্যবহার করা হয়েছে)
RUN apk add --no-cache curl libc6-compat
RUN curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

ENTRYPOINT cloudflared tunnel --no-autoupdate run --token eyJhIjoiMDUwNTFmYzliMjgxNTZkMGI4MmNjYWNhYWY1ZDczMGYiLCJ0IjoiMGUxNThhNzItYmNkNy00YmIzLThmN2EtNGJhNGRmOTllNDg5IiwicyI6IlkyVXlOelk0TTJVdFlXUTRNeTAwTnpZMUxXSXhPV0l0TUdJMk16Z3lOV1EyTldZMiJ9 & \
           /opt/adguardhome/AdGuardHome -w /opt/adguardhome/work -c /opt/adguardhome/conf/AdGuardHome.yaml
