# REMLA Project – Team 22

This repository contains the deployment and setup for our Restaurant Sentiment Analysis web application.

---

##  How to Start the Application

### Requirements
- Docker
- Docker Compose

### Running the application

(TODO)

The app-service will be available at: [http://localhost:8080](http://localhost:8080)

### Configuration Parameters (TODO)

| Variable             | Description                                          |
|----------------------|------------------------------------------------------|
| `APP_VERSION`        | Optional: can be printed via `lib-version`          |
| `MODEL_VERSION`      | Optional: fixed or dynamic depending on workflow     |

---

##  Project Structure & Pointers

This repository contains:

- `docker-compose.yml`: Brings up the app and model-service containers
- `README.md`: Overview of deployment setup and instructions
- `ACTIVITY.md`: Summary of individual team member GitHub contributions (PRs and approvals)

---

##  Related Repositories

| Component          | Repository                                                             |
|--------------------|------------------------------------------------------------------------|
| **App Frontend**            | [app-frontend](https://github.com/remla25-team22/app-frontend)                          |
| **App Service**            | [app-service](https://github.com/remla25-team22/app-service)                          |
| **Model Service**  | [model-service](https://github.com/remla25-team22/model-service)      |
| **Model Training** | [model-training](https://github.com/remla25-team22/model-training)    |
| **Preprocessing**  | [lib-ml](https://github.com/remla25-team22/lib-ml)                    |
| **Version Utility**| [lib-version](https://github.com/remla25-team22/lib-version)          |

---

## 📈 Assignment Progress Log

###  Assignment 1 – Versions, Releases, and Containerization

- All required repositories created in the team GitHub organization
- `lib-ml` and `lib-version` are implemented, versioned via `VERSION.txt`, and installable through GitHub tag
- Training script uses `lib-ml` for preprocessing; model is saved and versioned
- `model-service` serves a trained model using a REST API
- `app` queries the model-service and uses `lib-version` to show version info
- GitHub Actions workflows created:
- Docker Compose file allows the full system to be deployed locally

Each repository includes a `README.md`, tagged release, and is public for peer review.

---


##  Activity Log

See [ACTIVITY.md](./ACTIVITY.md) for individual contributions, PR links, and approvals.
