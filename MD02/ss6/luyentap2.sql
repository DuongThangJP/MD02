INSERT INTO `customers` (`id`, `name`, `email`) VALUES
(NULL, 'Lê Văn D', 'levand@gmail.com'),
(NULL, 'Nguyễn Thị E', 'nguyenthie@gmail.com');

-- Liệt kê những khách hàng đã có ít nhất một đơn hàng --
SELECT customers.id, customers.name
FROM customers
JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.id, customers.name
;
-- Tìm những khách hàng chưa từng đặt đơn hàng nào --
SELECT customers.id, customers.name, customers.email
FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id
WHERE orders.id IS NULL;

-- Tính toán tổng doanh thu mà mỗi khách hàng đã mang lại --
SELECT customers.id, customers.name, SUM(order_details.quantity * order_details.price)
FROM customers
INNER JOIN orders ON customers.id = orders.customer_id
INNER JOIN order_details ON orders.id = order_details.order_id
GROUP BY customers.id, customers.name;


SELECT *
FROM customers
INNER JOIN orders ON customers.id = orders.customer_id
INNER JOIN order_details ON orders.id = order_details.order_id
WHERE customers.id = 1;

-- Xác định khách hàng đã mua sản phẩm có giá cao nhất --
SELECT *
FROM customers
INNER JOIN orders ON customers.id = orders.customer_id
INNER JOIN order_details ON orders.id = order_details.order_id
WHERE order_details.price = (
SELECT MAX(price)
FROM order_details)
GROUP BY customers.id, customers.name, order_details.price;