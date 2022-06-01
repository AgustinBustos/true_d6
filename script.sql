
CREATE TABLE random1 (
    customer_ID varchar(64),
    target INT
);

--  the next is done from the command line
LOAD DATA LOCAL INFILE 'C:/Users/TheQwertyPhoenix/Documents/agusssd/randomNumber/first/train_labels.csv'
INTO TABLE random1  
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 rows;

SELECT * FROM random1;


-- the next step is necessary for any database, order the independent variable
CREATE TABLE orderedID ( 
SELECT customer_ID, target
FROM random1
ORDER BY customer_ID ASC
);

-- check for null values
SELECT customer_ID
FROM orderedID
WHERE customer_ID IS NULL;

SELECT target
FROM orderedID
WHERE target IS NULL;

SELECT * FROM orderedID;

 -- we want to create a coinflip
SELECT AVG(target)
FROM orderedID;

-- we need even rows
SELECT COUNT(*)
FROM orderedID;

DELETE FROM orderedID LIMIT 1;
-- we will add a column with the row number
SET @row_number = -1; 
CREATE TABLE mainRand AS 
SELECT 
    (@row_number:=@row_number + 1) AS num, 
    target
FROM
orderedID;


SELECT * FROM mainRand;
SELECT COUNT(*)
FROM mainRand;


-- generative seed (key)

SELECT num, 
       target,
        @Functional := (CASE WHEN  num %2 !=0 THEN 0 ELSE 1 END) as secondaryFunction,
        AVG(@Functional)
FROM mainRand;


-- main keyquerys frequency problem, still pattern
SELECT num, 
       target,
        @Functional := (CASE WHEN  num %2 !=0 THEN 0 ELSE 1 END) as secondaryFunction,
        (CASE WHEN  target = @Functional THEN 1 ELSE 0 END) as finalRand
FROM mainRand;

SELECT num, 
       target,
        @Functional := (CASE WHEN  num < 229456 THEN 0 ELSE 1 END) as secondaryFunction,
        (CASE WHEN  target = @Functional THEN 1 ELSE 0 END)as finalRand
FROM mainRand;


-- Lets max te entropy
CREATE TABLE entropy0 AS 
SELECT *
FROM
mainRand;

SELECT *
FROM
entropy0;

CREATE TABLE entropyIz AS 
SELECT *
FROM entropy0
WHERE num<229456;

CREATE TABLE entropyDer AS 
SELECT *
FROM entropy0
WHERE num>=229456;

UPDATE entropyDer 
SET num = num-229456;

SELECT * FROM entropyIz;

ALTER TABLE entropyIz 
ADD COLUMN functional INT;

-- we are going to make the transformation with itself increase entropy, the trade off is the number of rows (**laughs in big data**)
ALTER TABLE entropyIz ADD PRIMARY KEY(num);
ALTER TABLE entropyDer ADD PRIMARY KEY(num);

UPDATE entropyIz t1
INNER JOIN entropyDer t2 ON t1.num = t2.num 
SET t1.functional = t2.target;

CREATE TABLE firstEntropy AS 
SELECT num, 
       target,
        functional,
        (CASE WHEN  target != functional THEN 1 ELSE 0 END) as finalRand
FROM entropyIz;

SELECT * FROM firstEntropy;

SELECT AVG(target)
FROM orderedID;

-- logistic map actualization 2*0.2589*(1-0.2589)=0.3837
SELECT AVG(finalRand)
FROM firstEntropy;

-- drop auxiliary tables and columns
DROP TABLE entropyDer;
DROP TABLE entropyIz;
ALTER TABLE firstEntropy DROP COLUMN target;
ALTER TABLE firstEntropy DROP COLUMN functional;

-- ---------------------------------------- repeat the process to get close to 0.5
SELECT COUNT(*) FROM firstEntropy;
-- aux tables
CREATE TABLE entropyIz AS 
SELECT *
FROM firstEntropy
WHERE num<114728;
CREATE TABLE entropyDer AS 
SELECT *
FROM firstEntropy
WHERE num>=114728;
UPDATE entropyDer 
SET num = num-114728;
ALTER TABLE entropyIz 
ADD COLUMN functional INT;
ALTER TABLE entropyIz ADD PRIMARY KEY(num);
ALTER TABLE entropyDer ADD PRIMARY KEY(num);
UPDATE entropyIz t1
INNER JOIN entropyDer t2 ON t1.num = t2.num 
SET t1.functional = t2.finalRand;
-- create second table
CREATE TABLE secondEntropy AS 
SELECT num, 
       finalRand,
        functional,
        (CASE WHEN  finalRand != functional THEN 1 ELSE 0 END) as finalRand2
FROM entropyIz;
-- check values
SELECT * FROM secondEntropy;
SELECT AVG(finalRand)
FROM firstEntropy;
-- logistic map actualization 2*0.3844*(1-0.3844)=0.4732
SELECT AVG(finalRand2)
FROM secondEntropy;
-- drop auxiliary tables and columns
DROP TABLE entropyDer;
DROP TABLE entropyIz;
ALTER TABLE secondEntropy DROP COLUMN finalRand;
ALTER TABLE secondEntropy DROP COLUMN functional;


