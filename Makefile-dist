default:
	@echo "use \`make install\` to install qyanu bash tweaks and use for new users"
	@echo "use \`make edit-home-bashrc\` to use qyanu bash tweaks for your current user"

install:
	install --mode=u=rw,og=r -T "$(CURDIR)/profile.d/qyanu-bash-aliases.sh" /etc/profile.d/qyanu-bash-aliases.sh
	install --mode=u=rw,og=r -T "$(CURDIR)/profile.d/qyanu-bash-prompt.sh" /etc/profile.d/qyanu-bash-promp.sh
	touch /etc/skel/.bashrc
	$(CURDIR)/edit-bashrc.sh /etc/skel/.bashrc

edit-home-bashrc:
	touch $(HOME)/.bashrc
	$(CURDIR)/edit-bashrc.sh $(HOME)/.bashrc
