# http://clarkgrubb.com/makefile-style-guide

MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := test
.DELETE_ON_ERROR:
.SUFFIXES:

################
# Python build #
################

PYTHON ?= python3
UV ?= uv
MOUNTPOINT ?= /rum/libfaketimefs

UV_TOOL_RUN := $(UV) run --no-project

.PHONY: test
test:
	$(UV_TOOL_RUN) --with . $(PYTHON) -c "import doctest, libfaketimefs; raise SystemExit(doctest.testmod(libfaketimefs).failed)"
	$(UV_TOOL_RUN) --with flake8 flake8 bin/libfaketimefs libfaketimefs/*.py

.PHONY: build
build:
	$(UV) build

.PHONY: clean
clean:
	rm -rf build dist *.egg-info .venv

#################
# Local testing #
#################

# Run libfaketimefs.
.PHONY: run
run:
	$(UV_TOOL_RUN) --with flake8 flake8 ./bin/* ./libfaketimefs/*.py || true
	mkdir -p $(MOUNTPOINT)
	libfaketimefs $(MOUNTPOINT) --allow-other --debug

now := $(shell date +%s)
now10s := $(shell date -d '+10 seconds' +%s)
now10m := $(shell date -d '+10 minutes' +%s)
tomorrow := $(shell date -d '+86400 seconds' +%s)
tomorrow10s := $(shell date -d '+86410 seconds' +%s)

# Jump to now.
.PHONY: jump
jump:
	echo '$(now) $(now) $(now) 1' > $(MOUNTPOINT)/control
	watch -n 1 "cat $(MOUNTPOINT)/realtime && echo && cat $(MOUNTPOINT)/faketimerc"

# Jump to tomorrow.
.PHONY: jump1d
jump1d:
	echo '$(now) $(tomorrow) $(tomorrow) 1' > $(MOUNTPOINT)/control
	watch -n 1 "cat $(MOUNTPOINT)/realtime && echo && cat $(MOUNTPOINT)/faketimerc"

# Move at normal speed. This is useless.
.PHONY: move1s
move1s:
	echo '$(now) $(now) $(now10s) 1' > $(MOUNTPOINT)/control
	watch -n 1 "cat $(MOUNTPOINT)/realtime && echo && cat $(MOUNTPOINT)/faketimerc"

# Move at double speed.
.PHONY: move2s
move2s:
	echo '$(now) $(now) $(now10s) 2' > $(MOUNTPOINT)/control
	watch -n 1 "cat $(MOUNTPOINT)/realtime && echo && cat $(MOUNTPOINT)/faketimerc"

# Move at double speed starting tomorrow.
.PHONY: move2st
move2st:
	echo '$(now) $(tomorrow) $(tomorrow10s) 2' > $(MOUNTPOINT)/control
	watch -n 1 "cat $(MOUNTPOINT)/realtime && echo && cat $(MOUNTPOINT)/faketimerc"

# Move at 1 minute per second.
.PHONY: move1m
move1m:
	echo '$(now) $(now) $(now10m) 60' > $(MOUNTPOINT)/control
	watch -n 1 "cat $(MOUNTPOINT)/realtime && echo && cat $(MOUNTPOINT)/faketimerc"

# Move at 24 minutes per second, or 1 day per minute.
.PHONY: move24m
move24m:
	echo '$(now) $(now) $(tomorrow) 1440' > $(MOUNTPOINT)/control
	watch -n 1 "cat $(MOUNTPOINT)/realtime && echo && cat $(MOUNTPOINT)/faketimerc"
