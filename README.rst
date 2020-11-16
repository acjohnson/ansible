ansible
#######

Table of Contents
*****************

* `Description <#description>`__

 - `Requirements <#requirements>`__

*  `Usage <#usage>`__


Description
***********

Simple ansible roles and playbooks I've created for various personal projects

Requirements
============

Create a virtualenv, you could use something like ``pyenv`` if you'd prefer

.. code-block:: bash

  # virtualenv -p $(which python3) venv
  # source venv/bin/activate

Install ansible

.. code-block:: bash

  # pip install ansible

Install dependent roles

.. code-block:: bash

  # ansible-galaxy install -r requirements.yml -p ./roles

Usage
*****

docker-pulsar
=============

- You will need 3 x 4GB VMs at a minimum with root ssh keys installed and configured
- Swap out the IP addresses in ``inventories/pulsar``
- Review the defaults in ``group_vars/pulsar.yml`` and adjust if needed

**Note**: All pulsar related configuration templates live in ``roles/configure_container/templates``

- Run the ``playbook_pulsar.yml`` playbook against all 3 nodes (The playbook will fail to run if you run it against a single node)
**Note**: Use ``bootstrap_pulsar_zookeeper=true`` only when creating a brand new and empty pulsar cluster

.. code-block:: bash

  # ansible-playbook -i inventories/pulsar -e "bootstrap_pulsar_zookeeper=true" --limit pulsar playbook_pulsar.yml

Uninstall pulsar
================
If you would like to start over and recreate the pulsar containers run this *VERY DESTRUCTIVE* command
which will delete everything except for the very large pulsar docker image...

.. code-block:: bash

  # ansible pulsar -i inventories/pulsar -m shell -b -a 'docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q); rm -rf /docker'

You can now re-run ``playbook_pulsar.yml`` to deploy a new pulsar cluster

ffmpeg media video optimizer
============================
Run the ``playbook_ffmpeg.yml`` playbook to scan a directory of video files (eg. Movies or TV Shows)
and then have it automatically transcode the file to a smaller more stream friendly format (I use emby-server but could be useful for Plex as well)

.. code-block:: bash

  # ansible-playbook -i localhost, playbook_ffmpeg.yml

DIY Email server
================

You can use the ``playbook_mailserver.yml`` playbook to configure an all-in-one
email server with the following components:

- postfix (smtp/mta)
- dovecot (mailboxes/imap)
- denyhosts (ssh/imap tarpit)
- roundcube (webmail)
- spamassassin
- nginx
- php-fpm 

To use, set your desired defaults in ``group_vars/all`` and run ansible-playbook locally
on your future email server like so:

.. code-block:: bash

  # ansible-playbook -i localhost, playbook_mailserver.yml

Email users are standard local POSIX accounts combined with
the postfix virtual mail map and can be added by simply running:

.. code-block:: bash

  # adduser <username> --no-create-home

Then add an entry to the virtual map:

.. code-block:: bash

  # vim /etc/postfix/virtual.map
  # postmap /etc/postfix/virtual.map
  # systemctl reload postfix

Or better yet, add it to our ansible virtual.map.j2
template and rerun ``playbook_postfix.yml``

.. code-block:: bash

  # ansible-playbook -i localhost, playbook_postfix.yml

Once the user connects to the imap server, verify the mailbox location now exists:

.. code-block:: bash

  # ls -l /home/vmail
