ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

ifeq ($(wildcard $(MODULE)),)
	$(error Module directory not found...)
endif

MODULE_DIR := $(MODULE)/$(MODULE_OUTPUT_DIR)

ifeq ($(wildcard $(MODULE_DIR)),)
	$(error Module directory not found...)
endif

MODULE_NAME := $(shell basename $(MODULE))
MODULE_INSTALL_DIR := $(ROOT_DIR)/../../modules/$(MODULE_NAME)
MODULE_FLAG_FILE := $(MODULE_INSTALL_DIR)/module.flag

.PHONY: main

main:
	@rm -rf $(MODULE_INSTALL_DIR)
	@mkdir -p $(MODULE_INSTALL_DIR)
	@cp -r $(MODULE_DIR)/. $(MODULE_INSTALL_DIR)/
	@rm -rf $(MODULE_FLAG_FILE)
	@echo $(MODULE_VER) > $(MODULE_FLAG_FILE)
	@echo Installed '$(MODULE_NAME)' v$(MODULE_VER)...