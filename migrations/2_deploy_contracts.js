const MusicPulseNFT = artifacts.require("MusicPulseNFT");

module.exports = async function(deployer){
    await deployer.deploy(MusicPulseNFT);
};