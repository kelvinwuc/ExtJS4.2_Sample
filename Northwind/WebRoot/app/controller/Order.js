Ext.define('Northwind.controller.Order', {
    extend: 'Ext.app.Controller',


    stores: [
        'Order',
        'OrderDetail',
        'CustomerTreeStore'
    ],

    models: [
        'Order',
        'OrderDetail'
    ],

	views:["order.View"],

    refs: [
    	{ref:'contentPage', selector: '#contentPage'}
	],

    init: function() {
    	var me=this,
    		view=me.getOrderViewView(),
    		c=me.getContentPage();
        me.control({
            '#orderView': {
                render: this.onPanelRendered
            }
        });
    	c.add(view);
    },
    
    onPanelRendered :function(panel){
    	var me=this,
    		c=me.getContentPage();
    	c.getLayout().setActiveItem(panel);
    }
    


});
