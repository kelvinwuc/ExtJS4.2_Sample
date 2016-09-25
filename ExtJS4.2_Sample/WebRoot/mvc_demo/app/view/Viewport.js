Ext.define('mvc.view.Viewport', {
    extend: 'Ext.container.Viewport',
    layout: 'fit',

    requires: [
        'mvc.view.DemoView'
    ],

    initComponent: function() {
        this.items = [{xtype: 'demoView'}];

        this.callParent();
    }
});
