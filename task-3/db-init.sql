-- Чистый старт
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS tour_types;
DROP TABLE IF EXISTS destinations;
DROP TABLE IF EXISTS clients;

-- 1) Клиенты
CREATE TABLE clients (
  client_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(255) NOT NULL,
  email     VARCHAR(255) UNIQUE,
  phone     VARCHAR(50)  UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2) Направления
CREATE TABLE destinations (
  destination_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  country  VARCHAR(100) NOT NULL,
  city     VARCHAR(100) NOT NULL,
  UNIQUE KEY uq_destination (country, city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3) Типы туров
CREATE TABLE tour_types (
  tour_type_id INT PRIMARY KEY AUTO_INCREMENT,
  name      VARCHAR(100) NOT NULL UNIQUE,
  base_days SMALLINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4) Услуги (доп.)
CREATE TABLE services (
  service_id INT PRIMARY KEY AUTO_INCREMENT,
  name  VARCHAR(100) NOT NULL UNIQUE,
  price DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5) Заказы (переменная инф.)
CREATE TABLE orders (
  order_id       BIGINT PRIMARY KEY AUTO_INCREMENT,
  client_id      BIGINT   NOT NULL,
  destination_id BIGINT   NOT NULL,
  tour_type_id   INT      NOT NULL,
  service_id     INT      NULL,
  start_date     DATE     NOT NULL,
  end_date       DATE     NOT NULL,
  travelers_cnt  SMALLINT NOT NULL,
  total_price    DECIMAL(12,2) NOT NULL,

  CONSTRAINT fk_orders_client
    FOREIGN KEY (client_id)      REFERENCES clients(client_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_orders_destination
    FOREIGN KEY (destination_id) REFERENCES destinations(destination_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_orders_tour_type
    FOREIGN KEY (tour_type_id)   REFERENCES tour_types(tour_type_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_orders_service
    FOREIGN KEY (service_id)     REFERENCES services(service_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Индексы для поиска
CREATE INDEX idx_orders_client      ON orders(client_id);
CREATE INDEX idx_orders_destination ON orders(destination_id);
CREATE INDEX idx_orders_dates       ON orders(start_date, end_date);

-- Тестовые данные
INSERT INTO clients (full_name, email, phone) VALUES
('Иван Петров','ivan@example.com','+79990001122'),
('Анна Соколова','anna@example.com','+79995556677');

INSERT INTO destinations (country, city) VALUES
('Турция','Анталия'), ('Испания','Барселона'), ('Италия','Рим');

INSERT INTO tour_types (name, base_days) VALUES
('Пляжный',7), ('Экскурсионный',5);

INSERT INTO services (name, price) VALUES
('Страховка',1500.00), ('Аэропорт-трансфер',2500.00);

INSERT INTO orders
(client_id, destination_id, tour_type_id, service_id, start_date, end_date, travelers_cnt, total_price)
VALUES
(1, 1, 1, 1, '2025-06-10','2025-06-17', 2, 120000.00),
(2, 3, 2, 2, '2025-05-01','2025-05-06', 1,  80000.00),
(1, 2, 2, NULL,'2025-09-10','2025-09-15', 2, 150000.00);

