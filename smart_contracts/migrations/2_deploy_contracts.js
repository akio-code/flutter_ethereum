const AkioCoin = artifacts.require("AkioCoin");

module.exports = function(deployer) {
    // deployer.deploy(AkioCoin, `${199*10**18}`);
    deployer.deploy(AkioCoin);
};