yum-cron:
  notify-channel: 'smtp'

  update-behavior:
    el7:
      update-profile: 'default'
      update-message: 'yes'
      update-staging: 'yes'
      update-apply: 'no'
      update-hosntame:
      update-emitters: 'stio,email'
      email-from: 'patch-alerts'
      smtp-relay: 'localhost'
      addr-recipient: 'monitor@xyzzy.us'

  smtp:
    addr-sender: 'patch-alerts'
    sasl-user: 'AKIAI6P43B0SSZ5X4KBS'
    sasl-passwd: 'tlaL1djHIlteTjP3+zq8+EbsaPflYIL7drIFt70C5yuN'
    smart-relay: 'email-smtp.us-west-2.amazonaws.com'
    smart-relay-port: '587'
