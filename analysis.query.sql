-- =========================================================
-- MUSIC STORE ANALYSIS
-- PostgreSQL / pgAdmin SQL Analysis Queries
-- =========================================================


-- 01. View all artists
SELECT *
FROM artist;


-- 02. View all albums
SELECT *
FROM album;


-- 03. Count total artists
SELECT COUNT(*) AS total_artists
FROM artist;


-- 04. Count total albums
SELECT COUNT(*) AS total_albums
FROM album;


-- 05. Count total tracks
SELECT COUNT(*) AS total_tracks
FROM track;


-- 06. List all available genres
SELECT *
FROM genre
ORDER BY name;


-- 07. Find tracks longer than 5 minutes
SELECT
    track_id,
    name,
    milliseconds
FROM track
WHERE milliseconds > 300000
ORDER BY milliseconds DESC;


-- 08. Find the 10 longest tracks
SELECT
    track_id,
    name,
    milliseconds
FROM track
ORDER BY milliseconds DESC
LIMIT 10;


-- 09. Find the 10 shortest tracks
SELECT
    track_id,
    name,
    milliseconds
FROM track
ORDER BY milliseconds
LIMIT 10;


-- 10. Find tracks with price greater than 1
SELECT
    track_id,
    name,
    unit_price
FROM track
WHERE unit_price > 1
ORDER BY unit_price DESC;


-- 11. Show albums with their artists
SELECT
    a.album_id,
    a.title AS album_name,
    ar.name AS artist_name
FROM album AS a
JOIN artist AS ar
    ON a.artist_id = ar.artist_id
ORDER BY ar.name, a.title;


-- 12. Count albums for each artist
SELECT
    ar.artist_id,
    ar.name AS artist_name,
    COUNT(a.album_id) AS album_count
FROM artist AS ar
LEFT JOIN album AS a
    ON ar.artist_id = a.artist_id
GROUP BY ar.artist_id, ar.name
ORDER BY album_count DESC;


-- 13. Find artists having more than 5 albums
SELECT
    ar.name AS artist_name,
    COUNT(a.album_id) AS album_count
FROM artist AS ar
JOIN album AS a
    ON ar.artist_id = a.artist_id
GROUP BY ar.artist_id, ar.name
HAVING COUNT(a.album_id) > 5
ORDER BY album_count DESC;


-- 14. Show tracks with their album names
SELECT
    t.track_id,
    t.name AS track_name,
    a.title AS album_name
FROM track AS t
JOIN album AS a
    ON t.album_id = a.album_id
ORDER BY a.title, t.name;


-- 15. Show tracks with artist and album
SELECT
    t.track_id,
    t.name AS track_name,
    a.title AS album_name,
    ar.name AS artist_name
FROM track AS t
JOIN album AS a
    ON t.album_id = a.album_id
JOIN artist AS ar
    ON a.artist_id = ar.artist_id
ORDER BY ar.name, a.title;


-- 16. Count tracks by genre
SELECT
    g.name AS genre,
    COUNT(t.track_id) AS total_tracks
FROM genre AS g
LEFT JOIN track AS t
    ON g.genre_id = t.genre_id
GROUP BY g.genre_id, g.name
ORDER BY total_tracks DESC;


-- 17. Find the most popular genres by number of tracks
SELECT
    g.name AS genre,
    COUNT(t.track_id) AS track_count
FROM genre AS g
JOIN track AS t
    ON g.genre_id = t.genre_id
GROUP BY g.genre_id, g.name
ORDER BY track_count DESC;


-- 18. Find average track duration by genre
SELECT
    g.name AS genre,
    ROUND((AVG(t.milliseconds) / 60000.0)::numeric, 2)
        AS avg_duration_minutes
FROM genre AS g
JOIN track AS t
    ON g.genre_id = t.genre_id
GROUP BY g.genre_id, g.name
ORDER BY avg_duration_minutes DESC;


-- 19. Find the most expensive tracks
SELECT
    name AS track_name,
    unit_price
FROM track
ORDER BY unit_price DESC
LIMIT 10;


-- 20. Calculate total value of all tracks
SELECT
    ROUND(SUM(unit_price)::numeric, 2) AS total_track_value
FROM track;


-- 21. Show all customers with their countries
SELECT
    customer_id,
    first_name,
    last_name,
    country
FROM customer
ORDER BY country, last_name;


