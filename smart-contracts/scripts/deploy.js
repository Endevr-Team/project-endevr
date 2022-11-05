// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {

  const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying contracts with the account:",
    deployer.address
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const EndeavourDeployer = await hre.ethers.getContractFactory("EndeavourDeployer");
  const endeavourDeployer = await EndeavourDeployer.deploy("0x73C4e14793AD8406B9834796d2Cb6E56a0aDA9C5");

  await endeavourDeployer.deployed();

  console.log("EndeavourDeployer deployed to:", endeavourDeployer.address);

  const EndeavourController = await hre.ethers.getContractFactory("EndeavourController");
  const endeavourController = await EndeavourController.deploy(endeavourDeployer.address);

  await endeavourController.deployed();

  console.log("EndeavourController deployed to:", endeavourController.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
