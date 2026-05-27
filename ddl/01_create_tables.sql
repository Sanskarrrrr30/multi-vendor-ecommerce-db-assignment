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

CREATE TABLE addresses (
    address_id BIGSERIAL PRIMARY KEY,

    user_id BIGINT NOT NULL
    REFERENCES users(user_id)
    ON DELETE CASCADE,

    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),

    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,

    postal_code VARCHAR(20) NOT NULL,

    is_default BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id BIGSERIAL PRIMARY KEY,

    category_name VARCHAR(150) NOT NULL,

    parent_category_id BIGINT
    REFERENCES categories(category_id)
    ON DELETE SET NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE brands (
    brand_id BIGSERIAL PRIMARY KEY,

    brand_name VARCHAR(150) UNIQUE NOT NULL,

    is_verified BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id BIGSERIAL PRIMARY KEY,

    seller_id BIGINT NOT NULL
    REFERENCES seller_profiles(seller_id)
    ON DELETE CASCADE,

    brand_id BIGINT
    REFERENCES brands(brand_id)
    ON DELETE SET NULL,

    product_name VARCHAR(255) NOT NULL,

    sku VARCHAR(100) UNIQUE NOT NULL,

    slug VARCHAR(255) UNIQUE NOT NULL,

    description TEXT,

    base_price NUMERIC(10,2) NOT NULL
    CHECK (base_price > 0),

    average_rating NUMERIC(3,2) DEFAULT 0,

    status VARCHAR(20)
    DEFAULT 'active'
    CHECK (
        status IN
        ('active','inactive','out_of_stock')
    ),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_categories (
    product_id BIGINT
    REFERENCES products(product_id)
    ON DELETE CASCADE,

    category_id BIGINT
    REFERENCES categories(category_id)
    ON DELETE CASCADE,

    PRIMARY KEY(product_id, category_id)
);

CREATE TABLE product_images (
    image_id BIGSERIAL PRIMARY KEY,

    product_id BIGINT NOT NULL
    REFERENCES products(product_id)
    ON DELETE CASCADE,

    image_url TEXT NOT NULL,

    sort_order INT DEFAULT 1
);

CREATE TABLE warehouses (
    warehouse_id BIGSERIAL PRIMARY KEY,

    warehouse_name VARCHAR(150) NOT NULL,

    city VARCHAR(100),
    state VARCHAR(100),

    capacity INT CHECK (capacity >= 0),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventory (
    inventory_id BIGSERIAL PRIMARY KEY,

    product_id BIGINT NOT NULL
    REFERENCES products(product_id)
    ON DELETE CASCADE,

    warehouse_id BIGINT NOT NULL
    REFERENCES warehouses(warehouse_id)
    ON DELETE CASCADE,

    quantity_available INT NOT NULL
    CHECK (quantity_available >= 0),

    reorder_threshold INT DEFAULT 10,

    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(product_id, warehouse_id)
);

CREATE TABLE stock_movements (
    movement_id BIGSERIAL PRIMARY KEY,

    inventory_id BIGINT NOT NULL
    REFERENCES inventory(inventory_id)
    ON DELETE CASCADE,

    movement_type VARCHAR(20)
    CHECK (
        movement_type IN
        ('stock_in','stock_out','returned','damaged')
    ),

    quantity INT NOT NULL,

    notes TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE carts (
    cart_id BIGSERIAL PRIMARY KEY,

    customer_id BIGINT NOT NULL
    REFERENCES customer_profiles(customer_id)
    ON DELETE CASCADE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    expires_at TIMESTAMP
);

CREATE TABLE cart_items (
    cart_item_id BIGSERIAL PRIMARY KEY,

    cart_id BIGINT NOT NULL
    REFERENCES carts(cart_id)
    ON DELETE CASCADE,

    product_id BIGINT NOT NULL
    REFERENCES products(product_id)
    ON DELETE CASCADE,

    quantity INT NOT NULL
    CHECK (quantity > 0),

    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id BIGSERIAL PRIMARY KEY,

    customer_id BIGINT NOT NULL
    REFERENCES customer_profiles(customer_id),

    order_status VARCHAR(20)
    DEFAULT 'pending'
    CHECK (
        order_status IN (
            'pending',
            'confirmed',
            'shipped',
            'delivered',
            'cancelled'
        )
    ),

    total_amount NUMERIC(12,2)
    NOT NULL
    CHECK (total_amount >= 0),

    shipping_address_id BIGINT
    REFERENCES addresses(address_id),

    billing_address_id BIGINT
    REFERENCES addresses(address_id),

    coupon_id BIGINT,

    placed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    delivered_at TIMESTAMP
);

CREATE TABLE order_items (
    order_item_id BIGSERIAL PRIMARY KEY,

    order_id BIGINT NOT NULL
    REFERENCES orders(order_id)
    ON DELETE CASCADE,

    product_id BIGINT NOT NULL
    REFERENCES products(product_id),

    seller_id BIGINT NOT NULL
    REFERENCES seller_profiles(seller_id),

    quantity INT NOT NULL
    CHECK (quantity > 0),

    unit_price NUMERIC(10,2)
    NOT NULL
    CHECK (unit_price > 0),

    subtotal NUMERIC(12,2)
    GENERATED ALWAYS AS
    (quantity * unit_price) STORED
);

CREATE TABLE payments (
    payment_id BIGSERIAL PRIMARY KEY,

    order_id BIGINT NOT NULL
    REFERENCES orders(order_id)
    ON DELETE CASCADE,

    payment_method VARCHAR(50),

    payment_status VARCHAR(20)
    DEFAULT 'pending'
    CHECK (
        payment_status IN (
            'pending',
            'success',
            'failed',
            'refunded'
        )
    ),

    amount NUMERIC(12,2)
    NOT NULL,

    gateway_reference VARCHAR(255),

    paid_at TIMESTAMP
);

CREATE TABLE payment_transactions (
    transaction_id BIGSERIAL PRIMARY KEY,

    payment_id BIGINT NOT NULL
    REFERENCES payments(payment_id)
    ON DELETE CASCADE,

    transaction_status VARCHAR(20)
    CHECK (
        transaction_status IN (
            'initiated',
            'success',
            'failed'
        )
    ),

    transaction_reference VARCHAR(255),

    response_message TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE invoices (
    invoice_id BIGSERIAL PRIMARY KEY,

    order_id BIGINT UNIQUE NOT NULL
    REFERENCES orders(order_id)
    ON DELETE CASCADE,

    invoice_number VARCHAR(100)
    UNIQUE NOT NULL,

    invoice_date TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    total_amount NUMERIC(12,2)
    NOT NULL
);

CREATE TABLE coupons (
    coupon_id BIGSERIAL PRIMARY KEY,

    coupon_code VARCHAR(50)
    UNIQUE NOT NULL,

    discount_type VARCHAR(20)
    CHECK (
        discount_type IN (
            'flat',
            'percentage'
        )
    ),

    discount_value NUMERIC(10,2)
    NOT NULL,

    minimum_order_value NUMERIC(10,2)
    DEFAULT 0,

    max_uses INT DEFAULT 100,

    used_count INT DEFAULT 0,

    expires_at TIMESTAMP NOT NULL,

    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE coupon_usage (
    usage_id BIGSERIAL PRIMARY KEY,

    coupon_id BIGINT NOT NULL
    REFERENCES coupons(coupon_id)
    ON DELETE CASCADE,

    customer_id BIGINT NOT NULL
    REFERENCES customer_profiles(customer_id)
    ON DELETE CASCADE,

    order_id BIGINT NOT NULL
    REFERENCES orders(order_id)
    ON DELETE CASCADE,

    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reviews (
    review_id BIGSERIAL PRIMARY KEY,

    product_id BIGINT NOT NULL
    REFERENCES products(product_id)
    ON DELETE CASCADE,

    customer_id BIGINT NOT NULL
    REFERENCES customer_profiles(customer_id)
    ON DELETE CASCADE,

    review_title VARCHAR(255),

    review_body TEXT,

    verified_purchase BOOLEAN DEFAULT FALSE,

    helpful_votes INT DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ratings (
    rating_id BIGSERIAL PRIMARY KEY,

    review_id BIGINT NOT NULL
    REFERENCES reviews(review_id)
    ON DELETE CASCADE,

    stars INT NOT NULL
    CHECK (stars BETWEEN 1 AND 5),

    moderation_status VARCHAR(20)
    DEFAULT 'pending'
    CHECK (
        moderation_status IN (
            'pending',
            'approved',
            'rejected'
        )
    )
);

CREATE TABLE returns (
    return_id BIGSERIAL PRIMARY KEY,

    order_item_id BIGINT NOT NULL
    REFERENCES order_items(order_item_id)
    ON DELETE CASCADE,

    return_reason TEXT NOT NULL,

    item_condition VARCHAR(50),

    return_status VARCHAR(20)
    DEFAULT 'requested'
    CHECK (
        return_status IN (
            'requested',
            'approved',
            'rejected',
            'completed'
        )
    ),

    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE refunds (
    refund_id BIGSERIAL PRIMARY KEY,

    return_id BIGINT NOT NULL
    REFERENCES returns(return_id)
    ON DELETE CASCADE,

    payment_id BIGINT NOT NULL
    REFERENCES payments(payment_id)
    ON DELETE CASCADE,

    refund_amount NUMERIC(12,2)
    NOT NULL,

    refund_method VARCHAR(50),

    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

