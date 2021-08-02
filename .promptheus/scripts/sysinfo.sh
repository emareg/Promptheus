#!/usr/bin/env sh
# Shell Scirpt to print System Info
# author: emanuel.regnath@tum.de
# https://lzone.de/cheat-sheet/Linux-Networking


# Colors
white='\033[0;37m';  WHITE='\033[1;37m'
blue='\033[0;34m';   BLUE='\033[1;34m'
green='\033[0;32m';  GREEN='\033[1;32m'
cyan='\033[0;36m';   CYAN='\033[1;36m'
red='\033[0;31m';    RED='\033[1;31m'
purple='\033[0;35m'; PURPLE='\033[1;35m'
yellow='\033[0;33m'; YELLOW='\033[1;33m'
gray='\033[0;30m';   GRAY='\033[1;30m'
nocol='\033[0m';


_Ch="$cyan"  # color highlight
_Cs="$CYAN"  # color structure
_Cc="$WHITE"  # color command
_Cn="$white"  # color normal



# extracts the next word after paramter separated by space, : =
parse_key(){
	#sed -nr "s/^.*${1}\s*[ :=]\s*(\S+).*$/\1/p;q" # for some reason q (quit) also if no match
	sed -nr "s/^.*${1}\s*[ :=]\s*(\S+).*$/\1/p" | head -1
	#grep -m 1 -oP "${1}\s*[ :=]\s*\K(\S+)"
	#awk pattern="/$1\s*[ :=]\s*/" '{ print $2;exit }'
}


parse_keyline(){
	sed -nr "s/^.*${1}\s*[ :=]\s*(.*$)/\1/p" | head -1
}

# read_char var
read_char(){
  stty -icanon -echo
  eval "$1=\$(dd bs=1 count=1 2>/dev/null)"
  stty icanon echo	
}



# selects availables command
sel_cmd(){
	if command -v ${1%% *} >/dev/null; then 
		echo "$1"
	elif command -v ${2%% *} >/dev/null; then
		echo "$2"
	elif command -v ${3%% *} >/dev/null; then
		echo "$3"
	fi
}


run_cmd(){
	local IFS=' '
	clear
	echo "${_Cc}> $1${_Cn}"
	eval $1
	echo -n "[Any Key] to continue..."; read_char char
	if [ "$char" = "q" ]; then exit 0; fi
	clear
}


print_menu(){
local IFS='
'
while true; do
	# print summary
	print_summary

	# print section info
	print_"$1"

	# print menu
	printf "\n${_Cs}Main ⇒ $1${white}\n"
	count=0
	for line in $2; do
		count=$((count+1))
		line=${line#*>}
		cmd=${line%!*}
		desc=${line#*!}
	    printf "%2d. > ${_Cc}%-30s${white}  (%s)\n" $count "$cmd" "$desc"
	done

	# read choice
	printf "\nYour Choice: "; read_char choice; printf "$choice"
	if [ "$choice" = "q" ]; then exit 0; fi

	# run command
	count=0
	wasRun=""
	for line in $2; do
		count=$((count+1))
		line=${line#*>}
		cmd=${line%!*}
		if [ "$count" = "$choice" ]; then
			run_cmd "$cmd"
			wasRun="yes"
		fi
	done
	if [ -z "$wasRun" ]; then clear; break; fi
done
}



# ========================================================

main_menu(){

	mainchoice=1
	while [ $mainchoice != 'q' ]; do
		clear

		print_summary
		
		echo "${_Cs}Main Menu${white}"
		echo " 1. General System"
		echo " 2. Hardware (CPU, USB, ...)"
		echo " 3. Network"
		echo " 4. Filesystems"
		echo " *  Quit"


		printf "\nYour Choice: "; read_char choice;
		case $choice in
			1 ) clear; submenu_system;;
			2 ) clear; submenu_hardware;;
			3 ) clear; submenu_net;;
			4 ) clear; submenu_filesystem;;
			* ) exit 0;;
		esac
	done
}


