
Sequelize = require 'sequelize'

chai = require 'chai'
assert = chai.assert
expect = chai.expect
chai.should()
chai.use(require('chai-spies'))

log = (process.env.TEST_VERBOSE && console.log) || ->

utils = module.exports =
  chai: chai
  assert: assert
  expect: expect

  sequelize: new Sequelize(
    process.env.TEST_DB || 'sequelize_utils_test',
    process.env.TEST_DB_user || 'root',
    process.env.TEST_DB_password || '',
    logging: log
    sync: logging: log
  )

  requireTest: (path) ->
    require((process.env.APP_SRV_COVERAGE || '../') + path)

  requireUtils: -> utils.requireTest('lib/sequelize-utils')
