CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL
    CHECK (role IN ('customer', 'seller', 'admin')),
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customer_profiles (
    customer_id BIGINT PRIMARY KEY
    REFERENCES users(user_id),

    loyalty_points INT DEFAULT 0,
    preferred_address_id BIGINT,
    date_of_birth DATE
);

CREATE TABLE seller_profiles (
    seller_id BIGINT PRIMARY KEY
    REFERENCES users(user_id),

    business_name VARCHAR(255) NOT NULL,
    gst_number VARCHAR(100) UNIQUE,

    commission_rate NUMERIC(5,2)
    DEFAULT 10.00,

    verification_status VARCHAR(20)
    CHECK (
        verification_status IN
        ('pending','verified','rejected')
    )
);