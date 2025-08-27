# Скрипт для подключения к VPS серверу
$server = "94.131.107.227"
$user = "root"
$password = "oNa68L43zFe8"

Write-Host "🔗 Подключение к серверу $server..." -ForegroundColor Green

# Создаем объект для SSH подключения
$ssh = New-Object System.Net.Sockets.TcpClient($server, 22)

if ($ssh.Connected) {
    Write-Host "✅ Подключение установлено" -ForegroundColor Green
    Write-Host "📡 Сервер доступен" -ForegroundColor Green
    
    # Здесь можно добавить команды для выполнения на сервере
    Write-Host "🚀 Готов к выполнению команд на сервере" -ForegroundColor Yellow
} else {
    Write-Host "❌ Не удалось подключиться к серверу" -ForegroundColor Red
}

$ssh.Close()
