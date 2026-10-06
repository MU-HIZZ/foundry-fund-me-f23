-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

all: clean remove install update build

# Clean the repo
clean:
	forge clean

# Remove modules
remove:
	rm -rf .gitmodules .git/modules/lib & rm -rf lib

# Update dependencies
update:
	forge update

build:
	forge build

test:
	forge test

snapshot:
	forge snapshot

format:
	forge fmt

anvil:
	anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

deploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe $(NETWORK_ARGS)

deploy-anvil:
	@forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://127.0.0.1:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

fund:
	@forge script script/Interactions.s.sol:FundFundMe --rpc-url http://127.0.0.1:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

withdraw:
	@forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url http://127.0.0.1:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast