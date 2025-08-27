# 🚀 НАЧИНАЕМ РАЗВЕРТЫВАНИЕ GRANIVPN ПРЯМО СЕЙЧАС!

## ⏰ **Время выполнения: 15 минут**

---

## 📋 **ШАГ 1: GitHub репозиторий (2 минуты)**

### 1.1 Создайте репозиторий
1. Перейдите на [GitHub](https://github.com)
2. Нажмите "New repository"
3. **Repository name**: `granivpn`
4. **Description**: `GraniVPN - Full Stack VPN Platform`
5. **Visibility**: Public
6. **НЕ** ставьте галочки на README, .gitignore, license
7. Нажмите "Create repository"

### 1.2 Загрузите код
```bash
# В терминале (уже готово)
git remote add origin https://github.com/YOUR_USERNAME/granivpn.git
git push -u origin main
```

---

## 📋 **ШАГ 2: DigitalOcean аккаунт (3 минуты)**

### 2.1 Создайте аккаунт
1. Перейдите на [DigitalOcean](https://digitalocean.com)
2. Нажмите "Sign Up"
3. Заполните форму регистрации
4. Подтвердите email

### 2.2 Добавьте SSH ключ
1. В DigitalOcean перейдите в **Settings** → **Security** → **SSH Keys**
2. Нажмите **"Add SSH Key"**
3. **Name**: `GraniVPN`
4. **SSH Key Content**: Вставьте ключ из терминала:
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCki4pljZ+MiRhNEpgSuXQDqJ55h8d+LHdz6nIaJvL/EnKuL9nt8nlWobr5AZa7Ao3GHSfQnTH4v7xl3s2HEyZ9YA+qQLBXsDJ3Kzn9liCblEE8LOWZ1fZXvufKbzWgCr+xTD4HSPmVjUYZX3HFlFrcoYasY2nkVAygQltGUqb6WRrjdn+L0csoTY2V7KM0c2YQts595CYZGX15p4K95IaoT7SP56BIgcYkeTpmUQ1ehwtx1W+GnI/UmBPQ4PpczLJCvXujsmz869ttbDDXpOi5IiHd8Rqw+N1z7vaKtXGNjGcTwFgPw+U6xmKJ22DmRteOvgeE400lixSleNDdii4BKWzN7gOdWuh1KJFEUfj4qBlOa1Y3pgquKD7la3yTimPoHqoRAe5TdX53xCtwN9TqLh/jipDC+O6UFXXZrhLDoQMWI6f5DANNBh8oIIsSeRr5FWYSk0URc4BdfBxSe1p5ZKgCTzvm7ts8TwgiZckkRgj8DpX+W73b5Bipa5nLZt6rTKvrtr3wAlqGYaS81nXkkxXLbwElfUvMNej2WnUbFq44yXgaRHuOGMKfBwN095c9dwPxoDidlrV7zJgjGvMdBp56/BGppagVkoQ45so1nuoJPM8Ic9Y/w/l47QcpVDoNa2Z+5ED6qL99AO3mZKl2EdM7Mk/BGt8IFv3D/+vwzw== granivpn@example.com
```
5. Нажмите **"Add SSH Key"**

### 2.3 Добавьте способ оплаты
1. Перейдите в **Settings** → **Billing**
2. Добавьте кредитную карту или PayPal
3. Подтвердите платежный метод

---

## 📋 **ШАГ 3: Создание Droplet (3 минуты)**

### 3.1 Создайте Droplet
1. В DigitalOcean нажмите **"Create"** → **"Droplets"**
2. **Choose an image**: Ubuntu 22.04 LTS
3. **Choose a plan**: Basic → **$24/month** (4GB RAM, 2 CPU)
4. **Choose a datacenter region**: **Frankfurt** (ближе к России)
5. **Authentication**: SSH Keys → выберите **GraniVPN**
6. **Finalize and create**:
   - **Hostname**: `granivpn-server`
   - **Backups**: Включить
   - **Monitoring**: Включить
7. Нажмите **"Create Droplet"**

### 3.2 Запишите IP адрес
- Скопируйте IP адрес сервера (например: `164.92.123.456`)
- Сохраните для следующих шагов

---

## 📋 **ШАГ 4: Настройка домена (2 минуты)**

### 4.1 Купите домен
1. Перейдите на [Namecheap](https://namecheap.com) или [GoDaddy](https://godaddy.com)
2. Найдите и купите домен: `granivpn.com` (или похожий)
3. Запишите IP вашего сервера

### 4.2 Настройте DNS
1. В панели управления доменом найдите **DNS Management**
2. Добавьте A записи:
   ```
   A    @        → IP вашего сервера
   A    www      → IP вашего сервера
   A    api      → IP вашего сервера
   A    admin    → IP вашего сервера
   ```

---

## 📋 **ШАГ 5: Настройка сервера (3 минуты)**

### 5.1 Подключитесь к серверу
```bash
ssh root@YOUR_SERVER_IP
```

### 5.2 Запустите скрипт настройки
```bash
# Скачайте скрипт
wget https://raw.githubusercontent.com/YOUR_USERNAME/granivpn/main/scripts/setup_server.sh

# Сделайте исполняемым
chmod +x setup_server.sh

# Запустите настройку
./setup_server.sh granivpn.com admin@your-email.com
```

### 5.3 Дождитесь завершения
- Скрипт автоматически установит все необходимое
- Время выполнения: ~10 минут
- В конце появится сообщение об успешной настройке

---

## 📋 **ШАГ 6: Развертывание приложения (2 минуты)**

### 6.1 Клонируйте репозиторий
```bash
# На сервере
cd /opt/granivpn
git clone https://github.com/YOUR_USERNAME/granivpn.git .
```

### 6.2 Создайте .env файл
```bash
nano .env
```

**Вставьте содержимое:**
```env
# Database
DB_PASSWORD=granivpn_secure_password_2024
REDIS_PASSWORD=redis_secure_password_2024

# Security
SECRET_KEY=granivpn_super_secret_key_change_this_in_production_2024
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Environment
ENVIRONMENT=production
CORS_ORIGINS=https://granivpn.com,https://admin.granivpn.com

# Server URLs (замените на ваш IP)
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

### 6.3 Запустите приложение
```bash
# Запустите все сервисы
docker-compose -f docker-compose.production.yml up -d

# Проверьте статус
docker-compose -f docker-compose.production.yml ps
```

---

## 🎉 **ГОТОВО! Проверьте работу:**

### Веб-интерфейсы:
- ✅ **Главный сайт**: https://granivpn.com
- ✅ **Админ панель**: https://admin.granivpn.com
- ✅ **API документация**: https://api.granivpn.com/docs
- ✅ **Grafana мониторинг**: https://granivpn.com:3000

### SSH доступ:
```bash
ssh admin@granivpn.com
```

### Управление:
```bash
# Статус сервисов
docker-compose -f /opt/granivpn/docker-compose.production.yml ps

# Логи
docker-compose -f /opt/granivpn/docker-compose.production.yml logs -f

# Перезапуск
docker-compose -f /opt/granivpn/docker-compose.production.yml restart
```

---

## 🔐 **Безопасность (уже настроено):**
- ✅ SSH ключи только
- ✅ UFW файрвол
- ✅ Fail2ban защита
- ✅ SSL сертификаты
- ✅ Ежедневные бэкапы

## 📊 **Мониторинг (уже настроено):**
- ✅ Prometheus метрики
- ✅ Grafana дашборды
- ✅ Системный мониторинг
- ✅ Алерты по email

## 💰 **Стоимость:**
- **DigitalOcean**: $24/месяц
- **Домен**: ~$10/год
- **Итого**: ~$26/месяц

---

## 🚀 **Следующие шаги:**
1. **Настройте платежные системы** (см. PAYMENT_SETUP_GUIDE.md)
2. **Опубликуйте мобильное приложение** (см. mobile-app/PUBLISHING_GUIDE.md)
3. **Добавьте пользователей** через админ панель
4. **Протестируйте функциональность**

**🎯 GraniVPN успешно развернут и готов к использованию!**
