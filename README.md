# SSH Auth Socket

Master: [![Build Status](https://travis-ci.org/ansible-city/ssh_auth_sock.svg?branch=master)](https://travis-ci.org/ansible-city/ssh_auth_sock)  
Develop: [![Build Status](https://travis-ci.org/ansible-city/ssh_auth_sock.svg?branch=develop)](https://travis-ci.org/ansible-city/ssh_auth_sock)

This role set's permissions to SSH_AUTH_SOCK file and folder to a given user.




## ansible.cfg

This role is designed to work with merge "hash_behaviour". Make sure your
ansible.cfg contains these settings

```INI
[defaults]
hash_behaviour = merge
pipelining = true
sudo_flags=-HE
```




## Installation and Dependencies

This role has no dependencies




## Tags

This role uses two tags: **build** and **configure**

* `build` - Installs ACL
* `configure` - configures access to ssh auth socket file.




## Examples

To simply add swap to your server:

```YAML
- name: SSH Auth
  hosts: sandbox

  pre_tasks:
    - name: Update apt
      become: yes
      command: apt-get update
      tags:
        - build

  roles:
    - role: ansible-city.ssh_auth_sock
      ssh_auth_sock:
        user: my_user
```
