-- =====================================================
-- PetCare Database Schema for MySQL
-- Smart Pet Health & Adoption System
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS petcare_db;
USE petcare_db;

-- =====================================================
-- 1. USERS TABLE
-- =====================================================
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(100) UNIQUE NOT NULL,
    pass VARCHAR(255) NOT NULL,
    role ENUM('Adopter', 'Owner') NOT NULL DEFAULT 'Adopter',
    phone VARCHAR(20),
    address TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_active (is_active)
);

-- =====================================================
-- 2. PETS TABLE
-- =====================================================
CREATE TABLE pets (
    pet_id INT PRIMARY KEY AUTO_INCREMENT,
    owner_id INT NOT NULL,
    category ENUM('Dog', 'Cat', 'Bird') NOT NULL,
    pet_name VARCHAR(50) NOT NULL,
    breed VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    color VARCHAR(30) NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    temperament TEXT NOT NULL,
    location VARCHAR(100) NOT NULL,
    pet_image VARCHAR(255),
    diet_preferences TEXT,
    special_notes TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    is_adopted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (owner_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_category (category),
    INDEX idx_available (is_available),
    INDEX idx_adopted (is_adopted),
    INDEX idx_owner (owner_id)
);

-- =====================================================
-- 3. VACCINATIONS TABLE
-- =====================================================
CREATE TABLE vaccinations (
    vaccination_id INT PRIMARY KEY AUTO_INCREMENT,
    pet_id INT NOT NULL,
    vaccine_name VARCHAR(100) NOT NULL,
    vaccine_type ENUM('Compulsory', 'Extra') NOT NULL,
    certificate_file VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE,
    INDEX idx_pet (pet_id),
    INDEX idx_type (vaccine_type)
);

-- =====================================================
-- 4. ADOPTION_REQUESTS TABLE
-- =====================================================
CREATE TABLE adoption_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    pet_id INT NOT NULL,
    adopter_id INT NOT NULL,
    
   
    full_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    
    
    home_type ENUM('Owned', 'Rented') NOT NULL,
    has_fenced_yard BOOLEAN NOT NULL,
    household_members TEXT,
    other_pets TEXT,
    
   
    adopted_before BOOLEAN NOT NULL,
    pet_experience TEXT,
    dedicated_hours_per_day INT NOT NULL,
    willing_medical_care BOOLEAN NOT NULL,
   
    adoption_reason TEXT NOT NULL,
    preferences TEXT,
    ready_for_training BOOLEAN NOT NULL,
    
    
    willing_agreement BOOLEAN NOT NULL,
    references_info TEXT,
    aware_of_fees BOOLEAN NOT NULL,
    commitment_promise BOOLEAN NOT NULL,
    
    home_photo VARCHAR(255),
    scheduled_visit DATETIME,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE,
    FOREIGN KEY (adopter_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_pet (pet_id),
    INDEX idx_adopter (adopter_id),
    INDEX idx_created (created_at)
);

-- =====================================================
-- 5. ADOPTIONS TABLE (Completed Adoptions)
-- =====================================================
CREATE TABLE adoptions (
    adoption_id INT PRIMARY KEY AUTO_INCREMENT,
    request_id INT NOT NULL,
    pet_id INT NOT NULL,
    adopter_id INT NOT NULL,
    owner_id INT NOT NULL,
    adoption_date DATE NOT NULL,
    adoption_fee DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (request_id) REFERENCES adoption_requests(request_id),
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id),
    FOREIGN KEY (adopter_id) REFERENCES users(user_id),
    FOREIGN KEY (owner_id) REFERENCES users(user_id),
    INDEX idx_pet (pet_id),
    INDEX idx_adopter (adopter_id),
    INDEX idx_owner (owner_id),
    INDEX idx_date (adoption_date)
);

-- =====================================================
-- CREATE VIEWS FOR COMMON QUERIES
-- =====================================================

-- View for available pets with owner info
CREATE VIEW available_pets_view AS
SELECT 
    p.pet_id,
    p.pet_name,
    p.category,
    p.breed,
    p.age,
    p.gender,
    p.color,
    p.weight,
    p.temperament,
    p.location,
    p.pet_image,
    p.diet_preferences,
    p.special_notes,
    p.created_at,
    u.full_name as owner_name,
    u.phone as owner_phone,
    u.email as owner_email
FROM pets p
JOIN users u ON p.owner_id = u.user_id
WHERE p.is_available = TRUE AND p.is_adopted = FALSE;