-- 22. Count customers by country
SELECT
    country,
    COUNT(*) AS customer_count
FROM customer
GROUP BY country
ORDER BY customer_count DESC;


-- 23. Find countries with more than 5 customers
SELECT
    country,
    COUNT(*) AS customer_count
FROM customer
GROUP BY country
HAVING COUNT(*) > 5
ORDER BY customer_count DESC;


-- 24. Find total invoices
SELECT COUNT(*) AS total_invoices
FROM invoice;


-- 25. Find total revenue
SELECT
    ROUND(SUM(total)::numeric, 2) AS total_revenue
FROM invoice;


-- 26. Find average invoice value
SELECT
    ROUND(AVG(total)::numeric, 2) AS average_invoice_value
FROM invoice;


-- 27. Find the highest invoice amounts
SELECT
    invoice_id,
    customer_id,
    total
FROM invoice
ORDER BY total DESC
LIMIT 10;


-- 28. Find total spending by each customer
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(i.total)::numeric, 2) AS total_spent
FROM customer AS c
JOIN invoice AS i
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;


-- 29. Find the top 10 customers by spending
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(i.total)::numeric, 2) AS total_spent
FROM customer AS c
JOIN invoice AS i
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;


-- 30. Find average spending per customer
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(AVG(i.total)::numeric, 2) AS average_purchase
FROM customer AS c
JOIN invoice AS i
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY average_purchase DESC;


-- 31. Monthly revenue
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    ROUND(SUM(total)::numeric, 2) AS revenue
FROM invoice
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY month;


-- 32. Yearly revenue
SELECT
    EXTRACT(YEAR FROM invoice_date) AS year,
    ROUND(SUM(total)::numeric, 2) AS revenue
FROM invoice
GROUP BY EXTRACT(YEAR FROM invoice_date)
ORDER BY year;


-- 33. Revenue by country
SELECT
    billing_country AS country,
    ROUND(SUM(total)::numeric, 2) AS revenue
FROM invoice
GROUP BY billing_country
ORDER BY revenue DESC;


-- 34. Top countries by number of invoices
SELECT
    billing_country AS country,
    COUNT(*) AS invoice_count
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;


-- 35. Revenue by customer
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    ROUND(SUM(i.total)::numeric, 2) AS revenue
FROM customer AS c
JOIN invoice AS i
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY revenue DESC;


-- 36. Find the best-selling tracks
SELECT
    t.track_id,
    t.name AS track_name,
    SUM(il.quantity) AS units_sold
FROM track AS t
JOIN invoice_line AS il
    ON t.track_id = il.track_id
GROUP BY t.track_id, t.name
ORDER BY units_sold DESC
LIMIT 10;


-- 37. Calculate revenue generated by each track
SELECT
    t.track_id,
    t.name AS track_name,
    ROUND(SUM(il.quantity * il.unit_price)::numeric, 2)
        AS revenue
FROM track AS t
JOIN invoice_line AS il
    ON t.track_id = il.track_id
GROUP BY t.track_id, t.name
ORDER BY revenue DESC;


-- 38. Revenue by genre
SELECT
    g.name AS genre,
    ROUND(SUM(il.quantity * il.unit_price)::numeric, 2)
        AS revenue
FROM genre AS g
JOIN track AS t
    ON g.genre_id = t.genre_id
JOIN invoice_line AS il
    ON t.track_id = il.track_id
GROUP BY g.genre_id, g.name
ORDER BY revenue DESC;


-- 39. Units sold by genre
SELECT
    g.name AS genre,
    SUM(il.quantity) AS units_sold
FROM genre AS g
JOIN track AS t
    ON g.genre_id = t.genre_id
JOIN invoice_line AS il
    ON t.track_id = il.track_id
GROUP BY g.genre_id, g.name
ORDER BY units_sold DESC;


-- 40. Revenue by artist
SELECT
    ar.name AS artist_name,
    ROUND(SUM(il.quantity * il.unit_price)::numeric, 2)
        AS revenue
FROM artist AS ar
JOIN album AS a
    ON ar.artist_id = a.artist_id
JOIN track AS t
    ON a.album_id = t.album_id
JOIN invoice_line AS il
    ON t.track_id = il.track_id
GROUP BY ar.artist_id, ar.name
ORDER BY revenue DESC;


