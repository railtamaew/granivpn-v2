# 🌊 РАЗВЕРТЫВАНИЕ GRANIVPN В DIGITALOCEAN

## 🎯 Обзор
Это руководство описывает пошаговое развертывание GraniVPN в DigitalOcean с использованием Docker и Docker Compose.

## 📋 Предварительные требования

### 1. DigitalOcean аккаунт
- Зарегистрируйтесь на [digitalocean.com](https://digitalocean.com)
- Добавьте способ оплаты
- Создайте SSH ключ

### 2. Домен (опционально, но рекомендуется)
- Зарегистрируйте домен (например, granivpn.com)
- Настройте DNS записи

## 🚀 Шаг 1: Создание Droplet

### 1.1 Создание нового Droplet
1. Войдите в DigitalOcean Dashboard
2. Нажмите "Create" → "Droplets"
3. Выберите настройки:
   - **Image**: Ubuntu 22.04 LTS
   - **Size**: Basic → Regular → $12/month (2GB RAM, 1 CPU)
   - **Datacenter**: Выберите ближайший к вашим пользователям
   - **Authentication**: SSH Key (ваш ключ)
   - **Hostname**: granivpn-server

### 1.2 Подключение к серверу
```bash
ssh root@YOUR_SERVER_IP
```

## 🔧 Шаг 2: Настройка сервера

### 2.1 Обновление системы
```bash
apt update && apt upgrade -y
```

### 2.2 Установка Docker
```bash
# Установка Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Установка Docker Compose
apt install docker-compose-plugin -y

# Проверка установки
docker --version
docker compose version
```

### 2.3 Установка дополнительных инструментов
```bash
apt install -y curl wget git htop nginx certbot python3-certbot-nginx
```

## 📁 Шаг 3: Развертывание приложения

### 3.1 Клонирование репозитория
```bash
# Переход в домашнюю директорию
cd ~

# Клонирование проекта
git clone https://github.com/railtamaew/granivpn-v2.git
cd granivpn-v2
```

### 3.2 Настройка переменных окружения
```bash
# Копирование файла переменных
cp env.production .env

# Редактирование переменных (замените на ваши значения)
nano .env
```

### 3.3 Запуск развертывания
```bash
# Сделать скрипт исполняемым
chmod +x deploy-digitalocean.sh

# Запуск развертывания
./deploy-digitalocean.sh
```

## 🌐 Шаг 4: Настройка Nginx и SSL

### 4.1 Создание Nginx конфигурации
```bash
# Создание конфигурации для домена
cat > /etc/nginx/sites-available/granivpn << 'EOF'
server {
    listen 80;
    server_name granivpn.com www.granivpn.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    location /api {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    location /mobile {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF
```

### 4.2 Активация сайта
```bash
# Создание символической ссылки
ln -s /etc/nginx/sites-available/granivpn /etc/nginx/sites-enabled/

# Удаление дефолтного сайта
rm /etc/nginx/sites-enabled/default

# Проверка конфигурации
nginx -t

# Перезапуск Nginx
systemctl restart nginx
```

### 4.3 Получение SSL сертификата
```bash
# Получение SSL сертификата через Let's Encrypt
certbot --nginx -d granivpn.com -d www.granivpn.com

# Автоматическое обновление сертификатов
crontab -e
# Добавить строку: 0 12 * * * /usr/bin/certbot renew --quiet
```

## 🔒 Шаг 5: Настройка безопасности

### 5.1 Настройка Firewall
```bash
# Установка UFW
apt install ufw -y

# Настройка правил
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 51820/udp  # WireGuard

# Активация firewall
ufw enable
```

### 5.2 Настройка SSH
```bash
# Редактирование SSH конфигурации
nano /etc/ssh/sshd_config

# Изменить порт (опционально)
# Port 2222

# Отключить root логин
# PermitRootLogin no

# Перезапуск SSH
systemctl restart sshd
```

## 📊 Шаг 6: Мониторинг и логи

### 6.1 Просмотр логов
```bash
# Логи всех сервисов
docker compose -f docker-compose.production.yml logs -f

# Логи конкретного сервиса
docker compose -f docker-compose.production.yml logs -f backend
```

### 6.2 Мониторинг ресурсов
```bash
# Мониторинг в реальном времени
htop

# Статистика Docker
docker stats
```

## 🚀 Шаг 7: Тестирование

### 7.1 Проверка сервисов
```bash
# Backend API
curl https://granivpn.com/api/health

# Admin Panel
curl https://granivpn.com

# Mobile App
curl https://granivpn.com/mobile
```

### 7.2 Проверка WireGuard
```bash
# Проверка статуса WireGuard
docker exec granivpn-wireguard wg show
```

## 🔄 Шаг 8: Обновления и бэкапы

### 8.1 Автоматические обновления
```bash
# Создание скрипта обновления
cat > /root/update-granivpn.sh << 'EOF'
#!/bin/bash
cd /root/granivpn-v2
git pull origin main
docker compose -f docker-compose.production.yml down
docker compose -f docker-compose.production.yml up --build -d
EOF

chmod +x /root/update-granivpn.sh

# Добавление в cron (обновление каждый день в 3:00)
crontab -e
# 0 3 * * * /root/update-granivpn.sh
```

### 8.2 Бэкапы базы данных
```bash
# Создание скрипта бэкапа
cat > /root/backup-db.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

docker exec granivpn-postgres pg_dump -U granivpn granivpn > $BACKUP_DIR/granivpn_$DATE.sql

# Удаление старых бэкапов (старше 7 дней)
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
EOF

chmod +x /root/backup-db.sh

# Добавление в cron (бэкап каждый день в 2:00)
crontab -e
# 0 2 * * * /root/backup-db.sh
```

## 🎯 Шаг 9: Финальная настройка

### 9.1 Настройка DNS
Настройте DNS записи вашего домена:
```
A    granivpn.com        → YOUR_SERVER_IP
A    www.granivpn.com    → YOUR_SERVER_IP
A    api.granivpn.com    → YOUR_SERVER_IP
```

### 9.2 Проверка работоспособности
1. Откройте https://granivpn.com в браузере
2. Проверьте админ панель
3. Протестируйте API
4. Проверьте мобильное приложение

## 📋 Полезные команды

### Управление сервисами
```bash
# Запуск всех сервисов
docker compose -f docker-compose.production.yml up -d

# Остановка всех сервисов
docker compose -f docker-compose.production.yml down

# Перезапуск сервиса
docker compose -f docker-compose.production.yml restart backend

# Просмотр статуса
docker compose -f docker-compose.production.yml ps
```

### Логи и отладка
```bash
# Логи в реальном времени
docker compose -f docker-compose.production.yml logs -f

# Логи конкретного сервиса
docker logs granivpn-backend

# Вход в контейнер
docker exec -it granivpn-backend bash
```

## 🆘 Устранение проблем

### Сервис не запускается
```bash
# Проверка логов
docker logs CONTAINER_NAME

# Проверка статуса
docker ps -a

# Перезапуск
docker compose -f docker-compose.production.yml restart
```

### Проблемы с базой данных
```bash
# Проверка подключения
docker exec -it granivpn-postgres psql -U granivpn -d granivpn

# Сброс базы данных
docker exec -it granivpn-postgres psql -U granivpn -c "DROP DATABASE granivpn; CREATE DATABASE granivpn;"
```

## 🎉 Готово!

После выполнения всех шагов у вас будет:
- ✅ Работающий GraniVPN сервер
- ✅ Безопасное HTTPS соединение
- ✅ Автоматические обновления
- ✅ Регулярные бэкапы
- ✅ Мониторинг и логи

## 📞 Поддержка

При возникновении проблем:
1. Проверьте логи: `docker logs CONTAINER_NAME`
2. Проверьте статус сервисов: `docker ps -a`
3. Обратитесь к документации проекта
4. Создайте issue в GitHub репозитории

---

*Руководство создано для GraniVPN v2*
*Дата: $(date)*
