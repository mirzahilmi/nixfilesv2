.PHONY: os
os:
	git add --all
	nixos-rebuild switch --sudo --flake .

.PHONY: home
home:
	git add --all
	home-manager switch --flake .#$(shell hostname)@$(shell hostname)
