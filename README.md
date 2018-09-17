# Table of Contents
1. [Program Background](README.md#program-description)
2. [Data Model](README.md#data-model)
3. [How to Run the Program](README.md#run-instruction)
4. [Limitations and Future Work](README.md#future-work)
5. [Contact](README.md#contact)


# Program Background

TweeTrade platform allows user to write and automate conditional execution on stock trading using public sentiment from a web UI. It ingests livestream Twitter streaming API and ~3200 NASDAQ stock quotes (simulated) using Kafka, performs linear NLP sentiment analysis on Twitter stream and performs window stock averaging on each ticker using Spark stream processing, and utilizes Apache Cassandra for its database infrastructure. 

# Data Pipeline

![data-pipeline](/graphics/fig-2-nn.svg)

# Model and Settings
## Kafka Cluster Parameters & Settings
Kafka cluster is run in 3 node cluster with two topics -- for Twitter('twitter-stream1') and for stock('stock-stream1'). Twitter producer is fed with data from Twitter API using `tweepy` python module. The stock producer is simulated for ~3200 NASDAQ stocks sampled once every one seconds using python script. Kafka producers and consumers are created using [kafka-python](https://kafka-python.readthedocs.io). Although default settings are selected, among available setting, these parameters may be customized for better performance for this use case: `ack` for asynchronous messaging, `retries` for retrying on message delivery failure, change from random partioning to one that may be more optimal for the use case.

## Spark Streaming Parameters & Settings
Spark sptreamin is performed using pySpark.streaming.kafka module. The streams are not run in parallel, but multi-streams could be used and unionized to parallize processing. `spark.streaming.blockInterval` is set to default and may be fine tuned as needed.

## Cassandra Parameters & Settings
The project assumes cassandra service is running with the minimal properties needed for configuring a cluster. It utilizes the follwing tables within the keyspace `tweetdb`: `userTable`, 'stockTimeSeries', `twitterKeySentiments`, `userLogic`. 


# How to Run the Program
## Dependencies
Install python and python modules: `tweepy`, `pyspark`, `pyspark_cassandra`, kafka (and zookeeper), spark, cassandra.
## Run Command (in sequence)
1. Start Kafka (requires starting zookeeper before Kafka), Spark Streaming and Cassandra Service

2. Start Kafka Producers
python ./kafkaProducers/kStockProducer.py
python ./kafkaProducers/kTwitterProducer.py

3. Run Spark Streaming
$SPARK_HOME/bin/spark-submit --packages org.apache.spark:spark-streaming-kafka_2.11:1.6.3,anguenot/pyspark-cassandra:0.5.0 ./sparkStreamingProcessors/cssTwitterST.py
$SPARK_HOME/bin/spark-submit --packages org.apache.spark:spark-streaming-kafka_2.11:1.6.3,anguenot/pyspark-cassandra:0.5.0 ./sparkStreamingProcessors/cssStock.py	

4. Run Flask server
export FLASK_APP=./flask/app.py
flask run

# Limitations and Future Work
Currently, the project sets up data pipeline and infrastructure to perform automated trading -- it creates twitter table with keywords as primary keys, user table with user information, user instruction table, and stock time series. Spark stream processing performs NLP on twitter data and also window average on stock prices for the time frame. However, the spark stream processing for reading user instruction and performing trading logic is not yet implemented and is next step.   

# Contact
paurakh[at]gmail[dot]com

