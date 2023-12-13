# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "demo"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "shell", inline: $script
end

$script = <<SCRIPT
  yum upgrade
  yum update
  yum -y install epel-release
  #엔진X 설치
  yum -y install nginx
  #앤서블 설치
  yum -y install ansible
  #도커 설치
  yum -y install docker
  systemctl enable docker
  #git 설치
  yum -y install git
  #도커 컴포즈
  curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-uname -s -uname -m > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  #쿠버네티스
  CNI_PLUGINS_VERSION="v1.1.1"
  ARCH="amd64"
  DEST="/opt/cni/bin"
  mkdir -p "$DEST"
  curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_PLUGINS_VERSION}/cni-plugins-linux-${ARCH}-${CNI_PLUGINS_VERSION}.tgz" | sudo tar -C "$DEST" -xz
  DOWNLOAD_DIR="/usr/local/bin"
  mkdir -p "$DOWNLOAD_DIR"
  CRICTL_VERSION="v1.25.0"
  ARCH="amd64"
  curl -L "https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-${ARCH}.tar.gz" | sudo tar -C $DOWNLOAD_DIR -xz
  RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
  ARCH="amd64"
  cd $DOWNLOAD_DIR
  curl -L --remote-name-all https://dl.k8s.io/release/${RELEASE}/bin/linux/${ARCH}/{kubeadm,kubelet,kubectl}
  chmod +x {kubeadm,kubelet,kubectl}

  RELEASE_VERSION="v0.4.0"
  curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service" | sed "s:/usr/bin:${DOWNLOAD_DIR}:g" | sudo tee /etc/systemd/system/kubelet.service
  mkdir -p /etc/systemd/system/kubelet.service.d
  curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf" | sed "s:/usr/bin:${DOWNLOAD_DIR}:g" | sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
  systemctl enable --now kubelet
SCRIPT