const LPLock = artifacts.require("LPLock");

module.exports = async function (deployer) {
  await deployer.deploy(LPLock);
};
