# 🚀 Руководство по деплою GraniVPN на продакшн

## 📋 Подготовка к деплою

### 1. Требования к серверу

#### Минимальные требования:
- **CPU**: 4 ядра
- **RAM**: 8 GB
- **Диск**: 100 GB SSD
- **ОС**: Ubuntu 20.04+ / CentOS 8+ / Debian 11+
- **Сеть**: Статический IP, открытые порты 80, 443, 51820-51822

#### Рекомендуемые требования:
- **CPU**: 8 ядер
- **RAM**: 16 GB
- **Диск**: 200 GB NVMe SSD
- **ОС**: Ubuntu 22.04 LTS
- **Сеть**: Выделенный IP, CDN

### 2. Домены и DNS

#### Необходимые домены:
```
granivpn.com          - Основной сайт
www.granivpn.com      - WWW версия
api.granivpn.com      - API сервер
admin.granivpn.com    - Админ панель
```

#### DNS записи:
```
A    granivpn.com     -> YOUR_SERVER_IP
A    www.granivpn.com -> YOUR_SERVER_IP
A    api.granivpn.com -> YOUR_SERVER_IP
A    admin.granivpn.com -> YOUR_SERVER_IP
```

## 🔧 Установка на сервер

### 1. Подключение к серверу

```bash
ssh root@your-server-ip
```

### 2. Загрузка проекта

```bash
# Клонируем репозиторий
git clone https://github.com/your-username/granivpn.git
cd granivpn

# Делаем скрипт исполняемым
chmod +x scripts/deploy_production.sh
```

### 3. Полная установка

```bash
# Запускаем полную установку
sudo ./scripts/deploy_production.sh install
```

Этот скрипт автоматически:
- ✅ Установит Docker и Docker Compose
- ✅ Создаст все необходимые директории
- ✅ Настроит переменные окружения
- ✅ Создаст SSL сертификаты
- ✅ Настроит файрвол
- ✅ Настроит мониторинг и бэкапы

### 4. Настройка переменных окружения

Отредактируйте файл `/opt/granivpn/.env`:

```bash
nano /opt/granivpn/.env
```

#### Обязательные настройки:

```env
# Замените на реальные IP ваших серверов
EUROPE_SERVER_URL=your-europe-server-ip
ASIA_SERVER_URL=your-asia-server-ip
AMERICA_SERVER_URL=your-america-server-ip

# Настройте домены
API_URL=https://api.granivpn.com
CORS_ORIGINS=https://granivpn.com,https://admin.granivpn.com

# Платежные системы (получите после публикации приложения)
YANDEX_SHOP_ID=your_yandex_shop_id
YANDEX_SECRET_KEY=your_yandex_secret_key
CLOUDPAYMENTS_PUBLIC_ID=your_cloudpayments_public_id
```

### 5. Запуск системы

```bash
# Запускаем все сервисы
sudo ./scripts/deploy_production.sh start

# Проверяем статус
sudo ./scripts/deploy_production.sh status
```

## 🌐 Настройка SSL сертификатов

### 1. Let's Encrypt (рекомендуется)

```bash
# Устанавливаем Certbot
apt install certbot

# Получаем сертификаты
certbot certonly --standalone -d granivpn.com -d www.granivpn.com -d api.granivpn.com -d admin.granivpn.com

# Копируем сертификаты
cp /etc/letsencrypt/live/granivpn.com/fullchain.pem /opt/granivpn/nginx/ssl/granivpn.com.crt
cp /etc/letsencrypt/live/granivpn.com/privkey.pem /opt/granivpn/nginx/ssl/granivpn.com.key

# Настраиваем автообновление
echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -
```

### 2. Коммерческие сертификаты

Если используете коммерческие сертификаты, скопируйте их в:
```
/opt/granivpn/nginx/ssl/granivpn.com.crt
/opt/granivpn/nginx/ssl/granivpn.com.key
```

## 📱 Публикация мобильного приложения

### 1. Подготовка к публикации

```bash
# Собираем мобильное приложение
cd mobile-app

# Android
flutter build appbundle --release

# iOS
flutter build ios --release
```

### 2. Google Play Store

1. Создайте аккаунт разработчика ($25)
2. Загрузите AAB файл
3. Настройте подписки в Google Play Console
4. Получите API ключи для платежей

### 3. App Store

1. Создайте Apple Developer аккаунт ($99/год)
2. Загрузите приложение через Xcode
3. Настройте In-App Purchases
4. Получите API ключи для платежей

### 4. Обновление конфигурации

После получения API ключей обновите `/opt/granivpn/.env`:

```env
# Google Play Billing
GOOGLE_PLAY_BILLING_KEY=your_google_play_key

# App Store
APP_STORE_SHARED_SECRET=your_app_store_secret

# ЮKassa
YANDEX_SHOP_ID=your_yandex_shop_id
YANDEX_SECRET_KEY=your_yandex_secret_key

# CloudPayments
CLOUDPAYMENTS_PUBLIC_ID=your_cloudpayments_public_id
CLOUDPAYMENTS_API_SECRET=your_cloudpayments_secret
```

## 🔍 Мониторинг и аналитика

### 1. Доступ к мониторингу

```bash
# Grafana (локально)
http://your-server-ip:3001
# Логин: admin
# Пароль: admin123

# Prometheus
http://your-server-ip:9090
```

### 2. Логи

