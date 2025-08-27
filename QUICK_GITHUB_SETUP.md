# ⚡ БЫСТРАЯ НАСТРОЙКА GITHUB SECRETS

## 🎯 Минимальные секреты для автоматического развертывания

Для работы упрощенного workflow нужны только **4 секрета**:

### 🔑 Обязательные секреты:

#### 1. `DROPLET_HOST`
- **Что это**: IP адрес вашего DigitalOcean сервера
- **Пример**: `123.456.789.012`

#### 2. `DROPLET_USER`
- **Что это**: Имя пользователя для SSH
- **Значение**: `root`

#### 3. `DROPLET_SSH_KEY`
- **Что это**: Приватный SSH ключ
- **Как получить**: Содержимое файла `~/.ssh/id_rsa`

#### 4. `DROPLET_PORT`
- **Что это**: SSH порт
- **Значение**: `22`

## 🚀 Быстрая настройка (3 минуты)

### Шаг 1: Создайте SSH ключ (если нет)
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
# Нажмите Enter для всех вопросов
```

### Шаг 2: Скопируйте публичный ключ на сервер
```bash
ssh-copy-id root@YOUR_SERVER_IP
```

### Шаг 3: Добавьте секреты в GitHub
1. Перейдите в ваш репозиторий
2. **Settings** → **Secrets and variables** → **Actions**
3. **New repository secret**

### Шаг 4: Добавьте секреты
```
Name: DROPLET_HOST
Value: [IP вашего сервера]

Name: DROPLET_USER
Value: root

Name: DROPLET_SSH_KEY
Value: [содержимое ~/.ssh/id_rsa]

Name: DROPLET_PORT
Value: 22
```

## 🎯 Что произойдет после настройки

### При push в main ветку:
1. ✅ GitHub Actions автоматически запустится
2. ✅ Подключится к вашему серверу
3. ✅ Обновит код
4. ✅ Запустит Docker контейнеры
5. ✅ Проверит работоспособность

### Результат:
- 🌐 Backend API: `http://YOUR_SERVER_IP:8000`
- 🖥️ Admin Panel: `http://YOUR_SERVER_IP:3000`
- 📱 Mobile App: `http://YOUR_SERVER_IP:8080`

## 🔍 Проверка настройки

### 1. Добавьте секреты
### 2. Сделайте любой commit и push
### 3. Перейдите в **Actions** вкладку
### 4. Увидите запущенный workflow

## 🆘 Если что-то не работает

### Проверьте:
1. ✅ Все 4 секрета добавлены
2. ✅ SSH ключ работает: `ssh root@YOUR_SERVER_IP`
3. ✅ Сервер доступен по SSH
4. ✅ Docker установлен на сервере

### Полезные команды:
```bash
# Проверка SSH подключения
ssh root@YOUR_SERVER_IP

# Проверка Docker
docker --version
docker compose version

# Проверка портов
netstat -tlnp | grep :22
```

## 🎉 Готово!

После настройки:
- **Каждый push в main** автоматически развернет приложение
- **Ручной запуск** доступен в Actions → Run workflow
- **Логи** доступны в GitHub Actions

---

*Быстрая настройка GitHub Secrets для GraniVPN*
*Время настройки: 3 минуты*
*Статус: Готово к использованию*
