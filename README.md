sequelize-utils
===============

[![Greenkeeper badge](https://badges.greenkeeper.io/LoicMahieu/sequelize-utils.svg)](https://greenkeeper.io/)

```
npm install --save sequelize-utils
```


# Properties

## JSON

### Options

`indent`: Causes the resulting string to be pretty-printed. Default: 2

```
Model = sequelize.define('utils_property_list', {
  prop: utils.property.json('prop')
});
```


## List

### Options

`separator`: Delimiter. Default: ','

```
Model = sequelize.define('utils_property_list', {
  prop: utils.property.list('prop')
});
```
