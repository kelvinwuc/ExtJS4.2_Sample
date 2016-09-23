Ext.onReady(function() {
		
	var win = Ext.create('Ext.window.Window', {
		title: 'window元件demo02',
		//layout: 'fit',
		//maximizable: true,
		modal:true,		
		width: 300,
		height: 120,
		closable: true,
		resizeable: false,
		closeAction: 'hide',
		autoShow: true,
		items: form
	});
	
});