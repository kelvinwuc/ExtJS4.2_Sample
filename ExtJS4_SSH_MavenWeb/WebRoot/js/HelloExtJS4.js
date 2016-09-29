Ext.onReady(function(){
	new Ext.Viewport({
		layout:'fit',
		items:[{
			xtype:"panel",
			title:"歡迎",
			html:"<h1 style='text-align:center;font-size:60px;font-weight:bold;'>Hello World</h1>"
		}]
	});
});