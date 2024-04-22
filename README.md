# rsyslog-formula

This Salt formula will install and configure the rsyslog system-logging service. It is expected that this automation will be executed as part of a larger SaltStack execution such as that performed when running [Watchmaker](https://watchmaker.readthedocs.io/).

This formula expects that any remote syslog servers' information will be stored in a site-specifica Pillar-configuration. See the pillar.example file for what the Pillar-structure should look like. If nothing appropriate is defined in Pillar, informational-output to that effect will be emitted.

Note: this formula currently only supports setting up an Rsyslog client for basic TCP- or UDP-based logging to a remote syslog server. If encryption and/or RELP are requested for a given remote syslog destination, the formula will emit a not-supported message and not attempt to configure an entry in /etc/rsyslog.d.