-- 41. Top 10 artists by revenue
SELECT
    ar.name AS artist_name,
    ROUND(SUM(il.quantity * il.unit_price)::numeric, 2)
        AS revenue
FROM artist AS ar
JOIN album AS a
    ON ar.artist_id = a.artist_id
JOIN track AS t
    ON a.album_id = t.album_id
JOIN invoice_line AS il
    ON t.track_id = il.track_id
GROUP BY ar.artist_id, ar.name
ORDER BY revenue DESC
LIMIT 10;


-- 42. Top 10 albums by revenue
SELECT
    a.title AS album_name,
    ROUND(SUM(il.quantity * il.unit_price)::numeric, 2)
        AS revenue
FROM album AS a
JOIN track AS t
    ON a.album_id = t.album_id
JOIN invoice_line AS il
    ON t.track_id = il.track_id
GROUP BY a.album_id, a.title
ORDER BY revenue DESC
LIMIT 10;


-- 43. Find customers who spent more than average
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_spent
    FROM customer AS c
    JOIN invoice AS i
        ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    first_name,
    last_name,
    ROUND(total_spent::numeric, 2) AS total_spent
FROM customer_spending
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM customer_spending
)
ORDER BY total_spent DESC;


-- 44. Rank customers based on total spending
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_spent
    FROM customer AS c
    JOIN invoice AS i
        ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    first_name,
    last_name,
    ROUND(total_spent::numeric, 2) AS total_spent,
    RANK() OVER (
        ORDER BY total_spent DESC
    ) AS spending_rank
FROM customer_spending
ORDER BY spending_rank;


-- 45. Rank genres by revenue
WITH genre_sales AS (
    SELECT
        g.name AS genre,
        SUM(il.quantity * il.unit_price) AS revenue
    FROM genre AS g
    JOIN track AS t
        ON g.genre_id = t.genre_id
    JOIN invoice_line AS il
        ON t.track_id = il.track_id
    GROUP BY g.genre_id, g.name
)
SELECT
    genre,
    ROUND(revenue::numeric, 2) AS revenue,
    RANK() OVER (
        ORDER BY revenue DESC
    ) AS genre_rank
FROM genre_sales
ORDER BY genre_rank;


-- 46. Find the highest-selling track for each genre
WITH track_sales AS (
    SELECT
        g.name AS genre,
        t.name AS track_name,
        SUM(il.quantity) AS units_sold
    FROM genre AS g
    JOIN track AS t
        ON g.genre_id = t.genre_id
    JOIN invoice_line AS il
        ON t.track_id = il.track_id
    GROUP BY g.name, t.track_id, t.name
),
ranked_tracks AS (
    SELECT
        genre,
        track_name,
        units_sold,
        ROW_NUMBER() OVER (
            PARTITION BY genre
            ORDER BY units_sold DESC
        ) AS rn
    FROM track_sales
)
SELECT
    genre,
    track_name,
    units_sold
FROM ranked_tracks
WHERE rn = 1
ORDER BY genre;


-- 47. Find customers with more than 5 purchases
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(i.invoice_id) AS purchase_count
FROM customer AS c
JOIN invoice AS i
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(i.invoice_id) > 5
ORDER BY purchase_count DESC;


-- 48. Find the most purchased media types
SELECT
    m.name AS media_type,
    SUM(il.quantity) AS units_sold
FROM media_type AS m
JOIN track AS t
    ON m.media_type_id = t.media_type_id
JOIN invoice_line AS il
    ON t.track_id = il.track_id
GROUP BY m.media_type_id, m.name
ORDER BY units_sold DESC;


-- 49. Find playlists and number of tracks in each
SELECT
    p.playlist_id,
    p.name AS playlist_name,
    COUNT(pt.track_id) AS track_count
FROM playlist AS p
LEFT JOIN playlist_track AS pt
    ON p.playlist_id = pt.playlist_id
GROUP BY p.playlist_id, p.name
ORDER BY track_count DESC;


-- 50. Overall business summary
SELECT
    (SELECT COUNT(*) FROM customer) AS total_customers,
    (SELECT COUNT(*) FROM artist) AS total_artists,
    (SELECT COUNT(*) FROM album) AS total_albums,
    (SELECT COUNT(*) FROM track) AS total_tracks,
    (SELECT COUNT(*) FROM invoice) AS total_invoices,
    ROUND(
        (SELECT SUM(total) FROM invoice)::numeric,
        2
    ) AS total_revenue;