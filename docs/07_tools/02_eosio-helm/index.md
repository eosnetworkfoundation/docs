---
content_title: Antelope Nodeos Helm Charts
link_text: Antelope Nodeos Helm Charts
---

## Summary

* [Overview](#overview)
* [Installation](#installation)
    * [Local Deployment](#local-deployment)
    * [Cloud Deployment](#cloud-deployment)
* [Configuration](#configuration)
    * [Customizing Values](#customizing-values)
    * [Configuring Cloud Provider](#configuring-cloud-provider)
* [Tutorial](#tutorial)

## Overview

Antelope Helm Charts provides direct access to infrastructure-as-code (IaC) for rapid deployment of Antelope nodes via Kubernetes. It includes support for common cloud providers such as Amazon Web Services (AWS) and Google Cloud Platform (GCP). Antelope Helm Charts currently includes three charts:

  * `eosio`: provides the configuration umbrella for the Antelope ecosystem.
  * `eosio-common`: provides scaffolding for infrastructure extensions support.
  * `eosio-nodeos`: provides the configuration options for the Antelope node(s).

[[info | Note]]
| The [Antelope Web IDE](https://github.com/EOSIO/eosio-web-ide) is another tool that allows developers to get an Antelope network up and running quickly. It also allows developers to build and deploy Antelope applications smoothly from within a Docker-enabled web-based IDE.

## Installation

Antelope Helm Charts can be installed and run locally with a Docker Desktop backend, or run remotely with a cloud deployment. For quick prototyping and rapid testing choose a local deployment. For production environments or distributed testing select a cloud deployment.

### Local Deployment

To install Antelope Helm Charts for local deployment via Docker Desktop, follow the instructions below. You may also follow the [Tutorial](https://docs.eosnetwork.com/welcome/v2.2/tools/eosio-helm/tutorial) for step-by-step instructions.

1. Install Docker Desktop:
    * [Docker Official: Desktop](https://docs.docker.com/desktop)
2. Install Kubernetes command-line tool (kubectl):
    * [Kubernetes Official: Install and Set Up Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)
3. Install Helm:
    * [Helm Official: Installing Helm](https://helm.sh/docs/intro/install)
4. Configure Helm and Kubernetes for deployment:
    1. Helm repo add `eosio.helm` public repository.
    2. Set Kubernetes to use the Docker Desktop context.
        1. Verify the current context using `kubectl config current-context`.
        2. If the current context is not Docker Desktop, then
            1. Get a list of contexts via `kubectl config get-contexts`.
            2. Set the current context to the Docker Desktop Kubernetes namespace via `kubectl config use-context <docker local>`.
5. Deploy a Helm chart for Antelope applications:
    1. Clone the Antelope Help Charts github repository via `git clone https://github.com/EOSIO/eosio.helm.git`.
    2. Configure Helm Chart subpackages via `helm dependency update`.
        * File: [eosio/scripts/helm-dependency-update.sh](https://github.com/EOSIO/eosio.helm/blob/master/eosio/scripts/helm-dependency-update.sh)
    3. Deploy Antelope via `helm upgrade --install eosio eosio -f eosio/local.yaml -f eosio/nodeos_config.yaml`
        * File: [eosio/local.yaml](https://github.com/EOSIO/eosio.helm/blob/master/eosio/local.yaml)
        * File: [eosio/nodeos_config.yaml](https://github.com/EOSIO/eosio.helm/blob/master/eosio/nodeos_config.yaml)

### Cloud Deployment

To install Antelope Helm Charts for cloud deployment using a cloud provider like AWS or GCP, follow these instructions:

1. Deploy a Helm chart for Antelope applications:
    1. Clone the Antelope Help Charts github repository via `git clone https://github.com/EOSIO/eosio.helm.git`.
    1. Configure Helm chart subpackages for chain via `helm dependency update`.
        * File: [eosio/scripts/helm-dependency-update.sh](https://github.com/EOSIO/eosio.helm/blob/master/eosio/scripts/helm-dependency-update.sh)
    1. Deploy Antelope via `helm upgrade --install eosio eosio -f eosio/primary.yaml -f eosio/nodeos_config.yaml`
        * File: [eosio/primary.yaml](https://github.com/EOSIO/eosio.helm/blob/master/eosio/primary.yaml)
        * File: [eosio/nodeos_config.yaml](https://github.com/EOSIO/eosio.helm/blob/master/eosio/nodeos_config.yaml)

## Configuration

You can customize specific values to be passed to the Antelope Helm charts. You can also configure specific artefacts within the cloud provider.

### Customizing Values

1. Specify additional value files as desired using additional `-f` options. Remember that order matters and values are overridden from left-to-right in specification.
    * [Helm Official: Value Files](https://helm.sh/docs/chart_template_guide/values_files)
1. Specify values directly as command line arguments.
    * [Helm Official: Using Helm](https://helm.sh/docs/intro/using_helm)

### Configuring Cloud Provider

* Cloud provider: `.Values.global.cloudProvider`
* Autoscaler: `.Values.global.nodeSelector`

## Tutorial

Check the [Antelope Helm Tutorial](https://docs.eosnetwork.com/welcome/v2.2/tools/eosio-helm/tutorial), which demonstrates how to install Antelope Helm Charts for local deployment, how to use them to launch an Antelope node, and how to use Antelope Helm repositories.
