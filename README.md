nrser.state_mate
================

installs the `state_mate` gem and provides the `state` Ansible module for
maintaining system state on OSX.

Version
-------

0.0.1

Requirements
------------

a Ruby version where the user you run Ansible as can install gems.

Role Variables
--------------

-   `state_mate_version`: version of the `state_mate` gem to install.

Dependencies
------------

none.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
        - role: nrser.state_mate
      tasks:
        - name: always show scrollbars
          state:
            defaults:
              key: NSGlobalDomain:AppleShowScrollBars
              set: Always

License
-------

BSD

Author Information
------------------

<https://github.com/nrser>
