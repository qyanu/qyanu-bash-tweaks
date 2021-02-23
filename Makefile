
default:
	echo "use \`make install\` to install qyanu bash tweaks"

install:
	install --mode=u=rw,og=r -T "$(CURDIR)/profile.d/qyanu-bash-aliases.sh" /etc/profile.d/qyanu-bash-aliases.sh
	install --mode=u=rw,og=r -T "$(CURDIR)/profile.d/qyanu-bash-prompt.sh" /etc/profile.d/qyanu-bash-promp.sh
	$(CURDIR)/edit-bashrc.sh /etc/skel/.bashrc

edit-home-bashrc:
	$(CURDIR)/edit-bashrc.sh $(HOME)/.bashrc
