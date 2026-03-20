FROM pihole/pihole:latest

# root ইউজার নিশ্চিত করা
USER root

# Alpine এর জন্য সরাসরি tailscale প্যাকেজ ইন্সটল করা
RUN apk add --no-cache tailscale bash curl

# স্টার্টআপ স্ক্রিপ্ট তৈরি করা
RUN echo '#!/bin/bash\n\
# Tailscale ব্যাকগ্রাউন্ডে চালু করা\n\
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 & \n\
sleep 5\n\
# Tailscale কানেক্ট করা\n\
tailscale up --authkey=${TS_AUTHKEY} --hostname=render-pihole --accept-dns=false \n\
# Pi-hole শুরু করা\n\
exec /s6-init' > /start.sh && chmod +x /start.sh

# রান করার কমান্ড
ENTRYPOINT ["/bin/bash", "/start.sh"]
