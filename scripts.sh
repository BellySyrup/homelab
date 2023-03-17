#!/bin/bash

# Must haves for simple homelab
# docker 
#   jellyfin/jellyfin
#   doitandbedone/ispyagentdvr
#   mrlt8/wyze-bridge:latest
# neofetch 
# samba
# openssh
# nano


# updates nano and pacman to allow color/syntax highlighting and ups the number of parallel downloads to 20
sed -i 's:^# include "/usr/share/nano/\*.nanorc:include "/usr/share/nano/\*.nanorc:' /etc/nanorc
sed -i 's/^#Color = 5/Color/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 20/' /etc/pacman.conf

# get my custom samba share file to build new smb.conf, also create log file for samba
curl -o /etc/samba/smb.conf https://raw.githubusercontent.com/sconzen/homelab/main/smb.conf
mkdir -p /usr/local/samba/var && touch /usr/local/samba/var/log.smbd

# add to /etc/fstab to auto mount clone, docker, vault and security drives
/dev/disk/by-uuid/dd9e4db9-165f-450f-98f2-1e2cbe66896d /mnt/clone auto nosuid,nodev,nofail,x-gvfs-show 0 0
/dev/disk/by-uuid/9bb6a526-a61e-46d6-a98f-0b66fde96593 /mnt/docker auto nosuid,nodev,nofail,x-gvfs-show 0 0
/dev/disk/by-uuid/473659bd-4280-48b4-81db-7e7fac92f10f /mnt/vault auto nosuid,nodev,nofail,x-gvfs-show 0 0
/dev/disk/by-uuid/df2d6fab-02f6-467b-a74b-c4c647125145 /mnt/security auto nosuid,nodev,nofail,x-gvfs-show 0 0

# use NetworkManager to list all wifi networks and then connect to network
nmcli device wifi list
nmcli device wifi connect SSID password PASSWORD

# Docker permission check
# groupadd docker typically already exists hence ; add $USER to docker group and refresh
sudo groupadd docker ; sudo usermod -aG docker $USER && newgrp docker
sudo systemctl start docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Custom bashrc additions
# Custom command prompt
# alias for lsblk and dps -> a custom docker ps layout
add to ~/.bashrc # ~ $
  PS1="\[\033[036m\]\w \[\033[00m\]\$ "
  alias lsblk='lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS'
  alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.State}}\t{{.Status}}"'

add to ~/.bashrc for root # root ~ $
  PS1="\[\e[01;31m\]\u \[\e[00m\]\w $ "
  alias lsblk="lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS"
  alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.State}}\t{{.Status}}"'