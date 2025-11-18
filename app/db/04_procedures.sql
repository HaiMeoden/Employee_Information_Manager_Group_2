DELIMITER $$

CREATE PROCEDURE sp_add_employee (
    IN p_full_name VARCHAR(100),
    IN p_gender CHAR(1),
    IN p_date_of_birth DATE,
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_address VARCHAR(255),
    IN p_hire_date DATE,
    IN p_department_id INT,
    IN p_position VARCHAR(100),
    IN p_base_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO employees(full_name, gender, date_of_birth, phone_number, email, address, hire_date, department_id, position, base_salary)
    VALUES(p_full_name, p_gender, p_date_of_birth, p_phone, p_email, p_address, p_hire_date, p_department_id, p_position, p_base_salary);
    SELECT LAST_INSERT_ID() AS new_employee_id;
END $$

CREATE PROCEDURE sp_mark_attendance (
    IN p_emp_id INT,
    IN p_work_date DATE,
    IN p_check_in TIME,
    IN p_check_out TIME,
    IN p_status VARCHAR(10)
)
BEGIN
    DECLARE rec_count INT;
    SELECT COUNT(*) INTO rec_count 
    FROM attendance 
    WHERE employee_id = p_emp_id AND work_date = p_work_date;

    IF rec_count > 0 THEN
        UPDATE attendance
        SET check_in = p_check_in, check_out = p_check_out, status = p_status
        WHERE employee_id = p_emp_id AND work_date = p_work_date;
        SELECT CONCAT('Attendance record updated for ', p_work_date) AS message;
    ELSE
        INSERT INTO attendance(employee_id, work_date, check_in, check_out, status)
        VALUES(p_emp_id, p_work_date, p_check_in, p_check_out, p_status);
        SELECT CONCAT('Attendance record added for ', p_work_date) AS message;
    END IF;
END $$

DELIMITER ;