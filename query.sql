-- 1. Who is the oldest employee (highest level) based on job title?
SELECT
    title,
    last_name,
    first_name
FROM
    employees
ORDER BY
    levels
DESC
LIMIT 1;

-- 2. Which countries have the highest number of invoices?
SELECT
    billing_country,
    COUNT(*) nb_invoices
FROM
    invoices
GROUP BY
    billing_country
ORDER BY
    nb_invoices
DESC;

-- 3. What are the top 3 highest values of total invoices?
SELECT DISTINCT
    total
FROM
    invoices
ORDER BY
    total
DESC
LIMIT 3;

-- 4. Which city has the best customers?
-- We would like to organize a promotional music festival in the city where we generated the most revenue. 
-- Write a query that returns a single city having the highest sum of all invoice totals. 
-- Return both the city name and the sum of all invoice totals.
SELECT
    billing_city,
    SUM(total) invoices_total
FROM
    invoices
GROUP BY
    billing_city
ORDER BY
    invoices_total
DESC
LIMIT 1;

-- 5. Who is the top customer?
-- The customer who spent the most money will be declared the top customer. 
-- Write a query that returns the person who spent the most money.
SELECT
    c.customer_id,
    SUM(total) AS total_spent,
    CONCAT(
        MIN(c.first_name),
        ' ',
        MIN(c.last_name)
    ) AS customer
FROM
    customers c
JOIN invoices i ON
    c.customer_id = i.customer_id
GROUP BY
    c.customer_id
ORDER BY
    total_spent
DESC
LIMIT 1;


-- 6. Write a query to return the email, first name, last name of all rock music listeners. 
-- Return your list ordered alphabetically by email.
SELECT DISTINCT
    c.email,
    c.first_name,
    c.last_name
FROM
    customers c
JOIN invoices i ON
    c.customer_id = i.customer_id
JOIN invoice_lines il ON
    i.invoice_id = il.invoice_id
JOIN tracks t ON
    il.track_id = t.track_id
JOIN genres g ON
    t.genre_id = g.genre_id
WHERE
    g.name LIKE 'Rock%'
ORDER BY
    c.email;

-- 7. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the artist name and total track count of the top 10 rock artists.
SELECT
    artists.name artist_name,
    COUNT(tracks.track_id) total_tracks
FROM
    tracks
JOIN genres ON tracks.genre_id = genres.genre_id
JOIN albums ON albums.album_id = tracks.album_id
JOIN artists ON artists.artist_id = albums.artist_id
WHERE
    genres.name LIKE 'Rock%'
GROUP BY
    artists.name
ORDER BY
    total_tracks
DESC
LIMIT 10;

-- 8. Return all the track names that have a song length longer than the average song length. 
-- Return the name and milliseconds for each track. 
-- Order by the song length with the longest songs listed first.
-- method 1
SELECT
    tracks.name,
    tracks.milliseconds
FROM
    tracks
JOIN(
    SELECT
        AVG(milliseconds) avg_milliseconds
    FROM
        tracks
) avg_track
WHERE
    tracks.milliseconds >= avg_track.avg_milliseconds
ORDER BY
    tracks.milliseconds
DESC;
-- method 2
SELECT
    tracks.name,
    tracks.milliseconds
FROM
    tracks
WHERE
    tracks.milliseconds >(
    SELECT
        AVG(tracks.milliseconds) avg_track_length
    FROM
        tracks
)
ORDER BY
    tracks.milliseconds
DESC;

-- 9. Find how much amount spent by each customer on artists? 
-- Write a query to return customer name, artist name, and total spent.
SELECT
    CONCAT(
        MIN(c.first_name),
        ' ',
        MIN(c.last_name)
    ) AS customer_name,
    MIN(ar.name) AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM
    invoice_lines il
JOIN invoices i ON
    i.invoice_id = il.invoice_id
JOIN customers c ON
    c.customer_id = i.customer_id
JOIN tracks t ON
    il.track_id = t.track_id
JOIN albums al ON
    al.album_id = t.album_id
JOIN artists ar ON
    al.artist_id = ar.artist_id
GROUP BY
    c.customer_id,
    ar.artist_id;

-- 10. We want to find out the most popular music genre for each country. 
-- We define the most popular genre as the genre with the highest number of track purchases.
-- Write a query that returns each country along with the top genre. 
-- For countries where the maximum number of purchases is shared, return all genres.
SELECT
    a.country,
    genre_name,
    nb_purchases
FROM
    (
    SELECT
        i.billing_country AS country,
        MIN(g.name) AS genre_name,
        COUNT(t.track_id) AS nb_purchases
    FROM
        invoice_lines il
    JOIN invoices i ON
        i.invoice_id = il.invoice_id
    JOIN tracks t ON
        t.track_id = il.track_id
    JOIN genres g ON
        g.genre_id = t.genre_id
    GROUP BY
        i.billing_country,
        g.genre_id
) a
JOIN(
    SELECT
        sub.country AS country,
        MAX(nb_purchases) AS max_nb_purchases
    FROM
        (
        SELECT
            i.billing_country AS country,
            COUNT(t.track_id) AS nb_purchases
        FROM
            invoice_lines il
        JOIN invoices i ON
            i.invoice_id = il.invoice_id
        JOIN tracks t ON
            t.track_id = il.track_id
        GROUP BY
            i.billing_country,
            t.genre_id
    ) sub
GROUP BY
    country
) b
ON
    a.country = b.country AND a.nb_purchases = b.max_nb_purchases
ORDER BY
    a.country,
    nb_purchases
DESC;