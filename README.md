# ⚙️ setup-vibecoding

Script per configurare automaticamente:
- Supabase self-hosted (Docker)
- code-server con CLI custom (`cline`)

Progettati per girare su Debian stock con solo `git` installato.

---

## 📥 Requisiti
- Debian 11/12
- Git già installato

---

## 🚀 Uso

### 1. Clonare il repository su entrambe le macchine:
```bash
git clone https://github.com/tuoutente/setup-vibecoding.git
cd setup-vibecoding
```

### 2. Sulla VM Supabase:
```bash
sudo bash supabase-vm-setup.sh
```

### 3. Sul container LXC (code-server):
```bash
sudo bash code-server-lxc-setup.sh
```

---

## 🌐 Accesso remoto con Ngrok

Per testare i servizi fuori LAN:

```bash
ngrok http 54321   # per Supabase
ngrok http 8080    # per code-server
```

---

## 🧱 Rete interna
Assicurati che entrambe le macchine siano su `vmbr1` e abbiano IP nella stessa subnet (es: `192.168.10.0/24`).

Nel tuo frontend (o cline), usa l’IP della VM Supabase:

```js
const supabase = createClient(
  'http://192.168.10.10:54321',
  'public-anon-key'
);
```

---

## 📌 Sicurezza
- Non esporre `Studio` o `PostgreSQL` pubblicamente
- Usa ngrok solo per test temporanei
- Proteggi `code-server` con password o Tailscale in produzione
 
