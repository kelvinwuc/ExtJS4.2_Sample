Ext.define('app.store.Student', {
    extend: 'Ext.data.Store',
    requires: 'app.model.Student',
    model: 'app.model.Student',
	pageSize: 10,
	autoLoad:true,
	
	//{totalCount:16,result:[
	//{id:1,code:'2002015',name:'张光和',sex:1,age:21,political:'团员',origin:'湖北省',professional:'物流工程学院'}, 
	//{id:2,code:'2002002',name:'张值强',sex:1,age:22,political:'党员',origin:'河南省',professional:'动力工程系'}, 
	//{id:3,code:'2002003',name:'槐  心',sex:1,age:23,political:'团员',origin:'四川省',professional:'管理学院'}, 
	//{id:4,code:'2002004',name:'王小勇',sex:1,age:23,political:'团员',origin:'重庆市',professional:'材料学院'}, 
	//{id:5,code:'2002005',name:'王历历',sex:1,age:22,political:'党员',origin:'河北省',professional:'文法学院系'}, 
	//{id:6,code:'2002006',name:'吴孟达',sex:1,age:23,political:'群众',origin:'香港特别行政区',professional:'计算机学院'}, 
	//{id:7,code:'2002007',name:'金嫣红',sex:2,age:22,political:'团员',origin:'山西省',professional:'计算机学院'}, 
	//{id:8,code:'2002008',name:'刘长艳',sex:2,age:22,political:'党员',origin:'北京市',professional:'数理学院'}, 
	//{id:9,code:'2002009',name:'许  强',sex:2,age:23,political:'团员',origin:'安徽省',professional:'机械学院'}, 
	//{id:10,code:'2002010',name:'杨小鹃',sex:2,age:20,political:'团员',origin:'广西',professional:'文法学院'}]}
	proxy: {
		type: 'ajax',
		url: './jsp/list.jsp',
		//url: './data/user.txt',
		reader: {
			type: 'json',
			totalProperty: 'totalCount',
			root: 'result',
			idProperty: 'id'
		}
	},
	remoteSort: true
});
