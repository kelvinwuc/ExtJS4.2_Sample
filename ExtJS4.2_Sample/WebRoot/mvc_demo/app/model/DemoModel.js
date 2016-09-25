Ext.define('mvc.model.DemoModel', {
    extend: 'Ext.data.Model',
    fields: ['id', 'name'],

    proxy: {
        type: 'ajax',
        url: 'data/demo.json',
        reader: {
            type: 'json',
            root: 'results'
        }
    }
});
