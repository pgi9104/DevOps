Vagrant.configure("2") do |config|
 N=2
  config.disksize.size = '40GB'
  config.vm.boot_timeout = 3000
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/jammy64"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.hostname = "master"

    master.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 4
    end
    master.vm.provision "0", type: "shell", preserve_order: true, privileged: true, inline: <<-EOC
cat <<-'EOF' >/etc/modules-load.d/kubernetes.conf
br_netfilter
EOF

sudo swapoff -a
sudo ufw allow 6443
sudo modprobe br_netfilter

cat <<-'EOF' >/etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo apt-get update
sudo apt-get install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates tree

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install -y containerd.io

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

sudo snap install docker
sudo apt-get install -y net-tools
sudo apt-get install -y docker-compose
sudo usermode -aG docker $USER

sudo apt-get install cifs-utils -y
sudo apt-get install nfs-common -y

cat <<-'EOF' >/etc/default/kubelet
KUBELET_EXTRA_ARGS=--node-ip=192.168.56.10
EOF

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

OUTPUT_FILE=/vagrant/join.sh
rm -rf $OUTPUT_FILE
rm -rf /vagrant/.kube
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=192.168.56.10 --apiserver-advertise-address=192.168.56.10
sudo kubeadm token create --print-join-command > $OUTPUT_FILE
chmod +x $OUTPUT_FILE

mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
cp -R $HOME/.kube /vagrant/.kube
cp -R $HOME/.kube /home/vagrant/.kube
sudo chown -R vagrant:vagrant /home/vagrant/.kube
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
kubectl completion bash >/etc/bash_completion.d/kubectl
echo 'alias k=kubectl' >>/home/vagrant/.bashrc

kubectl apply -f https://docs.projectcalio.org/manifests/canal.yaml

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

source <(helm completion bash)
echo "source <(helm completion bash)">>~/.bashrc
    EOC
  end

  (1..N).each do |i|
    config.disksize.size = '50GB'
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = "ubuntu/jammy64"
      worker.vm.network "private_network", ip: "192.168.56.1#{i}"
      worker.vm.hostname = "worker#{i}"
      worker.vm.provider "virtualbox" do |v|
        v.memory = 8192
        v.cpus = 4
      end

      worker.vm.provision "0", type: "shell", preserve_order: true, privileged: true, inline: <<-EOC
cat <<-'EOF' >/etc/modules-load.d/kubernetes.conf
br_netfilter
EOF

sudo swapoff -a
sudo ufw allow 6443
sudo modprobe br_netfilter

cat <<-'EOF' >/etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo apt-get update
sudo apt-get install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates tree

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install -y containerd.io
sudo apt-get install net-tools -y

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

cat <<-'EOF' >/etc/default/kubelet
KUBELET_EXTRA_ARGS=--node-ip=192.168.56.1#{i}
EOF

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo apt-get install -y docker.io net-tools
sudo apt-get install -y docker-compose
sudo usermode -aG docker $USER
sudo apt-get install cifs-utils -y
sudo apt-get install nfs-common -y

sudo /vagrant/join.sh
      EOC
    end
  end
end