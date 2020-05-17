
.PHONY: main

main:
	@$(foreach DEP,$(MODULE_DEPENDENCIES),$(BIOSPHERE_ROOT)/utils/check-module.sh $(DEP);)
	