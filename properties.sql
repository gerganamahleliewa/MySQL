CREATE DATABASE Real_Estate_Agency_DB;

USE Real_Estate_Agency_DB;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200),
    position ENUM ('BROKER', 'SALES_AGENT', 'PROPERTY_MANAGER', 'REAL_ESTATE_AGENT', 'LEASING_CONSULTANT', 'MARKETING_COORDINATOR', 'ADMIN_ASSISTANT', 'OFFICE_MANAGER', 'FINANCIAL_ANALYST', 'PROPERTY_APPRAISER')
) ENGINE=InnoDB;

CREATE TABLE salary_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    salary_amount DECIMAL(10, 2) NOT NULL,
    monthly_bonus DECIMAL(10, 2) DEFAULT 0.00,
    payment_year YEAR NOT NULL,
    payment_month INT NOT NULL CHECK (payment_month >= 1 AND payment_month <= 12),
    payment_date DATE NOT NULL,
    CONSTRAINT fk_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ON UPDATE CASCADE,
	UNIQUE KEY empl_month_year (employee_id, payment_month, payment_year)
) ENGINE=InnoDB;

CREATE TABLE action (
    id INT AUTO_INCREMENT PRIMARY KEY,
    actionType VARCHAR(20) UNIQUE NOT NULL
);

INSERT INTO action (actionType) VALUES ('BUY');
INSERT INTO action (actionType) VALUES ('SELL');
INSERT INTO action (actionType) VALUES ('RENT');


CREATE TABLE ads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action_id INT,
    publication_date DATE,
    is_actual BOOLEAN,
    FOREIGN KEY (action_id) REFERENCES action(id) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE deals (
    deal_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    deal_date DATE NOT NULL,
    insert_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_type ENUM('CASH', 'CREDIT', 'CHECK') NOT NULL,
    ad_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON UPDATE CASCADE,
    FOREIGN KEY (ad_id) REFERENCES ads(id) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    typeName VARCHAR(50) UNIQUE NOT NULL
) ENGINE=InnoDB;

INSERT INTO types (typeName) VALUES
('PLOT'),
('BUILDING_WITH_PLOT'),
('APARTMENT'),
('HOUSE'),
('MAISONETTE');

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20) UNIQUE NOT NULL,
    CONSTRAINT check_phone CHECK (CHAR_LENGTH(phone) >= 7 AND CHAR_LENGTH(phone) <= 20),
    --    CONSTRAINT check_phone CHECK (phone LIKE '+359%' AND CHAR_LENGTH(phone) = 13) -- BG
    CONSTRAINT check_email CHECK (email LIKE '%_@__%.__%')
) ENGINE=InnoDB;

CREATE TABLE properties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_id INT,
    customer_id INT,
    area DECIMAL(7,1),
    price DECIMAL(10,2),
    location VARCHAR(255),
    description TEXT,
    FOREIGN KEY (type_id) REFERENCES types(id) ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON UPDATE CASCADE
) ENGINE=InnoDB;

ALTER TABLE ads
ADD property_id INT,
ADD CONSTRAINT fk_property_id FOREIGN KEY (property_id) REFERENCES properties(id) ON UPDATE CASCADE;


-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO employees (name, position) VALUES
('John Doe', 'BROKER'),
('Alice Smith', 'SALES_AGENT'),
('Bob Johnson', 'REAL_ESTATE_AGENT');

-- ex.1
DROP VIEW IF EXISTS  monthlyDeals;
CREATE VIEW monthlyDeals AS
SELECT c.name AS Customers,c.phone AS PhoneNumber,p.location AS Location,
p.area AS Area,p.price AS Price,e.name AS BrokerName
FROM customers AS c
JOIN properties AS p on c.id = p.customer_id
JOIN
    ads AS a ON p.id = a.property_id
JOIN action AS a2 on a2.id = a.action_id
JOIN
    deals AS d ON a.id = d.ad_id
