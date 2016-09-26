package com.aegon.comlib;

import com.aegon.*;

/**
 * @author Administrator
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class EncryptionBean extends RootClass 
{
	private String strHashAlgorithms = new String("SHA");
	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;

	public EncryptionBean()
	{
		this(null,null);
	}
	
	public EncryptionBean( GlobalEnviron thisGlobalEnviron , DbFactory thisDbFactory )
	{
		super();
		if( thisGlobalEnviron != null )
		{
			globalEnviron = thisGlobalEnviron ;
			this.setDebugFileName(thisGlobalEnviron.getDebugFileName());
			this.setDebug(thisGlobalEnviron.getDebug());
		}
		if( thisDbFactory != null )
		{
			dbFactory = thisDbFactory;
			this.setSessionId(thisDbFactory.getSessionId());
			if( thisGlobalEnviron == null )
			{
				globalEnviron = thisDbFactory.getGlobalEnviron() ;
				this.setDebugFileName(globalEnviron.getDebugFileName());
				this.setDebug(globalEnviron.getDebug());
			}
		}
		else
			dbFactory = new DbFactory(thisGlobalEnviron);
	}
	
	public EncryptionBean( DbFactory thisDbFactory )
	{
		this( null , thisDbFactory );
	}
	
	

	public void setHashAlgorithms( String strThisHashAlgorithms )
	{
		if( strThisHashAlgorithms != null )
		{
			strHashAlgorithms = strThisHashAlgorithms;
		}
	}
	
	public String getHashAlgorithms()
	{
		return strHashAlgorithms;
	}

	public String getEncryptedPassword( String strInputPassword )
	{
		String strReturnPassword = new String("");

		Encryption encoder = new Encryption(strHashAlgorithms);

		if( globalEnviron != null )
		{
			if( !globalEnviron.getPasswordCaseSenstivity() )
				strInputPassword = strInputPassword.toUpperCase();
		}	
		strReturnPassword = encoder.encryptPassword( strInputPassword);

		return strReturnPassword;
	}
	
	public boolean getPasswordCaseSenstivity()
	{
		boolean bReturn = true;
		if( globalEnviron != null )
			bReturn = globalEnviron.getPasswordCaseSenstivity();
		return bReturn;
	}
}
