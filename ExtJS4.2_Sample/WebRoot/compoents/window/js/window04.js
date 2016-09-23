Ext.onReady(function() {
	
	//設計form元件
	var form = Ext.create('Ext.form.Panel', {
		title: '表單01',
		region: 'center',
		height: 150,
		//layout: 'fit',
		items: [{
			xtype: 'textfield',
			name: 'account',
			fieldLabel: '帳號'
		}, {
			xtype: 'textfield',
			name: 'account2',
			fieldLabel: '帳號2'
		}],
		buttons: [
		{
			text: '查詢',
			handler: function() {
				Ext.Msg.alert('執行查詢', '查詢按鈕被執行了!');
				grid.store.reload;
			}
		}, {
			text: '取消',
			scope: this,
			handler: this.close
		}]
	});
	
	//設計store元件
	var datas = [
		['張三'], 
		['李四'], 
		['王五']
	];
	
	var store = Ext.create('Ext.data.Store', {
		fields: ['name'],
		proxy: {
			type: 'memory',
			data: datas,
			reader: 'array'
		}
		//autoLoad:true
	})
	
	//設計grid元件
	var grid = Ext.create('Ext.grid.Panel', {
		title: 'grid範例',
		region: 'south',
		height: 250,
		store: store,
		columns: {
			defaults: {
	            resizable: false
	        },
	        items: [Ext.create('Ext.grid.RowNumberer',{text : '行號', width : 35})
	        ,{
	            text: '帳號',
	            dataIndex: 'name',
	            flex: 50 / 100
	        }]
		}
	});
	
	//設計window元件
	var win = Ext.create('Ext.window.Window', {
		title: 'window元件demo04',
		layout: 'border',		
		width: 600,
		height: 700,
		closable: true,
		closeAction: 'hide',
		constrain: true,
		autoShow: true,
		//plain: true,
        items:[form,grid],
        buttons: [{
        text: 'win按鈕01',
        handler: function() {
        	Ext.Msg.alert('執行查詢', 'win按鈕01被執行了!');
        	grid.store.reload;
        }}, {text: 'win按鈕02'}]
	});
	
});