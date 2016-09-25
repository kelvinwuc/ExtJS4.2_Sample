Ext.define('app.view.Viewport', {
    extend: 'Ext.container.Viewport',
    layout: 'border',

    requires: [
       'app.view.Student'
    ],

    initComponent: function() {
        this.items = [/*{
    			region: 'west',
    			width: 150,
    			html: 'west'
    		}, */{
    			region: 'center',
    			xtype: 'Student'
        }];

        this.callParent();
    }
});
