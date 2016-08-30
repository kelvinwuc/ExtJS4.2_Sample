Ext.define('app.controller.Student', {
    extend: 'Ext.app.Controller',

    refs: [{
        ref: 'Student',
        selector: 'Student'
    }],

	models: ['Student'],
    stores: ['Student'],

    init: function() {
        this.control({
            'Student': {
                show: this.onStudentShow
            },
            'Student button[action=add]': {
                click: this.onStudentShow
            },
            'Student button[action=edit]': {
                click: this.onStudentShow
            },
            'Student button[action=delete]': {
                click: this.onStudentShow
            }
        });
    },

    onStudentShow: function() {
		var grid = this.getStudent();
		var seletionModel = grid.getSelectionModel();
		var sm = grid.getSelectionModel();
		if (sm.getSelection().length == 0) {
			Ext.Msg.alert('请选择一条记录');
			return;
		}
		
		var record = sm.selected;
		var nameArr = [];
		for(var i=0; i<record.getCount(); i++){
			nameArr.push((i+1) + ":" + record.get(i).get('name'));
		}		
		Ext.Msg.alert("共計選取" + record.getCount() + "列資料", "姓名:<br>" + nameArr.join("<br>"));
		
//		var store = this.getStudentStore();
//		var data = store.getAt(0).get('name');		
//    	Ext.Msg.alert("已選選的列數", store.data.length + "-" + data);
	}
});
