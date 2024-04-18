-- Question Set 1 - Easy
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


-- Question Set 2 – Moderate
-- 1. Write query to return the email, first name, last name of all Rock Music
-- listeners. Return your list ordered alphabetically by email
SELECT DISTINCT
    email,
    first_name,
    last_name
FROM
    customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE
    track_id IN(
    SELECT
        track_id
    FROM
        track
    JOIN genre ON track.genre_id = genre.genre_id
    WHERE
        genre.name LIKE 'Rock'
)
ORDER BY
    email;

-- 2. Let's invite the artists who have written the most rock music in our dataset. Write a
-- query that returns the Artist name and total track count of the top 10 rock bands
SELECT
    a.name,
    COUNT(a.track_id) total_track_id
FROM
    (
    SELECT
        track.track_id,
        artist.name
    FROM
        track
    JOIN genre ON track.genre_id = genre.genre_id
    JOIN album2 ON album2.album_id = track.album_id
    JOIN artist ON artist.artist_id = album2.artist_id
    WHERE
        genre.name LIKE '%Rock%'
) a
GROUP BY
    a.name
ORDER BY
    total_track_id
DESC
LIMIT 10;