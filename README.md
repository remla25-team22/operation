# REMLA Project – Team 22

This repository contains the deployment and setup for our Restaurant Sentiment Analysis web application.

---

##  How to Start the Application

### Requirements
- Docker
- Docker Compose

### Running the application

1. Open terminal in the operation (this folder)
2. Run `docker compose up`
3. Using any browser, navigate to [http://localhost:8080/index.html](http://localhost:8080/index.html)
4. Insert a review into the text box (i.e. "The selection on the menu was great and so were the prices.")
5. Press send to get sentiment prediction and give feedback.
   

---

###  Running the Kubernetes Cluster (Assignment 2)

#### Prerequisites
- VirtualBox
- Vagrant
- Ansible


All commands related to starting, stopping and provisioning the cluster are to be executed from within the `provisioning` directory. Before exectuing the following commands, change the current directory to the `provisioning` directory using the following command:

```bash
cd ./provisioning
```

#### Starting the cluster

```bash
vagrant up --provision

```
or if you have limited cources:
```bash
vagrant up --no-parallel
```

This will:
- Create one controller VM (`ctrl`)
- Create multiple worker VMs (`node-1`, `node-2`, ...)
- Run Ansible playbooks to provision the full cluster

> Troubleshooting VirtualBox Network Issues

If you encounter errors related to VM networking, static IP assignment, or unreachable VMs (e.g., `ssh: connect to host 192.168.56.100 port 22: No route to host`), it's likely due to broken or conflicting VirtualBox host-only network adapters.

To **automatically fix this**, run the provided script:

```bash
cd provisioning
chmod +x fix_virtualbox_hostonly.sh
./fix_virtualbox_hostonly.sh
```

After running the script, you can restart your provisioning:

```bash
vagrant destroy -f
rm -rf .vagrant
vagrant up --no-parallel
```

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
ssh -i ~/.ssh/student1 vagrant@192.168.56.101
```

#### Student 2:

```bash
ssh -i ~/.ssh/student2 vagrant@192.168.56.102
```

> For more nodes, replace the IP with the correct node (`192.168.56.102`, etc.)

 No password is required if the public key is registered. Without a registered ssh key a password is required, the default password set by vagrant is `vagrant`.


---

##  Project Structure & Pointers

This repository contains:

- `docker-compose.yml`: Brings up the app and model-service containers
- `provisioning/Vagrantfile`: Provisions Kubernetes-ready VMs using VirtualBox
- `provisioning/playbooks/`: Ansible playbooks to configure all VMs
- `provisioning/templates/hosts.j2`: Jinja2 template for dynamic /etc/hosts generation
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

- Create a scalable and configurable `Vagrantfile` using a loop, variables for CPU/memory, and fixed IPs for each VM.
- Define 1 controller node (`ctrl`) and 2 worker nodes (`node-1`, `node-2`) on a host-only network (`192.168.56.X`) with full VM-to-VM and host connectivity.
- Write a general Ansible playbook (`general.yaml`) to:
  - Disable swap and remove `/etc/fstab` entries
  - Load required kernel modules (`br_netfilter`, `overlay`)
  - Set sysctl values for Kubernetes networking (`ip_forward`, `bridge-nf-call-*`)
  - Register multiple students' SSH keys using a loop over the `ssh_keys/` folder
- Use a dynamic Jinja2 template (`hosts.j2`) to generate `/etc/hosts` based on the number of worker nodes passed via `ansible.extra_vars`
- Ensure provisioning is idempotent and completes in under 5 minutes.
- Successfully implemented and validated all provisioning tasks.
- Finalize the Cluster Setup using: 

```bash
ansible-playbook -i inventory.cfg playbooks/finalization.yml --limit ctrl
```

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

Run the following commands to update the environmental variable and install the Helm chart:

```bash
export KUBECONFIG=./admin.conf
helm upgrade --install my-app ../app -f ../app/values-simple.yaml -f ../app/values-grafana.yaml
```

---

#### 3. Set Local Host Entries

To make local domain names work, run this command on your host machine:

```bash
echo -e "192.168.56.92 app.local
192.168.56.91 dashboard.local
192.168.56.91 grafana.local
192.168.56.91 prometheus.local" | sudo tee -a /etc/hosts
```
NOTE: The reason why the 192.168.56.92 has an ip ending with 92 while the rest with 91 is that the former is bound to the Istio gateway while the rest to the ingress controller.


---

#### 4. Access the Services

-  App Frontend: [https://app.local/index.html](https://app.local/index.html)
-  Grafana: [https://grafana.local](https://grafana.local)
-  Prometheus: [https://prometheus.local](https://prometheus.local)
-  Kubernetes Dashboard: [https://dashboard.local](https://dashboard.local)

Grafana can be accessed using `admin` for both username and password, dasboards are loaded in automatically.

> **Dashboard Login Token**: The token is printed at the end of the `finalization.yml` playbook.  
> If needed, SSH into the controller VM and regenerate it with:
>
> ```bash
> kubectl -n kubernetes-dashboard create token admin-user
> ```
---





### Assignment 4 – ML Configuration Management and Testing


#### ML Configuration Management

- The `model-training` project has been refactored into a modular, Cookiecutter-inspired structure with clearly separated stages: data preparation, training, evaluation, and prediction.
- A complete DVC pipeline is defined using `dvc.yaml`, allowing full reproducibility via `dvc repro`.
- Model performance is logged to `metrics.json`, and DVC tracks experiments and metrics using `dvc exp show`.
- Remote dataset support is built-in — if the raw data is not present locally, it is downloaded from a remote URL (google drive folder) in `data_prep.py`.
- The pipeline includes:
  - `data_prep.py`: Cleans and prepares text data
  - `train.py`: Trains a Naive Bayes model and serializes it with joblib
  - `evaluate.py`: Evaluates the model and writes metrics
  - `predict.py`: Accepts custom review input and predicts sentiment interactively. to run it:
    ```bash
    python -m src.predict
    ```
- Exploratory code is kept in a notebooks folder, production code is kept in src/model-training
- The model is packaged and automatically published via Github Releases when pushed as a tag.
- The project applies `pylint` and `flake8` linters with non-default configurations (see files .pylintrc and setup.cfg).


#### Testing 

The table summarizes the implemented tests.

| **ML‐Test-Score Category**       | **ID**   | **Test Name (PyTest marker)**                      | **What it checks**                                                                                                                                                                                                 |
|----------------------------------|----------|----------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Feature & Data Integrity**     | FD-1     | `test_data_invariants`                             | Verifies that dataset contains the correct columns (`cleaned`, `Liked`), with proper values.                                                               |
|                                  | FD-2     | `test_feature_benefit_by_coefficients`             | Checks that ≥ 80% of Vectorizer features have significant coefficients (abs > 1e-3).                                                                                        |
| **Model Development**            | ML-5     | `test_simpler_model_not_better`                    | Ensures the trained model outperforms a majority-class baseline by at least 5 percentage accuracy                                                                                      |
|                                  | ML-6     | `test_negation_slice_accuracy`                     | Confirms at least 70% accuracy on reviews containing cleaned negation words (e.g., *not*, *never*).                                                                 |
| **ML Infrastructure**            | INF-1    | `test_determinism`                                 | Runs training five times with different seeds; all must reach ≥ 70% accuracy, proving model stability.                                                                                                  |
|                                  | INF-3 (a)| `test_full_dvc_pipeline`                           | Full DVC pipeline integration test: verifies the `prepare → train → evaluate` stages produce expected outputs without errors.                                                                                      |
|                                  | INF-3 (b)| `test_predict_function`                            | Succeeds if `predict` function returns either "positive" or "negative".                                                                                                             |
|                                  | INF-4    | `test_synonym_swap_invariance`                     | Swaps cleaned synonyms (e.g., *good*→*fine*) in test samples and ensures ≥ 85% output consistency.                                                            |
| **Monitoring / Non-functional**  | MON-6    | `test_inference_memory_under_500mb`                | Measures peak RAM usage during inference on test data - must stay below 500 MB.                                                                                           |
Test adequacy and coverage is measured and reported on the terminal when running the tests, also in the workflow execution.

#### Setup  

To run the tests locally, first clone the [model-training](https://github.com/remla25-team22/model-training) repo and run the following commands:

```
cd model-training
pip install -r requirements.txt
pip install -e .
```
Install the files:

```
cd ./.dvc && ./gdrive-access.sh
dvc pull
```
Run the tests:

```
pytest --cov=src --cov-report=term-missing
pylint src
flake8 src
```


---

### Assignment 5 – Continuous Experimentation & Istio Service Mesh

#### Traffic Management with Istio

- Enabled Istio sidecar injection for the `default` namespace.
- Two versions (`v1`, `v2`) of both `app-service` and `model-service` have been deployed to simulate a canary release scenario.
- Each deployment is labeled with `version: v1` and `version: v2` respectively.
- Created the following Istio configuration files in the `istio/` folder:
  - `gateway.yaml`: Defines an Istio `Gateway` to expose the app externally.
  - `virtual-service.yaml`: Routes a portion of traffic to the `v2` services (e.g. 90% to v1, 10% to v2).
  - `destination-rule.yaml`: Defines routing rules per version for sticky sessions.
- Used sticky session routing via headers to ensure consistent user experience (e.g., based on `user` header).
- Used curl to test traffic splitting and verify routing behavior.

> Deploy the app as explained previously then Apply istio.


#### Traffic Management with Istio - NEW VERSION


- Enabled Istio sidecar injection for the `default` namespace.
- Two versions (`v1`, `v2`) of both `app-service` and `model-service` have been deployed and synchronized to simulate a canary release scenario.
- Each deployment is labeled with `version: v1` and `version: v2`.
- `app/values-canary.yaml` contains configuration variables for virtual services (90% traffic to v1, 10% traffic to v2), destination rules, and related configurations.
- Sticky session has not been implemented.

Use the following command to deploy the application with the specified settings:

```
helm upgrade --install my-app ../app -f ../app/values-canary.yaml -f ../app/values-grafana.yaml
```

#### Additional Use Case

- Shadow launch has been implemented
- 2 versions of `model-service` are deployed, v2 is merely used for mirroring

Use the following commands for the deployment of the app with the specified settings
```
helm upgrade --install my-app ../app -f ../app/values-shadow.yaml -f ../app/values-grafana.yaml
```
#### Continuous Experimentation

Details can be found in docs/continous-experimentation.md
```
helm upgrade --install my-app ../app -f ../app/values-exp.yaml -f ../app/values-grafana.yaml
```

#### Testing

Testing can be done through accessing swagger through http://app.local/swagger/index.html

##  Activity Log

See [ACTIVITY.md](./ACTIVITY.md) for individual PR links, and approvals.


---

