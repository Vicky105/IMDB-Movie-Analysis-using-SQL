-- 1. DATA CLEANING AND FORMATTING

-- (i) Changing the datatype of the columns:

ALTER TABLE movies
ALTER COLUMN original_title VARCHAR(100);

ALTER TABLE movies
ALTER COLUMN title VARCHAR(100);

ALTER TABLE movies
ALTER COLUMN tagline VARCHAR(300);

ALTER TABLE movies
ALTER COLUMN overview VARCHAR(MAX);

ALTER TABLE movies
ALTER COLUMN release_date DATE;

ALTER TABLE directors
ALTER COLUMN name VARCHAR(40);

ALTER TABLE movies
ALTER COLUMN revenue FLOAT;

--(ii) Dropping a Column

ALTER TABLE directors
DROP COLUMN department;



-- 2. DATA EXPLORATION and DATA ANALYSIS

-- (i) Trend in the number of movies released per DECADE

SELECT 
    Decade, 
    COUNT(Decade) AS No_of_Movies 
FROM (
    SELECT release_date,
    CASE 
        WHEN release_date BETWEEN '1911-01-01' AND '1920-12-31' THEN '1910s' 
        WHEN release_date BETWEEN '1921-01-01' AND '1930-12-31' THEN '1920s'
        WHEN release_date BETWEEN '1931-01-01' AND '1940-12-31' THEN '1930s'
        WHEN release_date BETWEEN '1941-01-01' AND '1950-12-31' THEN '1940s'
        WHEN release_date BETWEEN '1951-01-01' AND '1960-12-31' THEN '1950s'
        WHEN release_date BETWEEN '1961-01-01' AND '1970-12-31' THEN '1960s'
        WHEN release_date BETWEEN '1971-01-01' AND '1980-12-31' THEN '1970s'
        WHEN release_date BETWEEN '1981-01-01' AND '1990-12-31' THEN '1980s'
        WHEN release_date BETWEEN '1991-01-01' AND '2000-12-31' THEN '1990s'
        WHEN release_date BETWEEN '2001-01-01' AND '2010-12-31' THEN '2000s'
        WHEN release_date BETWEEN '2011-01-01' AND '2020-12-31' THEN '2010s (upto 2017)'
        ELSE 'Unknown'
    END AS Decade
    FROM movies
) AS DECADE_QUERY
GROUP BY Decade
ORDER BY Decade;

-- (ii) Trend in the Number of movies released in each Month

SELECT 
    DATENAME(MONTH, release_date) AS MONTH, 
    MONTH(release_date) AS Month_no, 
    COUNT(release_date) AS No_of_Movies 
FROM movies
GROUP BY DATENAME(MONTH, release_date), MONTH(release_date)
ORDER BY Month_no;

-- (iii) Trend in the Number of movies released by Date

SELECT 
    DAY(release_date) AS DATE, 
    COUNT(release_date) AS No_of_Movies 
FROM movies
GROUP BY DAY(release_date)
ORDER BY DAY(release_date);

-- (iv) Year with the most number of movies released

SELECT 
    TOP 1 YEAR(release_date) AS Year, 
    COUNT(release_date) AS No_of_Movies 
FROM movies
GROUP BY YEAR(release_date)
ORDER BY No_of_Movies DESC;

-- (OR)

SELECT YEAR, Movie_Count 
FROM (
    SELECT 
        YEAR(release_date) AS YEAR, 
        COUNT(release_date) AS Movie_Count, 
        RANK() OVER(ORDER BY COUNT(release_date) DESC) AS rnk 
    FROM movies
    GROUP BY YEAR(release_date)
) AS Release_Count
WHERE rnk = 1;

-- (v) Director name, rating, and vote_count of the top 3 movies which collected the most revenue

SELECT 
    title, 
    name, 
    revenue, 
    vote_average, 
    vote_count 
FROM (
    SELECT 
        title, 
        name, 
        revenue, 
        vote_average, 
        vote_count, 
        RANK() OVER(ORDER BY revenue DESC) AS rnk 
    FROM movies m 
    JOIN directors d ON m.director_id = d.id
) AS Subquery
WHERE rnk <= 3;

-- (vi) Budget of the movie impact on profit %

SELECT 
    TOP 30 
    title, 
    budget, 
    revenue, 
    ROUND((revenue - budget) * 100 / budget, 2) AS profit_percent 
FROM movies
WHERE budget <> 0 AND revenue <> 0
ORDER BY budget DESC;

-- (vii) Number of male and female directors and average revenue collected by their movies

SELECT 
    CASE 
        WHEN gender = 1 THEN 'Female'
        WHEN gender = 2 THEN 'Male' 
    END AS 'Gender',
    COUNT(gender) AS Count,
    AVG(revenue) AS Revenue_Avg
