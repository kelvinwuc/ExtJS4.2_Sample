Ext.define("Northwind.store.CustomerTreeStore",{
    extend: 'Ext.data.TreeStore',
    proxy: {
		type:"direct",
		directFn:Ext.app.Customer.TreeList,
        reader:{
        	type: 'json',
        	root:"data"
        }
    }
})
