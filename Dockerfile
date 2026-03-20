FROM pihole/pihole:latest

# Cloudflared ইন্সটল করা
RUN apt-get update && apt-get install -y curl && \
    curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared.deb && \
    rm cloudflared.deb

# সরাসরি টানেল এবং পি-হোল স্টার্ট করার কমান্ড
ENTRYPOINT cloudflared tunnel --no-autoupdate run --token ${TUNNEL_TOKEN} & \
           exec /init
