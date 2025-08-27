# 🚀 Быстрое развертывание GraniVPN

## 📋 **Пошаговая инструкция (15 минут)**

### **Шаг 1: Создание GitHub репозитория (2 минуты)**

1. Перейдите на [GitHub](https://github.com)
2. Создайте новый репозиторий: `granivpn`
3. Скопируйте URL репозитория

### **Шаг 2: Загрузка кода в GitHub (3 минуты)**

```bash
# В локальной папке проекта
git remote add origin https://github.com/YOUR_USERNAME/granivpn.git
git branch -M main
git push -u origin main
```

### **Шаг 3: Создание DigitalOcean аккаунта (2 минуты)**

1. Перейдите на [DigitalOcean](https://digitalocean.com)
2. Создайте аккаунт
3. Добавьте способ оплаты

### **Шаг 4: Создание Droplet (3 минуты)**

1. Нажмите "Create" → "Droplets"
2. Выберите:
   - **Image**: Ubuntu 22.04 LTS
   - **Size**: Basic → $24/month (4GB RAM, 2 CPU)
   - **Region**: Frankfurt (ближе к России)
   - **Authentication**: SSH Keys (добавьте ваш ключ)
3. Нажмите "Create Droplet"

### **Шаг 5: Настройка домена (2 минуты)**

1. Купите домен (например: `granivpn.com`)
2. Настройте DNS записи:
   ```
   A    @        → IP вашего сервера
   A    www      → IP вашего сервера
   A    api      → IP вашего сервера
   A    admin    → IP вашего сервера
   ```

### **Шаг 6: Настройка сервера (3 минуты)**

```bash
# Подключитесь к серверу
ssh root@YOUR_SERVER_IP

# Скачайте и запустите скрипт настройки
wget https://raw.githubusercontent.com/YOUR_USERNAME/granivpn/main/scripts/setup_server.sh
chmod +x setup_server.sh
./setup_server.sh granivpn.com admin@your-email.com
```

### **Шаг 7: Настройка GitHub Actions (2 минуты)**

1. В GitHub репозитории перейдите в Settings → Secrets
2. Добавьте секреты:
   ```
   DROPLET_HOST=YOUR_SERVER_IP
   DROPLET_USER=admin
   DROPLET_SSH_KEY=ваш_приватный_ssh_ключ
   DROPLET_PORT=22
   DOMAIN=granivpn.com
   ```

### **Шаг 8: Развертывание приложения (2 минуты)**

```bash
# На сервере
cd /opt/granivpn
git clone https://github.com/YOUR_USERNAME/granivpn.git .

# Создайте файл .env
nano .env
```

**Содержимое .env:**
```env
# Database
DB_PASSWORD=your_secure_password_here
REDIS_PASSWORD=your_redis_password_here

# Security
SECRET_KEY=your_super_secret_key_change_this
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Environment
ENVIRONMENT=production
CORS_ORIGINS=https://granivpn.com,https://admin.granivpn.com

# Server URLs
EUROPE_SERVER_URL=YOUR_SERVER_IP
ASIA_SERVER_URL=YOUR_SERVER_IP
AMERICA_SERVER_URL=YOUR_SERVER_IP

# Payment Systems (заполните позже)
YANDEX_SHOP_ID=your_yandex_shop_id
YANDEX_SECRET_KEY=your_yandex_secret_key
CLOUDPAYMENTS_PUBLIC_ID=your_cloudpayments_public_id
CLOUDPAYMENTS_API_SECRET=your_cloudpayments_api_secret

# Monitoring
GRAFANA_PASSWORD=admin123

# Email (заполните позже)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=noreply@granivpn.com
SMTP_PASSWORD=your_email_password
```

### **Шаг 9: Запуск приложения (1 минута)**

```bash
# Запустите приложение
docker-compose -f docker-compose.production.yml up -d

# Проверьте статус
docker-compose -f docker-compose.production.yml ps
```

### **Шаг 10: Проверка (1 минута)**

Откройте в браузере:
- ✅ https://granivpn.com - Главный сайт
- ✅ https://admin.granivpn.com - Админ панель
- ✅ https://api.granivpn.com/docs - API документация

## 🎯 **Доступ к серверу**

### **SSH доступ:**
```bash
ssh admin@granivpn.com
```

### **Веб-интерфейсы:**
- **GraniVPN**: https://granivpn.com
- **Admin Panel**: https://admin.granivpn.com
- **API**: https://api.granivpn.com
- **Grafana**: https://granivpn.com:3000
- **Prometheus**: https://granivpn.com:9090

### **Управление:**
```bash
# Статус сервисов
docker-compose -f /opt/granivpn/docker-compose.production.yml ps

# Логи
docker-compose -f /opt/granivpn/docker-compose.production.yml logs -f

# Перезапуск
docker-compose -f /opt/granivpn/docker-compose.production.yml restart

# Обновление
cd /opt/granivpn && git pull && docker-compose -f docker-compose.production.yml up -d --build
```

## 🔐 **Безопасность**

- ✅ SSH ключи только
- ✅ UFW файрвол
- ✅ Fail2ban защита
- ✅ SSL сертификаты
- ✅ Ежедневные бэкапы

## 📊 **Мониторинг**

- ✅ Prometheus метрики
- ✅ Grafana дашборды
- ✅ Системный мониторинг
- ✅ Алерты по email/Telegram

## 💰 **Стоимость**

- **DigitalOcean Droplet**: $24/месяц
- **Домен**: ~$10/год
- **Итого**: ~$26/месяц

## 🚀 **Автоматические обновления**

После настройки GitHub Actions, каждое изменение в коде будет автоматически развертываться на сервере при push в main ветку.

---

## 🎉 **Готово!**

**GraniVPN успешно развернут и готов к использованию!**

**Следующие шаги:**
1. Настройте платежные системы (см. PAYMENT_SETUP_GUIDE.md)
2. Опубликуйте мобильное приложение (см. mobile-app/PUBLISHING_GUIDE.md)
3. Настройте мониторинг и алерты
4. Добавьте пользователей и протестируйте функциональность

**Нужна помощь?** См. DEPLOYMENT_GUIDE.md для подробных инструкций.
