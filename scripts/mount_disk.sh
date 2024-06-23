DISK=/dev/$(lsblk -o UUID,NAME | grep -oP '(?<=38ce5e64-fe03-49cb-8c74-703ffecf24b0...)[^\n]+') && \
mount $DISK /mnt

