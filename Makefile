VENDOR_PATH := $(CURDIR)/vendor
BIN_PATH    := $(VENDOR_PATH)/.bin

.PHONY: default install-ruby-dependencies install-git-submodules vagrant-provision install clean benchmark

# Do nothing if `make` invoked with no arguments.
default:
	@/bin/echo "No default '$(MAKE)' target configured. Did you mean any of the following:"
	@/bin/echo
	@cat '$(firstword $(MAKEFILE_LIST))' | grep '^[[:alnum:] \-]\+:' | sed -e 's/:.*//g' | sort -u | tr "\\n" ' ' | fold -sw 76 | sed -e 's#^#    #g'
	@/bin/echo
	@exit 1

# Check if a given command is available and exit if it's missing.
required-dependency =                                              \
	/bin/echo -n "Checking if '$(1)' is available... " ;             \
	$(eval COMMAND := which '$(1)')                                  \
	if $(COMMAND) >/dev/null; then                                   \
		$(COMMAND) ;                                                   \
	else                                                             \
		/bin/echo "command failed:" ;                                  \
		/bin/echo ;                                                    \
		/bin/echo "    $$ $(COMMAND)" ;                                \
		/bin/echo ;                                                    \
		/bin/echo "You must install $(2) before you could continue." ; \
		/bin/echo "On Debian-based systems, you may want to try:" ;    \
		/bin/echo ;                                                    \
		/bin/echo "    $$ [sudo] apt-get install $(3)" ;               \
		/bin/echo ;                                                    \
		exit 1;                                                        \
	fi

# Install a RubyGem if it's not present on the system.
install-ruby-gem-if-missing =                                                                      \
	/bin/echo -n "Checking if '$(1)' RubyGem is available... " ;                                     \
	$(eval GEM_VERSION := ruby -rubygems -e "puts Gem::Specification::find_by_name('$(1)').version") \
	if $(GEM_VERSION) 2>&1 1>/dev/null; then                                                         \
		$(GEM_VERSION) ;                                                                               \
	else                                                                                             \
		/bin/echo "nope." ;                                                                            \
		/bin/echo -n "Installing '$(1)' RubyGem... " ;                                                 \
		gem install --remote --no-ri --no-rdoc '$(1)' 1>/dev/null || (                                 \
			/bin/echo                                                                                                               ; \
			/bin/echo "Failed to install '$(1)' RubyGem."                                                                           ; \
			/bin/echo                                                                                                               ; \
			/bin/echo "On Debian-based systems, if you receive permission issues, please run the following commands and try again:" ; \
			/bin/echo "    $$ [sudo] mkdir -p /var/lib/gems"                                                                        ; \
			/bin/echo "    $$ [sudo] chown -R `whoami`:users /var/lib/gems /usr/local"                                              ; \
			/bin/echo                                                                                                               ; \
		) ;              \
		$(GEM_VERSION) ; \
	fi

# Create a .bundle/success file if the RubyGems bundle is installed.
$(shell rm -f '$(CURDIR)/.bundle/success' && bundle check 1>/dev/null 2>&1 && touch '$(CURDIR)/.bundle/success' )

# Install all RubyGems from Gemfile using Bundler.
install-ruby-dependencies: $(CURDIR)/.bundle/success
$(CURDIR)/.bundle/success:
	@$(call required-dependency,ruby,Ruby,ruby1.9.3)
	@$(call required-dependency,gem,RubyGems,rubygems1.8)
	@$(call install-ruby-gem-if-missing,bundler)
	@$(call required-dependency,bundle,Bundler,ruby-bundler)
	@/bin/echo -n 'Installing RubyGem project-specific dependencies... '
	@bundle install --path '$(VENDOR_PATH)' --binstubs '$(BIN_PATH)' 1>/dev/null
	@/bin/echo 'OK'

GIT_MODULES = $(shell cat '.gitmodules' | grep 'path' | cut -d'=' -f2 | tr -d ' ' | sort -u | sed -e 's/$$/\/.git/g')
install-git-submodules: $(GIT_MODULES)
$(GIT_MODULES):
	@$(call required-dependency,git,Git,git-core)
	@git submodule update --init --recursive

# Bring up the virtual machine if it doesn't already exist.
vagrant-provision: install-ruby-dependencies install-git-submodules .vagrant
.vagrant:
	@/bin/echo 'Creating default VM set up... please be patient.'
	@/bin/echo 'On Debian-based systems, you may be asked for your root password in order to configure the NFS daemon.'
	@$(BIN_PATH)/vagrant up || ( \
		/bin/echo                                                                                                                                                             ; \
		/bin/echo 'Failed to provision your virutal machine.'                                                                                                                 ; \
		/bin/echo                                                                                                                                                             ; \
		/bin/echo 'On Debian-based systems, if you have not installed VirtualBox, please run the following command and try again:'                                            ; \
		/bin/echo                                                                                                                                                             ; \
		/bin/echo "    $$ [sudo] apt-get install build-essential 'linux-headers-*-generic' virtualbox"                                                                        ; \
		/bin/echo                                                                                                                                                             ; \
		/bin/echo "In case the virtual machine booted, but the provisioning failed with 'VM must be created before running this command.', please run the following command:" ; \
		/bin/echo                                                                                                                                                             ; \
		/bin/echo "    $$ bin/vagrant reload"                                                                                                                                 ; \
		/bin/echo                                                                                                                                                             ; \
	)

# Bootstrap a development environment.
install-development: vagrant-provision

install: install-development

clean:
	@$(call required-dependency,git,Git,git-core)
	@if [ -f '$(CURDIR)/.vagrant' ]; then     \
		'$(BIN_PATH)/vagrant' destroy --force ; \
	fi
	@git clean -dfx

benchmark: vagrant-provision
	@$(BIN_PATH)/vagrant ssh -c 'sudo /vagrant/bin/simple-benchmark'


# vim: ts=2 sw=2 noet
