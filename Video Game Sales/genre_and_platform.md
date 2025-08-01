## Sales by genre and platform

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
    videogame_sales.unit_sales
GROUP BY
    genre, platform
ORDER BY
    total_global_sales DESC;
```


--  Grouping by decade across regions starting with 1990

```
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
GROUP BY
    decade, genre, platform
ORDER BY
    decade, total_global_sales DESC;
```


-- Omitting the platforms with low-volume unit sales

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
    videogame_sales.unit_sales
WHERE
    platform NOT IN ('PCFX', 'GG', 'TG-16', '3DO', 'SCD', 'WS', 'NG', '2600')
GROUP BY
    genre, platform
ORDER BY
    genre, total_global_sales DESC;
```



-- Group genre and platform by decade starting from 1990. Omitting low-volume platforms and summarizing sales.
-- Decades are depicted by their starting year ie. 1990-1999 is denoted as decade -> 1990. 

```postgresql
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
    ```


-- Sales by genre and platform broken down by region.
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
    videogame_sales.unit_sales
WHERE
    platform NOT IN ('PCFX', 'GG', 'TG-16', '3DO', 'SCD', 'WS', 'NG', '2600')
GROUP BY
    genre, platform
ORDER BY
    total_global_sales DESC;
```