FROM directors d 
JOIN movies m ON m.director_id = d.id
WHERE gender <> 0
GROUP BY gender;

-- (viii) Top 3 loss-making films and the directors of that film with respect to movie budget

WITH cte AS (
    SELECT 
        title, 
        name, 
        budget, 
        revenue, 
        (budget - revenue) AS Loss, 
        RANK() OVER(ORDER BY (budget - revenue) DESC) AS rnk
    FROM movies m 
    JOIN directors d ON m.director_id = d.id
    WHERE budget > revenue AND revenue <> 0
)
SELECT 
    title, 
    name, 
    budget, 
    revenue, 
    loss 
FROM cte
WHERE rnk <= 3;

-- (ix) How the genre of a movie affects the rating of the movie

SELECT 
    genre,
    ROUND(AVG(vote_average), 2) AS Rating, 
    RANK() OVER(ORDER BY ROUND(AVG(vote_average), 2) DESC) AS Rating_rank
FROM movie_genre_view
WHERE genre <> 'Others'
GROUP BY genre;

-- (x) How the genre of a movie affects the revenue of the movie

SELECT 
    genre,
    ROUND(AVG(revenue), 0) AS Rating, 
    RANK() OVER(ORDER BY ROUND(AVG(revenue), 0) DESC) AS Rating_rank
FROM movie_genre_view
WHERE genre <> 'Others'
GROUP BY genre;

-- (xi) Create a view by categorizing the genre of the movies based on keywords

CREATE VIEW movie_genre_view AS
SELECT *, 
       CASE
           WHEN overview LIKE '%alien%' OR overview LIKE '%space%' OR overview LIKE '%future%' OR overview LIKE '%technology%' 
               OR overview LIKE '%robot%' OR overview LIKE '%sci-fi%' OR overview LIKE '%time%' OR overview LIKE '%Avenger%' 
               OR overview LIKE '%super hero%' OR overview LIKE '%powers%' OR overview LIKE '%disaster%' OR overview LIKE '%giant%' 
               OR overview LIKE '%virus%' OR overview LIKE '%toy%' OR overview LIKE '%plague%' OR title LIKE '%man%' OR title LIKE '%men%' 
               OR overview LIKE '%universe%' THEN 'Sci-Fi'
           WHEN overview LIKE '%horror%' OR overview LIKE '%ghost%' OR overview LIKE '%scary%' OR overview LIKE '%terror%' 
               OR overview LIKE '%supernatural%' OR overview LIKE '%fright%' OR overview LIKE '%creepy%' OR overview LIKE '%haunt%' 
               OR overview LIKE '%monster%' OR overview LIKE '%died%' OR overview LIKE '%blood%' OR overview LIKE '%fear%' 
               OR overview LIKE '%zombie%' OR overview LIKE '%scream%' OR overview LIKE '%evil%' OR overview LIKE '%curse%' 
               OR overview LIKE '%murder%' OR overview LIKE '%nightmare%' OR overview LIKE '%creature%' OR overview LIKE '%paranormal%' THEN 'Horror'
           WHEN overview LIKE '%fun%' OR overview LIKE '%comedy%' OR overview LIKE '%humor%' OR overview LIKE '%laugh%' 
               OR overview LIKE '%hilarious%' OR overview LIKE '%satire%' OR overview LIKE '%parody%' OR overview LIKE '%joke%' 
               OR overview LIKE '%entertainment%' OR overview LIKE '%prank%' OR overview LIKE '%clown%' OR overview LIKE '%comic%' 
               OR overview LIKE '%light-hearted%' OR overview LIKE '%witty%' OR overview LIKE '%slapstick%' OR overview LIKE '%romantic comedy%' 
               OR overview LIKE '%farce%' THEN 'Comedy'
           WHEN overview LIKE '%romance%' OR overview LIKE '%love%' OR overview LIKE '%romantic%' OR overview LIKE '%relationship%' 
               OR overview LIKE '%affair%' OR overview LIKE '%heart%' OR overview LIKE '%passion%' OR overview LIKE '%dating%' 
               OR overview LIKE '%marriage%' OR overview LIKE '%kiss%' OR title LIKE '%love%' OR overview LIKE '%boy friend%' 
               OR overview LIKE '%boy-friend%' OR overview LIKE '%wedding%' THEN 'Love'
           WHEN overview LIKE '%thriller%' OR overview LIKE '%suspense%' OR overview LIKE '%myster%' OR overview LIKE '%dead%' 
               OR overview LIKE '%crime%' OR overview LIKE '%psychological%' OR overview LIKE '%investigate%' OR overview LIKE '%twist%' 
               OR overview LIKE '%chase%' OR overview LIKE '%animal%' OR overview LIKE '%terrible%' OR overview LIKE '%kill%' THEN 'Thriller'
           WHEN overview LIKE '%action%' OR overview LIKE '%adventure%' OR overview LIKE '%battle%' OR overview LIKE '%fight%' 
               OR overview LIKE '%explosion%' OR overview LIKE '%war%' OR overview LIKE '%hero%' OR overview LIKE '%rescue%' 
               OR overview LIKE '%combat%' OR overview LIKE '%race%' OR overview LIKE '%chase%' OR overview LIKE '%attack%' THEN 'Action'
           WHEN overview LIKE '%animation%' OR overview LIKE '%cartoon%' OR overview LIKE '%anime%' OR overview LIKE '%CGI%' 
               OR overview LIKE '%stop-motion%' OR overview LIKE '%puppet%' OR overview LIKE '%animated%' THEN 'Animation'
           WHEN overview LIKE '%documentary%' OR overview LIKE '%non-fiction%' OR overview LIKE '%true story%' OR overview LIKE '%biography%' 
               OR overview LIKE '%docudrama%' OR overview LIKE '%real life%' OR overview LIKE '%history%' OR overview LIKE '%fact%' 
               OR overview LIKE '%true crime%' OR overview LIKE '%nature%' THEN 'Documentary'
           ELSE 'Others'
       END AS Genre
