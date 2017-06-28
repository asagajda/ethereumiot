//var ConvertLib = artifacts.require("./ConvertLib.sol");
//var MetaCoin = artifacts.require("./MetaCoin.sol");
var doug = artifacts.require("Doug");
var am = artifacts.require("AppManager");
var es = artifacts.require("EternalStorage");
var dl = artifacts.require("DeviceLibrary");
var dm = artifacts.require("DeviceManager");

module.exports = function(deployer) {
  deployer.deploy(doug);
  deployer.deploy(am);
  deployer.deploy(es);
  deployer.deploy(dl);
  deployer.link(dl, dm);
  deployer.link(es, dm);
  deployer.deploy(dm);

};