```bash
# Просмотр логов
sudo ./scripts/deploy_production.sh logs

# Логи конкретного сервиса
docker logs granivpn-backend
docker logs granivpn-admin
docker logs granivpn-nginx
```

### 3. Метрики

Система автоматически собирает:
- 📊 Производительность серверов
- 👥 Активные пользователи
- 💰 Доходы от подписок
- 🔌 Статус VPN серверов
- 📈 Трафик и нагрузка

## 🔄 Управление системой

### Основные команды:

```bash
# Статус всех сервисов
sudo ./scripts/deploy_production.sh status

# Перезапуск
sudo ./scripts/deploy_production.sh restart

# Обновление системы
sudo ./scripts/deploy_production.sh update

# Создание бэкапа
sudo ./scripts/deploy_production.sh backup

# Остановка системы
sudo ./scripts/deploy_production.sh stop
```

### Управление WireGuard серверами:

```bash
# Статус VPN серверов
sudo ./scripts/manage_wireguard.sh status

# Логи серверов
sudo ./scripts/manage_wireguard.sh logs europe

# Создание клиентской конфигурации
sudo ./scripts/manage_wireguard.sh create-client europe client1
```

## 🛡️ Безопасность

### 1. Файрвол

Система автоматически настраивает файрвол:
- ✅ SSH (порт 22)
- ✅ HTTP/HTTPS (порты 80/443)
- ✅ WireGuard (порты 51820-51822)

### 2. SSL/TLS

- ✅ Принудительный HTTPS
- ✅ Современные шифры
- ✅ HSTS заголовки
- ✅ Автообновление сертификатов

### 3. Rate Limiting

- ✅ API: 10 запросов/сек
- ✅ Логин: 5 попыток/мин
- ✅ Защита от DDoS

## 💾 Бэкапы

### Автоматические бэкапы:

- 📅 **Расписание**: Ежедневно в 2:00
- 💾 **База данных**: PostgreSQL дамп
- ⚙️ **Конфигурации**: SSL, WireGuard
- 🗑️ **Хранение**: 7 дней

### Ручной бэкап:

```bash
sudo ./scripts/deploy_production.sh backup
```

### Восстановление:

```bash
# Восстановление БД
docker exec -i granivpn-postgres psql -U granivpn_user granivpn < backup.sql

# Восстановление конфигураций
tar -xzf configs_backup.tar.gz -C /
```

## 📈 Масштабирование

### 1. Горизонтальное масштабирование

```bash
# Увеличение количества воркеров backend
docker-compose -f docker-compose.production.yml up -d --scale backend=3
```

### 2. Вертикальное масштабирование

Обновите ресурсы в `docker-compose.production.yml`:

```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          cpus: '1'
          memory: 2G
```

### 3. Балансировка нагрузки

Для высоких нагрузок добавьте HAProxy или Nginx upstream.

## 🆘 Устранение неполадок

### Частые проблемы:

#### 1. Сервисы не запускаются
```bash
# Проверка логов
sudo ./scripts/deploy_production.sh logs

# Проверка ресурсов
docker system df
docker system prune
```

#### 2. SSL ошибки
```bash
# Проверка сертификатов
openssl x509 -in /opt/granivpn/nginx/ssl/granivpn.com.crt -text -noout

# Обновление Let's Encrypt
certbot renew
```

#### 3. VPN не работает
```bash
# Проверка WireGuard
sudo ./scripts/manage_wireguard.sh status

# Проверка портов
netstat -tulpn | grep 5182
```

#### 4. База данных недоступна
```bash
# Проверка PostgreSQL
docker exec granivpn-postgres pg_isready

# Восстановление из бэкапа
sudo ./scripts/deploy_production.sh backup
```

## 📞 Поддержка

### Контакты:
- 📧 Email: support@granivpn.com
- 💬 Telegram: @granivpn_support
- 📖 Документация: https://docs.granivpn.com

### Полезные команды:

```bash
# Полная диагностика системы
sudo ./scripts/deploy_production.sh status
docker system df
df -h
free -h
top

# Экспорт логов для поддержки
docker logs granivpn-backend > backend.log
docker logs granivpn-admin > admin.log
docker logs granivpn-nginx > nginx.log
```

---

## 🎯 Чек-лист деплоя

### ✅ Подготовка
- [ ] Сервер соответствует требованиям
- [ ] Домены настроены и указывают на сервер
- [ ] SSH доступ настроен

### ✅ Установка
- [ ] Проект загружен на сервер
- [ ] Полная установка выполнена
- [ ] Переменные окружения настроены
- [ ] SSL сертификаты установлены

### ✅ Запуск
- [ ] Все сервисы запущены
- [ ] Статус всех сервисов "healthy"
- [ ] Сайт доступен по HTTPS
- [ ] API отвечает на запросы

### ✅ Мобильное приложение
- [ ] Приложение опубликовано в Google Play
- [ ] Приложение опубликовано в App Store
- [ ] Платежные системы подключены
- [ ] API ключи обновлены

### ✅ Мониторинг
- [ ] Grafana доступен
- [ ] Метрики собираются
- [ ] Бэкапы работают
- [ ] Логирование настроено

### ✅ Безопасность
- [ ] Файрвол настроен
- [ ] SSL сертификаты валидны
- [ ] Rate limiting работает
- [ ] Бэкапы создаются

---

**🎉 Поздравляем! GraniVPN успешно развернут на продакшене!**