submenu_system(){
	cmd_logins=$(sel_cmd "lslogins" "who -a")
	cmd_kernel=$(sel_cmd "hostnamectl" "uname -a")
	cmd_proc=$(sel_cmd "pstree" "ps -aux")
	cmd_pack="apt-mark showmanual"
	cmd_mod="lsmod"
	cmd_services="systemctl --failed"

	sysmenu="
	>${cmd_logins}!Users and Logins
	>${cmd_kernel}!Kernel and OS
	>${cmd_proc}!Processes
	>${cmd_mod}!Modules
	>${cmd_pack}!Manual Installed Packages
	>${cmd_services}!Failed Services"

	print_menu "System" "$sysmenu"
}



submenu_hardware(){
	cmd_hw="lshw -short"
	cmd_cpu=$(sel_cmd "lscpu" "cat /proc/cpuinfo")
	cmd_pci="lspci"
	cmd_usb="lsusb"

	hwmenu="
	>${cmd_hw}!Harware
	>${cmd_pci}!PCI
	>${cmd_usb}!USB
	>${cmd_cpu}!CPU Info"

	print_menu "Hardware" "$hwmenu"
}



submenu_net(){
	cmd_routes=$(sel_cmd 'ip route | column -t' "route")
	cmd_iface=$(sel_cmd "nmcli device" "ip adress" "ifconfig") 
	cmd_dns="cat /etc/resolv.conf"
	cmd_arp="arp -n"
	cmd_nm_config="cat /etc/NetworkManager/NetworkManager.conf"
	cmd_if_config="cat /etc/network/interfaces"
	cmd_hostname="cat /etc/hostname"

	netmenu="
	>${cmd_iface}!interfaces
	>${cmd_routes}!Show routing
	>${cmd_dns}!Show DNS
	>${cmd_arp}!Show MACs
	>${cmd_hostname}!Show Hostname
	>${cmd_if_config}!Legacy Interfaces
	>${cmd_nm_config}!NM Config"

	print_menu "Network" "$netmenu"
}



submenu_filesystem(){
	cmd_df="df -Th -x tmpfs"
	cmd_journal="journalctl --verify"

	fsmenu="
	>${cmd_df}!List Filesystems
	>${cmd_journal}!Verify Journal"

	print_menu "Filesystem" "$fsmenu"
}


# Helper Functions
# ========================================================

echo_release(){
	if [ -f /etc/os-release ]; then # freedesktop.org and systemd
	    . /etc/os-release
		echo -n "${NAME} ${VERSION}"
	elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
	    echo -n "$(lsb_release -sd)"
	elif [ -f /etc/lsb-release ]; then # some Debian/Ubuntu
	    . /etc/lsb-release
	    echo -n "${DISTRIB_DESCRIPTION}"
	else #fall back
	    echo -n "$(uname -sr)"
	fi
}

# ========================================================


# Gather CPU Info
CPU_CORES="$(cat /proc/cpuinfo | grep processor | wc -l)"
CPU_NAME="$(cat /proc/cpuinfo | grep -m 1 -oP 'model name\s+: \K(.*)')"
CPU_ARCH="$(uname -m)"
# get CPU word width
case $CPU_ARCH in
	x86_64)CPU_BITS=64;;
	i*86) CPU_BITS=32;;
	*) CPU_BITS="?";;
esac

# GPU Info
GPU_NAME="$(lspci | grep -m 1 -oP 'VGA compatible controller: \K(.*)')"



# Network Info
NET_GATEWAY="$(/sbin/ip route | awk '/default/ { print $3;exit }')"
NET_IFACE="$(/sbin/ip route | awk '/default/ { print $5;exit }')"
NET_IP_GW="$(/sbin/ip route get 1 | awk '/via/ { print $3;exit }')"
NET_IP_LAN="$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')"
NET_IP_WAN="$(wget -qO- ipinfo.io/ip)"
NET_HOSTNAME=$(hostname)


