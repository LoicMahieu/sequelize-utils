
{chai, requireUtils, sequelize, assert, expect} = require './test_utils'

describe 'sequelize-utils :: property :: JSON', ->
  utils = requireUtils()

  it 'is a function', ->
    expect(utils.property.list).to.be.a('function')

  describe 'Create a Sequelize property object', ->
    [Model] = []

    getter = chai.spy (d) -> d
    setter = chai.spy (d) -> d

    before (done) ->
      Model = sequelize.define('utils_property_list', {
        prop: utils.property.json('prop',
          get: getter
          set: setter
        )
      })
      sequelize.sync(force: true).done done

    # At least one getter or setter should be called in this test
    after 'options.get should be called', ->
      getter.should.have.been.called()
    after 'options.set should be called', ->
      setter.should.have.been.called()


    it 'Can create a model with a json property', ->
      model = Model.build(prop: some: object: true)

      # the property an array
      expect(model.prop).to.be.a('object')
      expect(model.prop).to.deep.equals(some: object: true)
      model.prop.property = true
      expect(model.prop).to.deep.equals(
        some:
          object: true
        property: true
      )

    it 'Not modify the internal value if the value is not re-assigned', ->
      model = Model.build(prop: [])
      model.prop.push('pushed')

      expect(model.getDataValue('prop')).to.be.a('string')
      expect(model.getDataValue('prop')).to.equals('[]')

      model.prop = model.prop

      expect(model.getDataValue('prop')).to.be.a('string')
      expect(model.getDataValue('prop')).to.equals('[\n  "pushed"\n]')

    it 'Set an array', ->
      model = Model.build(prop: [])
      model.prop = ['1', '2', '3']
      expect(model.prop).to.deep.equals(['1', '2', '3'])
      expect(model.getDataValue('prop')).to.equals('[\n  "1",\n  "2",\n  "3"\n]')

    it 'Set a string', ->
      model = Model.build(prop: [])
      model.prop = '1,2,3'
      expect(model.prop).to.equals('1,2,3')
      expect(model.getDataValue('prop')).to.equals('"1,2,3"')

    it 'Can be created without options', ->
      sequelize.define('utils_property_json_without_options', {
        prop: utils.property.json('prop')
      })

