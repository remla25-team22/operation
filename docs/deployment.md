# Deployment Documentation
This document describes deployment architecture of this system, describing services, routing and Kubernetes & istio setup.



## First Party Repositories
The system relies on five first party components:

- [app-service](https://github.com/remla25-team22/app-service)
    
    Service responsible for hosting front-end page and handling front-end requests.
- [model-service](https://github.com/remla25-team22/model-service)

    Service responsible for hosting sentiment analysis model and providing predictions.
- [model-training](https://github.com/remla25-team22/model-training)

    Application responsible for training, evaluating and providing the sentiment analysis model used in `model-training`.

- [lib-version](https://github.com/remla25-team22/lib-version)

    Library used to indicate front-end version.
- [lib-ml](https://github.com/remla25-team22/lib-ml)

    Library used to indicate machine learning model version and containing preprocessing logic for model training & queries

## System Architecture
This system consists of a microservice architecture which is deployed on a kubernetes cluster, provisioned using Vagrant and Ansible. Services are deployed to the kubernetes cluster using Helm. 

The following services are deployed to the kubernetes cluster:

- `app-service`: Service handling front-end logic, hosting a web page and passing user input to `model-service`.

- `model-service`: Service exposing the sentiment analysis model.

- `Prometheus`: Service collecting application metrics for monitoring and alerting purposes.

- `Grafana`: Platform visualizing metrics collected from `Prometheus`.

- `Istio Service Mesh`: Routes internal and external requests. 
    Makes use of `IngressGateway`, `VirtualService`, and `DestinationRule` to support canary deployment.

The following image visually describes the afformentioned system architecture:

![cluster layout](img/cluster-diagram.png)


## Helm deployment
A Helm chart is used to deploy the `app-service` and `model-service` to the kubernetes cluster, as described in the [previous section](#system-architecture). 

The `Prometheus` and `Grafana` services are deployed during provisioning using ansible, and are therefore pre-set in the cluster. 

The [values file](../app/values.yaml) describes the versions for both the `app-service` and `model-service` which are to be deployed. The current setup defines both a v1 and v2 to be deployed for both serivces.


## Istio Service Mesh 
The istio serivce mesh is configured separate from the Helm chart, and performs the following roles:

- **Ingress management**
    
    A `IngressGateway` is deployed to expose the `app-service` to the outside of the cluster.

- **Routing**
    
    Traffic is routed through a `VirtualService` to split incoming traffic into a 90/10 split between `app-service` `v1` and `v2`. 

- **Sticky Sessions**

    To ensure a users requests are consistently routed to the same app and model version, sticky sessions are ensured through Istio.

## Request flow

1. An incoming (external) request enters the cluster through the Istio defined `Ingress Gateway`
2. Istio routes the request via a `Virtual Service` to `app-service v1` or `app-sesrvice v2` based on canary rules with a 90/10 split
3. Sticky sessions are used to ensure consistent routing per user
4. The `app-service` forwards incoming requests to the corresponding `model-service` (either `v1` or `v2`, based on `app-service` version)
5. `app-service` serves the response from `model-service` to the user

![Traffic flow](img/traffic-diagram.png)


## Monitoring

### Prometheus
The `app-service` reports metrics and telemetry data to the Prometheus service, which stores the data for monitoring and visualisation purposes.

### Grafana
To visualize data collected by Prometheus, Grafana is deployed to the cluster.  
