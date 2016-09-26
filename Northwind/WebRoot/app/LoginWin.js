Ext.define("Northwind.LoginWin",{
	extend:"Ext.window.Window",
    hideMode: 'offsets',
    closeAction: 'hide',
    closable:false,
    resizable: false,
    title:'Northwind管理系统登录窗口',
	singleton:true,
    width: 300,
    height: 250,
    modal:true,
    currentTabIndex:0,
    dockedItems:[],
    
    initComponent: function() {
    	var me=this;
    	
    	me.fields=[];
    	
    	me.fields.push(
    		Ext.widget("textfield",{
    			fieldLabel:"用户名",name:"username",
    			allowBlank:false,tabIndex:1,
    			listeners:{
    				scope:me,
    				focus:me.setTabIndex
    			}
    		})
    	);

    	me.fields.push(
    		Ext.widget("textfield",{
    			fieldLabel:"密码",name:"password",inputType:"password",
    			allowBlank:false,tabIndex:1,
    			listeners:{
    				scope:me,
    				focus:me.setTabIndex
    			}
    		})
    	);

    	me.fields.push(
    		Ext.widget("textfield",{
    			fieldLabel:"验证码",name:"vcode",
    			minLength:6,minLength:6,
    			allowBlank:false,tabIndex:3,
    			listeners:{
    				scope:me,
    				focus:me.setTabIndex
    			}
    		})
    	);
    	
    	me.image=Ext.create(Ext.Img);
    	
    	me.form=Ext.create(Ext.form.Panel,{
			border:false,bodyPadding:5,
			//api:{submit:Ext.app.Login.Check},
			bodyStyle:"background:#DFE9F6",
			fieldDefaults: {
             	labelWidth:80,labelSeparator:"：",anchor:"0"
			},
			items:[
				me.fields[0],
				me.fields[1],
				me.fields[2],
				{xtype:"container",height:80,anchor:"-5",layout:"fit",
					items:[me.image]
				}
			],
			dockedItems: [{
				xtype: 'toolbar',dock:'bottom',ui:'footer',layout:{pack:"center"},
			    items: [
		    		{text:"登录",disabled:true,formBind:true,handler:me.onLogin,scope:me},
		    		{text:"重置",handler:me.onReset,scope:me},
		    		{text:"刷新验证码",handler:me.onRefrehImage,scope:me}
			    ]
			}]
    	});
    	
    	me.items=[me.form]
    	
    	me.on("show",function(){
    		me.onReset();
    	},me);

    	me.callParent();
	},
	
	initEvents:function(){
		var me=this;
		me.KeyNav=Ext.create("Ext.util.KeyNav",me.form.getEl(),{
			enter:me.onFocus,
			scope:me
		});
	},
	
	onLogin:function(){
		var me=this,
			f=me.form.getForm();
		if(f.isValid()){
			f.submit({
				success:function(form,action){
					me.hide();
					Ext.state.Manager.set("userInfo",action.result.userInfo);
					Ext.create('Northwind.Application');
				},
                failure: function(form, action){
                	//測試 
                	action.failureType = "sussce";
                    if (action.failureType === "connect") {
                    	Ext.Msg.alert('错误',
                              '状态:'+action.response.status+': '+
                              action.response.statusText,Ext.Msg.ERROR);
//                        Ext.Msg.myAlert('错误',
//                            '状态:'+action.response.status+': '+
//                            action.response.statusText,Ext.Msg.ERROR);
                    	
                        return;
                    }
                	if(action.result){
                		if(action.result.msg)
                        	Ext.Msg.myAlert('错误', action.result.msg,Ext.Msg.ERROR);
                    }
                },
                scope:me
			});
		}
		//測試
		Ext.create('Northwind.Application');
	},
	
	onReset:function(){
		var me=this;
		me.form.getForm().reset();
		me.onRefrehImage();
	},
	
	onRefrehImage:function(){
		this.image.setSrc("Vcode?_dc="+(new Date()).getTime());
	},
	
	setTabIndex:function(el){
		this.currentTabIndex=el.tabIndex;
	},
	
	onFocus:function(){
		var me=this,
			index=me.currentTabIndex;
			index++;
			if(index>2){
				index=0;
			}
			me.fields[index].focus();
			me.currentTabIndex=index;
	}

	
})