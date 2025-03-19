CREATE TABLE netflix
(
    show_id      VARCHAR(6),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(250),
    casts        VARCHAR(1050),
    country      VARCHAR(150),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(350)
);

SELECT COUNT(*) as total_content
FROM netflix;

SELECT DISTINCT type
FROM netflix

--15 business problem from the dataset

--1.count the number of movies VS TVshows
SELECT 
    type,
    COUNT(*) as total_content
FROM netflix
GROUP BY type;

--2.find the most common rating for movies and TVshows
SELECT type, ranking
FROM
(
	SELECT type,rating,
	COUNT (*),
	RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2
) as t1
WHERE ranking=1 

--3.list all movies released in specific year(e.g. 2020)
SELECT * FROM netflix
WHERE
	type = 'Movie'
	and
	release_year = 2020;

--4.find the top 5 countries with most content on netflix
SELECT 
	country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

SELECT
	UNNEST(string_to_array(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--5.identify the longest movie
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)

--6.find content added in last 5 years
SELECT * FROM netflix
WHERE 
	TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

--7.find all the movie/TVshows directed by Rajiv Chilaka
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

--8.list all TV show with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

--9.count the number of content items in each genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT (show_id) as total_content
FROM netflix
GROUP BY 1

--10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as year,
	COUNT (*) as yearly_content,
	ROUND(COUNT (*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100,2)as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

--11.list all the movies that are documentries
SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries';

--12.find all the content without a director
SELECT * 
FROM netflix
WHERE director IS NULL;

--13.Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10

--15. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
WITH new_table
AS
(
SELECT *,
	CASE
	WHEN description ILIKE '%kill%' OR 
		 description ILIKE '%violence%' THEN 'bad_content'
		 ELSE 'good_content'
	END category
FROM netflix
)
SELECT category,
 COUNT(*) as total_content
 FROM new_table
 GROUP BY 1
 

  
