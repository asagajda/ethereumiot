//var ConvertLib = artifacts.require("./ConvertLib.sol");
//var MetaCoin = artifacts.require("./MetaCoin.sol");
var doug = artifacts.require("Doug");
var am = artifacts.require("AppManager");
var es = artifacts.require("EternalStorage");
var dl = artifacts.require("DeviceLibrary");
var dm = artifacts.require("DeviceManager");
var fixtures = artifacts.require("Fixtures");

module.exports = function(deployer) {
  deployer.deploy(doug);
  deployer.deploy(am);
  deployer.deploy(dl);
  deployer.link(dl, dm);
  deployer.link(dl, fixtures);
  deployer.deploy(es)
  .then(function() {
    return deployer.deploy(dm, es.address);
  })
  .then(function() {
    return deployer.deploy(fixtures, doug.address, es.address, am.address, dm.address);
  });
};
