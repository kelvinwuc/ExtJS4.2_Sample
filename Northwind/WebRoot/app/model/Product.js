Ext.define('Northwind.model.Product', {
    extend: 'Ext.data.Model',
    fields: [
    	{name:'ProductID',type:"int"},
    	'ProductName',
    	{name:'SupplierID',type:"int"},
    	{name:'CategoryID',type:"int"},
    	'QuantityPerUnit',
    	{name:'UnitPrice',type:"float"},
    	{name:'UnitsInStock',type:"int"},
    	{name:'UnitsOnOrder',type:"int"},
    	{name:'ReorderLevel',type:"int"},
    	{name:'Discontinued',type:"bool"},
    	"CategoryName","CompanyName"
    ],
    idProperty:"ProductID"
});
