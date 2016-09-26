Ext.define('Northwind.view.MainMenu', {
    extend: 'Ext.toolbar.Toolbar',
	alias : 'widget.mainmenu',
	
    id: 'mainmenu',

    initComponent: function() {
    	var me=this,
    		userInfo=Ext.state.Manager.get("userInfo"),
    		buttons=[];
    		
	   // if(userInfo.role=="管理员"){
	    	buttons.push({text:"用户",action:"user"});
//	    }else{
//			buttons.push({text:"订单管理",action:"order"});
//			buttons.push({text:"产品管理",action:"product"});
//	    }
		buttons.push("->");
		buttons.push({text:"退出",action:"quit"});
		
   		
        me.items = buttons;

        this.callParent(arguments);
    }
    
});
