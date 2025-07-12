#!/bin/bash

set -e

echo "🚀 Inizio setup code-server + cline CLI"

# === Update sistema ===
echo "🔧 Aggiorno i pacchetti..."
apt update && apt upgrade -y

# === Installa dipendenze ===
echo "📦 Installo curl, sudo, git..."
apt install -y curl sudo git

# === Crea utente coder se non esiste ===
if id "coder" &>/dev/null; then
  echo "ℹ️ Utente 'coder' già esistente, salto creazione"
else
  echo "👤 Creo utente 'coder'..."
  useradd -m -s /bin/bash coder
  echo 'coder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
fi

# === Installa code-server ===
echo "⚙️ Installo code-server..."
curl -fsSL https://code-server.dev/install.sh | sh

# === Configuro code-server ===
echo "🛠️ Configuro code-server con password..."
mkdir -p /home/coder/.config/code-server
cat <<EOF > /home/coder/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8080
auth: password
password: vibecoding
cert: false
EOF
chown -R coder:coder /home/coder/.config

systemctl enable --now code-server@coder

# === Dummy CLI: cline ===
echo "🧪 Creo dummy CLI cline..."
mkdir -p /opt/cline
cat <<EOF > /opt/cline/cline.sh
#!/bin/bash
echo \"CLine CLI attivo: connesso a Supabase.\"
EOF
chmod +x /opt/cline/cline.sh
ln -sf /opt/cline/cline.sh /usr/local/bin/cline

# === (Facoltativo) Installa ngrok ===
echo "🌐 (Opzionale) Installo ngrok per test WAN..."
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list
apt update && apt install -y ngrok

echo "✅ Setup completato. code-server disponibile su http://<IP locale>:8080"
