Ansible playground
==================

`Debian:stretch` based ansible playground. Spawn containers, allow passwordless root login for fun.

Scripts assume your public key is located at `$HOME/.ssh/id_rsa.pub`. Have fun.

## Build image

`bin/build`

```
Sending build context to Docker daemon  7.168kB
Step 1/6 : FROM debian:stretch
 ---> 2b98c9851a37
Step 2/6 : RUN apt-get update && apt-get install -y openssh-server
 ---> Using cache
 ---> 8be2a9865b70
Step 3/6 : RUN mkdir /var/run/sshd
 ---> Using cache
 ---> e932f211fb8e
Step 4/6 : RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
 ---> Using cache
 ---> a6bb7fedf882
Step 5/6 : EXPOSE 22
 ---> Using cache
 ---> 3805c1a41181
Step 6/6 : CMD ["/usr/sbin/sshd", "-D"]
 ---> Using cache
 ---> 2b8703296660
Successfully built 2b8703296660
Successfully tagged eg_sshd:latest
```

## Spawn containers

`bin/up 5`

```
sshd_1 - 22/tcp -> 0.0.0.0:32800
sshd_2 - 22/tcp -> 0.0.0.0:32801
sshd_3 - 22/tcp -> 0.0.0.0:32802
sshd_4 - 22/tcp -> 0.0.0.0:32803
sshd_5 - 22/tcp -> 0.0.0.0:32804
```

`docker ps`

```
CONTAINER ID        IMAGE               COMMAND               CREATED             STATUS              PORTS                   NAMES
72e95f32352e        eg_sshd             "/usr/sbin/sshd -D"   17 seconds ago      Up 15 seconds       0.0.0.0:32818->22/tcp   sshd_5
466fe1b99450        eg_sshd             "/usr/sbin/sshd -D"   19 seconds ago      Up 17 seconds       0.0.0.0:32817->22/tcp   sshd_4
5a07de62cd8b        eg_sshd             "/usr/sbin/sshd -D"   20 seconds ago      Up 18 seconds       0.0.0.0:32816->22/tcp   sshd_3
4474b5851ab4        eg_sshd             "/usr/sbin/sshd -D"   22 seconds ago      Up 20 seconds       0.0.0.0:32815->22/tcp   sshd_2
a0d25077424c        eg_sshd             "/usr/sbin/sshd -D"   24 seconds ago      Up 22 seconds       0.0.0.0:32814->22/tcp   sshd_1
```

## SSH into the container

Known host is added to `/dev/null` by the way so it won't spam your `known_hosts` file.

`bin/ssh 3`

```
Warning: Permanently added '[localhost]:32802' (ECDSA) to the list of known hosts.
Linux d1200bbb7e9b 4.4.0-119-generic #143-Ubuntu SMP Mon Apr 2 16:08:24 UTC 2018 x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.

root@d1200bbb7e9b:~#
```

## Destroy containers

`bin/destroy`

```
d1200bbb7e9b
4f3e602979cb
0d8c7824dee3
375202686b3d
3ed64b6c7474
```

## Dynamic Ansible inventory

Bash script fetches running container list and outputs list in Ansible's JSON format:

Example usage:

`ansible-playbook -i ansible/inventory playbook.yml`

Script output:

> {"Ansible":{"hosts":["78e45d91ae22.localhost","612ed77c432c.localhost","e3bb7c4a0fa9.localhost"]},"_meta":{"hostvars":{"78e45d91ae22.localhost":{"ansible_ssh_port":"32813","ansible_ssh_user":"root","ansible_connection":"ssh"},"612ed77c432c.localhost":{"ansible_ssh_port":"32812","ansible_ssh_user":"root","ansible_connection":"ssh"},"e3bb7c4a0fa9.localhost":{"ansible_ssh_port":"32811","ansible_ssh_user":"root","ansible_connection":"ssh"}}}}
