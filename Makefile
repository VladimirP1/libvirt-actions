all: install

MESSAGE:=$(shell which virsh  || echo Please install virsh using your package manager)

MESSAGE2:=$(shell which zenity || echo Please install zenity using your package manager)

.PHONY: check-deps all install uninstall

check-deps:
	echo ${MESSAGE}
	echo ${MESSAGE2}

virsh-action.patched.desktop:
	sed 's|PATHTODESKTOPFILE|'${PWD}'/virsh-action.sh|' virsh-action.desktop > virsh-action.patched.desktop

install: check-deps virsh-action.patched.desktop
	ln -fs ${PWD}/virsh-action.patched.desktop ~/.local/share/applications/virsh-action.desktop

uninstall:
	rm -f ~/.local/share/applications/virsh-action.desktop
	rm -f virsh-action.patched.desktop
