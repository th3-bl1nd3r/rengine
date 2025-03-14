#!/bin/bash
# Script to verify Tor proxy is working within Docker environment

echo "[+] Checking your normal IP address from host..."
curl -s https://api.ipify.org
echo ""

echo "[+] Checking IP address through Tor container..."
docker-compose exec tor curl -s https://api.ipify.org
echo ""

echo "[+] Checking IP address from reNgine web container..."
docker-compose exec web curl -s --socks5 tor:9050 https://api.ipify.org
echo ""

echo "[+] Verifying Tor connectivity from reNgine web container..."
docker-compose exec web curl -s --socks5 tor:9050 https://check.torproject.org/ | grep -o "Congratulations\|Sorry"
echo ""

echo "[+] Testing tool compatibility with Tor..."
docker-compose exec web bash -c 'export ALL_PROXY="socks5://tor:9050" && subfinder -silent -d zalopay.vn'
echo ""

echo "[+] If the IPs are different and you see 'Congratulations', your Tor proxy is working!"
echo "[+] If subfinder returned results, tools are working through Tor."
