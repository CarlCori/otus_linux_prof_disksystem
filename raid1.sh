sudo lshw -short | grep disk
sudo fdisk -l
sudo mdadm --create /dev/md0 --level=6 --raid-devices=5 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
#echo "DEVICE partitions" | sudo tee /etc/mdadm.conf
#sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf
sudo mdadm --detail /dev/md0
#sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/raid
#sudo mount /dev/md0 /mnt/raid
sleep 60
#echo "/dev/md0 /mnt/raid ext4 defaults 0 0" | sudo tee -a /etc/fstab
df -h /mnt/raid
sudo mdadm --detail /dev/md0
sudo cat /proc/mdstat
sudo parted -s /dev/md0 mklabel gpt
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
for i in $(seq 1 5); do echo "/dev/md0p$i /raid/part$i ext4 defaults 0 0" >> /etc/fstab; done
