
#  Analyzing Findings with Security Command Center [GSP1164]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell then run the following commands:

```
gcloud auth list
gcloud config list project
gcloud pubsub topics create export-findings-pubsub-topic
gcloud pubsub subscriptions create export-findings-pubsub-topic-sub --topic export-findings-pubsub-topic
```

## Perform using lab instruction.

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
