Ext.onReady(function() {
	
	Ext.QuickTips.init();
	
	var win = Ext.create('Ext.window.Window', {
		el: 'window-win',
		title: 'window元件demo03',
		layout: 'fit',		
		width: 500,
		height: 300,
		closable: true,
		closeAction: 'hide',
		constrain: true,
		autoShow: true,
		items: [{
			xtype: 'textfield',
			fieldLabel: '帳號'
		}],
		buttons: [{text: '按鈕'}]
	});
	
});