Ext.define('AM.controller.Users', {
	extend: 'Ext.app.Controller',
	views: ['user.List', 'user.Edit'],
	models: ['User'],
	stores: ['Users'],
	init: function() {
		this.control({
			'viewport > panel': {
				render: this.onPanelRendered
			},
			'userlist': {
				itemdblclick: this.editUser
			},
			'useredit button[action=save]': {
				click: this.updateUser
			}
		});
	},
	onPanelRendered: function() {
		console.log('The panel was rendered');
	},
	editUser: function(grid, record) {
		//創建useredit view的方式有三種:1.Ext.create 2.Ext.widget 3.xtype
		var view = Ext.widget('useredit');
		view.down('form').loadRecord(record);
	},
	updateUser: function(button) {
		var win = button.up('window'),
			form = win.down('form'),
			record = form.getRecord(),
			values = form.getValues();
		record.set(values);
		win.close();
		this.getUsersStore().sync();
	}
});