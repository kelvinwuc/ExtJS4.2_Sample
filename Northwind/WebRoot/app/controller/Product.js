Ext.define('Northwind.controller.Product', {
    extend: 'Ext.app.Controller',


    stores: [
        'Product',
        'SupplierCombo',
        'CategoryCombo'
    ],

    models: [
        'Product'
    ],

	views:["product.View","product.EditView"],

    refs: [
    	{ref:'contentPage', selector: '#contentPage'}
	],

    init: function() {
    	var me=this,
    		view=me.getProductViewView(),
    		c=me.getContentPage();
        me.control({
            '#productView': {
                render: me.onPanelRendered
            },
            '#productPaging button[action=productadd]':{
            	click:me.AddProduct
            },
            '#productPaging button[action=productedit]':{
            	click:me.EditProduct
            },
            '#productPaging button[action=productdelete]':{
            	click:me.DelProduct
            }
        });
    	c.add(view);
    },
    
    getEditView:function(){
    	var me=this;
    		view= me.editview;
    	if(!view){
    		view=me.view=Ext.widget("producteditview");
    	}
    	return view;
    },
    
    onPanelRendered :function(panel){
    	var me=this,
    		c=me.getContentPage();    	
    	c.getLayout().setActiveItem(panel);
    	me.grid=panel;
    },
    
    AddProduct:function(){
		var me=this,
			win=me.getEditView(),
			f=win.form,
			m=me.getProductStore().model;
		f.getForm().api.submit=Ext.app.Product.Add;
		f.loadRecord(new m());
		win.setTitle("添加新产品")
		win.show();
    },
    
    EditProduct:function(){
    	var me=this,
    		rs=me.grid.getSelectionModel().getSelection();
		if(rs.length>0){
			rs=rs[0];
	    	var win=me.getEditView();
			win.setTitle("编辑产品："+rs.get("ProductName"));
			win.form.getForm().api.submit=Ext.app.Product.Edit;
			win.form.getForm().loadRecord(rs);
			win.show();
	    }else{
			Ext.Msg.alert("提示信息","请选择一条记录进行编辑。");
	    }
    },

    DelProduct:function(){
		var grid=this.grid,
			rs=grid.getSelectionModel().getSelection();
		if(rs.length > 0){							
			var content=["确定删除以下产品？"];
			for(var i=0;ln=rs.length,i<ln;i++){
				content.push(rs[i].data.ProductName);
			}
			Ext.Msg.confirm("删除记录",content.join("<br/>"),function(btn){
				if(btn=="yes"){
					var me=this,store=me.store,ids=[];
					 	rs=me.getSelectionModel().getSelection();
					for(var i=0;ln=rs.length,i<ln;i++){
						ids.push(rs[i].data.ProductID);
					}
					Ext.app.Product.Delete(ids.join(","),function(result,e){
						if(e.type=="exception"){
							Ext.Msg.alert("提示信息",e.message);
						}else{
							if(result.success){
					 			var msg=[].concat(["以成功删除以下产品："],result.msg);
					 			msg.push("----------");
					 			msg.push("列表将刷新。");
					 			Ext.Msg.alert("删除成功",msg.join("<br/>"),function(){
						 			me.store.load();
					 			});
							}else{
								Ext.Msg.alert("提示信息",result.msg);
							}
						}
					});
				}
			},grid)
		}
    }

});
