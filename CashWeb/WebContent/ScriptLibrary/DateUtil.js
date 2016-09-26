
var DateUtil = function( rocFlag ) {

	if( rocFlag )
		this.rocFlag = rocFlag;
	else
		this.rocFlag = false;

	this.checkRange = true;
	this.formater = {
	    fillZero :false,
	    fillZero4 :false,
	    fillSpace :false,
	    separator :"/"
	};
};

//DateUtil.prototype.rocFlag = false;
//DateUtil.prototype.checkRange = true;
//DateUtil.prototype.formater = {
//    fillZero :false,
//    fillSpace :false,
//    separator :"/"
//};


DateUtil.prototype.trim = function( s ) {
    return s.replace( /^\s*|\s*$/g, "" );
};

DateUtil.prototype.trimZeroPrefix = function( s ) {
    return s.replace( /^0*/g, "" );
};

DateUtil.prototype.createDate = function( dateParams, rocFlag ) {

    if( rocFlag == undefined )
        rocFlag = this.rocFlag;

    if( !dateParams )
        return null;
    
    dateParams[ 0 ] = this.trim( dateParams[ 0 ] );
    dateParams[ 1 ] = this.trim( dateParams[ 1 ] );
    dateParams[ 2 ] = this.trim( dateParams[ 2 ] );
    dateParams[ 0 ] = this.trimZeroPrefix( dateParams[ 0 ] );
    dateParams[ 1 ] = this.trimZeroPrefix( dateParams[ 1 ] );
    dateParams[ 2 ] = this.trimZeroPrefix( dateParams[ 2 ] );
    
    var yy = parseInt( this.trim( dateParams[ 0 ] ) );
    var mm = parseInt( this.trim( dateParams[ 1 ] ) );
    var dd = parseInt( this.trim( dateParams[ 2 ] ) );
    if( rocFlag )
        yy = parseInt( yy ) + 1911;

    var date = new Date( yy, mm - 1, dd );

    if( this.checkRange ) {
        if( date.getFullYear() != yy || date.getMonth() + 1 != mm || date.getDate() != dd )
            return null;
    }

    return date;
};

DateUtil.prototype.parseDate = function( dateStr, rocFlag ) {

    if( !dateStr )
        return null;

    var str = this.trim( dateStr );
    if( str.length < 6 )
        return null;

    var dateParams = str.split( "/" );
    if( dateParams.length == 3 ) {
        return this.createDate( dateParams, rocFlag );
    }

    dateParams = str.split( "-" );
    if( dateParams.length == 3 ) {
        return this.createDate( dateParams, rocFlag );
    }

    var mySeparator = this.formater.separator;
    if( mySeparator.length > 0 && mySeparator != "/" && mySeparator != "-" && mySeparator != "" ) {
        dateParams = str.split( mySeparator );
        if( dateParams.length == 3 )
            return this.createDate( dateParams, rocFlag );
    }

    dateParams = [];
    dateParams.push( str.substring( 0, str.length - 4 ) );
    dateParams.push( str.substring( str.length - 2, str.length - 4 ) );
    dateParams.push( str.substring( str.length - 2 ) );

    if( isFinite( dateParams[ 0 ] ) && isFinite( dateParams[ 1 ] ) && isFinite( dateParams[ 2 ] ) )
        return this.createDate( dateParams, rocFlag );
    return null;
};

DateUtil.prototype.formatDate = function( date, rocFlag ) {

    if( date == null )
        return "";

    if( rocFlag == undefined )
        rocFlag = this.rocFlag;

    var separator = this.formater.separator;
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();

    if( rocFlag ) {
        year -= 1911;
        if( this.formater.fillZero && year < 100 ) {
        	year = '0' + year;
        	if( this.formater.fillZero4 )
        		year = '0' + year;
        }
    }
    
    if( this.formater.fillZero ) {
        if( month < 10 )
            month = '0' + month;
        if( day < 10 )
            day = '0' + day;
    }

    if( this.formater.fillSpace )
        return ' ' + year + ' ' + separator + ' ' + month + ' ' + separator + ' ' + day;
    else
        return year + separator + month + separator + day;
};

DateUtil.prototype.getDateDiff = function( date1, date2 ) {
    
    if( !date1 || !date2 )
        return 0;
    
    // 24 * 60 * 60 * 1000 = 86400000
    var d1 = Math.floor( date1.getTime() / 86400000 );
    var d2 = Math.floor( date2.getTime() / 86400000 );
    return d2 - d1;
}
