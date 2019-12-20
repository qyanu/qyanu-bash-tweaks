
default:
	echo "use \`make install\` to install qyanu bash tweaks"

install:
	install -T "$(CURDIR)/profile.d/qyanu-bash-aliases" /etc/profile.d/qyanu-bash-aliases
	install -T "$(CURDIR)/profile.d/qyanu-bash-prompt" /etc/profile.d/qyanu-bash-promp
