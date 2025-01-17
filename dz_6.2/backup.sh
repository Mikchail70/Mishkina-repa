#!/bin/bash

# Переменные
BACKUP_DIR="/home/ubuntu/backup"       # Каталог для временного хранения бэкапов
ARCHIVE_DIR="/archive"          # Каталог для окончательного хранения бэкапов
DATE=$(date +%Y-%m-%d_%H-%M-%S) # Формат даты
BACKUP_FILE="backup_$DATE.tar.gz" # Имя файла архива

# Директории и файлы для резервирования
HOME_DIR="/home"                # Домашние каталоги пользователей
LOG_DIR="/var/log"              # Логи системы
CONFIG_FILES=(                  # Конфигурационные файлы
  "/etc/ssh/sshd_config"
  "/etc/xrdp/xrdp.ini"
  "/etc/vsftpd.conf"
)

# Исключения
EXCLUDE_DIRS=(
  "$BACKUP_DIR"                 # Исключаем каталог для временного хранения архива
  "$ARCHIVE_DIR"                # Исключаем каталог для архивов
)

# Создание списка исключений для tar
EXCLUDE_PARAMS=()
for dir in "${EXCLUDE_DIRS[@]}"; do
  EXCLUDE_PARAMS+=("--exclude=$dir")
done

# Создание директории для бэкапа, если не существует
mkdir -p "$BACKUP_DIR"

# Создание tar архива
echo "Создание бэкапа: $BACKUP_FILE..."
tar "${EXCLUDE_PARAMS[@]}" -czf "$BACKUP_DIR/$BACKUP_FILE" "$HOME_DIR" "$LOG_DIR" "${CONFIG_FILES[@]}"

# Проверка успешности создания архива
if [ $? -eq 0 ]; then
  echo "Бэкап успешно создан в: $BACKUP_DIR/$BACKUP_FILE"
else
  echo "Ошибка при создании бэкапа!"
  exit 1
fi

# Перемещение бэкапа в директорию архива
echo "Перемещение бэкапа в директорию архива: $ARCHIVE_DIR"
mkdir -p "$ARCHIVE_DIR"
mv "$BACKUP_DIR/$BACKUP_FILE" "$ARCHIVE_DIR"

# Проверка успешности перемещения
if [ $? -eq 0 ]; then
  echo "Бэкап успешно перемещен в: $ARCHIVE_DIR/$BACKUP_FILE"
else
  echo "Ошибка при перемещении бэкапа!"
  exit 1
fi

# Завершение
echo "Операция резервного копирования завершена."
