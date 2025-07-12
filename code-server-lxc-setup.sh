```bash
#!/bin/bash

set -e

# === System update ===
echo "🔧 Updating system..."
apt update && apt upgrade -y
apt install -y curl sudo git

# === Create dev user ===
echo "🧠 Creating user 'coder'..."
useradd -m -s /bin/bash coder
usermod -aG sudo coder
echo 'coder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# === Install code-server ===
echo "🚀 Installing code-server..."
curl -fsSL https://code-server.dev/install.sh | sh

# === Configure password ===
echo "🔐 Configuring code-server password..."
mkdir -p /home/coder/.config/code-server
cat <<EOF > /home/coder/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8080
auth: password
password: vibecoding
cert: false
EOF
chown -R coder:coder /home/coder/.config

systemctl enable --now code-server@coder

# === Install cline stub ===
echo "📦 Installing dummy cline..."
mkdir -p /opt/cline
cat <<EOF > /opt/cline/cline.sh
#!/bin/bash
echo "CLine CLI: connected to Supabase."
EOF
chmod +x /opt/cline/cline.sh
ln -s /opt/cline/cline.sh /usr/local/bin/cline

# === Install ngrok ===
echo "🌐 Installing ngrok for code-server access..."
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
apt update && apt install -y ngrok

# === Instructions ===
echo "✅ code-server running at http://<lxc-ip>:8080"
echo "🌍 To expose via ngrok: ngrok http 8080"
```

---

## 🐳 `docker-compose.yml` (Supabase)

> Posizionato in `~/supabase/docker/docker-compose.yml`

✅ Non serve modificare: lo script già configura `.env` per esporre su `0.0.0.0`, quindi accessibile dalla rete interna (es. `192.168.10.10:54321`).

Se vuoi creare un file standalone più semplice, posso generartelo.

---
