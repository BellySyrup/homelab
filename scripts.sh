#!/bin/bash

# updates nano and pacman to allow color/syntax highlighting and ups the number of parallel downloads to 20
sed -i 's:^# include "/usr/share/nano/\*.nanorc:include "/usr/share/nano/\*.nanorc:' /etc/nanorc
sed -i 's/^#Color = 5/Color/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 20/' /etc/pacman.conf

# get my custom samba share file to build new smb.conf, also create log file for samba
curl -o /etc/samba/smb.conf https://raw.githubusercontent.com/sconzen/homelab/main/smb.conf
mkdir -p /usr/local/samba/var && touch /usr/local/samba/var/log.smbd