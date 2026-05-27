-- USER PROFILES

INSERT INTO users
(full_name, email, password_hash, role, phone)
VALUES
('Rahul Sharma', 'rahul@example.com', 'hash1', 'seller', '9876543210'),
('Priya Electronics', 'priya@example.com', 'hash2', 'seller', '9876543211'),
('Tech World', 'techworld@example.com', 'hash3', 'seller', '9876543212'),
('Fashion Hub', 'fashion@example.com', 'hash4', 'seller', '9876543213'),
('Home Essentials', 'home@example.com', 'hash5', 'seller', '9876543214'),

('Amit Verma', 'amit@example.com', 'hash6', 'customer', '9876543215'),
('Sneha Kapoor', 'sneha@example.com', 'hash7', 'customer', '9876543216'),
('Rohan Das', 'rohan@example.com', 'hash8', 'customer', '9876543217'),
('Neha Singh', 'neha@example.com', 'hash9', 'customer', '9876543218'),
('Karan Mehta', 'karan@example.com', 'hash10', 'customer', '9876543219'),
('Anjali Roy', 'anjali@example.com', 'hash11', 'customer', '9876543220'),
('Vikram Jain', 'vikram@example.com', 'hash12', 'customer', '9876543221'),
('Pooja Nair', 'pooja@example.com', 'hash13', 'customer', '9876543222'),
('Arjun Patel', 'arjun@example.com', 'hash14', 'customer', '9876543223'),
('Meera Iyer', 'meera@example.com', 'hash15', 'customer', '9876543224');

-- SELLER PROFILES

INSERT INTO seller_profiles
(seller_id, business_name, gst_number,
commission_rate, verification_status)
VALUES
(1, 'Rahul Retail Pvt Ltd', 'GST1001', 12.5, 'verified'),
(2, 'Priya Electronics Pvt Ltd', 'GST1002', 10.0, 'verified'),
(3, 'Tech World India', 'GST1003', 11.0, 'verified'),
(4, 'Fashion Hub Store', 'GST1004', 9.5, 'verified'),
(5, 'Home Essentials India', 'GST1005', 8.0, 'pending');

-- CUSTOMER PROFILES

INSERT INTO customer_profiles
(customer_id, loyalty_points, date_of_birth)
VALUES
(6, 150, '1998-05-12'),
(7, 300, '1997-08-21'),
(8, 120, '2000-11-02'),
(9, 450, '1995-03-15'),
(10, 80, '2001-07-18'),
(11, 220, '1999-09-25'),
(12, 175, '1996-01-11'),
(13, 90, '2002-04-08'),
(14, 400, '1994-06-30'),
(15, 260, '1998-12-19');

-- ADDRESSES

INSERT INTO addresses
(user_id, address_line1, city, state,
country, postal_code, is_default)
VALUES
(6, '12 MG Road', 'Bangalore', 'Karnataka', 'India', '560001', TRUE),
(7, '45 Park Street', 'Kolkata', 'West Bengal', 'India', '700016', TRUE),
(8, '78 Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', TRUE),
(9, '11 Marine Drive', 'Mumbai', 'Maharashtra', 'India', '400002', TRUE),
(10, '22 Connaught Place', 'Delhi', 'Delhi', 'India', '110001', TRUE);
