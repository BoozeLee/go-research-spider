# 🔒 Jazzy Jellyfish OS - AI Security & Privacy Setup

Complete guide for secure AI development environment on Arch Linux.

## Table of Contents

1. [System Hardening](#system-hardening)
2. [Privacy Tools](#privacy-tools)
3. [AI Security Best Practices](#ai-security-best-practices)
4. [Secure Development Environment](#secure-development-environment)
5. [Network Security](#network-security)

---

## System Hardening

### Kernel Hardening

```bash
# Install hardened kernel
pacman -S linux-hardened linux-hardened-headers

# Enable ASLR (usually enabled by default)
cat /proc/sys/kernel/randomize_va_space  # Should be 2

# Hide kernel pointers
echo "kernel.kptr_restrict=2" >> /etc/sysctl.d/99-hardening.conf

# Restrict dmesg access
echo "kernel.dmesg_restrict=1" >> /etc/sysctl.d/99-hardening.conf

# Disable unprivileged BPF
echo "kernel.unprivileged_bpf_disabled=1" >> /etc/sysctl.d/99-hardening.conf

# Restrict ptrace
echo "kernel.yama.ptrace_scope=2" >> /etc/sysctl.d/99-hardening.conf

# Apply settings
sysctl --system
```

### LKRG (Linux Kernel Runtime Guard)

```bash
# Install from AUR
paru -S lkrg-dkms

# Enable at boot
systemctl enable lkrg
```

### Secure Boot

```bash
# Install sbctl
pacman -S sbctl

# Create and enroll keys
sbctl create-keys
sbctl enroll-keys

# Verify status
sbctl status
```

---

## Privacy Tools

### Full Disk Encryption

Already configured with LUKS. Verify:
```bash
lsblk -f | grep crypto_LUKS
```

### Encrypted Home Directory

```bash
# Additional fscrypt for per-file encryption
pacman -S fscrypt

# Enable for root
fscrypt setup

# Enable for user
fscrypt setup /home

# Protect home directory
fscrypt encrypt /home/kilisan --user=kilisan
```

### Tor Integration

```bash
pacman -S tor torsocks

systemctl enable tor
systemctl start tor

# Use with torsocks
torsocks curl https://check.torproject.org
```

### DNS Privacy

```bash
# Install stubby for DNS-over-TLS
pacman -S stubby

# Configure /etc/stubby/stubby.yml
# Enable service
systemctl enable stubby
```

---

## AI Security Best Practices

### Model Security

1. **Verify Model Checksums**
```bash
# Always verify downloaded models
sha256sum model.bin
# Compare with official checksum
```

2. **Sandbox AI Models**
```bash
# Run untrusted models in Firejail
pacman -S firejail
firejail --noprofile python inference.py
```

3. **Use Trusted Sources**
- Hugging Face (verified organizations)
- Official model repositories
- Avoid random GitHub repos

### API Security

```bash
# Never hardcode API keys
# Use environment variables or secret managers

# Create .env file (gitignored)
echo "GROQ_API_KEY=your_key_here" >> .env
echo "OPENAI_API_KEY=your_key_here" >> .env

# Load in Python
from dotenv import load_dotenv
load_dotenv()
```

### Data Privacy

```bash
# Secure deletion
pacman -S secure-delete
srm -r sensitive_data/

# Secure file permissions
chmod 600 ~/.ssh/*
chmod 700 ~/.gnupg
```

---

## Secure Development Environment

### Container Isolation

```bash
# Install Docker
pacman -S docker docker-compose
systemctl enable docker

# Add user to docker group
usermod -aG docker kilisan

# Use rootless containers
pacman -S podman
```

### Python Virtual Environments

```bash
# Use uv for fast, secure environments
pacman -S uv

# Create isolated environment
uv venv --python 3.12
source .venv/bin/activate

# Install with hash checking
uv pip install --require-hashes -r requirements.txt
```

### Git Security

```bash
# Sign commits
git config --global user.signingkey your_gpg_key
git config --global commit.gpgsign true

# Verify signatures
git config --global tag.gpgsign true
```

### IDE Security

```bash
# Use sandboxed IDE when possible
# Review extensions before installing
# Keep IDE updated
```

---

## Network Security

### Firewall Configuration

```bash
pacman -S ufw

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (if needed)
ufw allow 22/tcp

# Allow specific ports for AI services
ufw allow 8000/tcp  # Local AI API
ufw allow 8080/tcp  # Web UI

# Enable
ufw enable
systemctl enable ufw
```

### Fail2ban

```bash
pacman -S fail2ban

# Enable SSH protection
cat > /etc/fail2ban/jail.local << 'EOF'
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
EOF

systemctl enable fail2ban
systemctl start fail2ban
```

### Network Monitoring

```bash
# Install monitoring tools
pacman -S wireshark-qt nmap netstat

# Monitor connections
ss -tulpn

# Check for suspicious connections
netstat -tulpn | grep ESTABLISHED
```

---

## AI-Specific Security Tools

### Ollama Security

```bash
# Run Ollama in isolated network
# Create systemd service override
systemctl edit ollama

# Add:
[Service]
PrivateTmp=true
ProtectHome=true
NoNewPrivileges=true
```

### Groq API Security

```python
# Use rate limiting
import time
from groq import Groq

client = Groq(api_key=os.environ.get("GROQ_API_KEY"))

def safe_request(prompt):
    try:
        response = client.chat.completions.create(
            messages=[{"role": "user", "content": prompt}],
            model="llama3-8b-8192",
        )
        return response.choices[0].message.content
    except Exception as e:
        log_error(e)
        time.sleep(1)  # Rate limit
        return None
```

### Local LLM Security

```bash
# Run local models with resource limits
systemd-run --scope -p MemoryMax=8G ollama serve

# Monitor GPU usage
watch -n 1 nvidia-smi
```

---

## Audit and Monitoring

### System Audit

```bash
pacman -S audit

# Enable auditing
systemctl enable auditd

# Monitor sensitive files
auditctl -w /etc/passwd -p wa
auditctl -w /etc/shadow -p wa
auditctl -w /etc/sudoers -p wa
```

### Log Analysis

```bash
# Centralized logging
journalctl -f

# Check for security events
journalctl -p err -b

# SSH failures
grep "Failed password" /var/log/auth.log
```

---

## Quick Setup Script

```bash
#!/bin/bash
# Jazzy Jellyfish Security Setup

# System hardening
pacman -S linux-hardened ufw fail2ban audit
systemctl enable ufw fail2ban auditd

# Privacy tools
pacman -S tor stubby fscrypt

# Dev security
pacman -S docker podman uv firejail

# Apply sysctl settings
cat >> /etc/sysctl.d/99-security.conf << EOF
kernel.kptr_restrict=2
kernel.dmesg_restrict=1
kernel.unprivileged_bpf_disabled=1
kernel.yama.ptrace_scope=2
EOF

sysctl --system

echo "✓ Security setup complete!"
```

---

## Resources

- [Arch Wiki Security](https://wiki.archlinux.org/title/Security)
- [CIS Benchmarks](https://www.cisecurity.org/benchmark/arch_linux)
- [OWASP AI Security](https://owasp.org/www-project-ai-security-and-privacy-guide/)
