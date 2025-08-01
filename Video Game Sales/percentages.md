## Looking at the percentage of each genre's global sales relative to the total global sales for its respective platform.

```postgresql
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
```
	

-- Percentage of each genre by decade relative to each platform globally
```postgresql
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
```



-- Percentage of Sales for each platform narrowed down by region
```postgresql
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
```
