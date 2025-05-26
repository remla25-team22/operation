# REMLA Project – Team 22

This repository contains the deployment and setup for our Restaurant Sentiment Analysis web application.

---

##  How to Start the Application

### Requirements
- Docker
- Docker Compose

### Running the application

1. Open terminal in operation (this folder)
2. Run `docker compose up`
3. Using any browser, navigate to [http://localhost:8080/index.html](http://localhost:8080/index.html)
4. Insert a review into the text box (i.e. "The selection on the menu was great and so were the prics.")
5. Press send to get sentiment prediction

---

###  Running the Kubernetes Cluster (Assignment 2)

#### Prerequisites
- VirtualBox
- Vagrant
- Ansible

#### Starting the cluster

```bash
vagrant up --provision
```

This will:
- Create one controller VM (`ctrl`)
- Create multiple worker VMs (`node-1`, `node-2`, ...)
- Run Ansible playbooks to provision the full cluster

#### Reprovision the cluster

```bash
vagrant provision
```

#### Stop the cluster

```bash
vagrant halt
```

#### Destroy all VMs

```bash
vagrant destroy -f
```

---

###  SSH Access

After provisioning, each team member can SSH into any VM using their registered SSH key:

#### Student 1 (from host machine):

```bash
ssh -i ~/.ssh/student1 vagrant@192.168.56.100
```

#### Student 2:

```bash
ssh -i ~/.ssh/student2 vagrant@192.168.56.101
```

> For more nodes, replace the IP with the correct node (`192.168.56.102`, etc.)

 No password is required if the public key is registered.

---


##  Project Structure & Pointers

This repository contains:

- `docker-compose.yml`: Brings up the app and model-service containers
- `Vagrantfile`: Provisions Kubernetes-ready VMs using VirtualBox
- `playbooks/`: Ansible playbooks to configure all VMs
- `templates/hosts.j2`: Jinja2 template for dynamic /etc/hosts generation
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

## Assignment Progress Log

### Assignment 1 – Versions, Releases, and Containerization

- All required repositories created in the team GitHub organization
- `lib-ml` and `lib-version` are implemented, versioned via `VERSION.txt`, and installable through GitHub tag
- Training script uses `lib-ml` for preprocessing; model is saved and versioned, and its tag is passed as an environmental variable
- `model-service` serves a trained model using a REST API
- `app` queries the model-service and uses `lib-version` to show version info
- GitHub Actions workflows created
- Docker Compose file allows the full system to be deployed locally

Each repository includes a `README.md`, tagged release, and is public for peer review.

---

### Assignment 2 – Provisioning a Kubernetes Cluster

- Created a scalable and configurable `Vagrantfile` using a loop, variables for CPU/memory, and fixed IPs for each VM.
- Defined 1 controller node (`ctrl`) and 2 worker nodes (`node-1`, `node-2`) on a host-only network (`192.168.56.X`) with full VM-to-VM and host connectivity.
- Wrote a general Ansible playbook (`general.yaml`) to:
  - Disable swap and remove `/etc/fstab` entries
  - Load required kernel modules (`br_netfilter`, `overlay`)
  - Set sysctl values for Kubernetes networking (`ip_forward`, `bridge-nf-call-*`)
  - Register multiple students' SSH keys using a loop over the `ssh_keys/` folder
- Used a dynamic Jinja2 template (`hosts.j2`) to generate `/etc/hosts` based on the number of worker nodes passed via `ansible.extra_vars`
- Ensured provisioning is idempotent and completes in under 5 minutes.
- Successfully implemented and validated all provisioning tasks through step 19 of the assignment.
---

### Assignment 3 – Kubernetes Services and Monitoring

- Migrated from Docker Compose to Kubernetes using Helm.
- Prometheus and Grafana have been integrated for monitoring; dashboards are available in the `dashboards/` folder.

#### 1. Finalize the Cluster Setup

Run the following playbook:

```bash
ansible-playbook -i inventory.cfg playbooks/finalization.yml --limit ctrl
```

This deploys MetalLB, NGINX Ingress, Istio, Prometheus, Grafana, and the Kubernetes Dashboard.

---

#### 2. Deploy the Application to Kubernetes

SSH into the controller node and install the Helm chart:

```bash
vagrant ssh ctrl
cd /vagrant
helm install my-app ./app
```

---

#### 3. Set Local Host Entries

To make local domain names work, run this command on your host machine:

```bash
echo -e "192.168.56.121 app.local
192.168.56.121 dashboard.local
192.168.56.121 grafana.local
192.168.56.121 prometheus.local" | sudo tee -a /etc/hosts
```

---

#### 4. Access the Services

-  App Frontend: [https://app.local/index.html](https://app.local/index.html)
-  Grafana: [https://grafana.local](https://grafana.local)
-  Prometheus: [https://prometheus.local](https://prometheus.local)
-  Kubernetes Dashboard: [https://dashboard.local](https://dashboard.local)

> **Dashboard Login Token**: The token is printed at the end of the `finalization.yml` playbook.  
> If needed, SSH into the controller VM and regenerate it with:
>
> ```bash
> kubectl -n kubernetes-dashboard create token admin-user
> ```





### Assignment 4 – ML Configuration Management and Testing


#### ML Configuration Management

- The `model-training` project has been refactored into a modular, Cookiecutter-inspired structure with clearly separated stages: data preparation, training, evaluation, and prediction.
- A complete DVC pipeline is defined using `dvc.yaml`, allowing full reproducibility via `dvc repro`.
- Model performance is logged to `metrics.json`, and DVC tracks experiments and metrics using `dvc exp show`.
- Remote dataset support is built-in — if the raw data is not present locally, it is downloaded from a remote URL in `data_prep.py`.
- The pipeline includes:
  - `data_prep.py`: Cleans and prepares text data
  - `train.py`: Trains a Naive Bayes model and serializes it with joblib
  - `evaluate.py`: Evaluates the model and writes metrics
  - `predict.py`: Accepts custom review input and predicts sentiment interactively. to run it:
    ```bash
    python -m src.predict
    ```

- A virtual environment is used with a `requirements.txt` including all necessary packages like `dvc`, `scikit-learn`, `pylint`, `pytest`, `coverage`, `bandit`, etc.
- A `.gitignore` has been added to exclude cache, venv, model artifacts, DVC files, and IDE/config files.
- Testing and CI setup is ongoing:
  - Unit and metamorphic tests will be added in `tests/`
  - Linting and test coverage will be integrated using GitHub Actions


#### Testing 

The table summarizes the implemented tests.
| Category                 | Test Description                                                                 |
|--------------------------|----------------------------------------------------------------------------------|
| **Feature & Data Integrity** | - Dataset contains `Review` column<br>- No empty reviews                    |
| **Model Development**       | - Model predicts correct output shape for multiple inputs                   |
| **ML Infrastructure**       | - Required model files exist (`BoW`, classifier)                             |
| **Monitoring**              | - Predictions are within valid range `{0, 1}`                                |
| **Mutamorphic Testing**     | - Synonyms and paraphrases produce consistent predictions                   |
| **Non-functional Requirements** | - Model inference takes < 0.5 seconds per input                        |
Continuous Training part has not been implemented yet. Tests can be run with pytest `tests/test_main.py` inside the `model-training` repository. 


##  Activity Log

See [ACTIVITY.md](./ACTIVITY.md) for individual PR links, and approvals.


---

