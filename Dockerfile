FROM pihole/pihole:latest

# root ইউজার হিসেবে কাজ করা নিশ্চিত করা
USER root

# Alpine বা Debian উভয় ক্ষেত্রেই প্যাকেজ ম্যানেজার চেক করে curl এবং Tailscale ইন্সটল করা
RUN (apt-get update && apt-get install -y curl) || (apk add --no-cache curl) && \
    curl -fsSL https://tailscale.com/install.sh | sh

# স্টার্টআপ স্ক্রিপ্ট
RUN echo '#!/bin/bash\n\
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 & \n\
sleep 5\n\
tailscale up --authkey=${TS_AUTHKEY} --hostname=render-pihole --accept-dns=false \n\
exec /s6-init' > /start.sh && chmod +x /start.sh

ENTRYPOINT ["/bin/bash", "/start.sh"]
