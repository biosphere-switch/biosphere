
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MODULE_PATH := $(ROOT_DIR)/../../modules/$(MODULE)
MODULE_FLAG_FILE := $(MODULE_PATH)/module.flag

ifeq ("$(wildcard $(MODULE_FLAG_FILE))","")
    $(error Module '$(MODULE)' is not installed...)
endif

MODULE_VER := $(shell head -n 1 $(MODULE_FLAG_FILE))
	
.PHONY: dummy
dummy:
	@echo Checked module '$(MODULE)' v$(MODULE_VER)...