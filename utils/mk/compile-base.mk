
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# Speficy LLVM executables/paths

ifeq ($(shell uname -s),Darwin)
	ifeq ($(shell brew --prefix llvm),)
		$(error need llvm installed via brew)
	else
		LLVM_CONFIG := $(shell brew --prefix llvm)/bin/llvm-config
	endif
else
	LLVM_CONFIG := llvm-config$(LLVM_POSTFIX)
endif

LLVM_BINDIR := $(shell $(LLVM_CONFIG) --bindir)
ifeq ($(LLVM_BINDIR),)
  $(error llvm-config needs to be installed)
endif

LD := $(LLVM_BINDIR)/ld.lld
CC := $(LLVM_BINDIR)/clang
CXX := $(LLVM_BINDIR)/clang++
AS := $(LLVM_BINDIR)/llvm-mc
AR := $(LLVM_BINDIR)/llvm-ar
RANLIB := $(LLVM_BINDIR)/llvm-ranlib

LINKLE := $(BIOSPHERE_ROOT)/utils/ld/linkle

# Expected exports: SOURCE_DIR, BUILD_DIR, OUTPUT_DIR, C_FLAGS, CXX_FLAGS, AS_FLAGS, AR_FLAGS, LD_FLAGS, OBJS, INCLUDE_DIRS

OBJS := $(CPP_SOURCES:.cpp=.o) $(C_SOURCES:.c=.o) $(S_SOURCES:.s=.o)
OBJ_DIR := $(BUILD_DIR)/obj
INCLUDE_PATHS := $(foreach INCLUDE_DIR,$(INCLUDE_DIRS),-I $(INCLUDE_DIR))
OBJ_LD_PATHS := $(foreach OBJ,$(OBJS),$(subst $(SOURCE_DIR),$(OBJ_DIR),$(OBJ)))

%.o: %.cpp
	$(eval CPP_OUTPUT := $(subst $(SOURCE_DIR),$(OBJ_DIR),$*))
	@mkdir -p $(dir $(CPP_OUTPUT))
	@echo $(notdir $<)
	$(CXX) $(CXX_FLAGS) $(INCLUDE_PATHS) -MMD -MP -MF $(CPP_OUTPUT).d -c -o $(CPP_OUTPUT).o $<

%.o: %.c
	$(eval C_OUTPUT := $(subst $(SOURCE_DIR),$(OBJ_DIR),$*))
	@mkdir -p $(dir $(C_OUTPUT))
	@echo $(notdir $<)
	$(CC) $(C_FLAGS) $(INCLUDE_PATHS) -MMD -MP -MF $(C_OUTPUT).d -c -o $(C_OUTPUT).o $<

%.o: %.s
	$(eval S_OUTPUT := $(subst $(SOURCE_DIR),$(OBJ_DIR),$*))
	@mkdir -p $(dir $(S_OUTPUT))
	$(AS) $(AS_FLAGS) $< -filetype=obj -o $(S_OUTPUT).o
	@touch $(S_OUTPUT).d

%.elf: $(OBJS)
	@echo linking $(notdir $@)
	@mkdir -p $(OUTPUT_DIR)
	$(LD) $(LD_FLAGS) -o $(OUTPUT_DIR)/$@ $(OBJ_LD_PATHS) $(LD_LIBRARIES)

%.a: $(OBJS)
	@echo archiving $(notdir $@)
	@mkdir -p $(OUTPUT_DIR)
	$(AR) $(AR_FLAGS) $(OUTPUT_DIR)/$@ $(OBJ_LD_PATHS)

%.nro: %.elf
	@mkdir -p $(OUTPUT_DIR)
	$(LINKLE) nro $(OUTPUT_DIR)/$< $(OUTPUT_DIR)/$@
	@echo built ... $(notdir $@)

%.nso: %.elf
	@mkdir -p $(OUTPUT_DIR)
	$(LINKLE) nso $(OUTPUT_DIR)/$< $(OUTPUT_DIR)/$@
	@echo built ... $(notdir $@)

compile_clean:
	@rm -rf $(BUILD_DIR)
	@rm -rf $(OUTPUT_DIR)