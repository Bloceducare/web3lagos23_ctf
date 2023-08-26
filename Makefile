-include .env

	
 deploy1:
	@forge script ./script/Prep.s.sol --fork-url http://127.0.0.1:8545 --broadcast -vvvvv
