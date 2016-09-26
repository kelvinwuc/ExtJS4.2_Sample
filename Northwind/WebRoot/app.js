Ext.Loader.setConfig({
    enabled: true,
    paths: {
        'Northwind': 'app'
    }
});

//Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
Ext.ns('Northwind.app');
Ext.require('Northwind.LoginWin');


Ext.onReady(function() {
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider({
	    expires: new Date(new Date().getTime()+(1000*60*60))
	}));	
	if(Ext.util.Cookies.get("hasLogin")=="true"){
		Ext.create("Northwind.Application");
	}else{
    	Northwind.LoginWin.show();
    }
});

