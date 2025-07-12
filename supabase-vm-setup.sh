```bash
#!/bin/bash

set -e

# === System update and tools ===
echo "🔧 Updating system..."
apt update && apt upgrade -y
apt install -y curl ca-certificates gnupg lsb-release unzip sudo git

# === Docker ===
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com | sh
systemctl enable docker

# === Docker Compose plugin ===
echo "📦 Installing Docker Compose CLI plugin..."
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) \
  -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# === Supabase setup ===
echo "📥 Cloning Supabase local setup..."
git clone https://github.com/supabase/supabase.git ~/supabase
cd ~/supabase/docker

# === Configure Supabase to bind on 0.0.0.0 ===
sed -i 's/localhost/0.0.0.0/g' .env

# === Start Supabase ===
echo "🚀 Starting Supabase..."
docker compose up -d

# === Install ngrok for remote testing ===
echo "🌐 Installing ngrok..."
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
apt update && apt install -y ngrok

# === Instructions ===
echo "✅ Supabase is running on LAN at http://<this-vm-ip>:54321"
echo "🌍 To expose via ngrok: ngrok http 54321"
```

---
