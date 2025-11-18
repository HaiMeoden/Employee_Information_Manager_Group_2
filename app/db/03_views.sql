-- View 1: Tổng hợp lương tháng (kèm thưởng/phạt)
CREATE VIEW v_monthly_salary_summary AS
SELECT 
    e.employee_id,
    e.full_name AS employee_name,
    sp.salary_month,
    sp.year,
    e.base_salary,
    (SELECT IFNULL(SUM(amount),0) FROM bonus_deductions bd 
        WHERE bd.employee_id = e.employee_id 
          AND bd.bd_type = 'Bonus'
          AND YEAR(bd.effective_date) = sp.year 
          AND MONTH(bd.effective_date) = MONTH(STR_TO_DATE(sp.salary_month, '%M'))
    ) AS total_bonus,
    (SELECT IFNULL(SUM(amount),0) FROM bonus_deductions bd 
        WHERE bd.employee_id = e.employee_id 
          AND bd.bd_type = 'Deduction'
          AND YEAR(bd.effective_date) = sp.year 
          AND MONTH(bd.effective_date) = MONTH(STR_TO_DATE(sp.salary_month, '%M'))
    ) AS total_deduction,
    (e.base_salary 
       + (SELECT IFNULL(SUM(amount),0) FROM bonus_deductions bd 
            WHERE bd.employee_id = e.employee_id 
              AND bd.bd_type = 'Bonus'
              AND YEAR(bd.effective_date) = sp.year 
              AND MONTH(bd.effective_date) = MONTH(STR_TO_DATE(sp.salary_month, '%M'))
          )
       - (SELECT IFNULL(SUM(amount),0) FROM bonus_deductions bd 
            WHERE bd.employee_id = e.employee_id 
              AND bd.bd_type = 'Deduction'
              AND YEAR(bd.effective_date) = sp.year 
              AND MONTH(bd.effective_date) = MONTH(STR_TO_DATE(sp.salary_month, '%M'))
          )
    ) AS net_amount,
    sp.total_amount AS recorded_payment,
    sp.payment_status
FROM employees e
JOIN salary_payments sp ON e.employee_id = sp.employee_id;

-- View 2: Tham gia dự án
CREATE VIEW v_project_participation AS
SELECT 
    p.project_id,
    p.project_name,
    COUNT(DISTINCT a.employee_id) AS total_employees,
    SUM(a.hours_worked) AS total_hours_worked
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name;

-- View 3: Lịch sử chấm công
CREATE VIEW v_employee_attendance AS
SELECT 
    a.work_date,
    e.employee_id,
    e.full_name AS employee_name,
    d.department_name,
    a.status,
    a.check_in,
    a.check_out
FROM attendance a
JOIN employees e ON a.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id;