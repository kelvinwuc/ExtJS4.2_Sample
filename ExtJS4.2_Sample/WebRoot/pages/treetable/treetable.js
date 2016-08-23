Ext.Loader.setConfig({enalbed: true});

Ext.Loader.setPath('Ext.ux', '../ExtJS4/ux/');

Ext.require([
	'Ext.data.*',
	'Ext.grid.*',
	'Ext.tree.*',
	'Ext.ux.CheckColumn'
]);

Ext.onReady(function() {
	Ext.QuickTips.init();
	
	Ext.define('Task', {
		extend: 'Ext.data.Model',
		fields: [
			{name: 'task',     type: 'string'},
            {name: 'user',     type: 'string'},
            {name: 'duration', type: 'string'}
		]
	});
	
	var store = Ext.create('Ext.data.TreeStore', {
		model: 'Task',
		proxy: {
			type: 'ajax',
			url: 'treegrid-data.json'},
		folderSort: true
	});
	
	var tree = Ext.create('Ext.tree.Panel', {
		title: 'Core Team Projects',
		width: 500,
		height: 300,
		renderTo: 'treegrid',
		collapsible: true,
		useArrows: true,
		rootVisible: false,
		store: store,
		multiSelect: true,
		singleExpand: true,
		columns:[{
			xtype: 'treecolumn',
			text: 'Task',
			flex: 2,
			sortable: true,
			dataIndex: 'task'
		},{
			xtype: 'templatecolumn',
			text: 'Duration',
			flex: 1,
			sortable: true,
			dataIndex: 'duration',
			align: 'center',
			tpl: Ext.create('Ext.XTemplate', '{duration:this.formatHours}', {
				formatHours: function(v) {
					if(v < 1) {
						return Math.random(v * 60) + 'mins';
					} else if(Math.floor(v) != v) {
						var min = v - Math.floor(v);
						return Math.floor(v) + 'h ' + Math.round(min * 60) + 'm'
					} else {
						return v + ' hour' + (v === 1 ? '' : 's');
					}
				}
			})
		}, {
			text: 'Assigned To',
			flex: 1,
			dataIndex: 'user',
			sortable: true
		}, {
			xtype: 'checkcolumn',
			text: 'Done',
			dataIndex: 'done',
			width: 40,
			stopSelection: false
		}, {
			text: 'Edit',
			width: 40,
			menuDisalbed: true,
			xtype: 'actioncolumn',
			tooltip: 'Edit task',
			align: 'center',
			icon: 'images/edit.png',
			handler: function(grid, rowIndex, colIndex, actionItem, event, record, row) {
				Ext.Msg.alert('Editing' + (record.get('done') ? ' completed task' : ''), record.get('task'));
			}
		}]
	});
	
});