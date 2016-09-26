Ext.define("Northwind.store.OrderDetail",{
    extend: 'Ext.data.Store',
	model:'Northwind.model.OrderDetail',
    proxy: {
		type:"ajax",
        reader:{
        	type: 'json',
        	root:"data"
        }
    }
})
