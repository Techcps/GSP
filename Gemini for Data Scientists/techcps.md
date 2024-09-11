
## 💡 Lab Link: [Gemini for Data Scientists](https://www.cloudskillsboost.google/focuses/80990?parent=catalog)

## 🚀 Lab Solution [Watch Here](https://youtu.be/edZnP0lbg64)

---

## 🚨Export the REGION name correctly:

```
export REGION=
```

## 🚨Copy and run the below commands:

```
curl -LO raw.githubusercontent.com/Techcps/GSP/master/Gemini%20for%20Data%20Scientists/techcps.sh
sudo chmod +x techcps.sh
./techcps.sh
```

## 🚨 Check your progress on Task 1-2 then move forward to the next task

---

# 🚨Build the Python Notebook

## 🚨Query 1
```
from google.cloud import bigquery
from google.cloud import aiplatform
import bigframes.pandas as bpd
import pandas as pd
from vertexai.language_models._language_models import TextGenerationModel
from bigframes.ml.cluster import KMeans
from bigframes.ml.model_selection import train_test_split
```
---

## 🚨Query 2
## 🚨Set your Project I'd and Location Name

```
project_id = 'qwiklabs-gcp-01-e8e9dc578f3c'
dataset_name = "ecommerce"
model_name = "customer_segmentation_model"
table_name = "customer_stats"
location = "us-central1"
client = bigquery.Client(project=project_id)
aiplatform.init(project=project_id, location=location)
```
---

## 🚨Query 3
```
%%bigquery
CREATE OR REPLACE TABLE ecommerce.customer_stats AS
SELECT
  user_id,
  DATE_DIFF(CURRENT_DATE(), CAST(MAX(order_created_date) AS DATE), day) AS days_since_last_order, ---RECENCY
  COUNT(order_id) AS count_orders, --FREQUENCY
  AVG(sale_price) AS average_spend --MONETARY
  FROM (
      SELECT
        user_id,
        order_id,
        sale_price,
        created_at AS order_created_date
        FROM `bigquery-public-data.thelook_ecommerce.order_items`
        WHERE
        created_at
            BETWEEN '2022-01-01' AND '2023-01-01'
  )
GROUP BY user_id;
```
---

## 🚨Query 4
```
# prompt: Convert the table ecommerce.customer_stats to a BigQuery DataFrames dataframe and show the top 10 records

df = bpd.read_gbq(f"{project_id}.{dataset_name}.{table_name}")
df.head(10)
```
---

## 🚨Query 5
```
# prompt: 1. Split df into test and training data for a K-means clustering algorithm store these as df_test_ and df_train. 2. Create a K-means cluster model using bigframes.ml.cluster KMeans with 5 clusters. 3. Save the model to BigQuery in a model called ecommerce.model_name using the to_gbq method.

df_train, df_test = train_test_split(df, test_size=0.2, random_state=42)
kmeans = KMeans(n_clusters=5)
kmeans.fit(df_train)
kmeans.to_gbq(model_name=f"{project_id}.{dataset_name}.{model_name}", replace=True)
```
---

## 🚨Query 6
```
# prompt: 1. Call the K-means prediction model on the df dataframe, and store the results as predictions_df and show the first 10 records.

predictions_df = kmeans.predict(df)
predictions_df.head(10)
```

# 🚨 Now below query will take around 20-25 minutes to completed
> Just wait and watch & Make aure your laptop will not go for sleep

---

## 🚨Query 7
```
# prompt: 1. Using predictions_df, and matplotlib, generate a scatterplot. 2. On the x-axis of the scatterplot, display days_since_last_order and on the y-axis, display average_spend from predictions_df. 3. Color by cluster. The chart should be titled "Attribute grouped by K-means cluster."

import matplotlib.pyplot as plt

# Create the scatter plot
plt.figure(figsize=(10, 6))
plt.scatter(predictions_df['days_since_last_order'], predictions_df['average_spend'], c=predictions_df['CENTROID_ID'], cmap='viridis')

# Add labels and title
plt.xlabel('Days Since Last Order')
plt.ylabel('Average Spend')
plt.title('Attribute grouped by K-means cluster')

# Show the plot
plt.show()
```
## 🚨 Note: If you're facing any kind of error then re-run the all above query
---
# 🚨 Generate insights from the results of the model

## 🚨Query 1

```
query = """
SELECT
 CONCAT('cluster ', CAST(centroid_id as STRING)) as centroid,
 average_spend,
 count_orders,
 days_since_last_order
FROM (
 SELECT centroid_id, feature, ROUND(numerical_value, 2) as value
 FROM ML.CENTROIDS(MODEL `{0}.{1}`)
)
PIVOT (
 SUM(value)
 FOR feature IN ('average_spend',  'count_orders', 'days_since_last_order')
)
ORDER BY centroid_id
""".format(dataset_name, model_name)

df_centroid = client.query(query).to_dataframe()
df_centroid.head()
```
---

## 🚨Query 2
```
df_query = client.query(query).to_dataframe()
df_query.to_string(header=False, index=False)

cluster_info = []
for i, row in df_query.iterrows():
 cluster_info.append("{0}, average spend ${2}, count of orders per person {1}, days since last order {3}"
  .format(row["centroid"], row["count_orders"], row["average_spend"], row["days_since_last_order"]) )

cluster_info = (str.join("\n", cluster_info))
print(cluster_info)
```
---

## 🚨Query 3
```
prompt = f"""
You're a creative brand strategist, given the following clusters, come up with \
creative brand persona, a catchy title, and next marketing action, \
explained step by step.

Clusters:
{cluster_info}

For each Cluster:
* Title:
* Persona:
* Next marketing step:
"""
```

---

## 🚨Query 4
```
#prompt:  Use the Vertex AI language_models API to call the PaLM2 text-bison model and generate a marketing campaign using the variable prompt. Use the following model settings: max_output_tokens=1024, temperature=0.4

model = TextGenerationModel.from_pretrained("text-bison")
response = model.predict(prompt, max_output_tokens=1024, temperature=0.4)
print(response.text)
```
---


### Congratulations, you're all done with the lab 😄

---

### 🌐 Join our Community

- **Join our [Discussion Group](https://t.me/Techcpschat)** <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25">
- **Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)** <img src="https://github.com/user-attachments/assets/6ee41001-c795-467c-8d96-06b56c246b9c" alt="icon" width="25" height="25">
- **Join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)** <img src="https://github.com/user-attachments/assets/aa10b8b2-5424-40bc-8911-7969f29f6dae" alt="icon" width="25" height="25">
- **Join our [Telegram Channel](https://t.me/Techcps)** <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25">
- **Follow us on [LinkedIn](https://www.linkedin.com/company/techcps/)** <img src="https://github.com/user-attachments/assets/b9da471b-2f46-4d39-bea9-acdb3b3a23b0" alt="icon" width="25" height="25">

### Thanks for watching and stay connected :)

---

### 🚨NOTE: copyright by Google Cloud
- **This script doesn't belong to this page, it has been edited and shared for the purpose of Educational. DM for credit or removal request (no copyright intended) ©All rights and credits for the original content belong to Google Cloud.**
- **Credit to the respective owner [Google Cloud Skill Boost website](https://www.cloudskillsboost.google/)** 🙏

---
