-- ER Diagram:
-- tip count is a derived attribute (done)
-- composite attribute (location) for longitude and lattitude (done)
-- same applied to address with state, stret, zip code, etc. (done)
-- Generally, ER is fine

-- SQL:
-- feel free to remove upper bounds on VARCHARs (done) (got rid of all upper bounds except the ones on business_id and user_id) 
-- Use double for latitude and longitude (done)
-- NOT NULL not necessary for business_hours, check_in, and in tip (done)
-- make sure open_time and close_time are represented accurately
-- business_category and business_attribute may not be necessary (done) (commented out)

-- Team Name: KPD
-- Team Members: Jake Dorick, Minhyuk Park, Jimmy Kim

DROP TABLE IF EXISTS tip;
DROP TABLE IF EXISTS friend;
DROP TABLE IF EXISTS yelp_user;
DROP TABLE IF EXISTS check_in;
DROP TABLE IF EXISTS has_attribute;
DROP TABLE IF EXISTS business_attribute;
DROP TABLE IF EXISTS in_category;
DROP TABLE IF EXISTS business_category;
DROP TABLE IF EXISTS business_hours;
DROP TABLE IF EXISTS business;

CREATE TABLE business (
    business_id VARCHAR(22),
    business_name VARCHAR(),
    street VARCHAR(),
    city VARCHAR(),
    state VARCHAR(),
    postal_code VARCHAR(), -- "12345" or "12345-6789"
    latitude DOUBLE, -- Can also be DECIMAL(8,6) to represent 8 total digits, 6 of which are after the decimal point 
    longitude DOUBLE, -- Can also be DECIMAL(9,6) to represent 9 total digits, 6 of which are after the decimal point
    stars DECIMAL(2,1), -- 0.0 to 5.0 with one decimal place
    is_open BOOLEAN, -- Yelp 1/0 mapped to PostgreSQL boolean
    tip_count INTEGER DEFAULT 0,
    PRIMARY KEY (business_id)
);

CREATE TABLE business_hours (
    business_id VARCHAR(22),
    day_of_week VARCHAR(), -- Maximum number of characters is "Wednesday"
    open_time TIME,
    close_time TIME,
    PRIMARY KEY (business_id, day_of_week),
    FOREIGN KEY (business_id) REFERENCES business(business_id)
);

-- CREATE TABLE business_category (
--     category_name VARCHAR(1),
--     PRIMARY KEY (category_name)
-- );

CREATE TABLE in_category (
    business_id VARCHAR(22),
    category_name VARCHAR(),
    PRIMARY KEY (business_id, category_name),
    FOREIGN KEY (business_id) REFERENCES business(business_id),
    FOREIGN KEY (category_name) REFERENCES business_category(category_name)
);

-- CREATE TABLE business_attribute (
--     attribute_name VARCHAR(500),
--     PRIMARY KEY (attribute_name)
-- );

CREATE TABLE has_attribute (
    business_id VARCHAR(22),
    attribute_name VARCHAR(),
    value VARCHAR(),
    PRIMARY KEY (business_id, attribute_name),
    FOREIGN KEY (business_id) REFERENCES business(business_id),
    FOREIGN KEY (attribute_name) REFERENCES business_attribute(attribute_name)
);

CREATE TABLE check_in (
    checkin_timestamp TIMESTAMP,
    business_id VARCHAR(22),
    PRIMARY KEY (business_id, checkin_timestamp),
    FOREIGN KEY (business_id) REFERENCES business(business_id)
);

CREATE TABLE yelp_user (
    user_id VARCHAR(22),
    user_name VARCHAR(),
    average_stars DECIMAL(2,1),
    funny INTEGER,
    useful INTEGER,
    cool INTEGER,
    fans INTEGER,
    account_creation_date DATE,
    tip_count INTEGER DEFAULT 0,
    PRIMARY KEY (user_id)
);

CREATE TABLE friend (
    user_id VARCHAR(22),
    friend_id VARCHAR(22),
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES yelp_user(user_id),
    FOREIGN KEY (friend_id) REFERENCES yelp_user(user_id)
);

-- Tip date is unique among the tips a specific user provides for a particular business.
CREATE TABLE tip (
    tip_timestamp TIMESTAMP,
    user_id VARCHAR(22), -- merged Writes relationship
    business_id VARCHAR(22), -- merged WrittenFor relationship
    tip_text TEXT,
    num_likes INTEGER,
    PRIMARY KEY (tip_timestamp, user_id, business_id),
    FOREIGN KEY (user_id) REFERENCES yelp_user(user_id),
    FOREIGN KEY (business_id) REFERENCES business(business_id)
);
