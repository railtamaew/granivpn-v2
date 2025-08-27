# 🚀 Инструкции по настройке сервера GraniVPN

## 📡 Подключение к VPS серверу

### Данные для подключения:
- **IP адрес**: 94.131.107.227
- **Пользователь**: root
- **Пароль**: oNa68L43zFe8

### Способ 1: Через PowerShell/CMD
```powershell
ssh root@94.131.107.227
# Введите пароль: oNa68L43zFe8
```

### Способ 2: Через PuTTY (Windows)
1. Скачайте PuTTY: https://www.putty.org/
2. Откройте PuTTY
3. Введите IP: 94.131.107.227
4. Порт: 22
5. Нажмите "Open"
6. Введите логин: root
7. Введите пароль: oNa68L43zFe8

### Способ 3: Через терминал Linux/Mac
```bash
ssh root@94.131.107.227
# Введите пароль: oNa68L43zFe8
```

## 🔧 Настройка сервера после подключения

### 1. Проверка текущего состояния
```bash
# Проверить текущую директорию
pwd

# Посмотреть содержимое
ls -la

# Проверить статус Docker
docker --version
docker-compose --version
```

### 2. Переход в рабочую директорию
```bash
cd /root
ls -la
```

### 3. Проверка структуры проекта
```bash
# Должны быть следующие папки:
# - admin-panel/
# - backend/
# - mobile-app/
# - server-config/
# - docs/
# - .env файл
```

### 4. Запуск Docker контейнеров
```bash
# Перейти в папку с Docker конфигурацией
cd server-config/docker

# Проверить наличие docker-compose.yml
ls -la

# Запустить контейнеры
docker-compose up -d --build

# Проверить статус контейнеров
docker-compose ps
```

### 5. Проверка работы API
```bash
# Проверить, что API отвечает
curl http://localhost:8000/health

# Проверить логи контейнеров
docker-compose logs api
```

## 🔗 Проверка интеграции

### 1. Тестирование API endpoints
```bash
# Здоровье API
curl http://localhost:8000/health

# Информация об API
curl http://localhost:8000/

# Тестовый endpoint
curl http://localhost:8000/api/test
```

### 2. Тестирование аутентификации
```bash
# Попытка входа (должна вернуть ошибку без пользователей)
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@granivpn.ru","password":"testpassword123"}'
```

### 3. Проверка CORS
```bash
# Тест с Origin header
curl -H "Origin: http://localhost:3000" \
  -H "Access-Control-Request-Method: GET" \
  -H "Access-Control-Request-Headers: X-Requested-With" \
  -X OPTIONS http://localhost:8000/health
```

## 🐛 Устранение проблем

### Проблема: Docker не установлен
```bash
# Установка Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl start docker
systemctl enable docker
```

### Проблема: Docker Compose не установлен
```bash
# Установка Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

### Проблема: Порты заняты
```bash
# Проверить, какие процессы используют порты
netstat -tulpn | grep :8000
netstat -tulpn | grep :5432
netstat -tulpn | grep :6379

# Остановить процессы если нужно
kill -9 <PID>
```

### Проблема: Нет доступа к базе данных
```bash
# Проверить логи PostgreSQL
docker-compose logs postgres

# Пересоздать контейнеры
docker-compose down
docker-compose up -d --build
```

## 📊 Мониторинг

### Проверка статуса сервисов
```bash
# Статус всех контейнеров
docker-compose ps

# Логи всех сервисов
docker-compose logs

# Логи конкретного сервиса
docker-compose logs api
docker-compose logs postgres
docker-compose logs redis
```

### Проверка ресурсов
```bash
# Использование CPU и памяти
htop

# Использование диска
df -h

# Использование памяти контейнерами
docker stats
```

## 🔐 Безопасность

### Настройка файрвола
```bash
# Установка UFW
apt update
apt install ufw

# Настройка правил
ufw allow ssh
ufw allow 80
ufw allow 443
ufw allow 8000
ufw enable
```

### Обновление системы
```bash
# Обновление пакетов
apt update && apt upgrade -y

# Перезагрузка если нужно
reboot
```

## 📝 Полезные команды

### Управление контейнерами
```bash
# Остановить все контейнеры
docker-compose down

# Запустить в фоновом режиме
docker-compose up -d

# Пересобрать и запустить
docker-compose up -d --build

# Посмотреть логи
docker-compose logs -f
```

### Резервное копирование
```bash
# Создать бэкап базы данных
docker-compose exec postgres pg_dump -U granivpn_user granivpn > backup.sql

# Восстановить из бэкапа
docker-compose exec -T postgres psql -U granivpn_user granivpn < backup.sql
```

---

## 🎯 Следующие шаги после настройки сервера:

1. **Проверить работу API** - все endpoints должны отвечать
2. **Настроить SSL сертификаты** - Let's Encrypt для api.granivpn.ru
3. **Обновить DNS записи** - убедиться, что api.granivpn.ru указывает на сервер
4. **Протестировать Admin Panel** - войти в админку и проверить все функции
5. **Интегрировать Mobile App** - обновить API URL в Flutter приложении

---

*Инструкции созданы: 19 августа 2024*
*Статус: Готово к выполнению*
