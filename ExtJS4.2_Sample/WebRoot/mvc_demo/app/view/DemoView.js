Ext.define('mvc.view.DemoView', {
    extend: 'Ext.Panel',
    alias: 'widget.demoView',
    store: 'DemoStore',
    queryMode: 'local',
	title: 'Demo',
	buttons: [{
		text: 'update',
		action: 'updatePanelBody'
	}],

    updateBody: function(html) {
        this.body.setHTML(html);
    }
});