JOIN
    employees AS e ON d.employee_id = e.id
WHERE a2.actionType = 'SELL' AND MONTH(deal_date) = MONTH(CURDATE()) AND YEAR(deal_date) = YEAR(CURDATE())
ORDER BY p.price;


-- ex.2
drop procedure if exists commition_payments;
DELIMITER //
CREATE PROCEDURE commition_payments(IN Month INT, IN Year INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total_sales DECIMAL(10, 2);
    DECLARE commission DECIMAL(10, 2);
    DECLARE broker_id INT;

    DECLARE dealsCursor CURSOR FOR
    SELECT d.deal_id,p.price
    FROM deals d
    JOIN ads a ON d.ad_id = a.id
    JOIN properties p ON a.property_id = p.id
    JOIN employees e on d.employee_id = e.id
    JOIN salary_payments sp on e.id = sp.employee_id
    WHERE MONTH(d.deal_date) = Month AND YEAR(d.deal_date) = Year
    ORDER BY p.price desc
    LIMIT 3;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN dealsCursor;
    START TRANSACTION;

read_l: LOOP
        FETCH dealsCursor INTO broker_id, total_sales;
        IF done THEN
            LEAVE read_l;
        END IF;

        IF total_sales <= 100000 THEN
            SET commission = total_sales * 0.02;
        ELSE
           SET commission = total_sales * 0.03;
        END IF;

        IF (SELECT COUNT(*) FROM salary_payments) <= 3 && (SELECT p.price FROM properties AS p) >= total_sales THEN
            SET commission = commission + (total_sales * CASE (SELECT COUNT(*) FROM salary_payments)
                                                    WHEN 0 THEN 0.15
                                                    WHEN 1 THEN 0.10
                                                    WHEN 2 THEN 0.05
                                                  END);
        END IF;

        UPDATE salary_payments
        SET monthly_bonus = commission
        WHERE broker_id = employee_id AND
        MONTH(payment_month) = Month AND YEAR(payment_year) = Year;
end loop;

CLose dealsCursor;

    COMMIT;

END//
delimiter ;
CALL commition_payments(5,2024);


-- ex.3
DELIMITER //
DROP TRIGGER IF EXISTS something;
CREATE TRIGGER something AFTER INSERT ON properties
    FOR EACH ROW
    BEGIN
        DECLARE id INT;
        DECLARE num_deals INT;
        DECLARE property_id INT;
        DECLARE discount DECIMAL(10,1);
        SET id = (SELECT customers.id From customers);
        SET property_id = (SELECT properties.id from properties);
SELECT COUNT(*) INTO num_deals
    FROM properties AS p
    WHERE id = p.customer_id;

    IF num_deals >= 1 AND num_deals <= 5 THEN
        SET discount = 0.5; -- 0.5% discount
    ELSEIF num_deals > 5 THEN
        SET discount = 1; -- 1% discount
    ELSE
        SET discount = 0; -- No discount
         -- CALL SendEmailToCustomer(NEW.   customer_id, NEW.id, discount);
    END IF;

#     IF discount > 0 THEN
#
#         -- CALL SendEmailToCustomer(NEW.customer_id, NEW.id, discount);
#     END IF;

END //
DELIMITER ;


-- ex.4
DROP TRIGGER IF EXISTS podnaem;
CREATE TRIGGER podnaem BEFORE INSERT ON ads
FOR EACH ROW
    BEGIN
        DECLARE active INT;

        SELECT COUNT(*)
          INTO active
          FROM ads AS a
          JOIN properties p ON a.property_id = p.id
          WHERE  a.action_id = (SELECT id FROM action WHERE actionType = 'RENT')
          AND a.is_actual = true;

        IF (active) >= 2 THEN
           SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Cannot add new rental ad. Property owner already has two or more active rental ads.';
        end if;

    end;
DELIMITER ;
