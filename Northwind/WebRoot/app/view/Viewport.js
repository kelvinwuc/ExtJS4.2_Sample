Ext.define('Northwind.view.Viewport', {
    extend: 'Ext.container.Viewport',

    id: 'viewport',
    layout:{type:'vbox',align:"stretch"},
    defaults:{xtype:'container',style:"background-color:#D3E1F1;"},

    initComponent: function() {
    	var me=this;
    		
		
    		
        me.items = [
	        {
	            height: 40,
	            id: 'logo-container',
	            html:"Northwind管理系统",
	            padding:"0 0 0 20",
	            style:"font-size:20px;font-weight:bold;line-height:40px;background-color:#D3E1F1;",
	        },
	        {xtype:"mainmenu"},
	        {xtype:"panel",
				id:"contentPage",
	            layout:'card',flex:1,
	            padding:"5",	            
	            items: [{
	            	title:"欢迎使用Northwind管理系统",
	                html:"欢迎使用Northwind管理系统"
	            }]			
	        }
        ];

        this.callParent(arguments);
    }
    
});
