-- DATABASE QUERIES

-- 1. Insert Data into Tables
INSERT INTO CUSTOMER
    VALUES('101', 'Mark', 'Scout', 'MS101@Lumon.com', '732-445-7832', 'MacroData Refinement'),
          ('102', 'Helly', 'Riggs', 'HR102@Lumon.com', '732-544-7211', 'MacroData Refinement'),
          ('103', 'Irving', 'Bailiff', 'IB103@Lumon.com', '732-333-3338', 'MacroData Refinment'),
          ('104', 'Dylan', 'George', 'DG104@Lumon.com', '732-338-8990', 'MacroData Refinement'),
          ('201', 'Burt', 'Goodman', 'BG201@Lumon.com', '732-667-5321', 'Optics & Design'),
          ('202', 'Felicia', 'Robinson', 'FR202@Lumon.com', '732-432-8890', 'Optics & Design'),
          ('001', 'Harmony', 'Cobel', 'HC001@Lumon.com', '879-456-3333', 'Management'),
          ('002', 'Seth', 'Milchick', 'SM002@Lumon.com', '732-443-8321', 'Managment'),
          ('003', 'Doug', 'Graner', 'DG003@Lumon.com', '732-333-3334', 'Management');

SELECT*FROM CUSTOMER;


INSERT INTO PRODUCT
    VALUES ('LPE47', 'Lumon pencil eraser', 'Office Supplies', 9.99),
           ('FTT33', 'Finger Trap Toy', 'Entertainment', 24.99),
           ('MDE29', 'Music & Dance Experience', 'Entertainment', 74.99),
           ('CCP10', 'Custom Caricature Portrait', 'Art', 99.99),
           ('WP52', 'Waffle Party', 'Cuisine', 59.99);

SELECT*FROM PRODUCT;


INSERT INTO ORDERS
    VALUES ('1191', '2022-02-10', 59.99, '103'),
           ('1192', '2022-02-12', 24.99, '104'),
           ('1193', '2022-02-20', 9.99, '101'),
           ('1194', '2022-03-12', 24.99, '101'),
           ('1195', '2022-03-14', 9.99, '102'),
           ('1196', '2022-03-20', 99.99, '201'),
           ('1197', '2022-04-02', 74.99, '103'), 
           ('1198', '2025-03-04', 174.98, '101');

SELECT* FROM ORDERS;


INSERT INTO ORDER_DETAIL
    VALUES ('0', '1191', 'WP52', 1, 59.99),
           ('1', '1192', 'FTT33', 1, 24.99),
           ('2', '1193', 'LPE47', 1, 9.99),
           ('3', '1194', 'FTT33', 1, 24.99),
           ('4', '1195', 'LPE47', 1, 9.99),
           ('5', '1196', 'CCP10', 1, 99.99),
           ('6', '1197', 'MDE29', 1, 74.99),
           ('7', '1198', 'MDE29', 1, 74.99),
           ('8', '1198', 'CCP10', 1, 99.99);

SELECT*FROM ORDER_DETAIL;


-- 2. Update Existing Data
UPDATE ORDERS
    SET CUST_ID = '104'
        WHERE ORDER_ID = '1191';

SELECT*FROM ORDERS;

-- 3. Delete Row in Existing Data
DELETE
    FROM CUSTOMER
        WHERE CUST_ID = '003';

SELECT*FROM CUSTOMER;

-- 4. Select Queries
 -- a. Retrieve all customers along with their orders.
SELECT C.CUST_ID, FIRST_NAME, LAST_NAME, O.ORDER_ID, PRODUCT_NAME
    FROM CUSTOMER C, ORDERS O, PRODUCT P, ORDER_DETAIL OD
        WHERE (C.CUST_ID = O.CUST_ID) AND (OD.PRODUCT_ID = P.PRODUCT_ID) AND (OD.ORDER_ID = O.ORDER_ID);

-- b. Retrieve products along with their categories ordered by price in descending order.
SELECT*
    FROM PRODUCT
        ORDER BY PRICE DESC;

-- c. Retrieve the latest order date for each customer.
SELECT C.CUST_ID, MAX(O.ORDER_DATE) AS MOST_RECENT_ORDER
    FROM CUSTOMER C, ORDERS O
        WHERE (C.CUST_ID = O.CUST_ID)
            GROUP BY C.CUST_ID;

