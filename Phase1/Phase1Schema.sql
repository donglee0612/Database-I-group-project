DROP TABLE Tip;
DROP TABLE Friends;
DROP TABLE User;
DROP TABLE CheckIn;
DROP TABLE HasAttribute;
DROP TABLE BusinessAttribute;
DROP TABLE InCategory;
DROP TABLE BusinessCategory;
DROP TABLE BusinessHours;
DROP TABLE Business;

CREATE TABLE Business (
    business_id CHAR(22),
    business_name VARCHAR(100),
    street VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(50),
    postal_code VARCHAR(10), -- "12345" or "12345-6789"
    latitude FLOAT, -- Can also be DECIMAL(8,6) to represent 8 total digits, 6 of which are after the decimal point 
    longitude FLOAT, -- Can also be DECIMAL(9,6) to represent 9 total digits, 6 of which are after the decimal point
    stars DECIMAL(2,1), -- 0.0 to 5.0 with one decimal place
    is_open BOOLEAN,
    tip_count INTEGER,
    PRIMARY KEY (business_id)
);

CREATE TABLE BusinessHours (
    business_id CHAR(22),
    day_of_week VARCHAR(9), -- Maximum number of characters is "Wednesday"
    open_time TIME,
    close_time TIME,
    PRIMARY KEY (business_id, day_of_week),
    FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE BusinessCategory (
    category_name VARCHAR(100),
    PRIMARY KEY (category_name)
);

CREATE TABLE InCategory (
    business_id CHAR(22),
    category_name VARCHAR(100),
    PRIMARY KEY (business_id, category_name),
    FOREIGN KEY (business_id) REFERENCES Business(business_id),
    FOREIGN KEY (category_name) REFERENCES Business_Category(category_name)
);

CREATE TABLE BusinessAttribute (
    attribute_name VARCHAR(500),
    PRIMARY KEY (attribute_name)
);

CREATE TABLE HasAttribute (
    business_id CHAR(22),
    attribute_name VARCHAR(500),
    value VARCHAR(500),
    PRIMARY KEY (business_id, attribute_name),
    FOREIGN KEY (business_id) REFERENCES Business(business_id),
    FOREIGN KEY (attribute_name) REFERENCES BusinessAttribute(attribute_name)
);

CREATE TABLE CheckIn (
    checkin_timestamp TIMESTAMP,
    business_id CHAR(22) NOT NULL, -- merged HasCheckIn relationship; NOT NULL required
    FOREIGN KEY (business_id) REFERENCES Business(business_id)
);

CREATE TABLE User (
    user_id CHAR(22),
    user_name VARCHAR(100),
    average_stars DECIMAL(2,1),
    funny INTEGER,
    useful INTEGER,
    cool INTEGER,
    fans INTEGER,
    account_creation_date DATE,
    tip_count INTEGER
    PRIMARY KEY (user_id)
);

CREATE TABLE Friends (
    user_id CHAR(22),
    friend_id CHAR(22),
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (friend_id) REFERENCES User(user_id)
);

-- NOTE: "You can assume that the tip date is unique among the tips that a specific user provides for a particular business."
CREATE TABLE Tip (
    tip_timestamp TIMESTAMP,
    user_id CHAR(22) NOT NULL, -- merged Writes relationship; NOT NULL required
    business_id CHAR(22) NOT NULL, -- merged WrittenFor relationship; NOT NULL required
    tip_text VARCHAR(500),
    num_likes INTEGER,
    PRIMARY KEY (tip_timestamp, user_id, business_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (business_id) REFERENCES Business(business_id)
);