-include .env

fund-fundme:
	forge script script/Interactions.s.sol:FundFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --verify -vvvv

withdraw-fundme:
	forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --verify -vvvv

deploy-sepolia:
	forge script script/FundMe.s.sol:FundMeScript --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --verify -vvvv

deploy-anvil: 
	forge script script/FundMe.s.sol:FundMeScript --rpc-url $(ANVIL_RPC_URL) --private-key $(DEFAULT_ANVIL_KEY) --broadcast