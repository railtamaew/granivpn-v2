#!/bin/bash

# Автоматическая интеграция Frontend с Backend API
# GraniVPN Project

set -e

echo "🚀 Начинаю интеграцию Frontend с Backend API..."

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. Исправляем Nginx конфигурацию
print_status "1. Исправляю Nginx конфигурацию..."

cat > /etc/nginx/sites-available/granivpn << 'EOF'
server {
    listen 80;
    server_name admin.granivpn.ru app.granivpn.ru api.granivpn.ru;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name admin.granivpn.ru;
    ssl_certificate /etc/letsencrypt/live/admin.granivpn.ru/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/admin.granivpn.ru/privkey.pem;
    
    location / {
        proxy_pass https://spectacular-begonia-477baa.netlify.app;
        proxy_set_header Host spectacular-begonia-477baa.netlify.app;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_ssl_verify off;
    }
}

server {
    listen 443 ssl http2;
    server_name app.granivpn.ru;
    ssl_certificate /etc/letsencrypt/live/admin.granivpn.ru/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/admin.granivpn.ru/privkey.pem;
    
    location / {
        proxy_pass https://gleaming-brioche-b0b809.netlify.app;
        proxy_set_header Host gleaming-brioche-b0b809.netlify.app;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_ssl_verify off;
    }
}

server {
    listen 443 ssl http2;
    server_name api.granivpn.ru;
    ssl_certificate /etc/letsencrypt/live/admin.granivpn.ru/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/admin.granivpn.ru/privkey.pem;
    
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# 2. Перезагружаем Nginx
print_status "2. Перезагружаю Nginx..."
nginx -t && systemctl reload nginx

# 3. Запускаем Backend API
print_status "3. Запускаю Backend API..."

cd /root/backend

# Создаем requirements.txt если его нет
if [ ! -f requirements.txt ]; then
    cat > requirements.txt << 'EOF'
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
redis==5.0.1
celery==5.3.4
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
pydantic==2.5.0
python-dotenv==1.0.0
requests==2.31.0
aiofiles==23.2.1
cryptography==41.0.8
pywireguard==0.1.0
pytz==2023.3
EOF
fi

# Устанавливаем зависимости
pip install -r requirements.txt

# Запускаем API в фоне
nohup uvicorn main:app --host 0.0.0.0 --port 8000 --reload > /var/log/granivpn-api.log 2>&1 &

# 4. Обновляем Admin Panel для работы с реальным API
print_status "4. Обновляю Admin Panel для работы с реальным API..."

cd /root/admin-panel

# Создаем .env файл
cat > .env << 'EOF'
REACT_APP_API_URL=https://api.granivpn.ru
REACT_APP_ADMIN_URL=https://admin.granivpn.ru
REACT_APP_APP_URL=https://app.granivpn.ru
EOF

# Обновляем API конфигурацию
cat > src/config/api.ts << 'EOF'
export const API_CONFIG = {
    BASE_URL: process.env.REACT_APP_API_URL || 'https://api.granivpn.ru',
    TIMEOUT: 10000,
    ENDPOINTS: {
        AUTH: {
            LOGIN: '/api/auth/login',
            REGISTER: '/api/auth/register',
            REFRESH: '/api/auth/refresh',
            LOGOUT: '/api/auth/logout',
        },
        USERS: {
            LIST: '/api/users',
            CREATE: '/api/users',
            UPDATE: '/api/users/{id}',
            DELETE: '/api/users/{id}',
        },
        SERVERS: {
            LIST: '/api/servers',
            CREATE: '/api/servers',
            UPDATE: '/api/servers/{id}',
            DELETE: '/api/servers/{id}',
        },
        PAYMENTS: {
            LIST: '/api/payments',
            CREATE: '/api/payments',
            STATUS: '/api/payments/{id}/status',
        },
        DASHBOARD: {
            STATS: '/api/dashboard/stats',
            CHARTS: '/api/dashboard/charts',
        }
    }
};
EOF

# 5. Обновляем Mobile App для работы с реальным API
print_status "5. Обновляю Mobile App для работы с реальным API..."

cd /root/mobile-app

# Обновляем конфигурацию
cat > lib/config/api_config.dart << 'EOF'
class ApiConfig {
  static const String baseUrl = 'https://api.granivpn.ru';
  static const int timeout = 10000;
  
  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String refresh = '/api/auth/refresh';
  static const String logout = '/api/auth/logout';
  
  // VPN endpoints
  static const String connect = '/api/vpn/connect';
  static const String disconnect = '/api/vpn/disconnect';
  static const String status = '/api/vpn/status';
  static const String servers = '/api/vpn/servers';
  
  // User endpoints
  static const String profile = '/api/user/profile';
  static const String subscription = '/api/user/subscription';
}
EOF

# 6. Тестируем интеграцию
print_status "6. Тестирую интеграцию..."

# Проверяем API
sleep 5
curl -k -I https://api.granivpn.ru/health || print_warning "API не отвечает"

# Проверяем Admin Panel
curl -k -I https://admin.granivpn.ru || print_warning "Admin Panel не отвечает"

# Проверяем Mobile App
curl -k -I https://app.granivpn.ru || print_warning "Mobile App не отвечает"

print_status "✅ Интеграция завершена!"
print_status "🌐 Доступные URL:"
echo "   - Admin Panel: https://admin.granivpn.ru"
echo "   - Mobile App: https://app.granivpn.ru"
echo "   - API: https://api.granivpn.ru"
echo "   - API Docs: https://api.granivpn.ru/docs"

print_warning "📝 Следующие шаги:"
echo "   1. Проверить работу доменов в браузере"
echo "   2. Настроить реальные данные в базе"
echo "   3. Протестировать VPN функциональность"
