const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying BasicAttendanceTracking contract with account:", deployer.address);

  const BasicAttendanceTracking = await hre.ethers.getContractFactory("BasicAttendanceTracking");
  const basicAttendanceTracking = await BasicAttendanceTracking.deploy();

  await basicAttendanceTracking.deployed();

  console.log("BasicAttendanceTracking deployed to:", basicAttendanceTracking.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
