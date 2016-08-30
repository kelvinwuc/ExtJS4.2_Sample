Ext.onReady(function(){

	var datas = [
		[100, '張三', 24], [200, '李四', 25], [300, '王五', 26]
	];
	
	Ext.create('Ext.grid.Panel', {
		title: 'grid範例',
		renderTo: Ext.getBody(),
		//不指定width及height時,grid會滿整個畫
//		width: 300,
//		height: 130,
		frame: true,
		viewConfig:{
			forceFit: true,
			stripeRows: true
//			listeners: {
//            refresh: function(dataview) {
//                Ext.each(dataview.panel.columns, function(column) {
//                    if (column.autoSizeColumn === true)
//                        column.autoSize();
//	                })
//	            }
//	        }
		},
		store:{
			fields: ['id', 'name', 'age'],
			proxy: {
				type: 'memory',
				data: datas,
				reader: 'array'
			},
			autoLoad:true
		},
//		columns: [
//			{header: "id", width: 60, dataIndex: 'id', autoSizeColumn: true, sortable: true},
//			{header: "姓名", width: 60, dataIndex: 'name', autoSizeColumn: true, minWidth: 150, sortable: true},
//			{header: "年齡", width: 60, dataIndex: 'age', autoSizeColumn: true, sortable: true,filterable : true, filter: { type : 'string' }}
//		]
		columns: {
			defaults: {
	            resizable: false
	        },
	        items: [{
	            text: 'id',
	            dataIndex: 'id',
	            flex: 25 / 100,
	            sortable: false
	        }, {
	            text: 'name',
	            dataIndex: 'name',
	            flex: 25 / 100
	        }, {
	            text: 'age',
	            dataIndex: 'age',
	            flex: 50 / 100
	        }]
		}
	});
	
});