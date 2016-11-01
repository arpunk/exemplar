compile:
	$(REBAR) compile

check:
	@echo
	@echo "=================================="
	@echo "Running tests using Github Sources ..."
	@echo "=================================="
	@echo
	$(REBAR) as test lfe test

check-gitlab:
	@echo
	@echo "=================================="
	@echo "Running tests using Gitlab Sources ..."
	@echo "=================================="
	@echo
	$(REBAR) as gitlab lfe test

check-hexpm: clean
	@echo
	@echo "==================================="
	@echo "Running tests using Hex.pm Packages ..."
	@echo "==================================="
	@echo
	@$(REBAR) as hexpm lfe clean
	$(REBAR) as hexpm lfe test

check-all: check check-gitlab check-hexpm

travis:
	@if [ "$(REBAR_BUILD)" = "github" ]; then make build-github; make check; fi;
	@if [ "$(REBAR_BUILD)" = "gitlab" ]; then make build-gitlab; make check-gitlab; fi;
	@if [ "$(REBAR_BUILD)" = "hexpm" ]; then make build-hexpm; make check-hexpm; fi;

repl:
	$(REBAR) as $(REBAR_PROFILE) compile
	$(LFE) -pa `$(REBAR) as $(REBAR_PROFILE) path -s " -pa "`

shell:
	@$(REBAR) shell

clean:
	@$(REBAR) clean
	@rm -rf ebin/* _build/default/lib/$(PROJECT) rebar.lock \
		rebar3.crashdump \
		$(HOME)/.cache/rebar3/hex/default/packages/*

clean-all: clean
	@$(REBAR) as dev lfe clean

push:
	git push github master
	git push gitlab master

push-tags:
	git push github --tags
	git push gitlab --tags

push-all: push push-tags

build-github: clean
	@echo
	@echo "============================="
	@echo "Building using Github Sources ..."
	@echo "============================="
	@echo
	$(REBAR) compile
	@$(REBAR) lock

build-gitlab: clean
	@echo
	@echo "============================="
	@echo "Building using Gitlab Sources ..."
	@echo "============================="
	@echo
	$(REBAR) as gitlab compile
	@$(REBAR) as gitlab lock

build-hexpm: clean
	@echo
	@echo "=============================="
	@echo "Building using Hex.pm Packages ..."
	@echo "=============================="
	@echo
	$(REBAR) as hexpm compile
	@$(REBAR) as hexpm lock

build-all: build-github build-gitlab build-hexpm

publish: clean
	$(REBAR) as hexpm hex publish

setup-rebar3:
	wget https://s3.amazonaws.com/rebar3/rebar3
	chmod +x rebar3

setup-hexpm: REBAR_HOME_CONFIG = ~/.config/rebar3/
setup-hexpm:
	mkdir -p $(REBAR_HOME_CONFIG)
	echo "{plugins, [rebar3_hex]}." > $(REBAR_HOME_CONFIG)/rebar.config