-- d. Retrieve the number of orders placed by each customer.
SELECT C.CUST_ID, COUNT(O.CUST_ID) AS ORDERS_PLACED
    FROM CUSTOMER C, ORDERS O
        WHERE (C.CUST_ID = O.CUST_ID)
        GROUP BY C.CUST_ID
        ORDER BY C.CUST_ID;

-- e. Retrieve the top 5 best-selling products (based on total quantity sold).
SELECT P.PRODUCT_ID, COUNT(QUANTITY) AS TOTAL_QUANTITY_ORDERED
    FROM ORDER_DETAIL OD, PRODUCT P
        WHERE (OD.PRODUCT_ID = P.PRODUCT_ID)
        GROUP BY P.PRODUCT_ID;

-- f. Retrieve customers who have not placed any orders.
SELECT C.*
FROM CUSTOMER C
LEFT JOIN ORDERS O ON C.CUST_ID = O.CUST_ID
WHERE O.ORDER_ID IS NULL;

-- g. Retrieve orders placed on a specific date (e.g., '2024-04-18').
SELECT*
    FROM ORDERS
        WHERE ORDER_DATE = '2025-03-04';

-- h. Retrieve orders with a total amount greater than $1000.
SELECT*
    FROM ORDERS
        WHERE TOTAL_AMOUNT > 1000;    -- There were no orders inserted into the orders table with amounts greater than $180.

-- i. Retrieve customers who have placed orders for more than one product category.
SELECT C.CUST_ID, FIRST_NAME, LAST_NAME, COUNT(CATEGORY) AS PRODUCT_CATEGORY_ORDERED
    FROM CUSTOMER C, ORDERS O, ORDER_DETAIL OD, PRODUCT P
        WHERE (C.CUST_ID = O.CUST_ID) AND (O.ORDER_ID = OD.ORDER_ID) AND (OD.PRODUCT_ID = P.PRODUCT_ID)
        GROUP BY C.CUST_ID, FIRST_NAME, LAST_NAME
             HAVING COUNT(CATEGORY) > 1;

/* j. Calculate the average order value for each customer and rank them by their average
      order value. (Tip: you can use AVG and RANK functions) */ 

SELECT C.CUST_ID, FIRST_NAME, LAST_NAME, ROUND(AVG(TOTAL_AMOUNT),2) AS AVG_TOTAL_AMOUNT, COUNT(ORDER_ID) AS COUNT_OF_ORDERS,
RANK() OVER(ORDER BY AVG(TOTAL_AMOUNT) DESC) AS RANK
    FROM CUSTOMER C, ORDERS O
        WHERE (C.CUST_ID = O.CUST_ID)
        GROUP BY C.CUST_ID, FIRST_NAME, LAST_NAME;

/* k. Identify customers who have not made any purchases in the last 3 months. (Tip: You
can use LEFT JOIN) */

SELECT C.CUST_ID, FIRST_NAME, LAST_NAME, DATEDIFF(MONTH,MAX(ORDER_DATE),GETDATE())AS MONTHS_SINCE_LAST_PURCHASE
    FROM CUSTOMER C 
        LEFT JOIN ORDERS O 
            ON (C.CUST_ID = O.CUST_ID)
            WHERE (ORDER_DATE < '2025-04-25') OR (ORDER_DATE IS NULL)
            GROUP BY C.CUST_ID, FIRST_NAME, LAST_NAME;

/* l. Retrieve the top 3 customers who have spent the most amount of money in total.
(Tip: You can use SUM function and LIMIT) */
SELECT TOP 3 *
    FROM CUSTOMER C
        INNER JOIN ORDERS O
            ON (C.CUST_ID = O.CUST_ID)
            ORDER BY TOTAL_AMOUNT DESC;

/* m. Calculate the cumulative total amount spent by customers over time, ordered by
customer, and order date. (Tip: You can use SUM function and PARTITION BY
Clause) */
SELECT C.CUST_ID, FIRST_NAME, LAST_NAME, ORDER_DATE, TOTAL_AMOUNT, 
SUM(TOTAL_AMOUNT) OVER(PARTITION BY C.CUST_ID ORDER BY C.CUST_ID, ORDER_DATE)  AS TOTAL_SPENT
    FROM CUSTOMER C, ORDERS O
        WHERE (C.CUST_ID = O.CUST_ID);
        






        


                                                  





