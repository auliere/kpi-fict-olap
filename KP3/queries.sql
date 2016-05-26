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
