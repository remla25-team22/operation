WORKER_COUNT = 2
WORKER_CPUS = 2
WORKER_RAM = 6144

CTRL_CPUS = 1
CTRL_RAM = 4096

NET_PREFIX = "192.168.56"

Vagrant.configure("2") do |config|
  NET_PREFIX  = "192.168.56"
  CTRL_RAM    = 4096
  CTRL_CPUS   = 2
  WORKER_COUNT = 2

  config.vm.box = "bento/ubuntu-24.04"

  config.vm.define "ctrl" do |ctrl|
    ctrl.vm.hostname = "ctrl"
    ctrl.vm.network  "private_network", ip: "#{NET_PREFIX}.99"

    ctrl.vm.provider "virtualbox" do |vb|
      vb.memory = CTRL_RAM
      vb.cpus   = CTRL_CPUS
    end

    # your real configuration playbook
    ctrl.vm.provision "ansible" do |ansible|
      ansible.playbook        = "playbooks/ctrl.yaml"
      ansible.inventory_path  = "inventory.cfg"
      ansible.extra_vars      = { worker_count: WORKER_COUNT }
    end
  end

  (1..WORKER_COUNT).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "#{NET_PREFIX}.#{100 + i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = WORKER_RAM
        vb.cpus = WORKER_CPUS
      end
      node.vm.provision "shell", inline: "sleep 10", run: "always"
      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbooks/node.yaml"
        ansible.inventory_path = "inventory.cfg"
        ansible.extra_vars = {
          worker_count: WORKER_COUNT
        }
      end
    end
  end
end
