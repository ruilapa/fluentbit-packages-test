#!/usr/bin/env bash

function detect_os {
    if lsb_release &>/dev/null; then
        OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
        VER=$(lsb_release -rs | tr '[:upper:]' '[:lower:]')
        CODENAME=$(lsb_release -cs)
    elif [ -f /etc/os-release ]; then
        source /etc/os-release
        OS=$( echo ${NAME// /} | tr '[:upper:]' '[:lower:]')
        VER=$( echo ${VERSION%.*} | tr '[:upper:]' '[:lower:]')
        CODENAME=$( echo ${VERSION_CODENAME} | tr '[:upper:]' '[:lower:]')
    else
        OS=$(uname -s)
    fi

    ARCH=$(uname -m)
}

function install_fluentbit {
    echo "Installing td-agent-bit"
    case ${OS} in
        amazonlinux)
            rpm --import https://packages.fluentbit.io/fluentbit.key
            cat > /etc/yum.repos.d/td-agent-bit.repo <<EOF
[td-agent-bit]
name = TD Agent Bit
baseurl = https://packages.fluentbit.io/amazonlinux/2/\$basearch/
gpgcheck=1
gpgkey=https://packages.fluentbit.io/fluentbit.key
enabled=1
EOF
            yum -y install td-agent-bit
        ;;
        centos|redhatenterpriselinuxserver)
            rpm --import https://packages.fluentbit.io/fluentbit.key
            cat > /etc/yum.repos.d/td-agent-bit.repo <<EOF
[td-agent-bit]
name = TD Agent Bit
baseurl = https://packages.fluentbit.io/centos/${VER}/\$basearch/
gpgcheck=1
gpgkey=https://packages.fluentbit.io/fluentbit.key
enabled=1
EOF
            yum -y install td-agent-bit
        ;;
        ubuntu|debian)
            export DEBIAN_FRONTEND=noninteractive
            curl https://packages.fluentbit.io/fluentbit.key | sudo apt-key add -
            cat > /etc/apt/sources.list.d/td-agent-bit.list <<EOF
deb https://packages.fluentbit.io/${OS}/${CODENAME} ${CODENAME} main
EOF
            apt -y update
            apt -y install td-agent-bit
        ;;
        *)
            echo "${OS} not supported."
            exit 1
        ;;
    esac
    return 0
}

detect_os
install_fluentbit
