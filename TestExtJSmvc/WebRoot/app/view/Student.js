    var sexRenderer = function(value) {
        if (value == 1) {
            return '<span style="color:red;font-weight:bold;">男</span>';
        } else if (value == 2) {
            return '<span style="color:green;font-weight:bold;">女</span>';
        }
    };
    
    var columns = [
                   {header: '学号', dataIndex: 'code'},
                   {header: '姓名', dataIndex: 'name'},
                   {header: '性别', dataIndex: 'sex', renderer: sexRenderer},
                   {header: '年龄', dataIndex: 'age'},
                   {header: '政治面貌', dataIndex: 'political'},
                   {header: '籍贯', dataIndex: 'origin'},
                   {header: '所属系', dataIndex: 'professional'}
               ];
 
    Ext.define('app.view.Student', {
        //extend: 'Ext.grid.GridPanel',
    	extend: 'Ext.grid.Panel',
        alias: 'widget.Student',
        title: '学生信息列表',
        iconCls: 'icon-user',
        loadMask: true,
        store: 'Student',
        columns: columns,
		forceFit: true,
		multiSelect : true,
		tbar: [{
			iconCls: 'icon-add',
			text: '添加',
			action: 'add'
		}, {
			iconCls: 'icon-edit',
			text: '修改',
			action: 'edit'
		}, {
			iconCls: 'icon-delete',
			text: '删除',
			action: 'delete'
		}],
		bbar: {
			xtype: 'pagingtoolbar',
			pageSize: 5,
			store: 'Student',
			displayInfo: true
		}
    });
