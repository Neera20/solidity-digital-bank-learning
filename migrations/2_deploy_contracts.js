const DaiToken = artifacts.require("DaiToken");
const DappToken = artifacts.require ("DappToken");
const TokenFarm = artifacts.require("TokenFarm");

// below three variables are accessible in the migration file
// async does the step by step process
module.exports = async function(deployer, network, accounts) {

  // Deploy the Mock dai token
  await deployer.deploy(DaiToken)
  const daiToken = await DaiToken.deployed();

  // Deploy the Mock dai token
  await deployer.deploy(DappToken)
  const dappToken = await DappToken.deployed();

  // Deploy the Mock dai token
  await deployer.deploy(TokenFarm, dappToken.address, daiToken.address)
  const tokenFarm = await TokenFarm.deployed();

  // transfer all the tokens to TokenFarm (1million)
  await dappToken.transfer(tokenFarm.address, '1000000000000000000000000')

  //Transfer 100 mock DAI tokens to an investor
  await daiToken.transfer(accounts[1],'100000000000000000000')

}
