
# Set Up a Google Cloud Network: Challenge Lab [GSP314](https://www.cloudskillsboost.google/focuses/10417?parent=catalog)

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Channel](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

## Install the pglogical database extension:
```
sudo apt install postgresql-13-pglogical
```
## Download and apply some additions to the PostgreSQL configuration files (to enable pglogical extension) and restart the postgresql service:

```
sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/pg_hba_append.conf ."
sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/postgresql_append.conf ."
sudo su - postgres -c "cat pg_hba_append.conf >> /etc/postgresql/13/main/pg_hba.conf"
sudo su - postgres -c "cat postgresql_append.conf >> /etc/postgresql/13/main/postgresql.conf"
sudo systemctl restart postgresql@13-main
```

## 3 Launch the psql tool:

```
sudo su - postgres
psql
```

## Add the pglogical database extension:

```
\c postgres;
CREATE EXTENSION pglogical;
\c orders;
CREATE EXTENSION pglogical;
\c gmemegen_db;
CREATE EXTENSION pglogical;
```

## Tap here to open the [online word replacer link](http://www.unit-conversion.info/texttools/replace-text/)

## Create the database migration user

```
CREATE USER migration_admin PASSWORD 'DMS_1s_cool!';
ALTER DATABASE orders OWNER TO migration_admin;
ALTER ROLE migration_admin WITH REPLICATION;



\c postgres;
GRANT USAGE ON SCHEMA pglogical TO migration_admin;
GRANT ALL ON SCHEMA pglogical TO migration_admin;
GRANT SELECT ON pglogical.tables TO migration_admin;
GRANT SELECT ON pglogical.depend TO migration_admin;
GRANT SELECT ON pglogical.local_node TO migration_admin;
GRANT SELECT ON pglogical.local_sync_status TO migration_admin;
GRANT SELECT ON pglogical.node TO migration_admin;
GRANT SELECT ON pglogical.node_interface TO migration_admin;
GRANT SELECT ON pglogical.queue TO migration_admin;
GRANT SELECT ON pglogical.replication_set TO migration_admin;
GRANT SELECT ON pglogical.replication_set_seq TO migration_admin;
GRANT SELECT ON pglogical.replication_set_table TO migration_admin;
GRANT SELECT ON pglogical.sequence_state TO migration_admin;
GRANT SELECT ON pglogical.subscription TO migration_admin;



\c orders;
GRANT USAGE ON SCHEMA pglogical TO migration_admin;
GRANT ALL ON SCHEMA pglogical TO migration_admin;
GRANT SELECT ON pglogical.tables TO migration_admin;
GRANT SELECT ON pglogical.depend TO migration_admin;
GRANT SELECT ON pglogical.local_node TO migration_admin;
GRANT SELECT ON pglogical.local_sync_status TO migration_admin;
GRANT SELECT ON pglogical.node TO migration_admin;
GRANT SELECT ON pglogical.node_interface TO migration_admin;
GRANT SELECT ON pglogical.queue TO migration_admin;
GRANT SELECT ON pglogical.replication_set TO migration_admin;
GRANT SELECT ON pglogical.replication_set_seq TO migration_admin;
GRANT SELECT ON pglogical.replication_set_table TO migration_admin;
GRANT SELECT ON pglogical.sequence_state TO migration_admin;
GRANT SELECT ON pglogical.subscription TO migration_admin;



GRANT USAGE ON SCHEMA public TO migration_admin;
GRANT ALL ON SCHEMA public TO migration_admin;
GRANT SELECT ON public.distribution_centers TO migration_admin;
GRANT SELECT ON public.inventory_items TO migration_admin;
GRANT SELECT ON public.order_items TO migration_admin;
GRANT SELECT ON public.products TO migration_admin;
GRANT SELECT ON public.users TO migration_admin;



\c gmemegen_db;
GRANT USAGE ON SCHEMA pglogical TO migration_admin;
GRANT ALL ON SCHEMA pglogical TO migration_admin;
GRANT SELECT ON pglogical.tables TO migration_admin;
GRANT SELECT ON pglogical.depend TO migration_admin;
GRANT SELECT ON pglogical.local_node TO migration_admin;
GRANT SELECT ON pglogical.local_sync_status TO migration_admin;
GRANT SELECT ON pglogical.node TO migration_admin;
GRANT SELECT ON pglogical.node_interface TO migration_admin;
GRANT SELECT ON pglogical.queue TO migration_admin;
GRANT SELECT ON pglogical.replication_set TO migration_admin;
GRANT SELECT ON pglogical.replication_set_seq TO migration_admin;
GRANT SELECT ON pglogical.replication_set_table TO migration_admin;
GRANT SELECT ON pglogical.sequence_state TO migration_admin;
GRANT SELECT ON pglogical.subscription TO migration_admin;



GRANT USAGE ON SCHEMA public TO migration_admin;
GRANT ALL ON SCHEMA public TO migration_admin;
GRANT SELECT ON public.meme TO migration_admin;



\c orders;
\dt
ALTER TABLE public.distribution_centers OWNER TO migration_admin;
ALTER TABLE public.inventory_items OWNER TO migration_admin;
ALTER TABLE public.order_items OWNER TO migration_admin;
ALTER TABLE public.products OWNER TO migration_admin;
ALTER TABLE public.users OWNER TO migration_admin;
\dt



ALTER TABLE public.inventory_items ADD PRIMARY KEY(id);
\q 
exit

```

## Tap here to open the [Online Notepad](https://onlinenotepad.org/notepad)

```
export VPC_NAME=

export SUBNET_1=

export REGION_1=

export SUBNET_2=

export REGION_2=

export RULE_CP1=

export RULE_CP2=

export RULE_CP3=
```

```
gcloud compute networks create $VPC_NAME --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create $SUBNET_1 --project=$DEVSHELL_PROJECT_ID --range=10.10.10.0/24 --stack-type=IPV4_ONLY --network=$VPC_NAME --region=$REGION_1

gcloud compute networks subnets create $SUBNET_2 --project=$DEVSHELL_PROJECT_ID --range=10.10.20.0/24 --stack-type=IPV4_ONLY --network=$VPC_NAME --region=$REGION_2

gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create $RULE_CP1 --direction=INGRESS --priority=65535 --network=$VPC_NAME --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0

gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create $RULE_CP2 --direction=INGRESS --priority=65535 --network=$VPC_NAME --action=ALLOW --rules=tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create $RULE_CP3 --direction=INGRESS --priority=65535 --network=$VPC_NAME --action=ALLOW --rules=icmp --source-ranges=0.0.0.0/0

```


## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
