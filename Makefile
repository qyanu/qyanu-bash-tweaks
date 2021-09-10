SHELL := /bin/bash
PACKAGE := qyanu-bash-tweaks
VERSION := $(shell cat $(CURDIR)/VERSION)
CURRENT_COMMIT_DATE = $(shell git show --format="%cI" --no-patch HEAD)

default:
	@echo "available make targets:"
	@echo
	@echo "  dist ... make distributable files into directory dist/"
	@echo "  package ... make distributable tar.gz"

clean:
	@rm -v -Rf dist/
	@rm -v -f $(PACKAGE)_$(VERSION).tar.bz2

dist:	\
		edit-bashrc.sh \
		Makefile-dist \
		VERSION \
		profile.d/qyanu-bash-aliases.sh \
		profile.d/qyanu-bash-prompt.sh \
		;
	@mkdir -p "dist/" "dist/profile.d/"
	@cp Makefile-dist dist/Makefile
	@cp -vt dist/ \
	    edit-bashrc.sh \
	    VERSION \
	#
	@cp -vt dist/profile.d \
	    profile.d/qyanu-bash-aliases.sh \
	    profile.d/qyanu-bash-prompt.sh \
	#
	@touch dist/

package: dist
	# make tar file reproducible with the following options:
	#   sort, owner, group, numeric-owner, mtime
	tar -vC $(CURDIR) --sort=name --owner=0 --group=0 --numeric-owner \
	    --mtime "$(CURRENT_COMMIT_DATE)" \
	    --transform=s/dist/$(PACKAGE)/ \
	    -cjf $(PACKAGE)_$(VERSION).tar.bz2 \
	    dist/
