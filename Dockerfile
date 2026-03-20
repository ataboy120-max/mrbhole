FROM pihole/pihole:latest

# Tailscale এবং প্রয়োজনীয় টুলস ইনস্টল
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://tailscale.com/install.sh | sh

# স্টার্টআপ স্ক্রিপ্ট
RUN echo '#!/bin/bash\n\
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 & \n\
tailscale up --authkey=${TS_AUTHKEY} --hostname=render-pihole --accept-dns=false \n\
/s6-init' > /start.sh && chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
