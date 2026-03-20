FROM adguard/adguardhome:latest

# প্রয়োজনীয় লাইব্রেরি এবং Cloudflared সেটআপ
RUN apk add --no-cache curl libc6-compat
RUN curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

# পারমিশন ইস্যু এড়াতে বাইনারি ফাইলকে অন্য লোকেশনে কপি করা এবং পারমিশন দেওয়া
RUN cp /opt/adguardhome/AdGuardHome /usr/local/bin/AdGuardHome && \
    chmod +x /usr/local/bin/AdGuardHome

# পোর্ট এক্সপোজ করা
EXPOSE 3000 80 53/tcp 53/udp

# নতুন লোকেশন থেকে রান করা
ENTRYPOINT cloudflared tunnel --no-autoupdate run --token eyJhIjoiMDUwNTFmYzliMjgxNTZkMGI4MmNjYWNhYWY1ZDczMGYiLCJ0IjoiMGUxNThhNzItYmNkNy00YmIzLThmN2EtNGJhNGRmOTllNDg5IiwicyI6IlkyVXlOelk0TTJVdFlXUTRNeTAwTnpZMUxXSXhPV0l0TUdJMk16Z3lOV1EyTldZMiJ9 & \
           /usr/local/bin/AdGuardHome -w /opt/adguardhome/work -c /opt/adguardhome/conf/AdGuardHome.yaml --no-check-update
