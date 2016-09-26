Ext.define("Northwind.store.Order",{
    extend: 'Ext.data.Store',
	model:'Northwind.model.Order',
	pageSize:20,
	batchActions:false,
	remoteFilter:true,
	remoteSort:true,
    proxy: {
		type:"direct",
		directFn:Ext.app.Order.List,
        reader:{
        	type: 'json',
        	root:"data"
        }
    }
})
