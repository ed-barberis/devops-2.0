#!/bin/sh -eux

devops='
This system was built with the DevOps 2.0 project by Ed Barberis.
More information can be found at: https://github.com/ed-barberis/devops-2.0/

Use of this system is acceptance of the OS vendor EULA and License Agreements.'

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-devops'

    cat >> "$MOTD_CONFIG" <<DEVOPS
#!/bin/sh

cat <<'EOF'
$devops
EOF
DEVOPS

    chmod 0755 "$MOTD_CONFIG"
else
    touch /etc/motd
    chmod 0777 /etc/motd
    echo "$devops" >> /etc/motd
    chmod 0755 /etc/motd
fi
