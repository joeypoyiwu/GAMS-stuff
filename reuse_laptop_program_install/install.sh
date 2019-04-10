#!/bin/bash


#installs JumpCloud

MacOSMinorVersion=$(sw_vers -productVersion | cut -d '.' -f 2)
MacOSPatchVersion=$(sw_vers -productVersion | cut -d '.' -f 3)

if [[ $MacOSMinorVersion -lt 13 ]]; then
    echo "Error:  Target system is not on macOS 10.13"
    exit 2
else

curl --silent --output /tmp/jumpcloud-agent.pkg "https://s3.amazonaws.com/jumpcloud-windows-agent/production/jumpcloud-agent.pkg" > /dev/null
mkdir -p /opt/jc
cat <<-EOF > /opt/jc/agentBootstrap.json
{
"publicKickstartUrl": "https://kickstart.jumpcloud.com:443",
"privateKickstartUrl": "https://private-kickstart.jumpcloud.com:443",
"connectKey": "d9dcfaa51279e69d2a194f030a2a67d24b01ec05"
}
EOF


cat <<-EOF > /var/run/JumpCloud-SecureToken-Creds.txt
$admin;$08190819
EOF

installer -pkg /tmp/jumpcloud-agent.pkg -target / & fi

#installs Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#calls on caskconfig
bash caskconfig.sh

#uninstalls Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
