# 🚀 БЫСТРОЕ РАЗВЕРТЫВАНИЕ В DIGITALOCEAN

## ⚡ Экспресс-развертывание (5 минут)

### 1. Создайте Droplet в DigitalOcean
- Ubuntu 22.04 LTS
- 2GB RAM, 1 CPU
- Ваш SSH ключ

### 2. Подключитесь к серверу
```bash
ssh root@YOUR_SERVER_IP
```

### 3. Выполните команды
```bash
# Обновление системы
apt update && apt upgrade -y

# Установка Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
apt install docker-compose-plugin -y

# Клонирование проекта
cd ~ && git clone https://github.com/railtamaew/granivpn-v2.git
cd granivpn-v2

# Запуск развертывания
chmod +x deploy-digitalocean.sh
./deploy-digitalocean.sh
```

### 4. Готово! 🎉
- Backend API: http://YOUR_SERVER_IP:8000
- Admin Panel: http://YOUR_SERVER_IP:3000
- Mobile App: http://YOUR_SERVER_IP:8080

## 🔗 Полная документация
См. `DIGITALOCEAN_DEPLOYMENT.md` для детальных инструкций.

## 📋 Что включено
- ✅ Backend API (Python FastAPI)
- ✅ Admin Panel (React)
- ✅ Mobile App (Flutter Web)
- ✅ PostgreSQL Database
- ✅ Redis Cache
- ✅ WireGuard VPN Server
- ✅ Nginx Reverse Proxy

## 💰 Стоимость
- **Droplet**: $12/месяц
- **Домен**: ~$10/год
- **SSL**: Бесплатно (Let's Encrypt)

---
*Быстрый старт GraniVPN в DigitalOcean*
