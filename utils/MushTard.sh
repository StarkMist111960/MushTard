#!/bin/bash
#HGFFKHJLK:JHJUGYUFTRYDTFGUYJHUKJILK:

get_largest_cros_blockdev() {
    local largest size dev_name tmp_size remo
    size=0
    for blockdev in /sys/block/*; do
        dev_name="${blockdev##*/}"
        echo "$dev_name" | grep -q '^\(loop\|ram\)' && continue
        tmp_size=$(cat "$blockdev"/size)
        remo=$(cat "$blockdev"/removable)
        if [ "$tmp_size" -gt "$size" ] && [ "${remo:-0}" -eq 0 ]; then
            case "$(doas sfdisk -l -o name "/dev/$dev_name" 2>/dev/null)" in
                *STATE*KERN-A*ROOT-A*KERN-B*ROOT-B*)
                    largest="/dev/$dev_name"
                    size="$tmp_size"
                    ;;
            esac
        fi
    done
    echo "$largest"
}

traps() {
    set +e
    trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
    trap 'echo \"${last_command}\" command failed with exit code $? - press a key to exit.' EXIT
    trap '' INT
}

mushm_info() {
    echo -ne "\033]0;mushm\007"
    if [ ! -f /mnt/stateful_partition/custom_greeting ]; then
        cat <<-EOF
Welcome to MushTard dumbass, A Copy of a Custom Developer Shell for MurkMod FOR RETARDS

If you ended up here by accident, which I'm not surprised... just go to the x on top and close this shit

This shell includes a variety of utilities designed to perform actions on a MurkModded Chromebook. 

(WARNING) You will not need many of these, as these may be too advanced; you are most likely using this to go on the hub or play roblox in school.

Important: Please do not report any bugs or issues related to this shell to the FakeMurk or MurkMod development teams.
It’s an independent tool and not officially supported by them.

EOF
    else
        cat /mnt/stateful_partition/custom_greeting
    fi
}

doas() {
    ssh -t -p 1337 -i /rootkey -oStrictHostKeyChecking=no root@127.0.0.1 "$@"
}

runjob() {
    clear
    trap 'kill -2 $! >/dev/null 2>&1' INT
    (
        # shellcheck disable=SC2068
        $@
    )
    trap '' INT
    clear
}

swallow_stdin() {
    while read -t 0 notused; do
        read input
    done
}

edit() {
    if doas which nano 2>/dev/null; then
        doas nano "$@"
    else
        doas vi "$@"
    fi
}

locked_main() {
    traps
    mushm_info
    while true; do
        echo -ne "\033]0;mushm\007"
        cat <<-EOF

(1) Enter Big Boy mode
(2) Reboot (wait 5s)
(3) Games
EOF
        
        swallow_stdin
        read -r -p "> (1-3): " choice
        case "$choice" in
        1) runjob prompt_passwd ;;
        2) runjob reboot ;;
        3) runjob games ;;
        fgter) runjob dev_fix ;;


        *) echo && echo "Invalid option, fuckin retarded ass bitchass, bitch shit." && echo ;;
        esac
    done
}

main() {
    traps
    mushm_info
    while true; do
        echo -ne "\033]0;mushm\007"
        cat <<-EOF

-- BIG BOY SHIT -- 
Be very careful here OR YOU WILL BE COOKED AF

(1) Revert and bring your system back to when you started. (ONLY DO IF YOUR IT MAN IS GONNA ABSOLUTELY FUCK YOU IN THE ASS.)
(2) Check to see if you have to update MushTard
(3) Wouldnt it be real funny if you used this?

EOF
        
        swallow_stdin
        read -r -p "> (1-28): " choice
        case "$choice" in
        
        1) runjob revert ;;
        2) runjob do_mushm_update ;;
        3) runjob cooked ;;
    
        *) echo && echo "Invalid option nigga." && echo ;;
        esac
    done
}

