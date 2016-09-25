Ext.onReady(function(){

	var datas = [
		[100, '張三', 24, true, new Date(2000,01,01), 'man'], 
		[200, '李四', 25, false, new Date(2001,02,02), 'woman'], 
		[300, '王五', 26, false, new Date(2002,03,03), 'man']
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
			fields: ['id', 'name', 'age', 'leader', 'birthday', 'sex'],
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
	        
	        items: [
	        Ext.create('Ext.grid.RowNumberer',{text : '行號', width : 35}),
	        {
	            text: 'id',
	            dataIndex: 'id',
	            flex: 10 / 100,
	            sortable: false
	        }, {
	            text: '姓名',
	            dataIndex: 'name',
	            flex: 10 / 100
	        }, {
	            text: '年齡',
	            dataIndex: 'age',
	            flex: 10 / 100,
	            renderer: formatAge
	        }, {
	        	text: '主管',
	        	dataIndex: 'leader',
	        	xtype: 'booleancolumn',
	        	trueText: '是',
	        	falseText: '否',
	        	flex: 10 / 100
	        }, {
	        	text: '生日',
	        	dataIndex: 'birthday',
	        	xtype: 'datecolumn',
	        	format: 'Y年m月d日',
	        	flex: 10 / 100
	        }, {
	        	text: '操作', 
	        	flex: 10 / 100,
	        	xtype: 'actioncolumn',
	        	items: [{
	        		icon: '../grids/images/edit.gif',
	        		handler: function(grid, rowIndex, colIndex) {
						var record = grid.getStore().getAt(rowIndex);
						gridColumns = grid.headerCt.getGridColumns();
						var fieldName = gridColumns[2].text;
						Ext.Msg.alert("編輯",fieldName + ":" + record.get('name'));
	        		}
	        	}, {
	        		icon: '../grids/images/del.gif',
	        		handler: function(grid, rowIndex, colIndex) {
						var record = grid.getStore().getAt(rowIndex);
						gridColumns = grid.headerCt.getGridColumns();
						var fieldName = gridColumns[4].text;
						Ext.Msg.alert("刪除",fieldName + ":" + record.get('leader'));
	        		}
	        	}, {
	        		icon: '../grids/images/save.gif',
	        		handler: function(grid, rowIndex, colIndex) {
						var record = grid.getStore().getAt(rowIndex);
						gridColumns = grid.headerCt.getGridColumns();
						var fieldName = gridColumns[5].text;
						Ext.Msg.alert("儲存",fieldName + ":" + record.get('birthday'));
	        		}
	        	}]
	        }, {
	        	text: '描述',
	        	xtype: 'templatecolumn',
	        	tpl: '{name}<tpl if="leader==false">不</tpl>是主',
	        	flex: 30 / 100
	        }, {
	        	text: '性別',
	        	dataIndex: 'sex',
	        	flex: 10 /100,
	        	renderer: formatSex
	        }]
		}
	});
	
	function formatAge(value, metadata) {
		if(value<25) {
			metadata.style = 'background-color:#CCFFFF;';
		}
		return value;
	}
	
	function formatSex(value) {
		return value=='man' ? '男':'<font color=red>女</font>'
	}
	
});