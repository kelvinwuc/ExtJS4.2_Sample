Ext.define('mvc.controller.DemoController', {
    extend: 'Ext.app.Controller',

    refs: [{
        ref: 'demoView',
        selector: 'demoView'
    }],

    stores: ['DemoStore'],

    init: function() {
        this.control({
        	'demoView': {
        		show: Ext.Msg.alert("測試11","測試11"),
        		//show: this.onDemoShow,
        		resize: this.onDemoShow
        	},
            'demoView button[action=updatePanelBody]': {
                click: this.onDemoUpdate
            }
        });
        
        this.application.on({
            show: this.onDemoShow,
            scope: this
        });
    },

	onDemoUpdate: function() {
		this.getDemoView().updateBody('body update');
	},
	
	onDemoShow: function() {
		this.getDemoView().updateBody('body show');
	}
	
});
