# 🔐 НАСТРОЙКА GITHUB SECRETS ДЛЯ АВТОМАТИЧЕСКОГО РАЗВЕРТЫВАНИЯ

## 🎯 Цель
Настроить GitHub Secrets для автоматического развертывания GraniVPN в DigitalOcean через GitHub Actions.

## 📋 Необходимые секреты

### 🔑 Основные секреты для DigitalOcean:

#### 1. `DIGITALOCEAN_ACCESS_TOKEN`
- **Описание**: Токен доступа к DigitalOcean API
- **Как получить**:
  1. Войдите в [DigitalOcean](https://cloud.digitalocean.com)
  2. Перейдите в **API** → **Tokens/Keys**
  3. Нажмите **Generate New Token**
  4. Выберите **Write** права
  5. Скопируйте токен

#### 2. `DIGITALOCEAN_REGISTRY`
- **Описание**: Имя Container Registry в DigitalOcean
- **Как получить**:
  1. В DigitalOcean перейдите в **Container Registry**
  2. Создайте новый registry (например, `granivpn-registry`)
  3. Скопируйте имя registry

#### 3. `DIGITALOCEAN_APP_ID`
- **Описание**: ID приложения в DigitalOcean App Platform
- **Как получить**:
  1. Создайте App в **App Platform**
  2. Скопируйте ID из URL или настроек

#### 4. `DOMAIN_NAME`
- **Описание**: Ваш домен (например, `granivpn.com`)
- **Как получить**: Зарегистрируйте домен или используйте существующий

#### 5. `DNS_A_RECORD_ID`
- **Описание**: ID DNS A записи для вашего домена
- **Как получить**:
  1. В DigitalOcean перейдите в **Networking** → **Domains**
  2. Выберите ваш домен
  3. Найдите A запись и скопируйте её ID

#### 6. `DIGITALOCEAN_LOAD_BALANCER_IP`
- **Описание**: IP адрес Load Balancer
- **Как получить**:
  1. Создайте Load Balancer в **Networking**
  2. Скопируйте IP адрес

### 🔑 Секреты для SSH развертывания:

#### 7. `DROPLET_HOST`
- **Описание**: IP адрес вашего DigitalOcean Droplet
- **Как получить**: IP адрес Droplet из панели управления

#### 8. `DROPLET_USER`
- **Описание**: Имя пользователя для SSH (обычно `root`)
- **Значение**: `root`

#### 9. `DROPLET_SSH_KEY`
- **Описание**: Приватный SSH ключ для подключения к серверу
- **Как получить**:
  1. Создайте SSH ключ: `ssh-keygen -t rsa -b 4096`
  2. Скопируйте содержимое приватного ключа (`~/.ssh/id_rsa`)

#### 10. `DROPLET_PORT`
- **Описание**: SSH порт (обычно 22)
- **Значение**: `22`

### 🔑 Дополнительные секреты:

#### 11. `SLACK_WEBHOOK` (опционально)
- **Описание**: Webhook URL для Slack уведомлений
- **Как получить**: Настройте Slack app и получите webhook URL

## 🚀 Пошаговая настройка

### Шаг 1: Перейдите в GitHub репозиторий
1. Откройте ваш репозиторий: `https://github.com/railtamaew/granivpn-v2`
2. Нажмите **Settings** (вкладка)

### Шаг 2: Откройте Secrets and variables
1. В левом меню нажмите **Secrets and variables** → **Actions**
2. Нажмите **New repository secret**

### Шаг 3: Добавьте каждый секрет
Добавляйте секреты по одному:

```
Name: DIGITALOCEAN_ACCESS_TOKEN
Value: [ваш токен]

Name: DIGITALOCEAN_REGISTRY
Value: [имя registry]

Name: DOMAIN_NAME
Value: [ваш домен]

Name: DROPLET_HOST
Value: [IP адрес сервера]

Name: DROPLET_USER
Value: root

Name: DROPLET_SSH_KEY
Value: [содержимое приватного ключа]

Name: DROPLET_PORT
Value: 22
```

## 🔍 Проверка настройки

### После добавления всех секретов:
1. Перейдите в **Actions** вкладку
2. Выберите workflow **Deploy GraniVPN to Production**
3. Нажмите **Run workflow**
4. Выберите ветку **main**
5. Нажмите **Run workflow**

### Что произойдет:
1. ✅ GitHub Actions запустит тесты
2. ✅ Соберет Docker образы
3. ✅ Отправит их в DigitalOcean Container Registry
4. ✅ Развернет на вашем сервере
5. ✅ Обновит DNS записи
6. ✅ Отправит уведомление об успехе

## 🎯 Результат

После успешного выполнения:
- 🌐 Ваш сайт будет доступен по адресу: `https://granivpn.com`
- 📱 Mobile App: `https://mobile.granivpn.com`
- 🖥️ Admin Panel: `https://admin.granivpn.com`
- 🔧 API: `https://api.granivpn.com`

## 🆘 Устранение проблем

### Если workflow не запускается:
1. Проверьте, что все секреты добавлены
2. Убедитесь, что workflow файлы в `.github/workflows/`
3. Проверьте права доступа к репозиторию

### Если развертывание не удается:
1. Проверьте логи в GitHub Actions
2. Убедитесь, что сервер доступен по SSH
3. Проверьте права доступа к DigitalOcean API

## 🎉 Готово!

После настройки всех секретов:
1. **Push в main ветку** автоматически запустит развертывание
2. **Pull Request** запустит тесты
3. **Manual trigger** доступен через **Actions** → **Run workflow**

---

*Инструкция по настройке GitHub Secrets для GraniVPN*
*Дата: $(date)*
*Статус: Готово к настройке*
