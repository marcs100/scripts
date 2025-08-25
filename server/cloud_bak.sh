#!/bin/bash
rclone sync /var/data-store mega:vault-tec-mega
rclone sync /var/lib/docker/volumes/vault-tec_nc-data/_data/marc/files  mega:vault-tec-mega
