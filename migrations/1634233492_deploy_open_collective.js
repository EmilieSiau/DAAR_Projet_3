const BuildCollective = artifacts.require('BuildCollective')
const OpenCollective = artifacts.require('OpenCollective')

module.exports = function (deployer) {
  deployer.deploy(OpenCollective)
}
