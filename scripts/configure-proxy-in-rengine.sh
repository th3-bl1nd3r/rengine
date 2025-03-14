#!/bin/bash
# Script to enable Tor proxy settings in reNgine UI

echo "[+] Setting up Tor proxy configuration in reNgine"

# Connect to the web container
docker-compose exec web bash -c '
# Access the Django shell
python3 manage.py shell << EOF
from scanEngine.models import Proxy

# Get or create a proxy object
proxy, created = Proxy.objects.get_or_create(id=1)
proxy.use_proxy = True
proxy.proxies = "socks5://tor:9050"  # This is the Tor container address
proxy.save()

print(f"Proxy configuration {'created' if created else 'updated'} successfully.")
print("Tor proxy set to: socks5://tor:9050")
print("Proxy enabled: True")
EOF
'

echo "[+] Tor proxy configuration complete!"
echo "[+] Now all scans will be routed through Tor automatically."
echo "[+] You can verify this by checking scan results or examining outgoing connections."
