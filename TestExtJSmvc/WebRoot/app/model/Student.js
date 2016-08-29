Ext.define('app.model.Student', {
    extend: 'Ext.data.Model',
    fields: [
     		{name: 'id', type: 'int'},
     		{name: 'code', type: 'string'},
     		{name: 'name', type: 'string'},
     		{name: 'sex', type: 'int'},
     		{name: 'age', type: 'int'},
     		{name: 'political', type: 'string'},
     		{name: 'origin', type: 'string'},
     		{name: 'professional', type: 'string'}
     	]
});
