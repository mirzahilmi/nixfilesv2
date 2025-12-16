.PHONY: os
os:
	git add --all
	sudo nixos-rebuild switch --flake .

.PHONY: home
home:
	git add --all
	home-manager switch --flake .
