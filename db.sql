CREATE DATABASE IF NOT EXISTS IaSoCS_db;
USE IaSoCS_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Уникальный ID пользователя
    username VARCHAR(50) NOT NULL UNIQUE, -- Логин для входа
    email VARCHAR(100) NOT NULL UNIQUE, -- Email адрес
    is_admin TINYINT(1) DEFAULT 0, -- Флаг администратора (1 - да, 0 - нет)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- Дата регистрации
);

CREATE TABLE files (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Уникальный ID файла
    parent_id INT DEFAULT NULL, -- ID родительской папки (NULL если корень)
    uploader_id INT NOT NULL, -- ID администратора, загрузившего файл
    file_path VARCHAR(1024) NOT NULL, -- Относительный путь к файлу на сервере
    file_name VARCHAR(255) NOT NULL, -- Оригинальное имя файла с расширением
    mime_type VARCHAR(100) NOT NULL, -- MIME-тип файла (напр. image/png)
    file_hash CHAR(64) DEFAULT NULL, -- SHA256 хеш для поиска дубликатов
    size BIGINT UNSIGNED DEFAULT 0, -- Размер файла в байтах
    is_system_file TINYINT(1) DEFAULT 0, -- Флаг системного файла (1 - да, 0 - нет; видят только админы)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Дата загрузки
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Дата последнего изменения метаданных

    FOREIGN KEY (parent_id) REFERENCES files(id) ON DELETE CASCADE,
    FOREIGN KEY (uploader_id) REFERENCES users(id) ON DELETE CASCADE,

    INDEX idx_parent (parent_id),
    INDEX idx_uploader (uploader_id),
    INDEX idx_system (is_system_file),
    INDEX idx_name (file_name),
    INDEX idx_hash (file_hash)
);