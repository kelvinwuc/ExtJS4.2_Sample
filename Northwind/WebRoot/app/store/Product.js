﻿Ext.define("Northwind.store.Product",{
	extend:"Ext.data.Store",
	model:'Northwind.model.Product',
	pageSize:20,
	autoLoad:true,
	remoteFilter:true,
	remoteSort:true,
	sorters:[{property :'ProductID',direction: 'DESC'}],
    proxy:{
    	type:"direct",
    	batchActions:false,
		api:{
        	read:Ext.app.Product.List,
        	destroy:Ext.app.Product.Delete
		},
		reader:{
			type:"json",
			root:"data"
		}
    }
})