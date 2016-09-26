Ext.define('Northwind.Application', {
    extend: 'Ext.app.Application',
    name: 'Northwind',

    controllers: ["MainMenu"],

    autoCreateViewport: true,

    launch: function() {
        Northwind.app = this;
    }
    
});
