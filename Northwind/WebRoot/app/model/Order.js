Ext.define('Northwind.model.Order', {
    extend: 'Ext.data.Model',
    fields: [
    	{name:'OrderID',type:"int"},
    	'CustomerID','CustomerName',
    	{name:'OrderDate',type:"date",format:"Y-m-d"}
    ],
    idProperty:"OrderID",
    hasMany:{model:"Northwind.model.OrderDetail",name:"OrderDetails",foreignKey:"OrderID"}
});
