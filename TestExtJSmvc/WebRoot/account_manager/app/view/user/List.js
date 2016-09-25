Ext.define('AM.view.user.List', {
	extend: 'Ext.grid.Panel',
	alias: 'widget.userlist',
	title: 'All Users',
	store: 'Users',
	initComponent: function() {
		/*this.store = {
			fields: ['name', 'email'],
			data: [{name: '張三', email: 'chang3@hotmail.com'}, 
		{name: '李四', email: 'li4@hotmail.com'}]
		};*/
		this.columns = [
			{header: '姓名', dataIndex: 'name', flex: 1}, 
			{header: '信箱', dataIndex: 'email', flex:1}];
		this.callParent(arguments);
	}
});