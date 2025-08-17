# This repository contains practical examples of Stored Procedures, Functions, Cursors, Transactions, and Views implemented in MySQL Workbench.

Contents
=========
1️. Basic Setup
---------------
Use database: demo
Tables used:
emp → For employee-related examples
Transactions → For bank statement examples

2️. Stored Procedures
---------------------
==> Without Parameters
SP_IncrAllSal() → Increments salary of all employees by 1000.

==> With Parameters
SP_IncrSalByDept(p_deptno) → Increments salaries of employees belonging to a specific department.

==> With Input & Output Parameters
SP_EmpNewSal(p_Empno, p_Amt, p_NewSal)

==> Increases salary of an employee by given amount.
Returns updated salary in an OUT parameter.

==> Using Cursor
SP_ListEmployeesByDept(p_Deptno)
Iterates over employees of a department using a cursor.
Prints each employee’s details row by row.

==> Bank Statement Example
sp_BankStatement(p_StartDate, p_EndDate)
Returns transactions between two given dates.
Works like a mini-bank statement generator.

3️. Scalar Valued Functions
---------------------------
--> fn_CalcBonus(p_Salary) → Returns 10% bonus of salary.
--> fn_FullName(p_First, p_Last) → Returns concatenated full name.
--> fn_DeptEmployees(p_Deptno) → Returns employee names in a department as a comma-separated string.

4️. Table-Valued Functions (TVF) Equivalent
-------------------------------------------
--> Since MySQL does not support true TVFs like SQL Server, we use Stored Procedures and Views:
--> sp_GetEmployeesByDept(p_Deptno) → Returns employee details of a department.
--> v_EmpByDept (View) → Acts like a TVF. Queryable with SELECT * FROM v_EmpByDept WHERE Deptno=30;.

5️. Utility Commands
-------------------
==> Drop Function
    DROP FUNCTION IF EXISTS fn_CalcBonus;

==> Show Procedures
    SHOW PROCEDURE STATUS WHERE Db = 'demo';

    
-> I have attached all screenshot of Table used and script code of all procedure and functions.