FROM movies;

-- (xii) - To find the names, revenue, and directors of all the movies in the Marvel Cinematic Universe (MCU) and display each movie's revenue as a percentage of the total revenue of all MCU movies

SELECT 
    title AS Movie_Name,
    revenue AS Box_office, 
    name AS Director_name, 
    ROUND((revenue)*100/SUM(revenue) OVER(), 2) AS Percentage_revenue 
FROM movies m 
JOIN directors d ON m.director_id = d.id
WHERE 
    title LIKE '%iron man%' 
    OR title LIKE '%hulk%' 
    OR title LIKE '%avengers%' 
    OR title LIKE 'thor%' 
    OR title LIKE '%captain america%' 
    OR title LIKE '%guardians of the galaxy%' 
    OR title LIKE '%ant-man%' 
    OR title LIKE '%black panther%' 
    OR title LIKE '%spider-man%' 
    OR title LIKE '%captain marvel%'
ORDER BY revenue DESC;

-- (xiii) - Find top movies and respective directors of each decade

WITH cte AS (
    SELECT 
        title, 
        decade, 
        revenue,
        director_id,
        vote_average, 
        RANK() OVER(PARTITION BY decade ORDER BY revenue DESC) AS rnk
    FROM (
        SELECT *,
            CASE 
                WHEN release_date BETWEEN '1911-01-01' AND '1920-12-31' THEN '1910s' 
                WHEN release_date BETWEEN '1921-01-01' AND '1930-12-31' THEN '1920s'
                WHEN release_date BETWEEN '1931-01-01' AND '1940-12-31' THEN '1930s'
                WHEN release_date BETWEEN '1941-01-01' AND '1950-12-31' THEN '1940s'
                WHEN release_date BETWEEN '1951-01-01' AND '1960-12-31' THEN '1950s'
                WHEN release_date BETWEEN '1961-01-01' AND '1970-12-31' THEN '1960s'
                WHEN release_date BETWEEN '1971-01-01' AND '1980-12-31' THEN '1970s'
                WHEN release_date BETWEEN '1981-01-01' AND '1990-12-31' THEN '1980s'
                WHEN release_date BETWEEN '1991-01-01' AND '2000-12-31' THEN '1990s'
                WHEN release_date BETWEEN '2001-01-01' AND '2010-12-31' THEN '2000s'
                WHEN release_date BETWEEN '2011-01-01' AND '2020-12-31' THEN '2010s (upto 2017)'
                ELSE 'Unknown'
            END AS Decade
        FROM movies
    ) AS DECADE_QUERY
)
SELECT 
    title AS Movie_Name,
    name AS Director_Name,
    Decade,
    revenue AS Box_Office,
    vote_average AS Rating
FROM cte 
JOIN directors d ON cte.director_id = d.id
WHERE rnk = 1;

-- (xiv) - Write a stored procedure, if movie name was given as input it should display the details of the movie like title, director, budget, revenue, rating and overview

ALTER PROCEDURE movie_details (@title VARCHAR(50))
AS
BEGIN
    SELECT 
        title AS Movie_name,
        name AS Director_name,
        (revenue - budget) AS profit_or_loss, 
        vote_average AS Rating, 
        overview AS Movie_Description
    FROM movies m 
    JOIN directors d ON m.director_id = d.id
    WHERE 
        title LIKE '%' + @title + '%' 
        AND budget <> 0 
        AND revenue <> 0;
END

EXEC movie_details 'avenger';
