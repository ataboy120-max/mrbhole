FROM adguard/adguardhome:latest

# Cloudflared ইনস্টল করা
RUN apk add --no-cache curl
RUN curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

# এন্ট্রি পয়েন্ট স্ক্রিপ্ট: একসাথে AdGuard এবং Cloudflared রান করবে
RUN echo '#!/bin/sh' > /start.sh && \
    echo '/usr/bin/AdGuardHome --work-dir /opt/adguardhome/work --conf /opt/adguardhome/conf/AdGuardHome.yaml &' >> /start.sh && \
    echo 'sleep 5 && cloudflared tunnel --no-autoupdate run --token ${eyJhIjoiMDUwNTFmYzliMjgxNTZkMGI4MmNjYWNhYWY1ZDczMGYiLCJ0IjoiZDNjZGJkNTYtOTE0ZC00MTAzLWJmNGEtNWEwNTAyYWM4YmUxIiwicyI6Ill6WTRZMlV6T0RNdFlUUmxPUzAwWXpkbExXRmxOMk10TXprNE16TXdZekZrWmpFMCJ9}' >> /start.sh && \
    chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]
