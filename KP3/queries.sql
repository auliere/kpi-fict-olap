-- 1a
SELECT 
  id_product,
  id_product_type,
  product_type_name,
  product_name,
  price,
  RANK() OVER (PARTITION BY id_product_type ORDER BY price DESC) AS R
FROM product
INNER JOIN product_type USING (id_product_type);

-- 1b
SELECT 
  id_product,
  id_product_type,
  product_type_name,
  product_name,
  price,
  DENSE_RANK() OVER (PARTITION BY id_product_type ORDER BY price DESC) AS R
FROM product
INNER JOIN product_type USING (id_product_type);

-- 2
SELECT 
    id_product,
    id_product_type,
    product_type_name,
    product_name,
    price
FROM
  (SELECT 
    id_product,
    id_product_type,
    product_type_name,
    product_name,
    price,
    ROW_NUMBER() OVER (PARTITION BY id_product_type ORDER BY price ASC) AS R
  FROM product
  INNER JOIN product_type USING (id_product_type))
WHERE R <=2;

-- 3
SELECT 
  product_type_name,
  top_product,
  sold_total
FROM
  (SELECT 
    product_type_name,
    product_name AS top_product,
    sold_total,
    DENSE_RANK() OVER (PARTITION BY id_product_type ORDER BY sold_total DESC) AS dnr
  FROM
    (SELECT DISTINCT
      id_product,
      id_product_type,
      product_name,
      product_type_name,
      SUM(quantity) OVER (PARTITION BY id_product) AS sold_total  
    FROM invoice_detail
    INNER JOIN product USING(id_product)
    INNER JOIN product_type USING(id_product_type)))
WHERE dnr = 1;

-- 4
SELECT DISTINCT
  id_product,
  price,
  ROUND((MAX(date_oper) OVER (PARTITION BY id_product)) 
        - (MIN(date_oper) OVER (PARTITION BY id_product)), 0) AS storage_period
FROM store
INNER JOIN product USING(id_product)
ORDER BY storage_period*price DESC;

-- 5a
SELECT 
  id_product,
  product_name,
  id_invoice,
  LAG(id_invoice, 1, -1) OVER (PARTITION BY id_product ORDER BY purchase_time ASC) AS prev_invoice,
  purchase_time,
  LAG(purchase_time, 1, NULL) OVER (PARTITION BY id_product ORDER BY purchase_time ASC) AS prev_purchase_time
FROM invoice
INNER JOIN invoice_detail USING(id_invoice)
INNER JOIN product USING(id_product);

-- 5b
SELECT 
  id_product,
  product_name,
  id_invoice,
  LEAD(id_invoice, 1, -1) OVER (PARTITION BY id_product ORDER BY purchase_time DESC) AS prev_invoice,
  purchase_time,
  LEAD(purchase_time, 1, NULL) OVER (PARTITION BY id_product ORDER BY purchase_time DESC) AS prev_purchase_time
FROM invoice
INNER JOIN invoice_detail USING(id_invoice)
INNER JOIN product USING(id_product);

-- 6a
SELECT 
  product_type_name,
  product_name,
  price,
  FIRST_VALUE(product_name) OVER(PARTITION BY id_product_type ORDER BY price) AS cheapest_product,
  FIRST_VALUE(price) OVER(PARTITION BY id_product_type ORDER BY price) AS cheapest_price
FROM product
INNER JOIN product_type USING(id_product_type);

-- 6b
SELECT 
  product_type_name,
  product_name,
  price,
  MIN(price) OVER(PARTITION BY id_product_type) AS cheapest_type_price
FROM product
INNER JOIN product_type USING(id_product_type);

-- 6c
SELECT
  id_stuff,
  name,
  surname,
  id_position,
  position_name,
  COUNT(*) OVER (PARTITION BY id_position) AS count_colleagues  
FROM stuff
INNER JOIN position USING (id_position);