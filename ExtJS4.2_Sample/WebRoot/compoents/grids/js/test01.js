Ext.onReady(function(){
	
		//Ext.Msg.alert("1","2");

	new Ext.Viewport({
		layout: 'fit',
		items: [{
			xtype: "panel",
			title: "歡迎",
			html: "<h2>hello world</h2>"
		}]
	});
	
});