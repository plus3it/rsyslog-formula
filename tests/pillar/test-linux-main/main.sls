rsyslog:
  lookup:
    remote_hosts:
      loghost-tcp.myhost.com:
        protocol: 'tcp'
        port: 514
        encrypted: false
        relp: false
      loghost-udp.myhost.com:
        protocol: udp
        port: 514
        encrypted: false
        relp: false
      loghost-tls.myhost.com:
        protocol: tcp
        port: 514
        encrypted: true
        relp: false
