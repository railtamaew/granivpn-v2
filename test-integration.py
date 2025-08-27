#!/usr/bin/env python3
"""
Скрипт для тестирования интеграции frontend с backend API
"""

import requests
import json
import time

# Конфигурация
API_BASE_URL = "http://localhost:8000"
ADMIN_PANEL_URL = "http://localhost:3000"

def test_api_health():
    """Тест здоровья API"""
    print("🔍 Тестирование здоровья API...")
    try:
        response = requests.get(f"{API_BASE_URL}/health")
        if response.status_code == 200:
            print("✅ API здоров")
            return True
        else:
            print(f"❌ API не отвечает: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Ошибка подключения к API: {e}")
        return False

def test_api_endpoints():
    """Тест основных endpoints"""
    print("\n🔍 Тестирование основных endpoints...")
    
    endpoints = [
        ("/", "Корневой endpoint"),
        ("/api/test", "Тестовый endpoint"),
        ("/api/auth/login", "Login endpoint"),
        ("/api/admin/users", "Users endpoint"),
    ]
    
    for endpoint, description in endpoints:
        try:
            response = requests.get(f"{API_BASE_URL}{endpoint}")
            print(f"✅ {description}: {response.status_code}")
        except Exception as e:
            print(f"❌ {description}: {e}")

def test_auth_flow():
    """Тест процесса аутентификации"""
    print("\n🔍 Тестирование процесса аутентификации...")
    
    # Тестовые данные
    test_user = {
        "email": "admin@granivpn.ru",
        "password": "testpassword123"
    }
    
    try:
        # Попытка входа
        response = requests.post(f"{API_BASE_URL}/api/auth/login", json=test_user)
        if response.status_code == 200:
            print("✅ Login endpoint работает")
            token_data = response.json()
            print(f"   Получен токен: {token_data.get('access_token', '')[:20]}...")
            
            # Тест получения текущего пользователя
            headers = {"Authorization": f"Bearer {token_data['access_token']}"}
            me_response = requests.get(f"{API_BASE_URL}/api/admin/me", headers=headers)
            if me_response.status_code == 200:
                print("✅ /me endpoint работает")
                user_data = me_response.json()
                print(f"   Пользователь: {user_data.get('email', '')}")
            else:
                print(f"❌ /me endpoint не работает: {me_response.status_code}")
                
        else:
            print(f"❌ Login endpoint не работает: {response.status_code}")
            print(f"   Ответ: {response.text}")
            
    except Exception as e:
        print(f"❌ Ошибка тестирования аутентификации: {e}")

def test_admin_endpoints():
    """Тест admin endpoints"""
    print("\n🔍 Тестирование admin endpoints...")
    
    # Сначала получаем токен
    test_user = {
        "email": "admin@granivpn.ru",
        "password": "testpassword123"
    }
    
    try:
        login_response = requests.post(f"{API_BASE_URL}/api/auth/login", json=test_user)
        if login_response.status_code != 200:
            print("❌ Не удалось получить токен для тестирования admin endpoints")
            return
            
        token = login_response.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}
        
        # Тест получения пользователей
        users_response = requests.get(f"{API_BASE_URL}/api/admin/users", headers=headers)
        if users_response.status_code == 200:
            print("✅ /api/admin/users работает")
        else:
            print(f"❌ /api/admin/users не работает: {users_response.status_code}")
            
        # Тест получения статистики
        stats_response = requests.get(f"{API_BASE_URL}/api/admin/dashboard", headers=headers)
        if stats_response.status_code == 200:
            print("✅ /api/admin/dashboard работает")
        else:
            print(f"❌ /api/admin/dashboard не работает: {stats_response.status_code}")
            
    except Exception as e:
        print(f"❌ Ошибка тестирования admin endpoints: {e}")

def test_cors():
    """Тест CORS настроек"""
    print("\n🔍 Тестирование CORS настроек...")
    
    try:
        # Тест с origin header
        headers = {"Origin": "http://localhost:3000"}
        response = requests.get(f"{API_BASE_URL}/health", headers=headers)
        
        if "Access-Control-Allow-Origin" in response.headers:
            print("✅ CORS настроен правильно")
            print(f"   Allow-Origin: {response.headers.get('Access-Control-Allow-Origin')}")
        else:
            print("❌ CORS не настроен")
            
    except Exception as e:
        print(f"❌ Ошибка тестирования CORS: {e}")

def main():
    """Основная функция тестирования"""
    print("🚀 Начинаем тестирование интеграции GraniVPN API")
    print("=" * 50)
    
    # Тест здоровья API
    if not test_api_health():
        print("\n❌ API недоступен. Убедитесь, что backend запущен на http://localhost:8000")
        return
    
    # Тест endpoints
    test_api_endpoints()
    
    # Тест аутентификации
    test_auth_flow()
    
    # Тест admin endpoints
    test_admin_endpoints()
    
    # Тест CORS
    test_cors()
    
    print("\n" + "=" * 50)
    print("✅ Тестирование завершено!")

if __name__ == "__main__":
    main()
