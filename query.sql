-- 1. Qui est l'employé le plus ancien (niveau le plus élevé) en fonction du titre de poste ?
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

-- 2. Quels pays ont le plus grand nombre de factures ?
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

-- 3. Quelles sont les 3 valeurs les plus élevées du total des factures ?
SELECT DISTINCT
    total
FROM
    invoices
ORDER BY
    total
DESC
LIMIT 3;

-- 4. Quelle ville a les meilleurs clients ?
-- Nous aimerions organiser un festival de musique promotionnel dans la ville où 
-- nous avons généré le plus de revenus. 
-- Écrivez une requête qui renvoie une seule ville ayant la somme la plus élevée de tous les totaux des factures. 
-- Renvoyez à la fois le nom de la ville et la somme de tous les totaux des factures.
SELECT
    billing_city,
    SUM(total) invoice_total
FROM
    invoices
GROUP BY
    billing_city
ORDER BY
    invoice_total
DESC
LIMIT 1;

-- 5. Qui est le meilleur client ? 
-- Le client qui a dépensé le plus d'argent sera déclaré meilleur client. 
-- Écrivez une requête qui renvoie la personne qui a dépensé le plus d'argent.
SELECT
    c.customer_id,
    SUM(total) AS total_spent,
    CONCAT(
        MIN(c.first_name),
        ' ',
        MIN(c.last_name)
    ) AS customer_name
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


-- Question Set 2 – Moderate
-- 1. Write query to return the email, first name, last name of all Rock Music
-- listeners. Return your list ordered alphabetically by email
SELECT DISTINCT
    customer.email,
    customer.first_name,
    customer.last_name
FROM
    customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE
    genre.name LIKE 'Rock%'
ORDER BY
    customer.email;

-- 2. Let's invite the artists who have written the most rock music in our dataset. Write a
-- query that returns the Artist name and total track count of the top 10 rock bands
SELECT
    artist.name,
    COUNT(track.track_id) total_track_id
FROM
    track
JOIN genre ON track.genre_id = genre.genre_id
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON artist.artist_id = album2.artist_id
WHERE
    genre.name LIKE 'Rock%'
GROUP BY
    artist.name
ORDER BY
    total_track_id
DESC
LIMIT 10;

-- 3. Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length with the
-- longest songs listed first
-- method 1
SELECT
    track.name,
    track.milliseconds
FROM
    track
JOIN(
    SELECT
        AVG(milliseconds) avg_milliseconds
    FROM
        track
) avg_track
WHERE
    track.milliseconds >= avg_track.avg_milliseconds
ORDER BY
    track.milliseconds
DESC;
-- method 2
SELECT
    track.name,
    track.milliseconds
FROM
    track
WHERE
    track.milliseconds >(
    SELECT
        AVG(track.milliseconds) avg_track_length
    FROM
        track
)
ORDER BY
    track.milliseconds
DESC;


-- 1. Find how much amount spent by each customer on artists? Write a query to return
-- customer name, artist name and total spent
SELECT
    customer.last_name,
    artist.name,
    SUM(invoice.total) total_spent
FROM
    invoice
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON album2.artist_id = artist.artist_id
GROUP BY
    customer.last_name,
    artist.name;