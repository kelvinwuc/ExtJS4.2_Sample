package com.aegon.servlet;

import javax.servlet.*;
/**
 *  ���O�W�١G
 *  ���O�\��G
 *  �إߤ���G (2001/2/24 �W�� 08:18:03)
 *  extends �G <|>
 *  throws  �G
 *  �ק�����G
 *  ��   ��    �� �� ��     ��      ��      ��       �e
 *  ========= =========== ===========================================================
 */
public class RootServlet extends javax.servlet.http.HttpServlet 
{
	public com.aegon.comlib.RootClass root = new com.aegon.comlib.RootClass();
/**
 * Initializes the servlet.
 */
public void init() 
{
	try
	{
		super.init();
	}
	catch( ServletException e )
	{
		root.setLastError("RootServlet",e);
	}
}
/**
 * Process incoming requests for information
 * 
 * @param request Object that encapsulates the request to the servlet 
 * @param response Object that encapsulates the response from the servlet
 */
public void performTask(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) {

	try

	{
		// Insert user code from here.

	}
	catch(Throwable theException)
	{
		// uncomment the following line when unexpected exceptions
		// are occuring to aid in debugging the problem.
		//theException.printStackTrace();
	}
}
}