ansible
#######

Table of Contents
*****************

* `Description <#description>`__

 - `Requirements <#requirements>`__

*  `Usage <#usage>`__


Description
***********

Simple ansible roles and playbooks I created to migrate my email server from Debian 8 -> 9

Requirements
============

Usage
*****

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
