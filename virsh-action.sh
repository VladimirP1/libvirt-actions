#!/bin/bash

ACTION=$(echo -e 'start\nshutdown\nlist\nlegacy-connect\nconnect\nconnect-noscale\nset-cursor-size\nsuspend\nresume\ndompmwakeup\nreset\nedit-forwarding\nopen-images-dir\nreload-forwarding' | zenity --list --title "What to do" --text "Actions" --column "" --height 420)

if [ "$ACTION" == "" ] ; then 
    exit 1
fi

case "$ACTION" in
    start|shutdown|suspend|resume|dompmwakeup|reset)
        DOMAIN=$(virsh -c qemu:///system list --name --all | zenity --list --title "Select domain" --text "Domains" --column "" --height 400)
        if [ "$DOMAIN" == "" ] ; then 
            exit 1
        fi
        gnome-terminal -- sh -c "echo Running: \"virsh -c qemu:///system $ACTION $DOMAIN\" ; virsh -c qemu:///system $ACTION $DOMAIN ; echo ------------------ ; read"
        ;;
    edit-forwarding)
        gedit admin:///etc/libvirt/hooks/hooks.json
        ;;
    legacy-connect)
        DOMAIN=$(virsh -c qemu:///system list --name | zenity --list --title "Select domain" --text "Domains" --column "" --height 400)

        if [ "$DOMAIN" == "" ] ; then 
            exit 1
        fi

        env GDK_BACKEND=x11 GDK_SCALE=1 virt-viewer --connect qemu:///system --attach "$DOMAIN"
        #env GDK_SCALE=1 GDK_DPI_SCALE=1 virt-viewer -z 50 --connect qemu:///system --attach "$DOMAIN"
        ;;
    connect)
        DOMAIN=$(virsh -c qemu:///system list --name | zenity --list --title "Select domain" --text "Domains" --column "" --height 400)

        if [ "$DOMAIN" == "" ] ; then 
            exit 1
        fi

        #env GDK_BACKEND=x11 GDK_SCALE=1 virt-viewer --connect qemu:///system --attach "$DOMAIN"
        env GDK_SCALE=1 GDK_DPI_SCALE=1 virt-viewer -z 50 --connect qemu:///system --attach "$DOMAIN"
        ;;
    connect-noscale)
        DOMAIN=$(virsh -c qemu:///system list --name | zenity --list --title "Select domain" --text "Domains" --column "" --height 400)

        if [ "$DOMAIN" == "" ] ; then 
            exit 1
        fi

        #env GDK_BACKEND=x11 GDK_SCALE=1 virt-viewer --connect qemu:///system --attach "$DOMAIN"
        env GDK_SCALE=1 GDK_DPI_SCALE=1 virt-viewer --connect qemu:///system --attach "$DOMAIN"
        ;;
    list)
        gnome-terminal -- sh -c "virsh -c qemu:///system list --all ; read"
        ;;
    open-images-dir)
cat <<EOF > /tmp/help.virsh-action.txt
To create a linked clone: qemu-img create -f qcow2 -b base-image.qcow2 linked-image.qcow2
To resize an image:       qemu-img resize vm.qcow2 +2G
EOF
        gnome-terminal -- sudo sh -c 'cd /var/lib/libvirt/images/ ; cat /tmp/help.virsh-action.txt ; bash'
        ;;
    set-cursor-size)
    	gnome-terminal -- sh -c 'echo -e To set cursor size, run:\\n gsettings set org.gnome.desktop.interface cursor-size 12 \\nto revert:\\n gsettings reset org.gnome.desktop.interface cursor-size ; read'
    	;;
    reload-forwarding)
        gnome-terminal -- sudo sh -c 'cd /etc/libvirt/hooks ; echo Run "\"./qemu <VM NAME> reconnect begin\"" to reload rules ; bash'
esac