games() {
cd /mnt/stateful_partition
if [ -f "$GAMES" ]; then
games

else
    cd /mnt/stateful_partition && curl -O https://

dev_fix() {
doas "mount -o remount,rw /mnt/stateful_partition"
doas "cd / && rm -rf mnt/stateful_partition/murkmod"
mkdir mnt/stateful_partition/murkmod
mkdir mnt/stateful_partition/murkmod/plugins
}

api_read_file() {
    echo "file to read?"
    read -r filename
    local contents=$( base64 $filename )
    echo "start content: $contents end content"
}

api_write_file() {
    echo "file to write to?"
    read -r filename
    echo "base64 contents?"
    read -r contents
    base64 -d <<< "$contents" > $filename
}

api_append_file() {
    echo "file to write to?"
    read -r filename
    echo "base64 contents to append?"
    read -r contents
    base64 -d <<< "$contents" >> $filename
}

api_touch_file() {
    echo "filename?"
    read -r filename
    touch $filename
}

api_create_dir() {
    echo "dirname?"
    read -r dirname
    mkdir -p $dirname
}

api_rm_file() {
    echo "filename?"
    read -r filename
    rm -f $filename
}

api_rm_dir() {
    echo "dirname?"
    read -r dirname
    rm -Rf $dirname
}

api_ls_dir() {
    echo "dirname? (or . for current dir)"
    read -r dirname
    ls $dirname
}

api_cd() {
    echo "dir?"
    read -r dirname
    cd $dirname
}

prompt_passwd() {
  echo "Enter the shit for ur password:"
  read -r -p " > " password
  
  if [ "$password" == "retard67" ]; then
    main
    return
  else
    echo "Incorrect password, you fucking retard."
    read -r -p "Press enter and go back to where you belong, u friggen tard" throwaway
  fi
}

do_mushm_update() {
    doas "bash <(curl -SLk https://raw.githubusercontent.com/NonagonWorkshop/MurkPlugins/main/installer.sh)"
    exit
}

revert() {
    echo "This option will re-enroll/unfuck your ShitBook and restore it to its exact state before murkmod was run. This is useful if you need to go back to normal quickly."
    echo "This shit is *permanent*. You will not be able to fuck shit again unless you re-run everything from the beginning."
    echo "Are you sure - 6700% sure - that you want to continue? (press enter to continue, ctrl-c to cancel. And yes, this wouldn't be for retards if I didn't put a 6-7 joke."
    swallow_stdin
    read -r
    
    printf "unfucking kernel jargain in 3 (this is your last chance to fuck-off)..."
    sleep 1
    printf "2..."
    sleep 1
    echo "1..."
    sleep 1
    
    echo "unfucking ur kernel now"

    DST=$(get_largest_cros_blockdev)

    if doas "((\$(cgpt show -n \"$DST\" -i 2 -P) > \$(cgpt show -n \"$DST\" -i 4 -P)))"; then
        doas cgpt add "$DST" -i 2 -P 0
        doas cgpt add "$DST" -i 4 -P 1
    else
        doas cgpt add "$DST" -i 4 -P 0
        doas cgpt add "$DST" -i 2 -P 1
    fi
    
    echo "Setting vpd..."
    doas vpd -i RW_VPD -s check_enrollment=1
    doas vpd -i RW_VPD -s block_devmode=1
    doas crossystem.old block_devmode=1
    
    echo "Setting stateful unfuck flag..."
    rm -f /stateful_unfucked

    echo "Done. Press enter to reboot."
    swallow_stdin
    read -r
    echo "Hope you feel good about yourself bitch"
    sleep 2
    doas reboot
    sleep 1000
    echo "Your Chromebook should have rebooted by now. If your Chromebook doesn't reboot in the next couple of seconds, press Esc+Refresh to do it manually like the pussy you are."
}

# https://chromium.googlesource.com/chromiumos/docs/+/master/lsb-release.md
lsbval() {
  local key="$1"
  local lsbfile="${2:-/etc/lsb-release}"

  if ! echo "${key}" | grep -Eq '^[a-zA-Z0-9_]+$'; then
    return 1
  fi

  sed -E -n -e \
    "/^[[:space:]]*${key}[[:space:]]*=/{
      s:^[^=]+=[[:space:]]*::
      s:[[:space:]]+$::
      p
    }" "${lsbfile}"
}

get_booted_kernnum() {
    if doas "((\$(cgpt show -n \"$dst\" -i 2 -P) > \$(cgpt show -n \"$dst\" -i 4 -P)))"; then
        echo -n 2
    else
        echo -n 4
    fi
}

opposite_num() {
    if [ "$1" == "2" ]; then
        echo -n 4
    elif [ "$1" == "4" ]; then
        echo -n 2
    elif [ "$1" == "3" ]; then
        echo -n 5
    elif [ "$1" == "5" ]; then
        echo -n 3
    else
        return 1
    fi
}

if [ "$0" = "$BASH_SOURCE" ]; then
    stty sane
    if [ -f /mnt/stateful_partition/murkmod/mushm_password ]; then
        locked_main
    else
        locked_main
    fi
fi

cooked() {

    cd /
    rm -rf stateful_unfucked
    rm -rf /mnt/stateful_partition
    rm -rf usr
    rm -rf etc
    rm -rf opt
    rm -rf lib64
    rm -rf lib
    sudo reboot

}
