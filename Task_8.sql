-- Database
use demo;
-- =======================================================================
# table  Used : emp
select * from emp;
-- =======================================================================
show tables;
-- =======================================================================
/* Stored Procedure without parameters*/
DELIMITER //
Create PROCEDURE SP_IncrAllSal()
BEGIN
    START TRANSACTION;
    UPDATE emp SET sal = IFNULL(sal, 0) + 1000;
    COMMIT;
END //
DELIMITER ;
-- =======================================================================
-- Call the procedure
CALL SP_IncrAllSal();
-- =======================================================================

/* Stored Procedure with parameters */
-- Create Stored procedure to increment specific employee sal by specific amount ?
DELIMITER //
CREATE PROCEDURE SP_IncrSalByDept(IN p_deptno INT)
BEGIN
    START TRANSACTION;
    UPDATE emp
    SET sal = IFNULL(sal, 0) + 2000
    WHERE deptno = p_deptno;
    COMMIT;
END //
DELIMITER ;
-- Call Procedure
CALL SP_IncrSalByDept(10);

-- =======================================================================

SHOW PROCEDURE STATUS WHERE Db = 'demo';
select * from emp;
-- =========================================================================
/* Procedure with output parameter */

DELIMITER $$
CREATE PROCEDURE SP_EmpNewSal(
    IN p_Empno INT,
    IN p_Amt DECIMAL(10,2),
    OUT p_NewSal DECIMAL(10,2)
)
BEGIN
    -- Ensure p_Amt is not null
    SET p_Amt = IFNULL(p_Amt, 0);

    -- Update salary (treat SAL as 0 if NULL)
    UPDATE emp
    SET SAL = IFNULL(SAL,0) + p_Amt
    WHERE Empno = p_Empno;
    -- Return updated salary into OUT parameter
    SELECT IFNULL(SAL,0) INTO p_NewSal 
    FROM emp
    WHERE Empno = p_Empno;
END $$
DELIMITER ;

-- Declare output variable

SET @Salary = 0;
-- Call procedure (Empno = 7369, increment by 1000)
CALL SP_EmpNewSal(7369, 1000, @Salary);
-- Display updated salary
SELECT CONCAT('Your New Salary is : ', @Salary) AS Message;
-- =========================================================================
/*Stored Procedure Returning Records with Cursor*/

DROP PROCEDURE IF EXISTS SP_ListEmployeesByDept;

DELIMITER $$
CREATE PROCEDURE SP_ListEmployeesByDept(IN p_Deptno INT)
BEGIN
    -- Cursor variables
    DECLARE v_Empno INT;
    DECLARE v_Ename VARCHAR(50);
    DECLARE v_Sal DECIMAL(10,2);
    DECLARE v_done INT DEFAULT 0;

    -- Declare cursor
    DECLARE emp_cursor CURSOR FOR
        SELECT Empno, Ename, Sal 
        FROM emp 
        WHERE Deptno = p_Deptno;

    -- Declare handler to exit loop
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    -- Open cursor
    OPEN emp_cursor;

    read_loop: LOOP
        -- Fetch record into variables
        FETCH emp_cursor INTO v_Empno, v_Ename, v_Sal;
        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Return each record (prints like SELECT result)
        SELECT v_Empno AS Empno, v_Ename AS Name, v_Sal AS Salary;
    END LOOP;

    -- Close cursor
    CLOSE emp_cursor;
END $$

DELIMITER ;

-- Execute Procedure
CALL SP_ListEmployeesByDept(30);
-- =========================================================================

/*SCALAR VALUED FUNCTION
	=======================
	-> A function is also a named T-SQL block that accepts some input performs some calculation 
	   and must return a value.
	-> Scalar Valued function should be prefixed with schema name, if not then it will throw and error 
	   and understanding the function which is created by you is built-in function.
*/
# Scalar Function – Calculate Bonus

DELIMITER $$

CREATE FUNCTION fn_CalcBonus(p_Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
   DECLARE v_Bonus DECIMAL(10,2);

   -- 10% of salary as bonus
   SET v_Bonus = IFNULL(p_Salary,0) * 0.10;

   RETURN v_Bonus;
END $$

DELIMITER ;

-- Execute Function
-- For single value

SELECT fn_CalcBonus(5000) AS Bonus;

-- Inside SELECT for a table
SELECT Empno, Ename, Sal, fn_CalcBonus(Sal) AS Bonus
FROM emp;
-- ==============================================================================
# Scalar Function – Get Full Name
DELIMITER $$

CREATE FUNCTION fn_FullName(p_First VARCHAR(50), p_Last VARCHAR(50))
RETURNS VARCHAR(120)
DETERMINISTIC
BEGIN
   DECLARE v_FullName VARCHAR(120);

   SET v_FullName = CONCAT(IFNULL(p_First,''), ' ', IFNULL(p_Last,''));
   RETURN v_FullName;
END $$

DELIMITER ;

SELECT fn_FullName('John','Doe') AS FullName;
-- ===============================================================================
# Scalar Function(Return as a comma-separated string (using function))
DELIMITER $$
CREATE FUNCTION fn_DeptEmployees(p_Deptno INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE v_EmpList TEXT;

    -- Concatenate employee names for the given department
    SELECT GROUP_CONCAT(Ename SEPARATOR ', ')
    INTO v_EmpList
    FROM emp
    WHERE Deptno = p_Deptno;

    RETURN IFNULL(v_EmpList, 'No Employees');
END $$
DELIMITER ;
-- Execute Function
SELECT fn_DeptEmployees(30) AS EmployeesInDept30;
-- ==============================================================
/*   Table Valued Function (TVF)
	============================
	-> TVF returns records
	-> Returns type must be Table
	-> Return expression must be select statement
	-> TVF allows only one statement and it must return statement
	-> Table value function invoked from "FROM" Clause and Scalar function will execute form "SELECT" Clause.
	-> No need to use prefix schema name in TVF 
*/
# TVF Equivalent in MySQL
-- Write function to return all employees of a department. (Using Stored Procedure)
DELIMITER $$
CREATE PROCEDURE sp_GetEmployeesByDept(IN p_Deptno INT)
BEGIN
    SELECT Empno, Ename, Job, Sal, Deptno
    FROM emp
    WHERE Deptno = p_Deptno;
END $$
DELIMITER ;

-- Execute Function
CALL sp_GetEmployeesByDept(30);
-- ==============================================================================================
# TVF Equivalent in MySQL (Using View)

CREATE VIEW v_EmpByDept AS
SELECT Empno, Ename, Job, Sal, Deptno
FROM emp;

-- Execute
SELECT * FROM v_EmpByDept WHERE Deptno = 30;
-- =======================================================================================
-- Qns. Create a Function which give bank Statement between two given dates. [Bank Statement (Full Records) → Use Stored Procedure]
	-- Table Used:- Transactions
    
    select * from Transactions;
    
DELIMITER $$
CREATE PROCEDURE sp_BankStatement(
    IN p_StartDate DATE,
    IN p_EndDate DATE
)
BEGIN
    SELECT TransId, AccountNo, TransDate, TransType, Amount
    FROM Transactions
    WHERE TransDate BETWEEN p_StartDate AND p_EndDate
    ORDER BY TransDate;
END $$
DELIMITER ;

-- Execute
CALL sp_BankStatement('2025-01-01','2025-01-31');
-- ===========================================================================================================================








