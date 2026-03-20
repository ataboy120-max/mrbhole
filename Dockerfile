FROM pihole/pihole:latest

# Alpine Linux এর জন্য প্রয়োজনীয় লাইব্রেরি এবং Cloudflared ডাউনলোড
RUN apk add --no-cache curl libc6-compat

RUN curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

# আপনার দেওয়া টোকেনটি সরাসরি এখানে বসিয়ে দেওয়া হলো
ENTRYPOINT cloudflared tunnel --no-autoupdate run --token eyJhIjoiMDUwNTFmYzliMjgxNTZkMGI4MmNjYWNhYWY1ZDczMGYiLCJ0IjoiMGUxNThhNzItYmNkNy00YmIzLThmN2EtNGJhNGRmOTllNDg5IiwicyI6IlkyVXlOelk0TTJVdFlXUTRNeTAwTnpZMUxXSXhPV0l0TUdJMk16Z3lOV1EyTldZMiJ9 & \
           exec /init
