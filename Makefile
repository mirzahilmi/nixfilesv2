.PHONY: os
os:
	git add --all
	nh os switch .

.PHONY: home
home:
	git add --all
	nh home switch . --configuration $(shell hostname)@$(shell hostname)

.PHONY: nvim
nvim:
	nix flake update nvim
	nh home switch . --configuration $(shell hostname)@$(shell hostname)
