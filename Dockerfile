FROM pihole/pihole:latest

# Tailscale এবং প্রয়োজনীয় টুলস ইন্সটল করা
RUN apk add --no-cache tailscale bash curl

# আপনার তৈরি করা start.sh ফাইলটি কন্টেইনারে কপি করা
COPY start.sh /start.sh

# ফাইলটিকে রান করার অনুমতি দেওয়া
RUN chmod +x /start.sh

# পোর্ট সেটিংস
EXPOSE 80
EXPOSE 53/tcp
EXPOSE 53/udp

# কন্টেইনার স্টার্ট হলে start.sh রান করবে
ENTRYPOINT ["/start.sh"]
