const MusicPulseNFT = artifacts.require("MusicPulseNFT");
const ERC6551Account = artifacts.require("ERC6551Account");
const ERC6551Registry = artifacts.require("ERC6551Registry");
const AccessToken = artifacts.require("AccessToken");

module.exports = async function(deployer){
    await deployer.deploy(MusicPulseNFT);
    await deployer.deploy(AccessToken);
    const accessToken = await AccessToken.deployed();
    await deployer.deploy(ERC6551Registry, accessToken.address);
    await deployer.deploy(ERC6551Account);
   
};