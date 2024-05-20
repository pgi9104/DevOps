NFS_SERVER=192.168.56.20
NFS_PATH=/home/vagrant/nfs_shared

sudo helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
sudo helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=$NFS_SERVER \
    --set nfs.path=$NFS_PATH


