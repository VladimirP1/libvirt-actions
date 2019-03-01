all: install

install:
	ln -fs ${PWD}/virsh-action.desktop ~/.local/share/applications/virsh-action.desktop

uninstall:
	rm -f ~/.local/share/applications/virsh-action.desktop
