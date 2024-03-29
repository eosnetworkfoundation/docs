---
title: Build Hyperion Components
contributors:
  - { name: Ross Dold (EOSphere), github: eosphere }
---

The Hyperion Full History service is a collection of  **eight**  purpose built EOS RIO software and industry standard applications.

This walk through will install all components excluding the SHIP node on a single Ubuntu 22.04 server, please reference  [Introduction to Hyperion Full History](./01_intro-to-hyperion-full-history.md) for infrastructure suggestions.

The process for building each of these primary building blocks is covered below:

## State-History (SHIP) Node

The Hyperion deployment requires access to a fully sync’d State-History Node, the current SHIP recommend version is Leap `v5.0.2`.

## RabbitMQ

To install the latest RabbitMQ currently  `3.13.0`  be sure to check their latest  [Cloudsmith Quick Start Script](https://www.rabbitmq.com/install-debian.html), this in our experience is the simplest way to ensure you are current and correctly built.

The summary process is below:

```bash
> sudo apt update

> sudo apt-get install curl gnupg apt-transport-https -y

#Team RabbitMQ's main signing key#
> curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/com.rabbitmq.team.gpg > /dev/null

#Cloudsmith: modern Erlang repository#
> curl -1sLf https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg > /dev/null

#Cloudsmith: RabbitMQ repository#
> curl -1sLf https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/rabbitmq.9F4587F226208342.gpg > /dev/null

--------------------------------------------------------------------
#Add apt repositories maintained by Team RabbitMQ#
> sudo tee /etc/apt/sources.list.d/rabbitmq.list <<EOF

## Provides modern Erlang/OTP releases ##
deb [signed-by=/usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-erlang/deb/ubuntu jammy main
deb-src [signed-by=/usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-erlang/deb/ubuntu jammy main

## Provides RabbitMQ ##
deb [signed-by=/usr/share/keyrings/rabbitmq.9F4587F226208342.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-server/deb/ubuntu jammy main
deb-src [signed-by=/usr/share/keyrings/rabbitmq.9F4587F226208342.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-server/deb/ubuntu jammy main

EOF
--------------------------------------------------------------------
> sudo apt-get update -y

#Install Erlang packages#
> sudo apt-get install -y erlang-base \
  erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
  erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
  erlang-runtime-tools erlang-snmp erlang-ssl \
  erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl

#Install rabbitmq-server and its dependencies#
> sudo apt-get install rabbitmq-server -y --fix-missing

**Check Version**
> sudo rabbitmqctl version
```
## Redis

Our current Hyperion deployments are running on the latest Redis stable version  `v7.2.4`  which is built as below:

```bash
> sudo apt install lsb-release curl gpg

#Redis Signing Key#  
> curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

#Latest Redis repository#  
> echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list> sudo apt update

#Install Redis#  
> sudo apt install redis

**Check Version**  
> redis-server --version
```

## Node.js

Hyperion requires Node.js v18 , our current Hyperion deployments are running the current LTS  `v18.19.1`  which is built below:

```bash
#Download and import the Nodesource GPG key#
> sudo apt update

> sudo apt install -y ca-certificates curl gnupg

> sudo mkdir -p /etc/apt/keyrings

> curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

#Create .deb repository#
> NODE_MAJOR=18

> echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

#Install Node.js#
> sudo apt update 

> sudo apt-get install -y nodejs

**Check Version**
> node -v
```

## PM2

The latest public version is  `5.3.1`  and is built as below:

```bash
> sudo apt update

#Install PM2#  
> sudo npm install pm2@latest -g

**Check Version**  
> pm2 -v
```

## Elasticsearch

Currently most of our Hyperion deployments are using Elasticsearch  `8.5-12.x`  with great results, however the current recommended Elasticsearch version is  `8.12.2`  which I expect will work just as well or better. Build the latest Elasticsearch  `8.x`  as below:

```bash
> sudo apt update

> sudo apt install apt-transport-https

> sudo apt install gpg

#Elasticsearch signing key#
> wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

#Latest Elasticsearch 8.x repository#
> echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

#Install Elasticsearch#
> sudo apt update && sudo apt install elasticsearch

**Take note of the super-user password**
```

## Kibana

The utilised Kibana version should be paired with the installed Elasticsearch version, the process below will install the current version:

```bash
> sudo apt update

> sudo apt-get install apt-transport-https

> sudo apt install gpg

#Elasticsearch signing key - Not needed if already added#
> wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

#Latest Elasticsearch 8.x repository - Not needed if already added#
> echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

#Install Kibana#
> sudo apt update && sudo apt install kibana
```

## **EOS RIO Hyperion Indexer and API**

Currently (March 2024) the most robust and production ready version of Hyperion from our experience is  `3.3.9–8`  and is used across all our Hyperion Full History Services. The EOS RIO Team are constantly developing and improving their code, the best way to stay on top of the current recommend version is to join the  [Hyperion Telegram Group](https://t.me/EOSHyperion). 

Build Hyperion from  `main`  as below:

```bash
> git clone https://github.com/eosrio/hyperion-history-api.git

> cd hyperion-history-api

> git checkout main

> npm install

> npm audit fix
```

After all Hyperion Software Components are built and provisioned you can now proceed to configuration.

The next guide will walk through the technical configuration of each component.
