Puppet ISC dhcp module
======================

Templated puppet class to allow for the definition of a dhcp service.

# WARNING

When adding this Puppet module as a git submodule, graft it as `isc_dhcp`.

This will avoid scope issues such as:

    Error 400 on SERVER: left operand of - is not a number at ...
