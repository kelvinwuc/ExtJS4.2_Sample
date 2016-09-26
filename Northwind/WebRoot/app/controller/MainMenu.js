Ext.define('Northwind.controller.MainMenu', {
    extend: 'Ext.app.Controller',

    requires: [
        'Northwind.view.MainMenu'
    ],

    refs: [
    	{ref:'contentPage', selector: '#contentPage'}
	],

    init: function(app) {
        this.control({
            '#mainmenu button[action=order]': {
                click: this.switchPage
            },
            '#mainmenu button[action=product]': {
                click: this.switchPage
            },
            '#mainmenu button[action=quit]': {
                click: this.Quit
            }
        });
    },
    
    switchPage:function(btn){
    	var me=this,
    		key=btn.action,
    		cmp=Ext.getCmp(key+"View");
    	if(cmp){
    		var layout=me.getContentPage().getLayout();
    		if(layout.getActiveItem().id!=cmp.id){
    			layout.setActiveItem(cmp);
    		}
    	}else{
	    	me.getController(Ext.String.capitalize(key)).init();
	    }
    },
    
    Quit:function(){
    	Ext.app.Login.Quit(function(){
    		window.location="index.html?_dc"+(new Date()).getTime();
    	});
    }

});