-- ----------------------------------------repeat the process to get close to 0.5, values to change= firstEntropy,secondEntropy, number, finalRand, finalRand2
SELECT COUNT(*) FROM secondEntropy;
-- aux tables
CREATE TABLE entropyIz AS 
SELECT *
FROM secondEntropy
WHERE num<57364;
CREATE TABLE entropyDer AS 
SELECT *
FROM secondEntropy
WHERE num>=57364;
UPDATE entropyDer 
SET num = num-57364;
ALTER TABLE entropyIz 
ADD COLUMN functional INT;
ALTER TABLE entropyIz ADD PRIMARY KEY(num);
ALTER TABLE entropyDer ADD PRIMARY KEY(num);
UPDATE entropyIz t1
INNER JOIN entropyDer t2 ON t1.num = t2.num 
SET t1.functional = t2.finalRand2;
-- create second table
CREATE TABLE thirdEntropy AS 
SELECT num, 
       finalRand2,
        functional,
        (CASE WHEN  finalRand2 != functional THEN 1 ELSE 0 END) as finalRand3
FROM entropyIz;
-- check values
SELECT * FROM thirdEntropy;
SELECT AVG(finalRand2)
FROM secondEntropy;
-- logistic map actualization 2*0.4732*(1-0.4732)=0.4985
SELECT AVG(finalRand3)
FROM thirdEntropy;
-- drop auxiliary tables and columns
DROP TABLE entropyDer;
DROP TABLE entropyIz;
ALTER TABLE thirdEntropy DROP COLUMN finalRand2;
ALTER TABLE thirdEntropy DROP COLUMN functional;

-- ----------------------------------------lastone= secondEntropy,thirdEntropy, finalRand2, finalRand3
SELECT COUNT(*) FROM thirdEntropy;
-- aux tables
CREATE TABLE entropyIz AS 
SELECT *
FROM thirdEntropy
WHERE num<28682;
CREATE TABLE entropyDer AS 
SELECT *
FROM thirdEntropy
WHERE num>=28682;
UPDATE entropyDer 
SET num = num-28682;
ALTER TABLE entropyIz 
ADD COLUMN functional INT;
ALTER TABLE entropyIz ADD PRIMARY KEY(num);
ALTER TABLE entropyDer ADD PRIMARY KEY(num);
UPDATE entropyIz t1
INNER JOIN entropyDer t2 ON t1.num = t2.num 
SET t1.functional = t2.finalRand3;
-- create second table
CREATE TABLE fourthEntropy AS 
SELECT num, 
       finalRand3,
        functional,
        (CASE WHEN  finalRand3 != functional THEN 1 ELSE 0 END) as finalRand4
FROM entropyIz;
-- check values
SELECT * FROM fourthEntropy;
SELECT AVG(finalRand3)
FROM thirdEntropy;
-- logistic map actualization 2*0.4985*(1-0.4985)=0.4999
SELECT AVG(finalRand4)
FROM fourthEntropy;
-- drop auxiliary tables and columns
DROP TABLE entropyDer;
DROP TABLE entropyIz;
ALTER TABLE fourthEntropy DROP COLUMN finalRand3;
ALTER TABLE fourthEntropy DROP COLUMN functional;

-- I should try the nist test using only raw data, and its combination with pseudorandom and with 1010101010 pattern
-- logistic map secures exponential convergence, so with sufficient data it should beat any pattern combination in the nist test
-- raw data
SELECT * FROM fourthEntropy;
-- pattern combo test
SELECT num, 
       finalRand4,
        @Functional := (CASE WHEN  num %2 !=0 THEN 0 ELSE 1 END) as secondaryFunction,
        (CASE WHEN  finalRand4 = @Functional THEN 1 ELSE 0 END) as patternCombo
FROM fourthEntropy;
-- resampler


SELECT num, 
       finalRand4,
       @Functional := (CASE WHEN rand()>0.5 THEN 1 ELSE 0 END) as pseudoRand, 
       (CASE WHEN  finalRand4 = @Functional THEN 1 ELSE 0 END) as pseudoCombo
FROM fourthEntropy;

-- we will use a combination with a pseudorand generation with a private key to create a private table
CREATE TABLE privateTable AS 
SELECT num, 
       finalRand4,
       @Functional := (CASE WHEN rand(1523)>0.5 THEN 1 ELSE 0 END) as pseudoRand, 
       (CASE WHEN  finalRand4 = @Functional THEN 1 ELSE 0 END) as pseudoCombo
FROM fourthEntropy;

ALTER TABLE privateTable
DROP COLUMN pseudoRand;

ALTER TABLE privateTable
DROP COLUMN finalRand4;
SELECT * FROM privateTable;

ALTER TABLE privateTable ADD PRIMARY KEY(num);