# system info
SYS_KERNEL="$(/bin/uname -sr)"
SYS_DISTRO="$(echo_release)"


RAM_TOTAL="$(( $(sed -n "s/MemTotal:[\t ]\+\([0-9]\+\) kB/\1/p" /proc/meminfo)/1000000)) GB"


print_summary(){
	echo "${_Cs}## System Info General ##${white}"
	echo "Kernel: $SYS_KERNEL"
	echo "Distro: $SYS_DISTRO"
	echo ""
	echo "Arch.:  $CPU_ARCH (${CPU_BITS} bit)"
	echo "CPU:    $CPU_NAME"
	echo "GPU:    $GPU_NAME"
	echo "MEM:    $RAM_TOTAL RAM, $(df -H --output=size / 2> /dev/null | awk ' NR==2 ')B /,  $(df -H --output=size /home 2> /dev/null | awk ' NR==2 ')B /home"
	echo ""
	echo "Login:  ${USER}${_Ch}@${_Cn}$NET_HOSTNAME"
	echo "NET:    ${NET_IFACE}${_Ch}:${_Cn} ${NET_IP_LAN} ${_Ch}→${_Cn} ${NET_GATEWAY} ${_Ch}→${_Cn} ${NET_IP_WAN} "
	echo ""
	#echo "WAN IP: $(wget -qO- ipinfo.io/ip)"
	#echo "USB:    $(lsusb | grep Device -c)"  # lsusb -v | grep "bcdUSB"
}



print_System(){
	echo "${_Cs}## System ##${white}"
	echo "Kernel:  $(/bin/uname -sr)"
	echo "Distro:  $(echo_release)"
	echo "Arch.:   $(/bin/uname -m) (${CPU_BITS} bit)"
	#echo "Boot CL: $(dmesg | parse_keyline 'Command line')"
	echo "Kopt:    $(dmesg | parse_keyline 'kopt')"
	echo "SecBoot: $(dmesg | parse_keyline 'secureboot')"
}



print_Hardware(){
	echo "${_Cs}## CPU ##${white}"
	echo "Model: ${CPU_NAME}"
	echo "Arch.: $(/bin/uname -m) (${CPU_BITS} bit)"
	echo "Cores: ${CPU_CORES}"
}


print_Network(){
	NET_IPv4_WAN=$(dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com)
	NET_IPv6_WAN=$(dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com)

	echo "${_Cs}## Network ##${white}"
	echo "Host:    $NET_HOSTNAME"
	echo "LAN IP:  $(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')"
	echo "GW IP:   $NET_GATEWAY"
	echo "WAN IP4: $NET_IPv4_WAN"
	echo "WAN IP6: $NET_IPv6_WAN"
	echo "DNS:     $(cat /etc/resolv.conf | parse_key nameserver)"


printf "\n${WHITE}%-16s %-20s %-20s %-6s"${white}"\n" "Interface" "IPv4" "MAC" "STATE" 

local IFS=' '
for iface in $(ip addr | sed -nr 's/^[0-9]: (.*):.*$/\1/p' | tr '\n' ' ')
do 
  ipaddr=$(ip -o -4 addr list $iface | parse_key inet)
  macaddr=$(ip -o link list $iface | parse_key ether)
  istate=$(ip addr list $iface | parse_key state)
  printf '%-16s %-20s %-20s %-6s\n' "$iface" "$ipaddr" "$macaddr" "$istate"
done	

	# DNS commands: nslookup, dig, host
}


print_Filesystem(){
	echo "${_Cs}## Filesystems ##${white}"
	echo "Mount: $(df -H --output=size / 2> /dev/null | awk ' NR==2 ') /,  $(df -H --output=size /home 2> /dev/null | awk ' NR==2 ') /home"
	echo "$(lsblk -o NAME,TYPE,FSTYPE,SIZE,MOUNTPOINT,ROTA -e 1,7)"

}


# run sysinfo
main_menu



