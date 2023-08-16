const MusicPulseNFT = artifacts.require("MusicPulseNFT");
const ERC6551Account = artifacts.require("ERC6551Account");
const ERC6551Registry = artifacts.require("ERC6551Registry");

module.exports = async function(deployer){
    await deployer.deploy(MusicPulseNFT);
    await deployer.deploy(ERC6551Account);
    await deployer.deploy(ERC6551Registry);
};