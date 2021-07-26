#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo apt-get update -y;
sudo apt-get install git binutils -y;
git clone https://github.com/aws/efs-utils;
cd efs-utils && ./build-deb.sh && sudo apt-get install ./build/amazon-efs-utils*deb -y && cd ..;
file_system_id=${efs_file_system_id};
efs_mount_point=/mnt/efs;
sudo mkdir $efs_mount_point;
sudo mount -t efs -o tls $file_system_id:/ $efs_mount_point;