FROM adguard/adguardhome:latest

# প্রয়োজনীয় টুলস ইনস্টল করা
RUN apk add --no-cache curl ca-certificates

# Cloudflared ডাউনলোড এবং সেটআপ
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# Render-এর জন্য পারমিশন ফিক্স (AdGuardHome বাইনারিকে এক্সিকিউটেবল পারমিশন দেওয়া)
RUN chmod +x /opt/adguardhome/AdGuardHome

# স্টার্টআপ স্ক্রিপ্ট তৈরি
RUN echo '#!/bin/sh' > /start.sh && \
    echo '/opt/adguardhome/AdGuardHome --work-dir /opt/adguardhome/work --conf /opt/adguardhome/conf/AdGuardHome.yaml --host 0.0.0.0 &' >> /start.sh && \
    echo 'sleep 10' >> /start.sh && \
    echo 'cloudflared tunnel --no-autoupdate run --token eyJhIjoiMDUwNTFmYzliMjgxNTZkMGI4MmNjYWNhYWY1ZDczMGYiLCJ0IjoiZDNjZGJkNTYtOTE0ZC00MTAzLWJmNGEtNWEwNTAyYWM4YmUxIiwicyI6Ill6WTRZMlV6T0RNdFlUUmxPUzAwWXpkbExXRmxOMk10TXprNE16TXdZekZrWmpFMCJ9' >> /start.sh && \
    chmod +x /start.sh

# পোর্ট এক্সপোজ (Render প্রধানত ৮০০০ বা ৩০০০ পোর্টের দিকে নজর দেয়)
EXPOSE 3000

# কন্টেইনার স্টার্ট কমান্ড
CMD ["/bin/sh", "/start.sh"]
