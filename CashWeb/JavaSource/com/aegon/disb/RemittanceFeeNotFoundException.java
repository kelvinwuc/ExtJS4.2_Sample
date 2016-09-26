/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *                        Leo Huang    		 2010/11/08           程式Merge
 *  =============================================================================
 */
/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : $Author: MISJIMMY $
 * 
 * Create Date : $Date: 2010/11/23 06:25:31 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: RemittanceFeeNotFoundException.java,v $
 * Revision 1.1  2010/11/23 06:25:31  MISJIMMY
 * R00226-百年專案
 *
 *  
 */

package com.aegon.disb;

public class RemittanceFeeNotFoundException extends RuntimeException {

    private static final long serialVersionUID = -7776857475832353912L;

    public RemittanceFeeNotFoundException() {
    }

    public RemittanceFeeNotFoundException(String message) {
        super( message );
    }
    //edit by Leo Huang 991108 Merge
/*
    public RemittanceFeeNotFoundException(Throwable cause) {
        super( cause );
    }

    public RemittanceFeeNotFoundException(String message, Throwable cause) {
        super( message, cause );
    }
*/
}
