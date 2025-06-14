# Deployment
This document describes deployment arichtecture of this system, describing services, routing and Kubernetes & istio setup.

## System Architecture
This system consists of a microservice architecture which is deployed on a kubernetes cluster, provisioned using Vagrant and Ansible.

The services in this system are:
- `app-service`: Service handling front-end logic, hosting a web page and passing user input to `model-service`.
- `model-service`: Service exposing the sentiment analysis model.

## Software components
The system relies on five software components:

- [app-service](https://github.com/remla25-team22/app-service)
    
    Service responsible for hosting front-end page and handling front-end requests.
- [model-service](https://github.com/remla25-team22/model-service)

    Service responsible for hosting sentiment analysis model and providing predictions.
- [lib-version](https://github.com/remla25-team22/lib-version)

    Library used to indicate front-end version.
- [lib-ml](https://github.com/remla25-team22/lib-ml)

    Library used to indicate machine learning model version and containing preprocessing logic for model training & queries

