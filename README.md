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

---

##  Activity Log

See [ACTIVITY.md](./ACTIVITY.md) for individual contributions, PR links, and approvals.


---

