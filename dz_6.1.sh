#!/bin/bash

# 1 отсчет времени
# 2 проверка на наличие репозитория Backports
# 3 обновление списка пакетов
# 4 установка и запуск Apache2
# 5 установка Python
# 6 Установка, запуск и настройка SSH-сервера
# 7 установка Midnight Commander
# 8 установка nano
# 9 создание пользователя testuser с паролем testpass и предоставление прав root
# 10 обеспечение доступа пользователя testuser по SSH
# 11 Запрос на удаление установленных пакетов


# Начало отсчёта времени
START_TIME=$(date +%s)

# Проверка на наличие репозитория Backports
if ! grep -q "$(lsb_release -sc)-backports" /etc/apt/sources.list; then
  echo "----------------------------------"
  echo "Добавляем репозиторий Backports..."
  echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-backports main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list
fi

# Обновление списка пакетов
echo "----------------------------------"
echo "Обновляем пакетный менеджер..."
sudo apt update -y

# Установка и запуск Apache2
echo "----------------------------------"
echo "Устанавливаем и запускаем Apache2..."
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

# Установка Python
echo "----------------------------------"
echo "Устанавливаем Python..."
sudo apt install python3 -y

# Установка, запуск и настройка SSH-сервера
echo "----------------------------------"
echo "Устанавливаем и запускаем SSH-сервер..."
sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh

# Установка Midnight Commander
echo "----------------------------------"
echo "Устанавливаем Midnight Commander..."
sudo apt install mc -y

# Установка nano
echo "----------------------------------"
echo "Устанавливаем nano..."
sudo apt install nano -y

# Создание пользователя testuser с паролем testpass и предоставление прав root
USER_NAME="testuser"
USER_PASS="testpass"
if ! id "$USER_NAME" &>/dev/null; then
  echo "----------------------------------"
  echo "Создаём пользователя $USER_NAME..."
  sudo useradd -m -s /bin/bash "$USER_NAME"
  echo "$USER_NAME:$USER_PASS" | sudo chpasswd
  sudo usermod -aG sudo "$USER_NAME"
else
  echo "Пользователь $USER_NAME уже существует."
fi

# Обеспечение доступа пользователя testuser по SSH
echo "----------------------------------"
echo "Обеспечиваем доступ пользователя $USER_NAME по SSH..."
sudo mkdir -p /home/$USER_NAME/.ssh
sudo chown $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh
sudo chmod 700 /home/$USER_NAME/.ssh

# Вывод времени выполнения скрипта
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "Скрипт выполнен за $DURATION секунд."

# Запрос на удаление установленных пакетов
read -p "Хотите удалить Apache2, Python, SSH-сервер и Midnight Commander? (y/n): " RESPONSE
if [[ "$RESPONSE" =~ ^[Yy]$ ]]; then
  echo "Удаляем Apache2, Python, SSH-сервер и Midnight Commander..."
  sudo apt remove --purge apache2 python3 openssh-server mc -y
  sudo apt autoremove -y
  sudo apt autoclean -y
  echo "Удаление завершено."
else
  echo "Пропускаем удаление пакетов."
fi

# Конец
exit 0
