
-- CATEGORIES

INSERT INTO categories
(category_name, parent_category_id)
VALUES
('Electronics', NULL),
('Mobiles', 1),
('Laptops', 1),
('Fashion', NULL),
('Men Clothing', 4),
('Women Clothing', 4),
('Home', NULL),
('Kitchen', 7);

-- BRANDS

INSERT INTO brands
(brand_name, is_verified)
VALUES
('Samsung', TRUE),
('Apple', TRUE),
('Dell', TRUE),
('HP', TRUE),
('Nike', TRUE),
('Adidas', TRUE),
('Philips', TRUE),
('Boat', TRUE);

-- PRODUCTS

INSERT INTO products
(
seller_id,
brand_id,
product_name,
sku,
slug,
description,
base_price,
status
)
VALUES
(1,1,'Samsung Galaxy S23','SKU1001',
'samsung-galaxy-s23',
'Flagship Samsung smartphone',
74999,'active'),

(1,2,'iPhone 15','SKU1002',
'iphone-15',
'Apple flagship smartphone',
89999,'active'),

(2,3,'Dell Inspiron 15','SKU1003',
'dell-inspiron-15',
'Dell performance laptop',
65999,'active'),

(2,4,'HP Pavilion','SKU1004',
'hp-pavilion',
'HP gaming laptop',
72000,'active'),

(3,5,'Nike Air Max','SKU1005',
'nike-air-max',
'Premium running shoes',
5999,'active'),

(3,6,'Adidas Hoodie','SKU1006',
'adidas-hoodie',
'Winter hoodie',
2999,'active'),

(4,7,'Philips Mixer','SKU1007',
'philips-mixer',
'Kitchen mixer grinder',
4999,'active'),

(5,8,'Boat Rockerz 450','SKU1008',
'boat-rockerz-450',
'Wireless headphones',
1499,'active');

-- PRODUCT CATEFORIES

INSERT INTO product_categories
(product_id, category_id)
VALUES
(1,2),
(2,2),
(3,3),
(4,3),
(5,5),
(6,6),
(7,8),
(8,1);

-- PRODUCT IMAGES

INSERT INTO product_images
(product_id, image_url, sort_order)
VALUES
(1,'https://example.com/s23.jpg',1),
(2,'https://example.com/iphone15.jpg',1),
(3,'https://example.com/dell.jpg',1),
(4,'https://example.com/hp.jpg',1);