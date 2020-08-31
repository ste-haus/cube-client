# Configuration

## Ansible setup
1. Install ansible
2. Generate an SSH key for ansible to use in `./ssh` using `ssh-keygen`

## Client setup
1. Install base OS
2. Create `ansible` user 
3. Add `ansible` user to sudoers
4. Enable passwordless sudo
    1. Using `visudo`:
        * Replace: `%sudo  ALL=(ALL:ALL) ALL`
        * With: `%sudo  ALL=(ALL:ALL) NOPASSWD: ALL`
    2. Without fear:
        * `sed -i "s/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=(ALL:ALL) NOPASSWD: ALL/g" /etc/sudoers`
5. Copy the public part of your ansible ssh key to `/home/ansible/.ssh/authorized_keys`
    1. Set the `.ssh` directory permissions:
        * `chown 700 /home/ansible/.ssh`
    2. Set the `authorized_keys` directory permissions:
        * `chown 600 /home/ansible/.ssh/authorized_keys`
6. Run the playbook: 
    1. Against all hosts: `ansible-playbook cube-client.yml`
    2. Against a single host: `ansible-playbook cube-client.yml -l cube-XXXX`
7. Sometimes some `gsettings` configurations won't be properly applied if the `cube` user hasn't been logged in - in that case, repeat Step 6.
