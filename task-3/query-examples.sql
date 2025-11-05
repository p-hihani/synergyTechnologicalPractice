-- 1) Заказы с расшифровкой справочников
SELECT o.order_id, c.full_name, d.country, d.city, tt.name AS tour_type,
       s.name AS service, o.start_date, o.end_date, o.travelers_cnt, o.total_price
FROM orders o
JOIN clients c      ON c.client_id = o.client_id
JOIN destinations d ON d.destination_id = o.destination_id
JOIN tour_types tt  ON tt.tour_type_id = o.tour_type_id
LEFT JOIN services s ON s.service_id = o.service_id
ORDER BY o.start_date;

-- 2) Выручка по направлениям
SELECT d.country, d.city, SUM(o.total_price) AS revenue
FROM orders o
JOIN destinations d ON d.destination_id = o.destination_id
GROUP BY d.country, d.city
ORDER BY revenue DESC;