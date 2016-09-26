Ext.define('Northwind.model.OrderDetail',{
    extend: 'Ext.data.Model',
    fields: [
    	{name:'OrderID',type:"int"},
    	{name:'ProductID',type:"int"},		    	
    	{name:'UnitPrice',type:"float"},
    	{name:'Quantity',type:"int"},
    	{name:'Discount',type:"float"},		    	
    	'ProductName'
    ]
});
