
gcloud auth list

bq query --use_legacy_sql=false "SELECT sum(cumulative_confirmed) as total_cases_worldwide FROM \`bigquery-public-data.covid19_open_data.covid19_open_data\` WHERE date='$DATE_CP1'"


bq query --use_legacy_sql=false "
with deaths_by_states as (
  SELECT subregion1_name as state, sum(cumulative_deceased) as death_count
  FROM \`bigquery-public-data.covid19_open_data.covid19_open_data\`
  WHERE country_name='United States of America' and date='$DATE_CP2' and subregion1_name is NOT NULL
  GROUP BY subregion1_name
)
SELECT count(*) as count_of_states
FROM deaths_by_states
WHERE death_count > $DEATH_COUNT_CP2"




bq query --use_legacy_sql=false "
SELECT * FROM (
  SELECT subregion1_name as state, sum(cumulative_confirmed) as total_confirmed_cases
  FROM \`bigquery-public-data.covid19_open_data.covid19_open_data\`
  WHERE country_code='US' AND date='$DATE_CP3' AND subregion1_name is NOT NULL
  GROUP BY subregion1_name
  ORDER BY total_confirmed_cases DESC
)
WHERE total_confirmed_cases > $DEATH_COUNT_CP3"



bq query --use_legacy_sql=false "
SELECT sum(cumulative_confirmed) as total_confirmed_cases, sum(cumulative_deceased) as total_deaths, (sum(cumulative_deceased)/sum(cumulative_confirmed))*100 as case_fatality_ratio
FROM \`bigquery-public-data.covid19_open_data.covid19_open_data\`
WHERE country_name='Italy' AND date BETWEEN '$DATE_X_CP4' AND '$DATE_Y_CP4'"




bq query --use_legacy_sql=false "
SELECT date
FROM \`bigquery-public-data.covid19_open_data.covid19_open_data\`
WHERE country_name='Italy' AND cumulative_deceased > $DEATHS_CROSS_CP5
ORDER BY date ASC
LIMIT 1"




bq query --use_legacy_sql=false "
WITH india_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    \`bigquery-public-data.covid19_open_data.covid19_open_data\`
  WHERE
    country_name = 'India'
    AND date BETWEEN '$DATE_X_CP6' AND '$DATE_Y_CP6'  -- corrected date range
  GROUP BY
    date
  ORDER BY
    date ASC
),
india_previous_day_comparison AS (
  SELECT
    date,
    cases,
    LAG(cases) OVER(ORDER BY date) AS previous_day,
    cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
  FROM
    india_cases_by_date
)
SELECT count(*)
FROM india_previous_day_comparison
WHERE net_new_cases = 0"




bq query --use_legacy_sql=false "
WITH us_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    \`bigquery-public-data.covid19_open_data.covid19_open_data\`
  WHERE
    country_name='United States of America'
    AND date BETWEEN '$DATE_X_CP7' AND '$DATE_Y_CP7'
  GROUP BY
    date
  ORDER BY
    date ASC
),
us_previous_day_comparison AS (
  SELECT
    date,
    cases,
    LAG(cases) OVER(ORDER BY date) AS previous_day,
    cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases,
    (cases - LAG(cases) OVER(ORDER BY date)) * 100 / LAG(cases) OVER(ORDER BY date) AS percentage_increase
  FROM
    us_cases_by_date
)
SELECT date AS Date,
       cases AS Confirmed_Cases_On_Day,
       previous_day AS Confirmed_Cases_Previous_Day,
       percentage_increase AS Percentage_Increase_In_Cases
FROM us_previous_day_comparison
WHERE percentage_increase > $DOUBLING_RATE_CP7"





bq query --use_legacy_sql=false '
WITH cases_by_country AS (
  SELECT
    country_name AS country,
    SUM(cumulative_confirmed) AS cases,
    SUM(cumulative_recovered) AS recovered_cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    date = "'"$DATE_CP8"'"
  GROUP BY
    country_name
),
recovered_rate AS (
  SELECT
    country,
    cases,
    recovered_cases,
    (recovered_cases * 100) / cases AS recovery_rate
  FROM
    cases_by_country
)
SELECT
  country,
  cases AS confirmed_cases,
  recovered_cases,
  recovery_rate
FROM
  recovered_rate
WHERE
  cases > 50000
ORDER BY
  recovery_rate DESC
LIMIT
  '"$LIMIT_CP8"''




bq query --use_legacy_sql=false "
WITH
  france_cases AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS total_cases
  FROM
    \`bigquery-public-data.covid19_open_data.covid19_open_data\`
  WHERE
    country_name='France'
    AND date IN ('$DATE_X_CP9',
      '$DATE_Y_CP9')
  GROUP BY
    date
  ORDER BY
    date)
, summary as (
SELECT
  first_day_cases,
  last_day_cases,
  days_diff,
  SQRT((last_day_cases/first_day_cases)/(1/days_diff))-1 as cdgr
FROM (
  SELECT
    total_cases AS first_day_cases,
    LEAD(total_cases) OVER(ORDER BY date) AS last_day_cases,
    DATE_DIFF(LEAD(date) OVER(ORDER BY date), date, day) AS days_diff
  FROM
    france_cases
  LIMIT 1
))
SELECT * FROM summary"



bq query --use_legacy_sql=false "
SELECT
  date,
  SUM(cumulative_confirmed) AS country_cases,
  SUM(cumulative_deceased) AS country_deaths
FROM
  \`bigquery-public-data.covid19_open_data.covid19_open_data\`
WHERE
  date BETWEEN '$DATE_X_CP10' AND '$DATE_Y_CP10'
  AND country_name = 'United States of America'
GROUP BY
  date"


