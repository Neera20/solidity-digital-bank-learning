pragma solidity ^0.5.0;

import "./DaiToken.sol";
import "./DappToken.sol";

contract TokenFarm{
	//
	string public name = "Dapp Token Farm";
	DappToken public dappToken;
	DaiToken public daiToken;
	address public owner;

	//hashtable
	address[] public stakers;
	mapping(address => uint) public stakingBalance;
	mapping(address => bool) public hasStaked;
	mapping(address => bool) public isStaking;

	constructor( DappToken _dappToken, DaiToken _daiToken) public{
		dappToken = _dappToken;
		daiToken = _daiToken;
		owner = msg.sender; // track the owner when deploying the contract

	}

	// 1. Stake Tokens (Deposit)

	function stakeTokens(uint _amount) public {
		// Require amount greater than 0
		require(_amount > 0, "amount cannot be 0");
		// Transfer mock dai tokens to this contract for staking
		// delegated transfer
		//msg.sender is a global variable (address where the call originated from)
		// address(this) adress of the contract instance
		daiToken.transferFrom(msg.sender, address(this), _amount); //(from, to , amount)



		//Update the staking balance hashtable
		stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

		// Add user to stakeers array *only* if they haven't staked already
		if (!hasStaked[msg.sender]) {
			stakers.push(msg.sender);
		}
		// Update staking staus
		isStaking[msg.sender] = true;
		hasStaked[msg.sender] = true;


	}

	// 2. Unstaking Tokens (Withdraw)

	function unstakeTokens() public {
		// Fetch the staking balance
		uint balance = stakingBalance[msg.sender];

		//Require balance to be greater than 0
		require(balance > 0, "staking balance cannot be zero" );
		daiToken.transfer(msg.sender,balance);
		stakingBalance[msg.sender]= 0;

		isStaking[msg.sender] = false;
	}

	// 3. Issuing Tokens
	function issueTokens() public{
		// Only owner can call this function
		require(msg.sender == owner, "caller must be the owner" );
		//Issue tokens to the stakers
		for (uint i=0; i<stakers.length; i++){
			address recipient = stakers[i];
			uint balance = stakingBalance[recipient];
			if(balance >0){
				dappToken.transfer(recipient,balance);
			}

		}
	}



}