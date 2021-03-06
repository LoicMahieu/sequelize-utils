
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
      Model = sequelize.define('utils_property_json', {
        prop: utils.property.json('prop',
          get: getter
          set: setter
        )
      })
      Model.sync(force: true).done done

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

    it 'Can populate with object and retrieve from DB', (done) ->
      data = some: object: true
      model = Model.build(prop: data)

      expect(model.prop).to.deep.equals(data)

      model.__old_model = true

      model.save().done (err) ->
        return done err if err
        Model.find(where: id: model.id).done (err, _model) ->
          return done err if err
          expect(_model.__old_model).to.be.a('undefined')
          expect(_model.prop).to.deep.equals(data)

          done()


    # it 'Can be created without options', ->
    #   sequelize.define('utils_property_json_without_options', {
    #     prop: utils.property.json('prop')
    #   })

  describe 'Options: indent', ->
    Model = sequelize.define('utils_property_json', {
      prop: utils.property.json('prop',
        indent: 0
      )
    })
    it 'Can overwrite default indent to 0', ->
      model = Model.build(prop: [])
      model.prop = ['1', '2', '3']
      expect(model.getDataValue('prop')).to.equals('["1","2","3"]')
      model.prop = '1,2,3'
      expect(model.getDataValue('prop')).to.equals('"1,2,3"')
      model.prop = {prop: 1}
      expect(model.getDataValue('prop')).to.equals('{"prop":1}')

  describe 'Options: defaultValue', ->
    Model = sequelize.define('utils_property_json', {
      prop: utils.property.json('prop',
        defaultValue: {prop: 1}
      )
    })
    it 'Stringify defaultValue', ->
      model = Model.build()
      expect(model.prop).to.deep.equals({prop: 1})
      expect(model.getDataValue('prop')).to.equals('{"prop":1}')
