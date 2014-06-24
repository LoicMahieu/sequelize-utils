
{chai, requireUtils, sequelize, assert, expect} = require './test_utils'

describe 'property.list', ->
  utils = requireUtils()

  it 'is a function', ->
    expect(utils.property.list).to.be.a('function')

  describe 'Create a Sequelize property object', ->
    [Model] = []

    getter = chai.spy (d) -> d
    setter = chai.spy (d) -> d

    before (done) ->
      Model = sequelize.define('utils_property_list', {
        prop: utils.property.list('prop',
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




    it 'Can create a model with a list property', ->
      model = Model.build(prop: [])

      # the property an array
      expect(model.prop).to.be.a('array')
      expect(model.prop).to.deep.equals([])
      model.prop.push('pushed')
      expect(model.prop).to.deep.equals(['pushed'])


    it 'Not modify the internal value if the value is not re-assigned', ->
      model = Model.build(prop: [])
      model.prop.push('pushed')

      expect(model.getDataValue('prop')).to.be.a('string')
      expect(model.getDataValue('prop')).to.equals('')

      model.prop = model.prop

      expect(model.getDataValue('prop')).to.be.a('string')
      expect(model.getDataValue('prop')).to.equals('pushed')

    it 'Set an array', ->
      model = Model.build(prop: [])
      model.prop = ['1', '2', '3']
      expect(model.prop).to.deep.equals(['1', '2', '3'])
      expect(model.getDataValue('prop')).to.equals('1,2,3')

    it 'Set a string', ->
      model = Model.build(prop: [])
      model.prop = '1,2,3'
      expect(model.prop).to.deep.equals(['1', '2', '3'])
      expect(model.getDataValue('prop')).to.equals('1,2,3')

    it 'Set an object clear the list', ->
      model = Model.build(prop: [])
      model.prop = '1,2,3'
      expect(model.prop).to.deep.equals(['1', '2', '3'])
      expect(model.getDataValue('prop')).to.equals('1,2,3')

      model.prop = some: object: true
      expect(model.prop).to.deep.equals([])
      expect(model.getDataValue('prop')).to.equals('')
