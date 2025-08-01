### I wanted to find sequels and/or follow up games to analyse franchise success

-- franchise sequels or follow-ups
```postgresql
SELECT
  franchise_name,
  COUNT(DISTINCT name) AS total_titles,
  SUM(global_sales) AS total_global_sales
FROM (
  SELECT
    name,
    global_sales,
    TRIM(
      REGEXP_REPLACE(
        LOWER(name),
        '(\s(2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20)\b.*|:.*)$',
        '',
        'g'
      )
    ) AS franchise_name
  FROM videogame_sales.unit_sales
  GROUP BY name, global_sales
) AS franchise_base
GROUP BY franchise_name
HAVING COUNT(DISTINCT name) > 1
ORDER BY total_global_sales DESC;
```


-- Sequels or follow ups by platform
```postgresql
SELECT
  franchise_name,
  platform,
  COUNT(DISTINCT name) AS total_titles,
  SUM(global_sales) AS total_global_sales
FROM (
  SELECT
    name,
    platform,
    global_sales,
    TRIM(
      REGEXP_REPLACE(
        LOWER(name),
        '(\s(2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20)\b.*|:.*)$',
        '',
        'g'
      )
    ) AS franchise_name
  FROM videogame_sales.unit_sales
  GROUP BY name, platform, global_sales
) AS franchise_base
GROUP BY franchise_name, platform
HAVING COUNT(DISTINCT name) > 1
ORDER BY total_titles, total_global_sales DESC;
```

-- adding a decade column
```postgresql
CREATE VIEW videogame_sales.franchise_summary AS
SELECT
  franchise_name,
  platform,
  (year / 10) * 10 AS decade,
  COUNT(DISTINCT name) AS total_titles,
  SUM(global_sales) AS total_global_sales
FROM (
  SELECT
    name,
    platform,
    year,
    global_sales,
    TRIM(
      REGEXP_REPLACE(
        LOWER(name),
        '(\s(2|3|4|5|6|7|8|9]|10|11|12|13|14|15|16|17|18|19|20)\b.*|:.*)$',
        '',
        'g'
      )
    ) AS franchise_name
  FROM videogame_sales.unit_sales
  WHERE year IS NOT NULL
  GROUP BY name, platform, year, global_sales
) AS franchise_base
GROUP BY franchise_name, platform, (year / 10) * 10
HAVING COUNT(DISTINCT name) > 1
ORDER BY franchise_name, decade, total_global_sales DESC;
```
