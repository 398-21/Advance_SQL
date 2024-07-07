-- Create Boroughs Table
CREATE TABLE IF NOT EXISTS Boroughs (
    borough_id INT PRIMARY KEY AUTO_INCREMENT,
    borough_name VARCHAR(50) UNIQUE NOT NULL
);

-- Create ServiceZones Table
CREATE TABLE IF NOT EXISTS ServiceZones (
    service_zone_id INT PRIMARY KEY AUTO_INCREMENT,
    service_zone_name VARCHAR(50) UNIQUE NOT NULL
);

-- Create Zones Table
CREATE TABLE IF NOT EXISTS Zones (
    zone_id INT PRIMARY KEY AUTO_INCREMENT,
    zone_name VARCHAR(100) UNIQUE NOT NULL,
    borough_id INT NOT NULL,
    service_zone_id INT NOT NULL,
    FOREIGN KEY (borough_id) REFERENCES Boroughs(borough_id),
    FOREIGN KEY (service_zone_id) REFERENCES ServiceZones(service_zone_id)
);

-- Create Locations Table
CREATE TABLE IF NOT EXISTS Locations (
    location_id INT PRIMARY KEY,
    zone_id INT NOT NULL,
    FOREIGN KEY (zone_id) REFERENCES Zones(zone_id)
);

-- Create Vendors Table
CREATE TABLE IF NOT EXISTS Vendors (
    vendor_id INT PRIMARY KEY,
    vendor_name VARCHAR(50) NOT NULL
);

-- Create PaymentTypes Table
CREATE TABLE IF NOT EXISTS PaymentTypes (
    payment_type_id INT PRIMARY KEY,
    payment_type_description VARCHAR(50) NOT NULL
);

-- Create RateCodes Table
CREATE TABLE IF NOT EXISTS RateCodes (
    ratecode_id INT PRIMARY KEY,
    ratecode_description VARCHAR(50) NOT NULL
);

-- Create Trips Table
CREATE TABLE IF NOT EXISTS Trips (
    trip_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT NULL,
    pickup_datetime DATETIME NOT NULL,
    dropoff_datetime DATETIME NOT NULL,
    passenger_count INT NULL,
    trip_distance DECIMAL(9,2) NULL,
    ratecode_id INT NULL,
    store_and_fwd_flag CHAR(1) NULL,
    pickup_location_id INT NULL,
    dropoff_location_id INT NULL,
    payment_type INT NULL,
    fare_amount DECIMAL(6,2) NULL,
    extra DECIMAL(4,2) NULL,
    mta_tax DECIMAL(4,2) NULL,
    tip_amount DECIMAL(6,2) NULL,
    tolls_amount DECIMAL(6,2) NULL,
    improvement_surcharge DECIMAL(3,2) NULL,
    total_amount DECIMAL(7,2) NULL,
    congestion_surcharge DECIMAL(3,2) NULL,
    airport_fee DECIMAL(3,2) NULL,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id),
    FOREIGN KEY (pickup_location_id) REFERENCES Locations(location_id),
    FOREIGN KEY (dropoff_location_id) REFERENCES Locations(location_id),
    FOREIGN KEY (payment_type) REFERENCES PaymentTypes(payment_type_id),
    FOREIGN KEY (ratecode_id) REFERENCES RateCodes(ratecode_id)
);

-- Create Datetime Table
CREATE TABLE IF NOT EXISTS Datetimes (
    datetime_id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL
);

-- Create Conditions Table
CREATE TABLE IF NOT EXISTS Conditions (
    condition_id INT AUTO_INCREMENT PRIMARY KEY,
    conditions VARCHAR(255) NOT NULL
);

-- Create Icons Table
CREATE TABLE IF NOT EXISTS Icons (
    icon_id INT AUTO_INCREMENT PRIMARY KEY,
    icon VARCHAR(255) NOT NULL
);

-- Create Weather Table
CREATE TABLE IF NOT EXISTS Weather (
    weather_id INT AUTO_INCREMENT PRIMARY KEY,
    datetime_id INT,
    condition_id INT,
    icon_id INT,
    temp FLOAT,
    feelslike FLOAT,
    dew FLOAT,
    humidity FLOAT,
    precip FLOAT,
    precipprob FLOAT,
    snow FLOAT,
    snowdepth FLOAT,
    windgust FLOAT,
    windspeed FLOAT,
    winddir FLOAT,
    sealevelpressure FLOAT,
    cloudcover FLOAT,
    visibility FLOAT,
    solarradiation FLOAT,
    solarenergy FLOAT,
    uvindex INT,
    severerisk INT,
    stations TEXT,
    FOREIGN KEY (datetime_id) REFERENCES Datetimes(datetime_id),
    FOREIGN KEY (condition_id) REFERENCES Conditions(condition_id),
    FOREIGN KEY (icon_id) REFERENCES Icons(icon_id)
);
