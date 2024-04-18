-- 1. Who is the senior most employee based on job title?
SELECT
    title,
    last_name,
    first_name
FROM
    employee
ORDER BY
    levels
DESC
LIMIT 1;

-- 2. Which countries have the most Invoices?
SELECT
    billing_country,
    COUNT(*) nb_invoices
FROM
    invoice
GROUP BY
    billing_country
ORDER BY
    nb_invoices
DESC;

-- 3. What are top 3 values of total invoice?
SELECT
    total
FROM
    invoice
GROUP BY
    total
ORDER BY
    total
DESC
LIMIT 3;

-- 4. Which city has the best customers? 
-- We would like to throw a promotional Music 
-- Festival in the city we made the most money. Write a query that returns one city that
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice
-- totals
SELECT
    billing_city,
    SUM(total) invoice_total
FROM
    invoice
GROUP BY
    billing_city
ORDER BY
    invoice_total
DESC
LIMIT 1;

-- 5. Who is the best customer? The customer who has spent the most money will be
-- declared the best customer. Write a query that returns the person who has spent the
-- most money
SELECT
    c.customer_id,
    SUM(total) money_spent,
    MIN(c.first_name),
    MIN(c.last_name)
FROM
    customer c
JOIN invoice i ON
    c.customer_id = i.customer_id
GROUP BY
    c.customer_id
ORDER BY
    money_spent
DESC
LIMIT 1;
