-include .env

deploy1:
	@forge script ./script/Prep.s.sol --fork-url http://127.0.0.1:8545 --broadcast -vvvvv

 deployChallenge1:
	@forge script ./script/DeployChallenge1.s.sol --rpc-url https://polygon-mainnet.infura.io/v3/<key> --etherscan-api-key $polygonscan --verifier-url https://api.polygonscan.com/api\
    --broadcast --verify -vvvvv 

 deployChallenge2:
	@forge script ./script/DeployChallenge2.s.sol --rpc-url https://polygon-mainnet.infura.io/v3/<key> --broadcast -vvvvv
 
