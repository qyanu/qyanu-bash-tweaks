SHELL := /bin/bash
PACKAGE := qyanu-bash-tweaks

all:
	@echo "done."

install:
	install --owner=root --group=root --mode=0755 \
		-d $(DESTDIR)/etc/profile.d/
	install --owner=root --group=root --mode=0755 \
		-d $(DESTDIR)/usr/share/$(PACKAGE)/
	install --owner=root --group=root --mode=0644 \
		profile.d/qyanu-bash-aliases.sh \
		profile.d/qyanu-bash-prompt.sh \
		$(DESTDIR)/etc/profile.d/
	install --owner=root --group=root --mode=755 \
		edit-bashrc.sh \
		$(DESTDIR)/usr/share/$(PACKAGE)/
