
gcloud auth list
gcloud services enable bigquery.googleapis.com


bq query --use_legacy_sql=false "
SELECT sum(CAST(total_sales AS FLOAT64)) as sum_total_sales
FROM \`thelook_gcda.orders_by_state\`;
"


bq query --use_legacy_sql=false "
SELECT country, sum(cast(total_sales as numeric)) as sum_total_sales
FROM \`thelook_gcda.orders_by_state\`
GROUP BY country;
"


bq query --use_legacy_sql=false "
SELECT country, order_year, sum(cast(total_sales as decimal)) as sum_total_sales
FROM \`thelook_gcda.orders_by_state\`
GROUP BY country, order_year
ORDER BY country asc, order_year desc;
"



bq query --use_legacy_sql=false "
SELECT
event_date,
event_name,
geo
FROM \`thelook_gcda.ga4_events\`;
"

bq query --use_legacy_sql=false "
SELECT
  event_date,
  event_name,
  geo
FROM
  \`thelook_gcda.ga4_events\`
WHERE
  event_name = 'view_item';
"



bq query --use_legacy_sql=false "
SELECT
event_date,
event_name,
geo.country
FROM \`thelook_gcda.ga4_events\`
WHERE
event_name = 'view_item'
and geo.country = 'Singapore';
"



bq query --use_legacy_sql=false "
SELECT
event_date,
event_name,
geo.country,
items
FROM \`thelook_gcda.ga4_events\`
WHERE
event_name = 'view_item'
and geo.country = 'Singapore';
"


bq query --use_legacy_sql=false "
SELECT
  event_date,
  event_name,
  geo.country,
  item.item_name
FROM \`thelook_gcda.ga4_events\`,
  UNNEST(items) AS item
WHERE
  event_name = 'view_item'
  AND geo.country = 'Singapore';
"



bq query --use_legacy_sql=false "
SELECT
event.event_date,
event_name,
geo.country,
item.item_name
FROM \`thelook_gcda.ga4_events\` as event
INNER JOIN unnest(items) as item
WHERE
event_name = 'view_item'
AND geo.country = 'Singapore';
"

bq query --use_legacy_sql=false "
SELECT
event.event_date,
event_name,
geo.country,
item.item_name
from \`thelook_gcda.ga4_events\` as event
INNER JOIN unnest(items) as item
WHERE
event_name = 'view_item'
AND geo.country = 'Singapore'
AND item.item_name = 'Google Dino Game Tee';
"


