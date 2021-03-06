PROJECT = exemplar
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE = _build/dev/lib/lfe/bin/lfe
REBAR3 = PATH=.:$(PATH) rebar3

include priv/make/code.mk
include priv/make/docs.mk
