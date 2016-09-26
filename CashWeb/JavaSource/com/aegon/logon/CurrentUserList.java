package com.aegon.logon;

import java.util.*;
import javax.servlet.http.*;
import com.aegon.comlib.*;

/**
 * @author misdisen
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class CurrentUserList extends RootClass{
	
		//static private CurrentUserList thisUserList = null ;
		
		private List currentUserList = new ArrayList(20) ;  // list for concurrent user session object
		private boolean bFromRemoveAll = false ;
		
		
		// constructor
		public CurrentUserList(){
			super();
		}
		
//		static public CurrentUserList getInstance(){
//			if(thisUserList==null){
//				thisUserList = new CurrentUserList();
//			}
//			return thisUserList ;
//		}
		
		public synchronized boolean add(HttpSession newSession){
			boolean returnStatus = true ;
			currentUserList.add(newSession)	;
			return returnStatus ;
		}
		
		public synchronized boolean remove(HttpSession rmvSession){
			boolean returnStatus = true ;
			if(!bFromRemoveAll){
                System.out.println("remove ->"+rmvSession.getId());
				currentUserList.remove(rmvSession);
			}
			return returnStatus ;
		}
		
		public synchronized boolean removeAll(String rmvUserId){
			boolean returnStatus = true ;
			Iterator ite = currentUserList.iterator();
			HttpSession tmpSession = null;
			String tmpUserId = null;
			bFromRemoveAll = true ;
			while(ite.hasNext()){
				tmpSession = (HttpSession) ite.next();
				tmpUserId  = ((SessionInfo)tmpSession.getAttribute(Constant.SESSION_INFO)).getUserInfo().getUserId();
				if(tmpUserId.equals(rmvUserId)){
					ite.remove();
                    System.out.println("removeAll->"+tmpSession.getId());
					tmpSession.invalidate();
				}
			}
			bFromRemoveAll = false ;			
			return returnStatus ;
		}
		
		/**
		 * Method isExist.
		 * @param chkUserId
		 * @return boolean
		 * 
		 * whether the giving use id is existed in current user list
		 */
		public synchronized boolean isExist(String chkUserId){
			if(chkUserId==null){
				return false;
			}
			boolean returnStatus = false ;
			String userId = null;
			Iterator ite = currentUserList.iterator();
			while(ite.hasNext()){
				userId = ((SessionInfo)((HttpSession)ite.next()).getAttribute(Constant.SESSION_INFO)).getUserInfo().getUserId() ;
				if(userId.equals(chkUserId)){
					returnStatus = true ;
					break;
				}
			}
			return returnStatus ;	
		}
		
		/**
		 * Method dumpData.
		 * @return String
		 * 
		 * Dump current user list
		 */
		public String dumpData(){

			String dumpList = "";
			HttpSession tmpSession = null;
			String tmpUserId = "";

			Iterator ite = currentUserList.iterator();
			while(ite.hasNext()){
				tmpSession = (HttpSession)ite.next();
				tmpUserId = ((SessionInfo)tmpSession.getAttribute(Constant.SESSION_INFO)).getUserInfo().getUserId() ;
				dumpList += tmpUserId + " ("+tmpSession.getId()+") "+System.getProperty("line.separator");
			}
			return dumpList ;	
		}
		
		public String dumpDataHtml(){
			String dumpList = "";
			HttpSession tmpSession = null;
			String tmpUserId = "";

			Iterator ite = currentUserList.iterator();
			while(ite.hasNext()){
				tmpSession = (HttpSession)ite.next();
				tmpUserId = ((SessionInfo)tmpSession.getAttribute(Constant.SESSION_INFO)).getUserInfo().getUserId() ;
				dumpList += tmpUserId + " ("+tmpSession.getId()+") <BR>"+System.getProperty("line.separator");
			}
			return dumpList ;	
		}
	}