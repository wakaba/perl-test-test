PERL = perl
PERL_VERSION = latest
PERL_PATH = $(abspath local/perlbrew/perls/perl-$(PERL_VERSION)/bin)
PROVE = prove

all: config/perl/libs.txt

## ------ Deps ------

Makefile-setupenv: Makefile.setupenv
	make --makefile Makefile.setupenv setupenv-update \
	    SETUPENV_MIN_REVISION=20120329

Makefile.setupenv:
	wget -O $@ https://raw.github.com/wakaba/perl-setupenv/master/Makefile.setupenv

config/perl/libs.txt local-perl generatepm \
perl-exec perl-version carton-install carton-update \
: %: Makefile-setupenv
	make --makefile Makefile.setupenv pmbundler-repo-update $@ \
            PMBUNDLER_REPO_URL=$(PMBUNDLER_REPO_URL)

## ------ Tests ------

PERL_ENV = PATH=$(PERL_PATH):$(PATH) PERL5LIB=$(shell cat config/perl/libs.txt)

test: safetest

test-deps: carton-install config/perl/libs.txt

safetest: safetest-main

safetest-main: 
	$(PERL_ENV) $(PROVE) t/test/*.t

always:

## License: Public Domain.
