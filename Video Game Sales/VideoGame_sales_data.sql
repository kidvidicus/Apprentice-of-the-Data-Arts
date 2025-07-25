--- Getting acquanted with the data
```
SELECT * FROM videogame_sales.unit_sales as vgsales

-- Grouping the sales by genre and platform
```
SELECT
    genre,
    platform,
    COUNT(*) AS num_games,
    SUM(na_sales) AS total_na_sales,
    SUM(eu_sales) AS total_eu_sales,
    SUM(jp_sales) AS total_jp_sales,
    SUM(other_sales) AS total_other_sales,
    SUM(global_sales) AS total_global_sales
FROM
    videogame_sales.unit_sales as vgsales
GROUP BY
    genre, platform
ORDER BY
    total_global_sales DESC;
```

--Grouping by decade across regions starting with 1990

SELECT
    (year / 10) * 10 AS decade,
    genre,
    platform,
    COUNT(*) AS num_games,
    SUM(na_sales) AS total_na_sales,
    SUM(eu_sales) AS total_eu_sales,
    SUM(jp_sales) AS total_jp_sales,
    SUM(other_sales) AS total_other_sales,
    SUM(global_sales) AS total_global_sales
FROM
    videogame_sales.unit_sales as vgsales
WHERE
    year >= 1990
GROUP BY
    decade, genre, platform
ORDER BY
    decade, total_global_sales DESC;

-- Needed a count of relevant platforms to omit some data points that may be irrevelent leading up to the end of the year 2020
SELECT
    platform,
    COUNT(*) AS num_games
FROM
    videogame_sales.unit_sales
GROUP BY
    platform
ORDER BY
    num_games DESC;


-- Omitting the platforms with low-volume unit sales

SELECT
    genre,
    platform,
    COUNT(*) AS num_games,
    SUM(na_sales) AS total_na_sales,
    SUM(eu_sales) AS total_eu_sales,
    SUM(jp_sales) AS total_jp_sales,
    SUM(other_sales) AS total_other_sales,
    SUM(global_sales) AS total_global_sales
FROM
    videogame_sales.unit_sales
WHERE
    platform NOT IN ('PCFX', 'GG', 'TG-16', '3DO', 'SCD', 'WS', 'NG', '2600')
GROUP BY
    genre, platform
ORDER BY
    genre, total_global_sales DESC;



--Group genre and platform by decade starting from 1990. Omitting low-volume platforms and summarizing sales.
--Decades are depicted by their starting year ie. 1990-1999 is donated as decade -> 1990. 

SELECT

    (year / 10) * 10 AS decade,
    genre,
    platform,
    COUNT(*) AS num_games,
    SUM(na_sales) AS total_na_sales,
    SUM(eu_sales) AS total_eu_sales,
    SUM(jp_sales) AS total_jp_sales,
    SUM(other_sales) AS total_other_sales,
    SUM(global_sales) AS total_global_sales
FROM
    videogame_sales.unit_sales
WHERE
    year >= 1990
    AND platform NOT IN ('PCFX', 'GG', 'TG-16', '3DO', 'SCD', 'WS', 'NG', '2600')
GROUP BY
    decade, genre, platform
ORDER BY
    decade ASC,
    total_global_sales DESC;


-- Sales by genre and platform broken down by region. 

SELECT
    genre,
    platform,
    COUNT(*) AS num_games,
    SUM(na_sales) AS total_na_sales,
    SUM(eu_sales) AS total_eu_sales,
    SUM(jp_sales) AS total_jp_sales,
    SUM(other_sales) AS total_other_sales,
    SUM(global_sales) AS total_global_sales
FROM
    videogame_sales.unit_sales
WHERE
    platform NOT IN ('PCFX', 'GG', 'TG-16', '3DO', 'SCD', 'WS', 'NG', '2600')
GROUP BY
    genre, platform
ORDER BY
    total_global_sales DESC;
	

-- Looking at the percentage of each genre's global sales relative to the total global sales for its respective platform.

SELECT
    genre,
    platform,
    SUM(global_sales) AS genre_sales,
    ROUND(
        SUM(global_sales) * 100.0 /
        SUM(SUM(global_sales)) OVER (PARTITION BY platform),
		2
    ) AS genre_pct_of_platform_sales
FROM
    videogame_sales.unit_sales
WHERE
    platform NOT IN ('PCFX', 'GG', 'TG-16', '3DO', 'SCD', 'WS', 'NG', '2600')
GROUP BY
    genre, platform
ORDER BY
    platform, genre_pct_of_platform_sales DESC;
	

-- Percentage of each genre by decade relative to each platform globally

SELECT
    (year / 10) * 10 AS decade,
    genre,
    platform,
    SUM(global_sales) AS genre_sales,
    ROUND(
        SUM(global_sales) * 100.0 /
        SUM(SUM(global_sales)) OVER (PARTITION BY (year / 10) * 10, platform),
        2
    ) AS genre_pct_of_platform_sales_global
FROM
     videogame_sales.unit_sales
WHERE
    year >= 1990
    AND platform NOT IN ('PCFX', 'GG', 'TG-16', '3DO', 'SCD', 'WS', 'NG', '2600')
GROUP BY
    (year / 10) * 10, genre, platform
ORDER BY
    decade, platform, genre_pct_of_platform_sales_global DESC;



-- Percentage of Sales for each platform narrowed down by region

SELECT
    (year / 10) * 10 AS decade,
    genre,
    platform,
    SUM(na_sales) AS genre_na_sales,
    SUM(eu_sales) AS genre_eu_sales,
    SUM(jp_sales) AS genre_jp_sales,
    SUM(other_sales) AS genre_other_sales,

    ROUND(
        SUM(na_sales) * 100.0 /
        NULLIF(SUM(SUM(na_sales)) OVER (PARTITION BY (year / 10) * 10, platform), 0),
        2
    ) AS pct_na_sales,

    ROUND(
        SUM(eu_sales) * 100.0 /
        NULLIF(SUM(SUM(eu_sales)) OVER (PARTITION BY (year / 10) * 10, platform), 0),
        2
    ) AS pct_eu_sales,

    ROUND(
        SUM(jp_sales) * 100.0 /
        NULLIF(SUM(SUM(jp_sales)) OVER (PARTITION BY (year / 10) * 10, platform), 0),
        2
    ) AS pct_jp_sales,

    ROUND(
        SUM(other_sales) * 100.0 /
        NULLIF(SUM(SUM(other_sales)) OVER (PARTITION BY (year / 10) * 10, platform), 0),
        2
    ) AS pct_other_sales

FROM
    videogame_sales.unit_sales
WHERE
    year >= 1990
    AND platform NOT IN ('PCFX', 'GG', 'TG-16', '3DO', 'SCD', 'WS', 'NG', '2600')
GROUP BY
    (year / 10) * 10, genre, platform
ORDER BY
    decade, platform, pct_na_sales DESC;



-- Finding games that have at least one sequel
-- I sought outside help with these remaining queiries
-- I wanted to find the games with sequels so I could explore trends between original titles and their sequels


WITH cleaned_titles AS (
  SELECT
    name,
-- Remove any trailing number (e.g., "Game 2" -> "Game")
    regexp_replace(name, '\s*\d+$', '') AS base_name,
    
-- Detect if the name ends with a number -> it's a sequel
    CASE 
      WHEN name ~ '\d+$' THEN 'sequel'
      ELSE 'original'
    END AS title_type
  FROM videogame_sales.unit_sales
),

originals AS (
  SELECT * FROM cleaned_titles WHERE title_type = 'original'
),

sequels AS (
  SELECT * FROM cleaned_titles WHERE title_type = 'sequel'
)

SELECT
  o.name AS original_game,
  s.name AS sequel_game,
  o.base_name
FROM originals o
JOIN sequels s
  ON o.base_name = s.base_name
ORDER BY o.name, s.name;


-- Sales comparisons of sequels versus original games
WITH cleaned_titles AS (
  SELECT
    name,
    regexp_replace(name, '\s*\d+$', '') AS base_name,
    CASE 
      WHEN name ~ '\d+$' THEN 'sequel'
      ELSE 'original'
    END AS title_type,
    global_sales
  FROM videogame_sales.unit_sales
),

originals AS (
  SELECT * FROM cleaned_titles WHERE title_type = 'original'
),

sequels AS (
  SELECT * FROM cleaned_titles WHERE title_type = 'sequel'
)

SELECT
  o.base_name,
  o.name AS original_game,
  o.global_sales AS original_sales,
  s.name AS sequel_game,
  s.global_sales AS sequel_sales,
  ROUND(s.global_sales - o.global_sales, 2) AS sales_difference,
  ROUND((s.global_sales - o.global_sales) / NULLIF(o.global_sales, 0) * 100, 2) AS pct_change
FROM originals o
JOIN sequels s
  ON o.base_name = s.base_name
ORDER BY o.name, s.name;

-- Sales comparisons of sequels by platform to original titles. base_name replaced as franchise_name
WITH cleaned_titles AS (
  SELECT
    name,
    regexp_replace(name, '\s*\d+$', '') AS base_name,
    CASE 
      WHEN name ~ '\d+$' THEN 'sequel'
      ELSE 'original'
    END AS title_type,
    global_sales,
    year as release_year,
	platform
  FROM videogame_sales.unit_sales
),

originals AS (
  SELECT * FROM cleaned_titles WHERE title_type = 'original'
),

sequels AS (
  SELECT * FROM cleaned_titles WHERE title_type = 'sequel'
)

SELECT
  o.name AS franchise,
  o.name AS original_game,
  o.release_year AS original_year,
  o.global_sales AS original_sales,
  s.name AS sequel_game,
  s.platform,
  s.release_year AS sequel_year,
  s.global_sales AS sequel_sales,
  ROUND(s.global_sales - o.global_sales, 2) AS sales_difference,
  ROUND((s.global_sales - o.global_sales) / NULLIF(o.global_sales, 0) * 100, 2) AS pct_change
FROM originals o
JOIN sequels s
  ON o.base_name = s.base_name
ORDER BY franchise, sequel_year;


--Total Sequel sales compared to originals
WITH cleaned_titles AS (
  SELECT
    name,
    regexp_replace(name, '\s*\d+$', '') AS base_name,
    CASE 
      WHEN name ~ '\d+$' THEN 'sequel'
      ELSE 'original'
    END AS title_type,
    global_sales,
    year AS release_year
  FROM videogame_sales.unit_sales
),

aggregated_titles AS (
  SELECT
    name,
    base_name,
    title_type,
    SUM(global_sales) AS total_sales,
    MIN(release_year) AS release_year
  FROM cleaned_titles
  GROUP BY name, base_name, title_type
),
originals AS (
  SELECT * FROM aggregated_titles WHERE title_type = 'original'
),
sequels AS (
  SELECT * FROM aggregated_titles WHERE title_type = 'sequel'
)
SELECT
  o.name AS franchise,
  o.name AS original_game,
  o.release_year AS original_year,
  o.total_sales AS original_sales,
  s.name AS sequel_game,
  s.release_year AS sequel_year,
  s.total_sales AS sequel_sales,
  ROUND(s.total_sales - o.total_sales, 2) AS sales_difference,
  ROUND((s.total_sales - o.total_sales) / NULLIF(o.total_sales, 0) * 100, 2) AS pct_change
FROM originals o
JOIN sequels s
  ON o.base_name = s.base_name
ORDER BY franchise, sequel_year;
