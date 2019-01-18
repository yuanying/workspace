#!/bin/bash

set -e

mkdir -p /home/$USER/.ssh && \
    curl -fsL https://github.com/$GITHUB_USER.keys > /home/$USER/.ssh/authorized_keys && \
    chown -R dev:dev /home/$USER/.ssh \
    chmod 700 /home/$USER/.ssh && \
    chmod 600 /home/$USER/.ssh/authorized_keys

/usr/sbin/sshd -D
