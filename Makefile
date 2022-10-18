RUN = run --include .
OPC = opc

clvm_target_for_coin = $(1).clvm.hex $(1).clvm.hex.sha256tree
clvm_target_for_folder = $(foreach target,$(2),$(call clvm_target_for_coin,$(1)/$(target)))

.PRECIOUS: %.clvm %.clvm.hex %.clvm.hex.sha256tree

%.clvm: %.clsp
	$(RUN) $^ > $@

%.clvm.hex: %.clvm
	$(OPC) $^ > $@

%.clvm.hex.sha256tree: %.min.clvm
	$(OPC) --script-hash $^ > $@

chia_clvm_targets = $(call clvm_target_for_folder,chia,cat-v1 cat-v2 singleton singleton-v1-1)
compile-chia: $(chia_clvm_targets)

test_targets = $(basename $(wildcard tests/test-*.clsp))

test-%:
	$(RUN) $@.clsp

test: $(test_targets)
