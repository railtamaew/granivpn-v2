# ⚡ Быстрый старт деплоя GraniVPN

## 🎯 Результат
После деплоя у вас будет:
- ✅ **Admin Panel**: https://spectacular-begonia-477baa.netlify.app (уже работает)
- ✅ **Mobile App**: https://gleaming-brioche-b0b809.netlify.app (уже работает)
- 🔄 **Backend API**: https://api.granivpn.ru (нужен VPS)
- 🔄 **Собственные домены**: admin.granivpn.ru, app.granivpn.ru

---

## 🚀 Шаг 1: Аренда VPS сервера

### Рекомендуемые провайдеры:
- **DigitalOcean**: $20/месяц (4GB RAM, 2 CPU) - [создать](https://digitalocean.com)
- **Vultr**: $20/месяц (4GB RAM, 2 CPU) - [создать](https://vultr.com)
- **Hetzner**: €15/месяц (4GB RAM, 2 CPU) - [создать](https://hetzner.com)

### Требования:
- **OS**: Ubuntu 20.04 LTS
- **RAM**: минимум 2GB (рекомендуется 4GB)
- **Disk**: минимум 20GB SSD
- **Network**: минимум 100 Mbps

---

## ⚡ Шаг 2: Автоматический деплой (5 минут)

```bash
# 1. Подключение к серверу
ssh root@YOUR_SERVER_IP

# 2. Скачивание проекта
git clone https://github.com/YOUR_USERNAME/granivpn.git
cd granivpn

# 3. Запуск автоматического деплоя
chmod +x server-config/deploy-production.sh
sudo ./server-config/deploy-production.sh
```

**Скрипт автоматически:**
- ✅ Установит Docker, WireGuard, SSL
- ✅ Настроит файрвол и безопасность
- ✅ Создаст базу данных и администратора
- ✅ Запустит все сервисы

---

## 🌐 Шаг 3: Настройка DNS (если есть домен)

Создайте A-записи в вашем DNS провайдере:
```
granivpn.ru          → YOUR_SERVER_IP
api.granivpn.ru      → YOUR_SERVER_IP  
admin.granivpn.ru    → YOUR_SERVER_IP
app.granivpn.ru      → YOUR_SERVER_IP
```

---

## 🔗 Шаг 4: Интеграция с существующими сайтами

### Обновление Admin Panel:
```bash
# Изменить API URL в admin panel
cd admin-panel
nano src/services/api.ts

# Заменить на:
const API_BASE_URL = 'https://api.granivpn.ru';

# Пересобрать и переопубликовать
npm run build
# Загрузить build/ на Netlify
```

### Обновление Mobile App:
```bash
# Изменить API URL в mobile app
cd mobile-app
nano lib/config/app_config.dart

# Заменить на:
static const String apiBaseUrl = 'https://api.granivpn.ru';

# Пересобрать и переопубликовать
flutter build web
# Загрузить build/web/ на Netlify
```

---

## ✅ Проверка работоспособности

После деплоя проверьте:

### Backend API:
- https://api.granivpn.ru/docs - Swagger документация
- https://api.granivpn.ru/health - Статус здоровья

### Admin Panel:
- https://admin.granivpn.ru (или Netlify ссылка)
- Логин: admin@granivpn.ru
- Пароль: admin123

### Mobile App:
- https://app.granivpn.ru (или Netlify ссылка)
- Протестируйте все экраны

### Мониторинг:
- https://granivpn.ru:5555 - Flower (Celery мониторинг)

---

## 🔧 Полезные команды

```bash
# Логи всех сервисов
docker-compose logs -f

# Рестарт сервисов
docker-compose restart

# Обновление проекта
git pull && docker-compose up -d --build

# Статус контейнеров
docker-compose ps

# Бэкап базы данных
docker-compose exec postgres pg_dump -U granivpn_user granivpn > backup.sql
```

---

## 💰 Стоимость

### Текущие расходы (в месяц):
- ✅ **Netlify**: $0 (бесплатно)
- 🔄 **VPS сервер**: $20-50
- 🔄 **Домен**: $1-2 (опционально)

**Итого**: $20-52/месяц

---

## 🚨 Поддержка

При возникновении проблем:

1. **Проверьте логи**: `docker-compose logs -f`
2. **Перезапустите сервисы**: `docker-compose restart`
3. **Проверьте DNS**: `nslookup api.granivpn.ru`
4. **Проверьте SSL**: `curl -I https://api.granivpn.ru`

---

## 🎉 Готово!

После выполнения всех шагов у вас будет:
- **Полностью работающий VPN сервис**
- **Красивая админ панель**  
- **Мобильное приложение**
- **Автоматические SSL сертификаты**
- **Мониторинг и логирование**

**Проект готов к продакшену и демонстрации инвесторам!** 🚀




