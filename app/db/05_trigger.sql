DELIMITER $$

CREATE TRIGGER trg_after_bonus_insert
AFTER INSERT ON bonus_deductions
FOR EACH ROW
BEGIN
    INSERT INTO bonus_deduction_log(bd_id, employee_id, description, bd_type, amount, effective_date, log_time)
    VALUES(NEW.bd_id, NEW.employee_id, NEW.description, NEW.bd_type, NEW.amount, NEW.effective_date, NOW());
END $$

DELIMITER ;