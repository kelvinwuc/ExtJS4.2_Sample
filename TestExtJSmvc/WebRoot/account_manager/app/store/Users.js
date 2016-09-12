Ext.define('AM.store.Users', {
	extend: 'Ext.data.Store',
	model: 'AM.model.User',
	autoLoad: true,
	/*data: [{name: '張三', email: 'chang3@hotmail.com'}, 
		{name: '李四', email: 'li4@hotmail.com'}]*/	
	proxy: {
		type: 'ajax',
		//url: 'data/users.json',
		api: {
			read: 'data/users.json',
			update: 'data/updateUsers.json'
		},
		reader: {
			type: 'json',
			root: 'users',
			successProperty: 'success'
		}
	}
});