Ext.define('Northwind.view.product.View', {
    extend: 'Ext.grid.Panel',
    alias : 'widget.productview',
	
	title:"产品管理",
	id:"productView",
	store:"Product",
	selType:"checkboxmodel",
	selModel:{mode:"MULTI"},
	
    initComponent: function() {
    	var me=this;
    	
    	me.searchField=Ext.widget("textfield",{
    		width:160
    	});
    	
    	me.paging=Ext.widget("pagingtoolbar",{
    		id:"productPaging",
    		store:me.store,
    		displayInfo:true,
    		items:[
    			"|",
    			{text:"增加",action:"productadd"},
    			{text:"编辑",action:"productedit",disabled:true},
    			{text:"删除",action:"productdelete",disabled:true},
				"|",
				"查找：",
				me.searchField,
				{text:"Go",handler:me.search,scope:me},
				{text:"显示全部",handler:me.showAll,scope:me}
			]}
		);
    	
    	me.tbar=me.paging;
    	
		me.columns=[
			{text:'id',dataIndex:'ProductID',text:"产品编号",width:60},
			{text:'ProductName',dataIndex:'ProductName',text:"产品名称",
				renderer:me.onProductNameRenderer
			},
			{text:'供应商',dataIndex:'CompanyName',titleAlign:"center",
				sortable:false,flex:1
			},
			{text:'类别',dataIndex:'CategoryName',titleAlign:"center",
				sortable:false,flex:1
			},
			{text:'单位',dataIndex:'QuantityPerUnit',titleAlign:"center",flex:1},
			{xtype:"numbercolumn",text:'单价',dataIndex:'UnitPrice',titleAlign:"center",
				align:"right",format:"$0.00",width:60
			},
			{xtype:"numbercolumn",text:'库存',dataIndex:'UnitsInStock',align:"center",
				format:"0",width:60
			},
			{xtype:"numbercolumn",text:'订购量',dataIndex:'UnitsOnOrder',align:"center",
				format:"0",width:60
			},
			{xtype:"numbercolumn",text:'再订购量',dataIndex:'ReorderLevel',align:"center",
				format:"0",width:60
			},
			{xtype:"booleancolumn",text:'停产',dataIndex:'Discontinued',
				align:"center",trueText:"是",falseText:"否",width:60
			}
		]


        this.callParent(arguments);
        
        me.on("selectionchange",me.onSelectionchange);
    },
    
	search:function(){
		var me=this,
			store=me.store,
			search=me.searchField.getValue();
		if(search && search.length>0){
			store.currentPage=1;
        	store.filters.clear();
			store.filter("ProductName",search);
		}
	},

	showAll:function(){
		var store=this.store;
		store.currentPage=1;
		store.clearFilter();
	},
	
	onProductNameRenderer:function(v,meta,rec,row,col,store){
		var filter = store.filters.items;
		if(filter.length>0){
			var value=filter[0].value;
			return v.replace(new RegExp(value,'gi'),function(m){
				return "<font color='red'>"+m+"</font>";
			})
		}else{
			return v;
		}							
	},
	
	onSelectionchange:function(seltype,rs){
		var me=this,
			length=!(rs.length>0);
		me.paging.down("button[action=productedit]").setDisabled(length);
		me.paging.down("button[action=productdelete]").setDisabled(length);
	}
    
});