-- View for adoption requests with details
CREATE VIEW adoption_requests_view AS
SELECT 
    ar.request_id,
    ar.pet_id,
    p.pet_name,
    p.category,
    ar.adopter_id,
    u.full_name as adopter_name,
    u.email as adopter_email,
    ar.status,
    ar.created_at,
    ar.updated_at
FROM adoption_requests ar
JOIN pets p ON ar.pet_id = p.pet_id
JOIN users u ON ar.adopter_id = u.user_id;

-- =====================================================
-- CREATE STORED PROCEDURES
-- =====================================================

DELIMITER //

-- Procedure to approve adoption request
CREATE PROCEDURE ApproveAdoptionRequest(
    IN p_request_id INT,
    IN p_adoption_fee DECIMAL(10,2),
    IN p_admin_notes TEXT
)
BEGIN
    DECLARE v_pet_id INT;
    DECLARE v_adopter_id INT;
    DECLARE v_owner_id INT;
    
    -- Get request details
    SELECT pet_id, adopter_id INTO v_pet_id, v_adopter_id
    FROM adoption_requests 
    WHERE request_id = p_request_id;
    
    -- Get pet owner
    SELECT owner_id INTO v_owner_id
    FROM pets 
    WHERE pet_id = v_pet_id;
    
    -- Update request status
    UPDATE adoption_requests 
    SET status = 'Approved', admin_notes = p_admin_notes
    WHERE request_id = p_request_id;
    
    -- Mark pet as adopted
    UPDATE pets 
    SET is_adopted = TRUE, is_available = FALSE
    WHERE pet_id = v_pet_id;
    
    -- Create adoption record
    INSERT INTO adoptions (request_id, pet_id, adopter_id, owner_id, adoption_fee, notes)
    VALUES (p_request_id, v_pet_id, v_adopter_id, v_owner_id, p_adoption_fee, p_admin_notes);
    
    -- Log the action
    INSERT INTO audit_logs (action, table_name, record_id, new_values)
    VALUES ('ADOPTION_APPROVED', 'adoptions', LAST_INSERT_ID(), 
            JSON_OBJECT('request_id', p_request_id, 'pet_id', v_pet_id, 'adopter_id', v_adopter_id));
END //

-- Procedure to reject adoption request
CREATE PROCEDURE RejectAdoptionRequest(
    IN p_request_id INT,
    IN p_rejection_reason TEXT,
    IN p_admin_notes TEXT
)
BEGIN
    -- Update request status
    UPDATE adoption_requests 
    SET status = 'Rejected', 
        rejection_reason = p_rejection_reason,
        admin_notes = p_admin_notes
    WHERE request_id = p_request_id;

END //

DELIMITER ;

-- =====================================================
-- CREATE TRIGGERS
-- =====================================================

-- Trigger to update pet availability when adopted
DELIMITER //
CREATE TRIGGER tr_pet_adopted
AFTER INSERT ON adoptions
FOR EACH ROW
BEGIN
    UPDATE pets 
    SET is_adopted = TRUE, is_available = FALSE
    WHERE pet_id = NEW.pet_id;
END //
DELIMITER ;

-- Trigger to log user registration
DELIMITER //
CREATE TRIGGER tr_user_registered
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (user_id, action, table_name, record_id, new_values)
    VALUES (NEW.user_id, 'USER_REGISTERED', 'users', NEW.user_id, 
            JSON_OBJECT('email', NEW.email, 'role', NEW.role));
END //
DELIMITER ;

-- =====================================================
-- CREATE INDEXES FOR PERFORMANCE
-- =====================================================

-- Additional indexes for better performance
CREATE INDEX idx_pets_category_available ON pets(category, is_available);
CREATE INDEX idx_adoption_requests_status_date ON adoption_requests(status, created_at);
CREATE INDEX idx_messages_unread ON messages(receiver_id, is_read, created_at);
CREATE INDEX idx_audit_logs_user_action ON audit_logs(user_id, action, created_at);

-- =====================================================
-- GRANT PERMISSIONS (Adjust as needed)
-- =====================================================

-- Create application user (replace 'petcare_user' and 'secure_password' with actual credentials)
-- CREATE USER 'petcare_user'@'localhost' IDENTIFIED BY 'secure_password';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON petcare_db.* TO 'petcare_user'@'localhost';
-- FLUSH PRIVILEGES;

-- =====================================================
-- END OF SCHEMA
-- =====================================================
