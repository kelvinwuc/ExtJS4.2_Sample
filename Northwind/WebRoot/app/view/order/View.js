Ext.define('Northwind.view.order.View', {
    extend: 'Ext.panel.Panel',
    alias : 'widget.orderview',
	
	layout:"border",
	
	title:"订单管理",
	id:"orderView",

    initComponent: function() {
    	var me=this;
    	
    	me.tree=Ext.widget("treepanel",{
			title:"客户",region:"west",collapsible: true,
			rootVisible:false,store:"CustomerTreeStore",
			width:200,minWidth:100,split:true,
			viewConfig:{
				listeners:{
					scope:me,
					refresh: me.onTreeRefresh
				}
			},
			listeners:{
				scope:me,
				selectionchange:me.onTreeSelect
			}
    	});
    	
    	me.orderGrid=Ext.widget("grid",{
			title:"订单",region:"center",minHeight:200,
			tbar:{xtype:"pagingtoolbar",store:"Order",displayInfo:true},
			selMode:{mode:"SINGLE"},store:"Order",
			collapsible: true,
			columns:[
				{xtype:"rownumberer",sortable:false,width:60},
				{text:'订单号',dataIndex:'OrderID'},
				{text:'客户编号',dataIndex:'CustomerID'},
				{text:'客户名称',dataIndex:'CustomerName',sortable:false,flex:1},
				{xtype:"datecolumn",text:'订购日期',dataIndex:'OrderDate',format:"Y-m-d",width:100}
			],
			viewConfig:{
				listeners:{
					scope:me,
					refresh:me.onOrderRefresh
				}
			},
			listeners:{
				scope:me,
				selectionchange:me.onOrderSelect
			}
    	});
    	
    	me.detailsGrid=Ext.widget("grid",{
			title:"订单明细",region:"south",
			split:true,height:300,minHeight:200,
			collapsible: true,store:"OrderDetail",
			columns:[
				{xtype:"rownumberer",sortable:false,width:60},
				{text:'产品名称',dataIndex:'ProductName',sortable:false,flex:1},
				{xtype:"numbercolumn",text:'单价',dataIndex:'UnitPrice',align:"right",format:"0,0.00"},
				{xtype:"numbercolumn",text:'数量',dataIndex:'Quantity',format:"0,0"},
				{xtype:"numbercolumn",text:'折扣',dataIndex:'Discount',format:"0,0.00"}
			]
    	});

		this.items=[me.tree,me.orderGrid,me.detailsGrid];
        this.callParent(arguments);
        
    },
    
    onTreeRefresh:function(){
    	//this.tree.view.select(0);
    },
    
    onTreeSelect:function(model,sels){
		if(sels.length>0){
			var rs=sels[0],
				store=this.orderGrid.store;
			store.proxy.extraParams.CustomerID=rs.data.id;
			this.detailsGrid.store.loadRecords([]);
			store.load();
		}
    },
    
    onOrderRefresh:function(){
    	if(this.orderGrid.store.getCount()>0){
    		this.orderGrid.view.select(0);
    	}
    },
    
    onOrderSelect:function(model,rs){
    	var me=this;
		if(rs.length>0){
			var g=me.detailsGrid;
			g.store.loadRecords(rs[0].OrderDetailsStore.data.items);
		}
    }
    
});
