
# Build LookML Objects in Looker: Challenge Lab [GSP361]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Channel](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

# Click the toggle button to on Development mode.

# Task 1. Create dimensions and measures

## create a new view file
``` 
order_items_challenge
```
```
view: order_items_challenge {
  sql_table_name: `cloud-training-demos.looker_ecomm.order_items’  ;;
  drill_fields: [order_item_id]
  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  
  dimension: is_search_source {
    type: yesno
    sql: ${users.traffic_source} = "Search" ;;
  }
  
  
  measure: sales_from_complete_search_users {
    type: sum
    sql: ${TABLE}.sale_price ;;
    filters: [is_search_source: "Yes", order_items.status: "Complete"]
  }
  
  
  measure: total_gross_margin {
    type: sum
    sql: ${TABLE}.sale_price - ${inventory_items.cost} ;;
  }
  
  
  dimension: return_days {
    type: number
    sql: DATE_DIFF(${order_items.delivered_date}, ${order_items.returned_date}, DAY);;
  }
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }
}
```
## Save changes and click on validate the LookML

## training_ecommerce.model
> Add below contents into the explore: order_items > line No.18

```
join: order_items_challenge {
type: left_outer
sql_on: ${order_items.order_id} = ${order_items_challenge.order_id} ;;
relationship: many_to_one
}
```
## Save the changes, Validate LooML and then Commit for deploying into production

# Task 2. Create a persistent derived table
## Clickon explore > Order Items > Under order items select
> Order ID

> User ID

> Total Revenue

## From Users select
> Age

> City

> State

## Click on Run then gear icon just beside of run option
## Click on Get LookML > then click on Derived Table section
## Navigate back to the develop > ecommerce > views folder and create a new file:
```
user_details
```
## Remove all default code and copy to Derived Table code & paste
## Replace the default view name line 5 with above file name & click on save changes

## training_ecommerce.model
> Add below code in the file (add this in order items explore) > line No. 18 
```
join: user_details {
 
type: left_outer
 
sql_on: ${order_items.user_id} = ${user_details.user_id} ;;
 
relationship: many_to_one
 
}
```
## Save the changes, Validate LooML and then Commit for deploying into production

# Task 3. Use Explore filters
## training_ecommerce.model - filter #1 & #2 
> add the below line in the order_item explore > line No. 18
> Make sure to change the value

```
sql_always_where: ${sale_price} >= VALUE ;;
 
 
conditionally_filter: {
 
filters: [order_items.shipped_date: "2018"]
 
unless: [order_items.status, order_items.delivered_date]
 
}
```

## training_ecommerce.model - filter #3 & #4
> add the below line in the order_item explore > line No. 18
> Make sure to change the value

```
sql_always_having: ${average_sale_price} > VALUE ;;
 
always_filter: {
               filters: [order_items.status: "Shipped", users.state: "California", users.traffic_source:   
             "Search"]
             }

```
## Save the changes, Validate LooML and then Commit for deploying into production

# Task 4. Apply a datagroup to an Explore

## training_ecommerce.model
## Remove any filters you created from the previous section & datagroup - line 18-34
## Add this code before the order_item explore (Make sure to change the value) - line 8-11

```
datagroup: order_items_challenge_datagroup {
sql_trigger: SELECT MAX(order_item_id) from order_items ;;
max_cache_age: "VALUE hours"
}
```
## Replace below code with line 13
```
persist_with: order_items_challenge_datagroup
```
## Save the changes, Validate LooML and then Commit for deploying into production

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
