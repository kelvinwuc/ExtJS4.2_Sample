Ext.onReady(function() {
	var loginForm = Ext.create('Ext.form.Panel', {
		bodyStyle:'padding:5px 5px 0',
		width: 350,
		border : false,
		fieldDefaults: {
			msgTarget: 'side',
			labelWidth: 30
		},
		defaultType: 'textfield',
		defaults: {
			anchor: '100%'
		},
		items: [{
			fieldLabel: '帐号',
		 	name: 'userName', //就所HTML标记中到name=“”
		  	allowBlank:false,
			blankText : '请输入帐号'
		},{
			fieldLabel: '密码',
			name: 'passWord',
			inputType : 'password', //输入类型
			allowBlank:false,
			blankText : '请输入密码'
		}]
	});
			
	var loginWindow = Ext.create('Ext.window.Window',{
		title : '登录',
		items : [loginForm],
		plain : true,
		resizable : false,
		buttonAlign : 'center',		
		buttons: [{
			text: '登录',
		 	handler : function(){
		 		if (loginForm.form.isValid()) {
		 			loginForm.form.submit({
		 				waitTitle : '请稍候',
						waitMsg : '正在登录......',
						url : '../../servlet/LoginController', //提交到servlet地址
						method:'POST',
						success : function(form, action) {
  							Ext.Msg.alert('系统提示','登录成功!--' + action.result.text);
  							//可以进行别的业务操作，比如跳转页面到你到主页面
  							window.location = '../grids/index.html';
						},
						failure : function(form, action) {
							if(action.result){
								Ext.Msg.alert('系统提示',action.result.text);
							}else{
								loginForm.form.reset();
							}
						}
					});
				}//end if
			}
		},
		{
			text: '重置',
		  	handler : function(){
		  		loginForm.form.reset();
		  	}
		}]
	});
			
	loginWindow.show();
});