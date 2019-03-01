all: install

MESSAGE:=$(shell which virsh  || echo Please install virsh using your package manager)

MESSAGE2:=$(shell which zenity || echo Please install zenity using your package manager)

.PHONY: check-deps all install uninstall

check-deps:
	echo ${MESSAGE}
	echo ${MESSAGE2}

install: check-deps
	ln -fs ${PWD}/virsh-action.desktop ~/.local/share/applications/virsh-action.desktop

uninstall:
	rm -f ~/.local/share/applications/virsh-action.desktop
