package com.aegon.disb.util;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.GlobalEnviron;
import com.aegon.comlib.RootClass;
import com.aegon.comlib.WorkingDay;
import com.aegon.disb.RemittanceFeeNotFoundException;
import com.aegon.disb.disbmaintain.DISBAccFinRmtServlet;
import com.ibm.as400.access.AS400;
import com.ibm.as400.access.AS400Message;
import com.ibm.as400.data.PcmlException;
import com.ibm.as400.data.ProgramCallDocument;

import org.apache.log4j.Logger;
/**
 * System   : CashWeb
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.63 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : 2005/04/04
 * 
 * Request ID  : R30530
 * 
 * CVS History:
 * 
 * RD0397:20150904,Kelvin Wu,�ק�I�ڱb���M�檺�Ƨ�
 * 
 * $$Log: DISBBean.java,v $
 * $Revision 1.63  2015/11/24 04:16:23  001946
 * $*** empty log message ***
 * $
 * $Revision 1.62  2015/09/08 02:09:44  001946
 * $*** empty log message ***
 * $
 * $Revision 1.61  2014/08/25 02:05:33  missteven
 * $RC0036-3
 * $
 * $Revision 1.60  2014/02/26 06:39:32  MISSALLY
 * $EB0537 --- �s�W�U���Ȧ欰�~�����w�Ȧ�
 * $
 * $Revision 1.59  2013/12/18 07:22:52  MISSALLY
 * $RB0302---�s�W�I�ڤ覡�{��
 * $
 * $Revision 1.58  2013/11/08 05:52:33  MISSALLY
 * $EB0194-PB0016-BC255�Q�v�ܰʫ��Y���~���O�I�M��
 * $
 * $Revision 1.57  2013/05/30 02:03:54  MISSALLY
 * $RA0064-CMP�M��CASH�t�X�ק�
 * $
 * $Revision 1.56  2013/05/02 11:07:05  MISSALLY
 * $R10190 �������īO��@�~
 * $
 * $Revision 1.55  2013/04/12 06:10:26  MISSALLY
 * $RA0074 FNE�����ͦs�����q�H�b��ε��I
 * $
 * $Revision 1.54  2013/03/29 09:55:05  MISSALLY
 * $RB0062 PA0047 - �s�W���w�Ȧ� ���ƻȦ�
 * $
 * $Revision 1.52  2013/01/23 07:53:06  MISSALLY
 * $R00135  ���oORNBSN�Ǹ�
 * $
 * $Revision 1.51  2013/01/08 04:24:06  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.50.4.1  2012/08/31 01:21:31  MISSALLY
 * $RA0140---�s�W���׬��~�����w��
 * $
 * $Revision 1.50  2012/05/18 09:47:35  MISSALLY
 * $R10314 CASH�t�η|�p�@�~�ק�
 * $
 * $Revision 1.49  2012/03/23 02:48:22  MISSALLY
 * $R10285-P10025
 * $�]���Ǩ��M�ש��I�D�ɷs�W�z�ߨ��z�s��
 * $
 * $Revision 1.48  2012/01/16 01:28:30  MISSALLY
 * $QA0001
 * $Fix SQLException
 * $
 * $Revision 1.47  2012/01/13 02:16:36  MISSALLY
 * $QA0001
 * $�ץ��J��1231���D�u�@��ɷ|�^��1200
 * $
 * $Revision 1.46  2011/10/21 10:04:37  MISSALLY
 * $R10260---�~���ǲΫ��O��ͦs�����I�@�~
 * $
 * $Revision 1.45  2011/07/06 11:45:44  MISSALLY
 * $Q10180
 * $�W�[���I�q�����ˮ֥\��
 * $
 * $Revision 1.44  2011/06/02 10:28:07  MISSALLY
 * $Q90585 / R90884 / R90989
 * $CASH�t�ζװh�B�z�@�~�s�W�װh��]���íץ��h�ש��Ӫ�
 * $
 * $Revision 1.43  2011/04/22 01:46:26  MISSALLY
 * $R10068-P00026
 * $�s�W�w���Ȧ欰�~�׫��w�����O�ΤU���ɳ]�w
 * $
 * $Revision 1.42  2011/04/14 01:41:28  MISJIMMY
 * $R00566--���j�Ȧ�s�W�״���
 * $
 * $Revision 1.41  2010/11/23 07:02:28  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.40  2010/05/21 08:58:57  MISJIMMY
 * $R00217--��s�״��ɮפW���B
 * $
 * $Revision 1.39  2009/12/03 04:15:47  missteven
 * $R90628 ���ڮw�s�s�W
 * $
 * $Revision 1.38  2009/01/21 02:04:53  misvanessa
 * $Q90020_�ӽЭ��}USER�ϥ��I��覡
 * $
 * $Revision 1.37  2009/01/19 08:21:05  MISODIN
 * $Q80691 ���H�P�����P�_�վ�
 * $
 * $Revision 1.36  2008/10/31 09:48:11  MISODIN
 * $R80413_�����b�ڹO�����L���J
 * $
 * $Revision 1.35  2008/09/17 01:49:30  MISODIN
 * $R80338 Ū���ײvfor�X�Ƕ״ڤ���
 * $
 * $Revision 1.34  2008/09/03 02:11:38  misvanessa
 * $R80685_���H����O�խ���300
 * $
 * $Revision 1.33  2008/08/21 09:17:01  misvanessa
 * $R80631_�s�W��l�I�ڤ覡 (FOR FF)
 * $
 * $Revision 1.32  2008/08/12 06:56:50  misvanessa
 * $R80480_�W���Ȧ�~�������s�ɮ�
 * $
 * $Revision 1.31  2008/08/06 06:55:48  MISODIN
 * $R80338 �վ�CASH�t�� for �X�ǥ~���@��@�ݨD
 * $
 * $Revision 1.30  2008/06/12 09:41:56  misvanessa
 * $R80300_�������x�s,�s�W�W���ɮפγ���
 * $
 * $Revision 1.29  2008/04/30 07:49:27  misvanessa
 * $R80300_�������x�s,�s�W�U���ɮפγ���
 * $
 * $Revision 1.28  2008/03/21 07:35:58  misvanessa
 * $Q80223_�����\�Ÿ�
 * $
 * $Revision 1.26  2008/03/05 02:19:00  MISODIN
 * $R80172 �վ�״���Download File ���椺�X
 * $
 * $Revision 1.25  2008/03/03 08:38:57  MISODIN
 * $Q80110�վ㬰�����Ҧa�}
 * $
 * $Revision 1.24  2008/02/25 09:39:33  misvanessa
 * $Q80122_�U�@�u�@��ץ�
 * $
 * $Revision 1.23  2007/10/30 02:03:25  MISVANESSA
 * $Q70494_��I�s,�q�T�B�ק�
 * $
 * $Revision 1.22  2007/10/05 09:12:09  MISVANESSA
 * $R70770_ACTCD2 �X�� 11 �X
 * $
 * $Revision 1.21  2007/10/04 01:34:18  MISODIN
 * $R70477 �~���O��״ڤ���O
 * $
 * $Revision 1.20  2007/09/07 10:25:52  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.19  2007/08/28 01:38:54  MISVANESSA
 * $R70574_SPUL�t���s�W�ץX�ɮ�
 * $
 * $Revision 1.18  2007/08/06 07:53:13  MISVANESSA
 * $R70605_�j���Ȧ�t���ഫ
 * $
 * $Revision 1.17  2007/08/03 09:50:33  MISODIN
 * $R70477 �~���O��״ڤ���O
 * $
 * $Revision 1.16  2007/06/08 07:57:48  MISVANESSA
 * $R70366_�|�p��ةM�װh�|�p��حק�
 * $
 * $Revision 1.15  2007/04/20 03:37:52  MISODIN
 * $R60713 FOR AWD
 * $
 * $Revision 1.14  2007/04/13 09:47:39  MISVANESSA
 * $R70292_�t���䲼��W�h����
 * $
 * $Revision 1.13  2007/03/16 01:42:47  MISVANESSA
 * $R70088_SPUL�t���ק����Orule
 * $
 * $Revision 1.12  2007/03/08 10:10:57  MISVANESSA
 * $R70088_SPUL�t���ק����O
 * $
 * $Revision 1.11  2007/03/06 01:31:50  MISVANESSA
 * $R70088_SPUL�t���s�W�Ȥ�t�����O
 * $
 * $Revision 1.10  2007/02/08 03:25:26  MISVANESSA
 * $R70088_SPUL�t��_�s�WMETHOD
 * $
 * $Revision 1.9  2007/01/31 08:02:06  MISVANESSA
 * $R70088_SPUL�t��
 * $
 * $Revision 1.8  2007/01/05 01:43:44  miselsa
 * $R60550_ getETable  �W�[ ���Ȧ�O(�T�X)���B�z --> valueType =BANKS
 * $
 * $Revision 1.7  2006/12/07 22:08:52  miselsa
 * $R60463��R60550�ק�GETBATNO
 * $
 * $Revision 1.6  2006/11/30 09:37:36  MISVANESSA
 * $R60550_�s�WSWIFT CODE&COUNTRY CODE
 * $
 * $Revision 1.5  2006/11/24 08:54:44  miselsa
 * $R60463��R60550 �W�[getPFeeForD (��~�״ڤ���O��k)
 * $
 * $Revision 1.4  2006/10/31 09:40:38  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.3  2006/09/04 09:43:36  miselsa
 * $R60747_1.���״ڼW�[�X�ǽT�{�� 2.�ץX����״ڤ���אּ�X�ǽT�{�� 3.��I�d�ߥI�ڤ�����X�ǽT�{��
 * $
 * $Revision 1.2  2006/08/29 02:34:59  miselsa
 * $Q60159_getACTCD3�W�x�[�ɤs8083
 * $
 * $Revision 1.1  2006/06/29 09:40:13  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.22  2005/08/19 07:07:58  misangel
 * $R50427 : �״ڥ�̳���+�m�W+�b���X��
 * $
 * $Revision 1.1.2.20  2005/04/25 07:23:52  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.19  2005/04/04 07:02:26  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

public class DISBBean extends RootClass {
	
	private static Logger log = Logger.getLogger(DISBBean.class);

	private DbFactory dbFactory = null;
	private GlobalEnviron globalEnviron = null;

	public DISBBean() {
		this(null, null);
	}

	public DISBBean(GlobalEnviron thisGlobalEnviron) {
		this(thisGlobalEnviron, null);
	}

	public DISBBean(GlobalEnviron thisGlobalEnviron, DbFactory thisDbFactory) {
		super();
		if (thisGlobalEnviron != null) {
			globalEnviron = thisGlobalEnviron;
			this.setDebugFileName(globalEnviron.getDebugFileName());
			this.setDebug(globalEnviron.getDebug());
			this.setSessionId(globalEnviron.getSessionId());
			if (thisDbFactory != null) {
				dbFactory = thisDbFactory;
			} else {
				dbFactory = new DbFactory(globalEnviron);
			}
		}
	}

	public DISBBean(DbFactory thisDbFactory) {
		this(thisDbFactory.getGlobalEnviron(), thisDbFactory);
	}

	public List getETable(String strValueType) {
		return getETable(strValueType, "");
	}

	/**
	 *   strActionType = bank --> �Ȧ�b���λȦ椤��W��, ����join�� ET-VALUE ,ET-VALUE-DESC
	 */
	public List getETable(String strValueType, String strActionType) {
		return getETable(strValueType, strActionType, true);
	}

	public List getETable(String strValueType, String strActionType, boolean trimValue) {

		List alETalbe = new ArrayList();
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getETable()", "The dbFactory is null, can't get Data.");
		} else {
			if (strActionType.equals("BANK")) {
				strSql = "select  A1.FLD0002 AS FLD0002,SUBSTR(A1.FLD0004,1,30) AS FLD0003, A2.BKNM AS FLD0004 ";
				strSql += " from ORDUET A1 ";
				strSql += " LEFT OUTER JOIN CAPCCBF A2 ON SUBSTRING(A1.FLD0004, 1, 7) = A2.BKNO ";
				strSql += " where A1.FLD0001='  ' AND A1.FLD0002 ='" + strValueType + "' ";
//RA0140		strSql += " AND SUBSTRING(A1.FLD0004,31,2) ='NT' "; //R70477
				strSql += " ORDER BY A1.FLD0004 "; //R80338
				System.out.println("inside BANK getETable-->strSql=" + strSql);
			} else if (strActionType.equals("BANKS")) {
				strSql = "select  distinct A1.FLD0002 AS FLD0002,substr(A1.FLD0004,1,3) AS FLD0003, substr(A2.BKNM ,1,5) AS FLD0004 ";
				strSql += " from ORDUET A1 ";
				strSql += " LEFT OUTER JOIN CAPCCBF A2 ON SUBSTRING(A1.FLD0004, 1, 7) = A2.BKNO ";
				strSql += " where A1.FLD0001='  ' AND A1.FLD0002 ='" + strValueType + "' ";
//RA0140		strSql += " AND SUBSTRING(A1.FLD0004,31,2) ='NT' "; //R70477
			} else if (strActionType.equals("BANKD")) {
				strSql = "select  A1.FLD0002 AS FLD0002,SUBSTR(A1.FLD0004,1,30) AS FLD0003, A2.BKNM AS FLD0004 ";
				strSql += " from ORDUET A1 ";
				strSql += " LEFT OUTER JOIN CAPCCBF A2 ON SUBSTRING(A1.FLD0004, 1, 7) = A2.BKNO ";
				strSql += " where A1.FLD0001='  ' AND A1.FLD0002 ='" + strValueType + "' ";
				//R80338 strSql += " AND SUBSTRING(A1.FLD0004,31,2) ='US' ";	
				strSql += " AND SUBSTRING(A1.FLD0003,1,1) ='F' "; //R80338
				strSql += " ORDER BY A1.FLD0004 "; //R80338
			} else if (strActionType.equals("BANKP")) {
				strSql = "select  A1.FLD0002 AS FLD0002,SUBSTR(A1.FLD0004,1,30) AS FLD0003, A2.BKNM AS FLD0004 ";
				strSql += " from ORDUET A1 ";
				strSql += " LEFT OUTER JOIN CAPCCBF A2 ON SUBSTRING(A1.FLD0004, 1, 7) = A2.BKNO ";
				strSql += " where A1.FLD0001='  ' AND A1.FLD0002 ='" + strValueType + "' ";
				strSql += " AND SUBSTRING(A1.FLD0003,1,1) ='P' ";
				//RD0397:20150904,Kelvin Wu,�ק�I�ڱb���M�檺�Ƨ�
				//strSql += " ORDER BY A1.FLD0004 ";
			} else if (strActionType.equals("BANKFR")) {
				strSql = "select distinct A1.FLD0002 AS FLD0002,SUBSTR(A1.FLD0004,1,30) AS FLD0003, CASE WHEN A2.BKNM IS NULL THEN '' ELSE A2.BKNM END AS FLD0004 ";
				strSql += " from ORDUET A1 ";
				strSql += " LEFT OUTER JOIN CAPCCBF A2 ON SUBSTRING(A1.FLD0004, 1, 7) = A2.BKNO ";
				strSql += " where A1.FLD0001='  ' AND A1.FLD0002 ='" + strValueType + "' ";
				strSql += " ORDER BY FLD0003 ";
			} else if (strActionType.equals("BANKDC")) {
				strSql = "select  A1.FLD0002 AS FLD0002,SUBSTR(A1.FLD0004,1,30) AS FLD0003, A2.BKNM AS FLD0004 ";
				strSql += " from ORDUET A1 ";
				strSql += " LEFT OUTER JOIN CAPCCBF A2 ON SUBSTRING(A1.FLD0004, 1, 7) = A2.BKNO ";
				strSql += " where A1.FLD0001='  ' AND A1.FLD0002 ='" + strValueType + "' ";	
				strSql += " AND SUBSTRING(A1.FLD0003,1,1) ='F' ";
				strSql += " ORDER BY A1.FLD0004 ";
			} else if (strActionType.equals("BANKFRC")) {
				strSql = "select distinct A1.FLD0002 AS FLD0002,SUBSTR(A1.FLD0004,1,30) AS FLD0003, CASE WHEN A2.BKNM IS NULL THEN '' ELSE A2.BKNM END AS FLD0004 ";
				strSql += " from ORDUET A1 ";
				strSql += " LEFT OUTER JOIN CAPCCBF A2 ON SUBSTRING(A1.FLD0004, 1, 7) = A2.BKNO ";
				strSql += " where A1.FLD0001='  ' AND A1.FLD0002 ='" + strValueType + "' ";
				strSql += " ORDER BY FLD0003 ";
			}
			// R80132  ���O�D��
			else if (strActionType.equals("CASH")) {
				strSql = "select FLD0002, FLD0003, FLD0004 ";
				strSql += " from ORDUET ";
				strSql += " where FLD0001='  ' AND FLD0002 = 'CURRA' ";
			} else {
				strSql = "select FLD0002,FLD0003,FLD0004 ";
				strSql += " from ORDUET ";
				strSql += " where FLD0001='  ' AND FLD0002 ='" + strValueType + "'";
				strSql += " ORDER BY FLD0002, FLD0003 ";
			}
			System.out.println("inside DISBBean getETable-->strSql=" + strSql);
			writeDebugLog(Constant.DEBUG_DEBUG, "getETable()", "get Data from ETable --> sql = '" + strSql + "'");
			log.info("inside DISBBean getETable-->strSql=" + strSql);
			Connection conDb = null;

			PreparedStatement pstmt1 = null;
			PreparedStatement pstmt2 = null;
			ResultSet rst1 = null;
			ResultSet rst2 = null;
			
			String strTmpSql1 = "select BKCODE,BKATNO,COUNT(BKATNO) from CAPBNKF where BKCURR<>'NT' and BKSTAT='Y' and BKCODE=? and BKATNO=? group by BKCODE,BKATNO having COUNT(BKATNO)=1 ";
			String strTmpSql2 = "select BKCODE,BKATNO,BKCURR from CAPBNKF where BKCURR<>'NT' and BKSTAT='Y' and BKCODE=? and BKATNO=? ";
			try {
				conDb = dbFactory.getAS400Connection("getETable()");
				pstmt1 = conDb.prepareStatement(strTmpSql1);
				pstmt2 = conDb.prepareStatement(strTmpSql2);
				if (conDb != null) {
					String strBKCURR = "";
					Hashtable<String, String> htETtable = null;
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					while (rstResultSet.next()) {
						htETtable = new Hashtable<String, String>();
						String ETType = rstResultSet.getString("FLD0002");
						String ETValue = rstResultSet.getString("FLD0003");
						String ETVDesc = rstResultSet.getString("FLD0004");
						//log.info("ETType:" + ETType + ",ETValue:" + ETValue + ",ETVDesc:" + ETVDesc);
						
						//RD0382��RE0189:���סB�x�s�B�Ͱ�OIU
						if(!strActionType.equals("BANKDC") && !strActionType.equals("BANKFRC")) {
							if ("0170701/07058016878".equals(CommonUtil
									.AllTrim(ETValue))
									|| "8120687/068760020883".equals(CommonUtil
											.AllTrim(ETValue))
									|| "8090094/018587169906".equals(CommonUtil
											.AllTrim(ETValue))) {
								ETVDesc += "-OIU";
							}
						}						

						htETtable.put("ETType", trimValue ? ETType.trim() : ETType);
						htETtable.put("ETValue", trimValue ? ETValue.trim() : ETValue);
						htETtable.put("ETVDesc", trimValue ? ETVDesc.trim() : ETVDesc);
						alETalbe.add(htETtable);

						if(strActionType.equals("BANKDC") || strActionType.equals("BANKFRC")) {
							pstmt1.clearParameters();
							pstmt1.setString(1, ETValue.substring(0, 3));
							pstmt1.setString(2, CommonUtil.AllTrim(ETValue.substring(8)));
							rst1 = pstmt1.executeQuery();
							if(rst1.next()) {
								pstmt2.clearParameters();
								pstmt2.setString(1, ETValue.substring(0, 3));
								pstmt2.setString(2, CommonUtil.AllTrim(ETValue.substring(8)));
								rst2 = pstmt2.executeQuery();
								if(rst2.next()) {
									alETalbe.remove(htETtable);
									strBKCURR = rst2.getString("BKCURR");

									ETVDesc = CommonUtil.AllTrim(ETVDesc) + "-" + strBKCURR;
									
									//RD0382��RE0189:���סB�x�s�B�Ͱ�OIU
									if ("0170701/07058016878".equals(CommonUtil
											.AllTrim(ETValue))
											|| "8120687/068760020883".equals(CommonUtil
													.AllTrim(ETValue))
											|| "8090094/018587169906".equals(CommonUtil
													.AllTrim(ETValue))) {
										ETVDesc += "-OIU";
									}

									htETtable.put("ETType", trimValue ? ETType.trim() : ETType);
									htETtable.put("ETValue", trimValue ? ETValue.trim() : ETValue);
									htETtable.put("ETVDesc", trimValue ? ETVDesc.trim() : ETVDesc);
									alETalbe.add(htETtable);
								}
							}
						}
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getETable()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return alETalbe;
	}

	/**
	 * @param strCheckNoStart
	 * @param strCheckNoEnd
	 * @return boolean
	 */
	public boolean isValidCheckNo(String strCheckNoStart, String strCheckNoEnd) {

		boolean isValid = false;
		String strSql = "";
		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "isValidCheckNo(strCheckNoStart,strCheckNoEnd)", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "select  CNO ";
			strSql += " from CAPCHKF ";
			strSql += " where CNO  between '" + strCheckNoStart + "'  and '" + strCheckNoEnd + "' ";

			//	System.out.println("inside DISBBean isValidCheckNo(strCheckNoStart,strCheckNoEnd)-->strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("isValidCheckNo(strCheckNoStart,strCheckNoEnd)");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						isValid = true;
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				isValid = false;
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) {
					dbFactory.releaseAS400Connection(conDb);
				}
			}
		}

		return isValid;
	}

	/**
	 * @param strCheckNo
	 * @return boolean
	 */
	public boolean isValidCheckNo(String strCheckNo) throws SQLException {

		boolean isValid = false;
		String strSql = "";
		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "isValidCheckNo(strCheckNo)", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "select  CNO ";
			strSql += " from CAPCHKF ";
			strSql += " where CNO ='" + strCheckNo + "' ";

			//	System.out.println("inside DISBBean isValidCheckNo(strCheckNo)-->strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("isValidCheckNo(strCheckNo)");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						isValid = true;
					} else {
						isValid = false;
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				isValid = false;
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return isValid;
	}

	/**
	 * @param strBankCode 
	 * @param strAccount 
	 * @param strBatNo 
	 * @param strCheckNoStart
	 * @param strCheckNoEnd
	 * @return String
	 */
	public String isCheckBookUsed(String strBankCode, String strAccount, String strBatNo, String strCheckNoStart, String strCheckNoEnd) {

		String strSql = "";
		String strReturnMsg = "";
		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "isValidCheckNo(strCheckNoStart,strCheckNoEnd)", "The dbFactory is null, can't get Data.");
		} else {
			strSql = " select CBKNO,CACCOUNT,CBNO,CNO ";
			strSql += " from  CAPCHKF";
			strSql += " WHERE  1=1 ";
			strSql += "  AND  CBKNO='" + strBankCode + "' AND CACCOUNT='" + strAccount + "'  AND CSTATUS<>'' ";
			strSql += " AND CNO BETWEEN  '" + strCheckNoStart + "'  AND '" + strCheckNoEnd + "'  AND CBNO='" + strBatNo + "' ";

			//	System.out.println("inside DISBBean isCheckBookUsed-->strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("isCheckBookUsed()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						strReturnMsg = "�Ӥ䲼���w�Q�ϥ�";
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				strReturnMsg = "�d�ߤ䲼����T�o�Ϳ��~: " + ex;
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return strReturnMsg;
	}

	//R90628	
	public int isCheckBookUseCount(String strBankCode, String strAccount, String strBatNo, String strCheckNoStart, String strCheckNoEnd) {

		String strSql = "";
		int strReturnMsg = 999999999;
		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "isValidCheckNo(strCheckNoStart,strCheckNoEnd)", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "SELECT CAST(SUBSTR(CHKENO,3) AS INTEGER) - CAST(SUBSTR(CHKSNO,3) AS INTEGER) + 1 - B.TOTAL AS USECOUNT ";
			strSql += "FROM CAPCKNOF A,";
			strSql += "(SELECT COUNT(1) AS TOTAL FROM CAPCHKF ";
			strSql += "WHERE CBKNO = '" + strBankCode + "' AND CACCOUNT = '" + strAccount + "' AND CSTATUS <> '' ";
			strSql += "AND CNO BETWEEN '" + strCheckNoStart + "' AND '" + strCheckNoEnd + "' AND CBNO='" + strBatNo + "') B ";
			strSql += "WHERE CBKNO = '" + strBankCode + "' AND CACCOUNT = '" + strAccount + "' AND CBNO = '" + strBatNo + "' ";

			//System.out.println("inside DISBBean isCheckBookUsed-->strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("isCheckBookUsed()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					while (rstResultSet.next()) {
						strReturnMsg = rstResultSet.getInt("USECOUNT");
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return strReturnMsg;
	}

	/**
	 *	GET DISB SEQ NO FROM ORNBSN
	 *	input : "DISB" 
	 */
	public Hashtable getDISBSeqNo(String strSysId, String strEntryUsr, Connection conDb) throws SQLException, IOException {
		int iDISBSeqNo = 0;
//		int iNO001 = 0;
		String strDISBSeqNo = "";
		String strDISBSeqNoTemp = "";
//		String strSql = "";
		Hashtable htReturnInfo = new Hashtable();

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getDISBSeqNo()", "The dbFactory is null, can't get Data.");
		} else {
			/* get max seq no from ORNBSN*/
//			strSql = "select max(NO01) as NO01 from ORNBSN ";
//			strSql += " where ASSORT ='" + strSysId + "'";
			//	System.out.println("inside DISBBEAN.getDISBSeqNo()_strSql="+strSql);
			//	Connection conDb = null;
			try {
				//	conDb = dbFactory.getAS400Connection("getDISBSeqNo()");
				if (conDb != null) {
//					Statement stmtStatement = conDb.createStatement();
//					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
//					if (rstResultSet.next()) {
//						iNO001 = rstResultSet.getInt("NO01");
//					}
//					rstResultSet.close();

//					iDISBSeqNo = iNO001 + 1;

					/*UPDATE ORNBSN*/
//					String strUpdateSql = " update ORNBSN ";
//					strUpdateSql += " set NO01 = " + iDISBSeqNo;
//					strUpdateSql += " where ASSORT ='" + strSysId + "'";
//					PreparedStatement pstmtTmp = conDb.prepareStatement(strUpdateSql);

					iDISBSeqNo = getSequenceNumber(strSysId, conDb);

//					if (pstmtTmp.executeUpdate() != 1) {
//						htReturnInfo.put("ReturnMsg", "���ͤ�I�ǥ���");
//						htReturnInfo.put("ReturnValue", "");
//					} else {
					strDISBSeqNoTemp = Integer.toString(iDISBSeqNo);
					int iSeqLengthTemp = 20 - strEntryUsr.length();
					strDISBSeqNo = strEntryUsr + CommonUtil.padLeadingZero(strDISBSeqNoTemp, iSeqLengthTemp);
					htReturnInfo.put("ReturnMsg", "");
					htReturnInfo.put("ReturnValue", strDISBSeqNo);
//					}
//					pstmtTmp.close();
//					rstResultSet.close();
//					stmtStatement.close();
				}

			} catch (Exception ex) {
				htReturnInfo.put("returnMsg", "���ͤ�I�Ǹ�����:" + ex);
				htReturnInfo.put("ReturnValue", "");
			}
		}
		return htReturnInfo;
	}

	/**
	 * @param strPNO
	 * @param strLogonUser
	 * @param iUpdDate
	 * @param iUpdTime
	 * @param con
	 * @return
	 */
	public synchronized String insertCAPPAYFLOG(String strPNO, String strLogonUser, int iUpdDate, int iUpdTime, Connection con) throws SQLException {
		PreparedStatement pstmtTmp = null;
		String strSql = ""; //SQL String
		String strReturnMsg = "";

		strSql =" insert into  CAPPAYFH "
				+ " (LOGDT,LOGTM,LOGUSR,PNO,PMETHOD,PDATE,PNAME,PSNAME,PID,PCURR,PAMT,PSTATUS,"
				+ "PCFMDT1,PCFMTM1,PCFMUSR1,PCFMDT2,PCFMTM2,PCFMUSR2,PDESC,PSRCGP,PSRCCODE,PPLANT,PSRCPGM,"
				+ "PVOIDABLE,PDISPATCH,PBBANK,PBACCOUNT,PCHECKNO,PCHKM1,PCHKM2,PRBANK,PRACCOUNT,PCRDNO,"
				+ "PCRDTYPE,PAUTHDT,PAUTHCODE,PCRDEFFMY,POLICYNO,APPNO,BRANCH,RMTFEE,PCSHDT,PBATNO,PNOH,"
				+ "ENTRYDT,ENTRYTM,ENTRYUSR,ENTRYPGM,UPDDT,UPDTM,UPDUSR,MEMO,BATSEQ,PCSHCM,PPAYCURR,PPAYAMT,"
				+ "PPAYRATE,PFEEWAY,PSYMBOL,PINVDT,PSWIFT,PBKCOTRY,PBKCITY,PBKBRCH,PENGNAME,PORGAMT,PORGCRDNO,"
				+ "PROJECTCD,REMITBACK,BACKRMK,PMETHODO,PAMTNT,REMITFAILD,REMITFAILT,REMITFCODE,REMITFDESC,PCLMNUM,PBNKRFDT,SRVBH,ANNPDATE) "
				+ " select " + iUpdDate + ", " + iUpdTime + ",'" + strLogonUser + "',PNO,PMETHOD,PDATE,"
				+ "PNAME,PSNAME,PID,PCURR,PAMT,PSTATUS,PCFMDT1,PCFMTM1,PCFMUSR1,PCFMDT2,PCFMTM2,PCFMUSR2,"
				+ "PDESC,PSRCGP,PSRCCODE,PPLANT,PSRCPGM,PVOIDABLE,PDISPATCH,PBBANK,PBACCOUNT,PCHECKNO,"
				+ "PCHKM1,PCHKM2,PRBANK,PRACCOUNT,PCRDNO,PCRDTYPE,PAUTHDT,PAUTHCODE,PCRDEFFMY,POLICYNO,APPNO,"
				+ "BRANCH,RMTFEE,PCSHDT,PBATNO,PNOH,ENTRYDT,ENTRYTM,ENTRYUSR,ENTRYPGM,UPDDT,UPDTM,UPDUSR,"
				+ "MEMO,BATSEQ,PCSHCM,PPAYCURR,PPAYAMT,PPAYRATE,PFEEWAY,PSYMBOL,PINVDT,PSWIFT,PBKCOTRY,"
				+ "PBKCITY,PBKBRCH,PENGNAME,PORGAMT,PORGCRDNO,PROJECTCD,REMITBACK,BACKRMK,PMETHODO,PAMTNT,"
				+ "REMITFAILD,REMITFAILT,REMITFCODE,REMITFDESC,PCLMNUM,PBNKRFDT,SRVBH,ANNPDATE "
				+ " from CAPPAYF where PNO='" + strPNO + "'";

		System.out.println(" inside DISBPMaintainServlet.insertCAPPAYFLOG()--> strSql =" + strSql);
		log.info(" inside DISBPMaintainServlet.insertCAPPAYFLOG()--> strSql =" + strSql);
		try {
			pstmtTmp = con.prepareStatement(strSql);

			if (pstmtTmp.executeUpdate() < 1) {
				strReturnMsg = "�s�Wlog ����";
				log.warn(strReturnMsg);
			} else {
				strReturnMsg = "";
			}
			pstmtTmp.close();
		} catch (SQLException e) {
			strReturnMsg = "�s�Wlog ����" + e;
			log.error(e.getMessage(), e);
		}
		return strReturnMsg;
	}

	/**
	 * @param strPNO
	 * @param strLogonUser
	 * @param iUpdDate
	 * @param iUpdTime
	 * @return
	 */
	public synchronized boolean insertCAPPAYFLOG(String strPNO, String strLogonUser, int iUpdDate, int iUpdTime) {

		Connection con = null;
		boolean bContinue = false;

		try {
			con = dbFactory.getAS400Connection("insertCAPPAYFLOG()");
			String strMsg = insertCAPPAYFLOG(strPNO, strLogonUser,iUpdDate,iUpdTime,con);

			if (strMsg.equals("")) {
				bContinue = true;
			}

		} catch (SQLException e) {
			setLastError(this.getClass().getName() + "insertCAPPAYFLOG()", e);
		} finally {
			if (con != null) 
				dbFactory.releaseAS400Connection(con);
		}

		return bContinue;
	}

	/**
	 * @param strPolNo		
	 * @return iPFee
	 */
	public Hashtable getPolDiv(String strPolNo, Connection conDb) throws SQLException, IOException {

		String strPolDiv = "";
		String strSRVBH = "";
		String strSql = "";
		Hashtable htReturnInfo = new Hashtable();
		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getETable()", "The dbFactory is null, can't get Data.");
		} else { //Q70494 ������PCAPSIL�U�Ӹ��
			//Q70494strSql = "SELECT A1.FLD0002 AS FLD0002,A1.FLD0184 AS FLD0184,A1.FLD0185 AS FLD0185, A2.BD01 AS BD01,A2.BD03 AS BD03 " ;
			//Q70494strSql += " FROM  ORDUPO A1 LEFT JOIN ";
			//Q70494strSql += "  BRCCBD A2 ON SUBSTRING(A1.FLD0185, 1, 3) = A2.BD01 ";
			//Q70494strSql += " where A1.FLD0002 ='" + strPolNo + "' ";
			strSql = "SELECT B.AGLIOF AS AGLIOF, A.FLD0184 AS SRVBH ";
			strSql += " FROM  ORDUPO A JOIN ORDUAG B ON A.FLD0185=B.AGCONU";
			strSql += " WHERE A.FLD0001='  ' AND A.FLD0002 ='" + strPolNo + "' ";

			try {
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						strPolDiv = (String) rstResultSet.getString("AGLIOF").trim();
						strSRVBH = CommonUtil.AllTrim(rstResultSet.getString("SRVBH"));
						htReturnInfo.put("ReturnMsg", "");
						htReturnInfo.put("ReturnValue", strPolDiv);
						htReturnInfo.put("RVSRVBH", strSRVBH);
					} else {
						htReturnInfo.put("ReturnMsg", "���o��쥢��-�d�L���");
						htReturnInfo.put("ReturnValue", "");
						htReturnInfo.put("RVSRVBH", "");
					}

					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				htReturnInfo.put("ReturnMsg", "���o��쥢��:" + ex);
				htReturnInfo.put("ReturnValue", "");
				htReturnInfo.put("RVSRVBH", "");
			}
		}

		return htReturnInfo;
	}

	public String getPolMailOffice(String strPolNo) {
		String strMailOffice = "";
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getPolMailOffice()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = " select a.fld0184 as fld0184 ,a.fld0185 as fld0185,b.agliof  as agliof ,c.BD01 AS BD01,c.BD03 AS BD03 ";
			strSql += " from ordupo a ";
			strSql += " left outer join orduag b on a.fld0185=b.agconu ";
			strSql += " LEFT OUTER JOIN BRCCBD c ON SUBSTRING(a.FLD0185, 1, 3) = c.BD01 ";
			strSql += " where a.FLD0001='  ' and a.FLD0002 ='" + strPolNo + "' ";

			//	System.out.println("inside DISBBEAN.getPolMailOffice()_strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getPolMailOffice()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						if (rstResultSet.getString("FLD0184").trim().equals("AEGON")) {
							strMailOffice = (String) rstResultSet.getString("agliof").trim();
						} else {
							strMailOffice =
								(String) rstResultSet.getString("BD03").trim();
						}
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getPolMailOffice()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) {
					dbFactory.releaseAS400Connection(conDb);
				}
			}
		}
		return strMailOffice;
	}

	public Hashtable getPolMailAdd(String strPolNo) {
		String strSql = "";
		Hashtable htPolMailAdd = new Hashtable();

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getPolMailOffice()", "The dbFactory is null, can't get Data.");
		} else {
			// Q80110 ��� BILLAD, BILLZC
			//	strSql = " select a.pono,a.mailad,a.mailzc from ornbcl a ";
			strSql = " select a.pono,a.billad,a.billzc from ornbcl a ";
			strSql += " where a.pono ='" + strPolNo + "' ";

			//System.out.println("inside DISBBEAN.getPolMailAdd()_strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getPolMailAdd()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						// Q80110 ��� BILLAD, BILLZC
						//		htPolMailAdd.put("mailzc",(String)rstResultSet.getString("mailzc").trim())
						//		htPolMailAdd.put("mailad",(String)rstResultSet.getString("mailad").trim());
						htPolMailAdd.put("mailzc", (String) rstResultSet.getString("billzc").trim());
						htPolMailAdd.put("mailad", (String) rstResultSet.getString("billad").trim());
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getPolMailAdd()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return htPolMailAdd;

	}

	public String getServiceNm(String strPolNo) {
		String strServiceNm = "";
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getPolMailOffice()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = " select a.fld0185,b.fld0004,b.fld0003,b.FLD0070  from ordupo a";
			strSql += " join orduna b   on a.fld0185 = b.fld0002 ";
			strSql += " where a.FLD0001='  ' and a.FLD0002 ='" + strPolNo + "' ";

			//System.out.println("inside DISBBEAN.getServiceNm()_strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getServiceNm()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						//  R60713
						//	strServiceNm =  (String)rstResultSet.getString("fld0004").trim() + (String)rstResultSet.getString("fld0003").trim();
						//strServiceNm = (String) rstResultSet.getString("fld0004").replace('�@', ' ').trim() + (String) rstResultSet.getString("fld0003").replace('�@', ' ').trim();
						strServiceNm = CommonUtil.AllTrim(rstResultSet.getString("FLD0070"));
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getServiceNm()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return strServiceNm;
	}

	public String getInsuredNm(String strPolNo) {
		String strInsuredNm = "";
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getInsuredNm()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "  select a.CLIENTNO1,b.fld0004,b.fld0003,b.FLD0070  from orduco a";
			strSql += " join orduna b   on a.CLIENTNO1 = b.fld0002 ";
			strSql += " where TRAILER=1 AND a.POLICY ='" + strPolNo + "' ";

			//System.out.println("inside DISBBEAN.getInsuredNm()_strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getInsuredNm()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						//  R60713
						//	strInsuredNm =  (String)rstResultSet.getString("fld0004").trim() + (String)rstResultSet.getString("fld0003").trim();
						//strInsuredNm = (String) rstResultSet.getString("fld0004").replace('�@', ' ').trim() + (String) rstResultSet.getString("fld0003").replace('�@', ' ').trim();
						strInsuredNm = CommonUtil.AllTrim(rstResultSet.getString("FLD0070"));
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getInsuredNm()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return strInsuredNm;
	}

	public String getAppNm(String strPolNo) {
		String strInsuredNm = "";
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getAppNm()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = " select a.fld0021,b.fld0004,b.fld0003,b.FLD0070  from ordupo a";
			strSql += " join orduna b   on a.fld0021 = b.fld0002 ";
			strSql += " where a.FLD0001='  ' and a.FLD0002 ='" + strPolNo + "' ";

			//System.out.println("inside DISBBEAN.getPolMailOffice()_strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getInsuredNm()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						// R60713 
						//	strInsuredNm =  (String)rstResultSet.getString("fld0004").trim() + (String)rstResultSet.getString("fld0003").trim();
						//strInsuredNm = (String) rstResultSet.getString("fld0004").replace('�@', ' ').trim() + (String) rstResultSet.getString("fld0003").replace('�@', ' ').trim();
						strInsuredNm = CommonUtil.AllTrim(rstResultSet.getString("FLD0070"));
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getAppNm()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return strInsuredNm;
	}

	// R80132 READ  ETAB
	public String getETableDesc(String strETType, String strETValue) {
		String strETableDesc = "";
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getPolMailOffice()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "select FLD0002, FLD0003, FLD0004 ";
			strSql += " from ORDUET ";
			strSql += " where FLD0001='  ' AND FLD0002 ='" + strETType + "' AND  FLD0003 ='" + strETValue + "' ";

			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getETableDesc()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						strETableDesc = rstResultSet.getString("FLD0004").replace('�@', ' ').trim();
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getServiceNm()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return strETableDesc;
	}
	// R80132 END

	/**
	 * @return List
	 */
	public List getBankList() {
		List alBankList = new ArrayList();
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getETable()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "select  BKNO,BKFNM ";
			strSql += " from CAPCCBF ";

			//System.out.println("inside DISBBean getBankList-->strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getBankList()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					while (rstResultSet.next()) {
						Hashtable htTemp = new Hashtable();
						htTemp.put("BKNO", (String) rstResultSet.getString("BKNO").trim());
						htTemp.put("BKNM", (String) rstResultSet.getString("BKFNM").trim());
						alBankList.add(htTemp);
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getBankList()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return alBankList;
	}

	/**
	 * R60550 �s�W��O�X
	 * @return List
	 */
	public List getCotryList() {
		List alCotryList = new ArrayList();
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getCotryList()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "select COUNTRYCD,CTRYNAME,CTRYENNAME";
			strSql += " from CAPCTRY ORDER BY COUNTRYCD";

			//System.out.println("inside DISBBean getCountryList->strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getCotryList()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					while (rstResultSet.next()) {
						Hashtable htTemp = new Hashtable();
						htTemp.put("CotryCODE", (String) rstResultSet.getString("COUNTRYCD").trim());
						htTemp.put("CotryCHNM", (String) rstResultSet.getString("CTRYNAME").trim());
						htTemp.put("CotryENNM", (String) rstResultSet.getString("CTRYENNAME").trim());
						alCotryList.add(htTemp);
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getCotryList()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return alCotryList;
	}

	/**
	 * R60550 �s�WSWIFT��
	 * RA0074 ���ɮ׬�ORCHSWFT
	 * @return List
	 */
	public List getSWIFTList() {
		List alSWIFTList = new ArrayList();
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getSWIFTList()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "select SWIFT_CODE,BANK_NAME,BANK_NO";
			strSql += " from ORCHSWFT ORDER BY SWIFT_CODE";

			//System.out.println("inside DISBBean getCountryList->strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getSWIFTList()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					while (rstResultSet.next()) {
						Hashtable htTemp = new Hashtable();
						htTemp.put("SwiftCD", (String) rstResultSet.getString("SWIFT_CODE").trim());
						htTemp.put("SwiftBK", (String) rstResultSet.getString("BANK_NO").trim());
						htTemp.put("SwiftBN", (String) rstResultSet.getString("BANK_NAME").trim());
						alSWIFTList.add(htTemp);
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getSWIFTList()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return alSWIFTList;
	} //R60550 END

	/**
	 * Q90020 �s�WUSER LIST��
	 * @return List
	 */
	public List getUSERList() {
		List alUSERList = new ArrayList();
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getUSERList()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "select USRID,USRNAM";
			strSql += " from USER WHERE STAT='A' ORDER BY USRID";

			//System.out.println("inside DISBBean getUSERList->strSql="+strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getUSERList()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					while (rstResultSet.next()) {
						Hashtable htTemp = new Hashtable();
						htTemp.put("USERid", (String) rstResultSet.getString("USRID").trim());
						htTemp.put("USERname", (String) rstResultSet.getString("USRNAM").trim());
						alUSERList.add(htTemp);
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getUSERList()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return alUSERList;
	} //Q90020 END

	/**
	 * @param strPMethod
	 * @param iUpdDate		
	 * @param iUpdTime
	 * @param PBANK   R60550_R60463�~���״ڬ����B�z
	 * @return strPBatNo
	 */
	public String getPBatNo(String strPMethod, int iUpdDate, int iUpdTime, String PBANK) {
		String strPBatNo = "";
		try{
			String strUpdDateTemp = "";
			strUpdDateTemp = Integer.toString(iUpdDate).trim();
			if (strUpdDateTemp.length() < 7) {
				strUpdDateTemp = "0" + strUpdDateTemp;
			}
			//R60550_R60463 �״ڧ帹�[�J�Ȧ�N��
			strPBatNo = strPMethod.trim() + strUpdDateTemp + PBANK.substring(0, 3) + Integer.toString(iUpdTime).trim();
		} catch(Exception e){
			log.error(e.getMessage(), e);
		}
		

		return strPBatNo;
	}

	/**
		 * @param strBankCode ���y�I�ڻȦ�
		 * @param strBankCode �Ȥᤧ�״ڻȦ�
		 * @param iPAmt �I�ڪ��B
		 * @param strPMethod �I�ڤ覡
		 * @return iPFee
		 */
	public double getPFee(String strBankCode, String strRemitBankCode, double iPAmt, String strPMethod, String strSWIFT, String strSWITCH) {
		// ����O���p��ݨ̥I�ڤ覡�Ϥ��H�Υd�λȦ�״ڪ��p��
		//�[�J�~���״�(D)���p��
		log.info("getPFee:strPMethod�O" + strPMethod);
		if (strPMethod.equals("D")) {
			return getPFeeForD(strBankCode, strRemitBankCode, iPAmt, strSWIFT, strSWITCH); //�I�ڤ覡���~���״ڮ�
		} else {
			return getPFeeForB(strBankCode, strRemitBankCode, iPAmt); //�I�ڤ覡���Ȧ��
		}
	}

	/**
	 * @��~�״ڤ���O��k
	 * @param strBankCode ���y�I�ڻȦ�
	 * @param strRemitBankCode �Ȥᤧ�״ڻȦ�
	 * @param iPAmt �I�ڪ��B
	 * @return iPFee
	 * @return strSWIFTCODE
	 * @return strSWITCH�O�_�t���M���_�l��e
	 */
	private double getPFeeForD(String strBankCode, String strRemitBankCode, double iPAmt, String strSWIFT, String strSWITCH) {
		int iPfee = 0;
		String strBankCodeTp = ""; //���y�I�ڻȦ�
		if (strBankCode.length() > 3) {
			strBankCodeTp = strBankCode.substring(0, 3);
		} else {
			strBankCodeTp = strBankCode;
		}
		//Q80691
		String strRemitBankCodeTp = ""; //�״ڻȦ�
		if (strRemitBankCode.length() > 3) {
			strRemitBankCodeTp = strRemitBankCode.substring(0, 3);
		} else {
			strRemitBankCodeTp = strRemitBankCode;
		}

		if (strBankCodeTp.equals("822")) //�p�����H�h�� 500 ���x��,�P�����t��,���_�l��e�����׶O
			{
			//R80338 if ((!strSWIFT.equals("") && strSWIFT.substring(0,6).equals("CTCBTW")) || strSWITCH.equals("Y")) 
			//Q80691 if ((!strSWIFT.equals("") && strSWIFT.substring(0,6).equals("CTCBTW"))) // R80338 �վ㬰�u�P�_�O�_�P�����
			if ((!strSWIFT.equals("") && strSWIFT.substring(0, 6).equals("CTCBTW")) 
				|| (strSWIFT.equals("") && strRemitBankCodeTp.equals("822"))) // Q80691 �վ�P�_�O�_�P����઺����
				iPfee = 0;
			else
				iPfee = 300; //R80685 ����O�վ� 500 -> 300
		} else if (strBankCodeTp.equals("007")) {	//�p���@�Ȧ���100 ���x��
			iPfee = 100;
		} else if (strBankCodeTp.equals("021")) {	//�p����X�h�� 10 ������
			//R70477 ��X�P�����, �h��0
			if ((!strSWIFT.equals("") && strSWIFT.substring(0, 4).equals("CITI")))
				iPfee = 0;
			else
				iPfee = 10;
		} else {
			iPfee = 0;
		}
		return iPfee;
	}

	/**
	 * @��~�״ڤ���O��k(�Ȧ�V�Ȥ᦬��,�D���q�V�Ȥ᦬��)
	 * @param strBankCode ���y�I�ڻȦ�
	 * @param iRPAYRATE �~���ײv
	 * @return iPFee
	 */
	public double getPFeeBEN(String strBankCode, double iRPAYRATE) {
		String strBankCodeTp = ""; //���y�I�ڻȦ�(��I�Ȧ�)
		if (strBankCode.length() > 3) {
			strBankCodeTp = strBankCode.substring(0, 3);
		} else {
			strBankCodeTp = strBankCode;
		}
		return getBENFEE(strBankCodeTp, iRPAYRATE);
	}

	/**
	 * @��~�״ڤ���O��k(�Ȧ�V�Ȥ᦬��,�D���q�V�Ȥ᦬��)
	 * @param strBankCode ���y�I�ڻȦ�
	 * @param iRPAYRATE �~���ײv
	 * @return iPFee
	 */
	private double getBENFEE(String strBankCode, double iRPAYRATE) {
		double iPfee = 0;
		if (strBankCode.equals("007")) {	//�p���@�Ȧ���100 ���x��
			iPfee = 100 / iRPAYRATE;
		} else {
			iPfee = 0;
		}
		return iPfee;
	}

	/**
	 * ���o (�x��) �״ڤ���O <p>
	 * �� �GR00217 �HŪ�� table (BANKFEE) ���覡�Ө��N�즳�{���p��W�h <br>
	 *    �즳�{���אּ {@link #getPFeeForB_old(String, String, double)} <p>
	 * 
	 * @�״ڤ���O��k
	 * @param strBankCode ���y�I�ڻȦ�
	 * @param strBankCode �Ȥᤧ�״ڻȦ�
	 * @param iPAmt �I�ڪ��B
	 * @return iPFee Ū�����\�^�ǳ]�w�����B, Ū������^ -1
	 */
	public double getPFeeForB(String strBankCode, String strRemitBankCode, double iPAmt) {
		return getPFeeForB(strBankCode, strRemitBankCode, iPAmt, "NT");
	}

	public double getPFeeForB(String strBankCode, String strRemitBankCode, double iPAmt, String currCode) {
		log.info("strBankCode�O" + strBankCode + ",strRemitBankCode�O" + strRemitBankCode);
		String strBankCodeTp = ""; //���y�I�ڻȦ�
		String strRemitBankCodeTp = ""; //�Ȥᤧ�״ڻȦ�

		if (strBankCode.length() > 3) {
			strBankCodeTp = strBankCode.substring(0, 3);
		} else {
			strBankCodeTp = strBankCode;
		}

		if (strRemitBankCode.length() > 3) {
			log.info("strRemitBankCode.length() > 3 : strRemitBankCode.length()�O" +  strRemitBankCode.length());
			strRemitBankCodeTp = strRemitBankCode.substring(0, 3);
		} else {
			log.info("strRemitBankCode.length() <= 3 : strRemitBankCode.length()�O" +  strRemitBankCode.length());
			strRemitBankCodeTp = strRemitBankCode;
		}
		
		log.info("�ˬd�I�ڻȦ�ζ״ڻȦ�O�_�ۦP:strBankCodeTp�O" + strBankCodeTp + ",strRemitBankCodeTp�O" + strRemitBankCodeTp);
		if (strBankCodeTp.equals(strRemitBankCodeTp)) {
			// �p�I�ڻȦ�ζ״ڻȦ�ۦP�h����O��0
			log.info("�ˬd�I�ڻȦ�ζ״ڻȦ�O�_�ۦP:strBankCodeTp�O" + strBankCodeTp + ",strRemitBankCodeTp�O" + strRemitBankCodeTp + "�ۦP!�׶O=0");
			return 0;
		}
		log.info("�ˬd�I�ڻȦ�ζ״ڻȦ�O�_�ۦP:strBankCodeTp�O" + strBankCodeTp + ",strRemitBankCodeTp�O" + strRemitBankCodeTp + "���ۦP!�׶O�p�⤤....");

		if (currCode == null || currCode.length() == 0)
			currCode = "NT";

		Connection conn = null;
		PreparedStatement stat1 = null;
		PreparedStatement stat2 = null;
		ResultSet result1 = null;
		ResultSet result2 = null;
		try {
			// ���d�̤j��, ���n���ܭn���q
			String sql =
				"SELECT FLD004, FLD005, FLD006, FLD007 "
					+ " FROM BANKFEE "
					+ " WHERE FLD002 = ? AND FLD004 = "
					+ " ( SELECT MAX(FLD004) FROM BANKFEE WHERE FLD002 = ? )";
			conn = dbFactory.getConnection("DISBBean");
			stat1 = conn.prepareStatement(sql);
			stat1.setString(1, currCode);
			stat1.setString(2, currCode);
			log.info("�׶O�p�⤤(#1):" + sql + ",FLD002�O" + currCode);
			result1 = stat1.executeQuery();
			if (!result1.next()) // not found
				return -1;

			double maxAmt = result1.getDouble("FLD004");
			double partialFee = 0;
			double remainder = iPAmt % maxAmt;

			if (iPAmt >= maxAmt)
				partialFee = ((int) (iPAmt / maxAmt)) * getPFeeByBankId(strBankCodeTp, strRemitBankCodeTp, result1);

			if (remainder == 0 && partialFee > 0){
				// �㰣�̤j�״ڪ��B (���n��), ���ݦA���l����
				log.info("�׶O�p�⧹��partialFee:" + partialFee + ",�㰣�̤j�״ڪ��B (���n��), ���ݦA���l����");
				return partialFee;
			}				

			sql = "SELECT FLD005, FLD006, FLD007 FROM BANKFEE WHERE FLD002=? AND FLD003<=? AND FLD004>=?";
			stat2 = conn.prepareStatement(sql);
			stat2.setString(1, currCode);
			stat2.setDouble(2, remainder);
			stat2.setDouble(3, remainder);
			log.info("�׶O�p�⤤(#2):" + sql + ",FLD002�O" + currCode + ",FLD003�O" + remainder + "FLD004�O" + remainder);
			result2 = stat2.executeQuery();
			// �p�G�䤣��]�w, �^�� -1
			if (!result2.next())
				return -1;

			//�u�f�׶O �� �@��׶O			
			double retFee = partialFee + getPFeeByBankId(strBankCodeTp, strRemitBankCodeTp, result2);
			log.info("�׶O�p�⧹��retFee:" + retFee + ",�u�f�׶O �� �@��׶O");
			return retFee;

		} catch (SQLException e) {
			e.printStackTrace();
			// ���F���� API, ��� RuntimeException
			throw new RuntimeException("Ū���״ڤ���O���ѡAmsg=" + e.getMessage());
		} finally {
			try { if (result1 != null) result1.close(); } catch (Exception e) {}
			try { if (result2 != null) result2.close(); } catch (Exception e) {}
			try { if (stat1 != null) stat1.close(); } catch (Exception e) {}
			try { if (stat2 != null) stat2.close(); } catch (Exception e) {}
			try { if (conn != null) dbFactory.releaseConnection(conn); } catch (Exception e) {}
		}
	}

	private double getPFeeByBankId(String bankCode, String remitBankCode, ResultSet feeResult) throws SQLException {
		if (bankCode.equals("822") || bankCode.equals("812"))
			return feeResult.getDouble("FLD006");
		else
			return feeResult.getDouble("FLD007");
	}

	public double getPFeeForB_old(String strBankCode, String strRemitBankCode, double iPAmt) {
		double iPFee = 0;
		String strBankCodeTp = ""; //���y�I�ڻȦ�
		String strRemitBankCodeTp = ""; //�Ȥᤧ�״ڻȦ�

		//�u�f�׶O
		double iSBasicFee = 10; // �򥻶׶O
		double iSMinAMT = 2000000; //�򥻶״��B��
		double iSRange = 1000000; //�[�B�϶�
		double iSAddFee = 5; //�֥[5��

		//�@��׶O
		double iNBasicFee = 30; // �򥻶׶O
		double iNMinAMT = 2000000; //�򥻶״��B��
		double iNRange = 1000000; //�[�B�϶�
		//double iNMaxAMT = 20000000 ; //�̤j�״��B��
		double iNMaxAMT = 50000000; //�̤j�״��B��
		double iNAddFee = 10; //�֥[10��

		if (strBankCode.length() > 3) {
			strBankCodeTp = strBankCode.substring(0, 3);
		} else {
			strBankCodeTp = strBankCode;
		}
		if (strRemitBankCode.length() > 3) {
			strRemitBankCodeTp = strRemitBankCode.substring(0, 3);
		} else {
			strRemitBankCodeTp = strRemitBankCode;
		}

		if (strBankCodeTp.equals(strRemitBankCodeTp)) {
			// �p�I�ڻȦ�ζ״ڻȦ�ۦP�h����O��0
			iPFee = 0;
			return iPFee;
		}

		if (strBankCodeTp.equals("822")) {	//�u�f�׶O
			if (iPAmt >= 0 && iPAmt <= iSMinAMT) {
				iPFee = iSBasicFee;
			} else {
				double iSRangeCount = 0;
				if ((iPAmt - iSMinAMT) % iSRange == 0) {
					iSRangeCount = (int) (iPAmt - iSMinAMT) / (int) iSRange;
				} else {
					iSRangeCount = (int) (iPAmt - iSMinAMT) / (int) iSRange + 1;
				}

				iPFee = iSBasicFee + iSRangeCount * iSAddFee;
			}

		} else {	//�@��׶O
			if (iPAmt >= 0 && iPAmt <= iNMinAMT) {
				iPFee = iNBasicFee;
			} else if (iPAmt > iNMinAMT && iPAmt <= iNMaxAMT) {
				double iNRangeCount = 0;
				if ((iPAmt - iNMinAMT) % iSRange == 0) {
					iNRangeCount = (int) (iPAmt - iNMinAMT) / (int) iNRange;
				} else {
					iNRangeCount = (int) (iPAmt - iNMinAMT) / (int) iNRange + 1;
				}
				iPFee = iNBasicFee + iNRangeCount * iNAddFee;
			} else if (iPAmt > iNMaxAMT) //�״��B�פ��o�t�LiNMaxAMT
				{
				iPFee = -1;
			}
		}

		return iPFee;
	}

	// R80338 READ  CAPBNKF
	/**
	 * @�X�Ƕ״ڷ|�p���
	 * @param strBankCode �Ȧ�N�X x(03)
	 * @param strBKAcctNo �Ȧ�b��
	 * @param strCurrency    ���O
	 * @return  GLACT         �|�p��� 
	 */
	//R80413 public String getACTCDFinRmt(String strBankCode,String strBKAcctNo)
	public String getACTCDFinRmt(String strBankCode, String strBKAcctNo, String strCurrency) {
		String strACTCDFinRmt = "";
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getPolMailOffice()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "SELECT GLACT ";
			strSql += " FROM  CAPBNKF ";
			strSql += " WHERE BKCODE ='" + strBankCode + "' ";
			strSql += " AND BKATNO ='" + strBKAcctNo + "' ";
			strSql += " AND BKCURR ='" + strCurrency + "' "; // R80413
			strSql += " AND BKSTAT ='Y' ";

			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getServiceNm()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					System.out.println("DISBBean.getACTCDFinRmt():" + strSql);
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						strACTCDFinRmt = (String) rstResultSet.getString("GLACT").replace('�@', ' ').trim();
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getServiceNm()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return strACTCDFinRmt;
	}
	// R80338 END	

	// R80338 READ  ORDUER
	/**
	 * @�ײv
	 * @param strERCURRCODE           ���O�N�X x(02)
	 * @param strEREFFDATE                �ײv���
	 * @param strDataType                     ������O  S--> Sell Price , B--> Buy Price
	 * @return  ERRate                            �ײv 
	 */
	public double getERRate(String strERCURRCODE, String strEREFFDATE, String strDataType) {
		double iERRATE = 0;
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getPolMailOffice()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "SELECT ER_BUY_RATE AS BRATE,ER_SELL_RATE AS SRATE FROM ORDUER A WHERE A.ER_EFF_DATE_DISP = ";
			strSql += " (SELECT MAX( B.ER_EFF_DATE_DISP ) FROM ORDUER B WHERE ";
			strSql += " B.ER_CURR_CODE ='" + strERCURRCODE + "' ";
			strSql += " AND B.ER_EFF_DATE_DISP <=" + strEREFFDATE + ")";
			strSql += " AND A.ER_CURR_CODE ='" + strERCURRCODE + "' ";

			System.out.println("inside DISBBEAN.getERRate_strSql=" + strSql);
			log.info("inside DISBBEAN.getERRate_strSql=" + strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getServiceNm()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						if (strDataType.trim().equals("B")) {
							iERRATE = rstResultSet.getDouble("BRATE");
						} else {
							iERRATE = rstResultSet.getDouble("SRATE");
						}
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getServiceNm()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return iERRATE;
	}
	// R80338 END		
	
	//RD0440-�s�W�~�����w�Ȧ�-�x�W�Ȧ�
	public double getERRate004(String strERCURRCODE, String strEREFFDATE) {
		double iERRATE = 0;
		String strSql = "";

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "getPolMailOffice()", "The dbFactory is null, can't get Data.");
		} else {
			strSql = "SELECT ER_TWBK_BUY_RATE AS BRATE,ER_TWBK_SELL_RATE AS SRATE FROM ORDUER A WHERE A.ER_EFF_DATE_DISP = ";
			strSql += " (SELECT MAX( B.ER_EFF_DATE_DISP ) FROM ORDUER B WHERE ";
			strSql += " B.ER_CURR_CODE ='" + strERCURRCODE + "' ";
			strSql += " AND B.ER_EFF_DATE_DISP <=" + strEREFFDATE + ")";
			strSql += " AND A.ER_CURR_CODE ='" + strERCURRCODE + "' ";

			System.out.println("inside DISBBEAN.getERRate004_strSql=" + strSql);
			log.info("inside DISBBEAN.getERRate004_strSql=" + strSql);
			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("getServiceNm()");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
					if (rstResultSet.next()) {
						iERRATE = rstResultSet.getDouble("BRATE");
					}
					rstResultSet.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError(this.getClass().getName() + "getServiceNm()", ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null) 
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return iERRATE;
	}

	/**
	 * @param strCBkNo
	 * @return
	 */
	public String getACTCD3(String strCBkNo) {
		String strACTCD3 = "";
		String strCBkNoTemp = "";
		if (strCBkNo.length() == 3)
			strCBkNoTemp = strCBkNo;
		else if (strCBkNo.length() > 3)
			strCBkNoTemp = strCBkNo.substring(0, 3);
		else {
			strACTCD3 = "0000";
			return strACTCD3;
		}

		if (strCBkNoTemp.equals("822"))
			strACTCD3 = "8225";
		else if (strCBkNoTemp.equals("812"))
			strACTCD3 = "8123";
		else if (strCBkNoTemp.equals("808")) //Q60159�W�[�ɤs�Ȧ�N�X
			strACTCD3 = "8083";
		else
			strACTCD3 = "0000";
		return strACTCD3;
	}

	/**R70366
	 * @param strPayBank,strPayAcct
	 * @return strACTCD3
	 */
/*	public String getACTCD3(String strPayBank, String strPayAcct) {
		String strACTCD3 = "";

		if (strPayBank.equals("8220635") && strPayAcct.equals("635530015707"))
			strACTCD3 = "8223";
		else if (strPayBank.equals("8220635") && strPayAcct.equals("635300021303"))
			strACTCD3 = "8225";
		else if (strPayBank.equals("8220635") && strPayAcct.equals("635131008304"))
			strACTCD3 = "8226";
		else if (strPayBank.equals("8080532") && strPayAcct.equals("0532435000239"))
			strACTCD3 = "8083";
		else if (strPayBank.equals("8120610") && strPayAcct.equals("06120001666600"))
			strACTCD3 = "8123";
		else if (strPayBank.equals("8120610") && strPayAcct.equals("20613900000176"))
			strACTCD3 = "8125";
		else if (strPayBank.equals("0520672") && strPayAcct.equals("06805300019323"))
			strACTCD3 = "0523";
		else if (strPayBank.equals("8070014") && strPayAcct.equals("00100800030031"))
			strACTCD3 = "8073";
		else if (strPayBank.equals("8060035") && strPayAcct.equals("0035281352851"))
			strACTCD3 = "8062";
		else if (strPayBank.equals("0070937") && strPayAcct.equals("09340040798"))
			strACTCD3 = "0076";
		else if (strPayBank.equals("8040240") && strPayAcct.equals("01405004003300"))
			strACTCD3 = "8042";
		else if (strPayBank.equals("0172026") && strPayAcct.equals("20253105899"))
			strACTCD3 = "0179";
		else if (strPayBank.equals("0050795") && strPayAcct.equals("079101009292"))
			strACTCD3 = "0052";
		else if (strPayBank.equals("0081005") && strPayAcct.equals("102970305885"))
			strACTCD3 = "0084";
		else if (strPayBank.equals("0170055") && strPayAcct.equals("00509015266"))
			strACTCD3 = "0171";
		//R70605 else if(strPayBank.equals("8140209") && strPayAcct.equals("014302007196"))
		else if (strPayBank.equals("8140209") && (strPayAcct.equals("200102463017") || strPayAcct.equals("207102463015")))
			strACTCD3 = "8143";
		else if (strPayBank.equals("8150174") && strPayAcct.equals("015100098444"))
			strACTCD3 = "8152";
		else
			strACTCD3 = "0000";
		return strACTCD3;
	}*/

	/**R70366
	 * @param strPayBank
	 * @return strACTCD2
	 */
	public String getACTCD2(String inputCURR) {
		String strACTCD2 = "";
		//R70770 ZZ�אּZZZ 
		if (inputCURR.equals("TWD"))
			strACTCD2 = "10172000ZZZ";
		else if (inputCURR.equals("USD"))
			strACTCD2 = "10172100ZZZ";
		else if (inputCURR.equals("HKD"))
			strACTCD2 = "10172300ZZZ";
		else if (inputCURR.equals("AUD"))
			strACTCD2 = "10172400ZZZ";
		else if (inputCURR.equals("NZD")) //R80132
			strACTCD2 = "10172600ZZZ"; //R80132		
		else if (inputCURR.equals("EUR")) //R80132
			strACTCD2 = "10172500ZZZ"; //R80132		
		else if (inputCURR.equals("JPY")) //R80132
			strACTCD2 = "10172200ZZZ"; //R80132		
		else if (inputCURR.equals("GBP")) //R80132
			strACTCD2 = "10172700ZZZ"; //R80132		
		else if (inputCURR.equals("SEK")) //R80132
			strACTCD2 = "10172800ZZZ";	//R80132
		else if (inputCURR.equals("CNY"))
			strACTCD2 = "10172900ZZZ";

		return strACTCD2;
	}

	/**
	 * @param getSafeCode807 - R70088
	 * @param returnType, ����׻Ȧ�w���X:�Ȥ�b��.������B.�ýX�ǦC�[�`��X�Pmaping table�o�X
	 * @return
	 */
	public String getSafeCode807(String inPACCT, String inAMT) {
		//int e = 0;		
		//java.util.Vector v = new java.util.Vector();
		int[] addNUM = { 10, 5, 6, 3, 4, 1, 2, 4, 2, 4, 5, 5, 8, 2 };
		int[] addPACCT = new int[14];
		int[] addAMT = new int[14];
		int[] sumAMT = new int[14];
		String[] compNUM =
			{
				"a",
				"1",
				"b",
				"2",
				"c",
				"3",
				"d",
				"4",
				"e",
				"5",
				"g",
				"6",
				"h",
				"7",
				"i",
				"8",
				"j",
				"9",
				"k",
				"a",
				"l",
				"b",
				"m",
				"c",
				"n",
				"d",
				"o",
				"e" };
		String safeCode = "";

		for (int i = 0; i < 14; i++) {
			addPACCT[i] = Integer.parseInt(inPACCT.substring(i, i + 1));
		}
		for (int i = 0; i < 13; i++) {
			addAMT[i] = Integer.parseInt(inAMT.substring(i, i + 1));
		}
		addAMT[13] = 5;
		//�`�M
		for (int i = 0; i < 14; i++) {
			sumAMT[i] = addNUM[i] + addPACCT[i] + addAMT[i];
			safeCode = safeCode + compNUM[(sumAMT[i] - 1)];
		}
		return safeCode;
	}

	/**
	 * @param writeTOfile - R70088
	 * @param returnType, �ץX�gTXT��
	 * @return
	 */
	public String writeTOfile(String[][] downloadData, String BATNO, String selCURR, String remitKind, String strLogonUser) {
		String fileLOC = "";
		String returnROOT = "";

		ByteArrayInputStream is = null;
		FileOutputStream os = null;

		try {
			//�إߥؿ�
			String fileROOT = globalEnviron.getAppPath() + "DISB\\DISBDownData\\";
			System.out.println("fileROOT : " + fileROOT);

			returnROOT = "/DISB/DISBDownData/";

			String export = "";
			for (int index = 0; index < downloadData.length; index++) {
				for (int pos = 0; pos < downloadData[index].length; pos++) {
					export += downloadData[index][pos];
				}
				export += ((char) 13);
				export += ((char) 10);
			}
			System.out.println(export);

			//�B�z�ɦW
			//R80300 �H�Υd�ɮ�:
			if (BATNO.substring(0, 1).equals("C")) {
				String strMD = BATNO.substring(4, 8);
				int iY = Integer.parseInt(BATNO.substring(1, 4)) + 1911;
				String strYMD = String.valueOf(iY) + strMD;
				fileLOC = "000812000104576" + strYMD + "01.pay";
			} else if (BATNO.substring(0, 1).equals("D") && BATNO.substring(8, 11).equals("011")) {
				fileLOC = "VSTRSBB";
				//R80480�W���ӻ� 
			} else if (BATNO.substring(0, 1).equals("D") && BATNO.substring(8, 11).equals("007") && !selCURR.equals("NT")) {
				fileLOC = "MEDIA.DAT";
			}
			//R00566���j�Ȧ�
			else if (BATNO.substring(0, 1).equals("D") && BATNO.substring(8, 11).equals("806")) {
				fileLOC = "70817744_" + selCURR + ".txt";
			// RB0062 ���ƻȦ�
			} else if(BATNO.substring(0, 1).equals("D") && BATNO.substring(8, 11).equals("009")) {
				//��b��
				if(remitKind.equals("t")) {
					fileLOC = selCURR + "_PCCUT.TXT";
				}
				//�״���
				if(remitKind.equals("r")) {
					String strRMD = String.valueOf(Integer.parseInt(BATNO.substring(1, 8)) + 19110000);
					DecimalFormat df = new DecimalFormat("00");
					File tmpFile = null;
					for(int i=0; i<10; i++) {
						fileLOC = "OR" + strRMD + "_666F5185" + df.format(i+1) + "_TX.TXT";
						tmpFile = new File(fileROOT + fileLOC);
						if(!tmpFile.exists()) 
							break;
					}
				}
			// EB0537 �U���Ȧ�
			// RE0189:�ק�Ͱ����ɪ��ɦW������R�W
			} else if(BATNO.substring(0, 1).equals("D") && BATNO.substring(8, 11).equals("809") && remitKind.equals("t")) {
				fileLOC = "WT_" + selCURR + ".txt";
			} else if(BATNO.substring(0, 1).equals("D") && BATNO.substring(8, 11).equals("004")){
				//RD0440�O�W�Ȧ�
				if(remitKind.equals("t")){
					fileLOC = "BS2360015T" + "-" + selCURR + ".TXT";
				}else if(remitKind.equals("r")){
					fileLOC = "BS2360015R" + "-" + selCURR + ".TXT";
				}				
			}else {
				fileLOC = strLogonUser + "_" + BATNO + remitKind + "_" + selCURR + ".txt";
			} 

			//�g�ɮ�
			is = new ByteArrayInputStream(export.getBytes());
			os = new FileOutputStream(fileROOT + fileLOC);
			int reader = 0;
			byte[] buffer = new byte[1 * 1024];
			while ((reader = is.read(buffer)) > 0) {
				os.write(buffer, 0, reader);
			}

		} catch (Exception e) {
			System.err.println(e.toString());
		} finally {
			try {
				is.close();
				os.flush();
				os.close();
			} catch(Exception e) {
			}
		}

		return (returnROOT + fileLOC);
	}

	/**
	 * @param writeTOfileXLS - R70088
	 * @param returnType, �ץX�gEXCEL��
	 * @return
	 */
	public String writeTOfileXLS(String[][] downloadData, String BATNO, String selCURR, String remitKind, String strLogonUser) {
		return writeTOfileXLS(downloadData, BATNO, selCURR, remitKind, strLogonUser, false);
	}

	public String writeTOfileXLS(String[][] downloadData, String BATNO, String selCURR, String remitKind, String strLogonUser, boolean allCellString) {
		String fileLOC = "";
		String returnROOT = "";
		try {
			//�إߥؿ�
			//R00231 edit by Leo Huang
			//String fileROOT = "D:\\WAS5App\\CashWeb_war.ear\\CashWeb.war\\DISB\\DISBDownData\\";
			String fileROOT = globalEnviron.getAppPath() + "DISB\\DISBDownData\\";
			System.out.println("fileROOT : " + fileROOT); //leo
			// for testing
			//String fileROOT = "D:/fprj/CashWeb/WebContent/DISB/DISBDownData/";
			//TEST String fileROOT = "D:\\DISBDownData\\";
			returnROOT = "/DISB/DISBDownData/";
			File dir = new File(fileROOT);
			if (!dir.isDirectory()) {
				dir.mkdir();
			}

			fileLOC = strLogonUser + "_" + BATNO + remitKind + "_" + selCURR + ".xls";
			PrintWriter pw = new PrintWriter(new FileWriter(fileROOT + fileLOC));
			String xlsHeading =
				"<HTML xmlns:o=\"urn:schemas-microsoft-com:office:office\""
					+ " xmlns:x=\"urn:schemas-microsoft-com:office:excel\">"
					+ "<HEAD><META HTTP-EQUIV=\"Content-Type\" CONTENT=\"application/vsd.ms-excel; CHARSET=Big5\"></HEAD>"
					+ "<BODY>"
					+ "<TABLE border=1 Style=\"background-color:white;font-size:10.0pt;font-family:�ө���\" >";
			pw.write(xlsHeading);

			for (int index = 0; index < downloadData.length; index++) {
				StringBuffer sbTmp = new StringBuffer("<TR>");
				String tmpS = null;
				for (int pos = 0; pos < downloadData[index].length; pos++) {
					tmpS = downloadData[index][pos];
					if (pos == 3 && !allCellString)
						tmpS = "<TD x:num=\"" + tmpS + "\">" + tmpS + "</TD>";
					else
						tmpS = "<TD x:str=\"" + tmpS + "\">" + tmpS + "</TD>";
					sbTmp.append(tmpS);
				}
				sbTmp.append("</TR>" + System.getProperty("line.separator"));
				pw.write(sbTmp.toString());
			}

			String xlsFooter = "</TABLE></BODY></HTML>";
			pw.write(xlsFooter);
			pw.flush();

			pw.flush();
			pw.close();
		} catch (Exception e) {
			System.err.println(e.toString());
		}
		return (returnROOT + fileLOC);
	}

	/**
	 * R70292 ��U�@�Ӥu�@��
	 * @param �I�ڤ�
	 * @return �U�@�Ӥu�@��
	 */
	public int GetNextWorkDay(String strPdate) {
		int nextWorkDate = 0;
		int iPdate = Integer.parseInt(strPdate);

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "GetNextWordDay(strCheckNoStart,strCheckNoEnd)", "The dbFactory is null, can't get Data.");
		} else {
			try {
				WorkingDay objWorkDate = new WorkingDay(dbFactory);
				nextWorkDate = objWorkDate.nextDay(iPdate+19110000, 1)-19110000;
			} catch (SQLException e) {
				System.err.println(e);
			}
		}
		
		return nextWorkDate;
		/* Mark By Sally QA0001 �ץ��J��1231���D�u�@��ɷ|�^��1200
		String strSql = "";
		String[] sDAY = new String[31];
		int nextDAY = 0;
		int nextMON = 0;
		int nextYEAR = 0;
		int nextWorkDate = 0;
		int nextWorkD = 0;
		int wkY = 0;
		int wkM = 0;
		int wkD = 0;
		int iPdate = Integer.parseInt(strPdate);

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "GetNextWordDay(strCheckNoStart,strCheckNoEnd)", "The dbFactory is null, can't get Data.");
		} else {
			//�I�ڤ�
			wkY = iPdate / 10000;
			wkM = (iPdate - wkY * 10000) / 100;
			wkD = iPdate - wkY * 10000 - wkM * 100;
			//�U�@�Ӥu�@��
			if (wkM == 12 && wkD == 31) {
				nextYEAR = wkY + 1;
				nextMON = 1;
				nextDAY = 1;
			} else if (((wkM == 1 || wkM == 3 || wkM == 5 || wkM == 7 || wkM == 8 || wkM == 10) && wkD == 31)
						|| ((wkM == 4 || wkM == 6 || wkM == 9 || wkM == 11) && wkD == 30)
						|| (wkM == 2 && (((wkY + 1911) % 4 == 0 && wkD == 29) || ((wkY + 1911) % 4 != 0 && wkD == 28)))) {
				nextYEAR = wkY;
				nextMON = wkM + 1;
				nextDAY = 1;
			}
			//Q80122 if (((wkY+1911) % 4 ==0 && wkD==29) || ((wkY+1911) % 4 !=0 && wkD==28))
			//Q80122	nextMON = wkM + 1;
			//Q80122	nextDAY = 1;
			else {
				nextYEAR = wkY;
				nextMON = wkM;
				nextDAY = wkD + 1;
			}
			strSql = "select  * ";
			strSql += " from NB00010F ";
			strSql += " where CEWRKYR =" + (nextYEAR + 111) + "  and CEWRKMT=" + nextMON;

			Connection conDb = null;
			try {
				conDb = dbFactory.getAS400Connection("GetNextWorkDay("+strPdate+")");
				if (conDb != null) {
					Statement stmtStatement = conDb.createStatement();
					ResultSet rs = stmtStatement.executeQuery(strSql);
					if (rs.next()) {
						for (int i = 0; i < 31; i++) {
							sDAY[i] = rs.getString(i + 3);
						}
					}
					for (int i = (nextDAY - 1); i < 31; i++) {
						if (sDAY[i].equals("Y")) {
							nextWorkD = i + 1;
							i = 31;
						}
					}
					nextWorkDate = nextYEAR * 10000 + nextMON * 100 + nextWorkD;
					rs.close();
					stmtStatement.close();
				}
			} catch (Exception ex) {
				setLastError("DISBBean.GetNextWorkDay",ex);
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			} finally {
				if (conDb != null)
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		//System.out.println("nextWorkDate"+nextWorkDate);
		return nextWorkDate;
		*/
	}

	/**
	 * @param strdate :����~YYYMMDD
	 * @return : ����~YYYMMDD
	 */
	public int GetPreWorkDay(String strdate) {
		int preWorkDate = 0;
		int iPdate = Integer.parseInt(strdate);

		if (dbFactory == null || globalEnviron == null) {
			setLastError(this.getClass().getName() + "GetPreWorkDay(strdate)", "The dbFactory is null, can't get Data.");
		} else {
			try {
				WorkingDay objWorkDate = new WorkingDay(dbFactory);
				preWorkDate = objWorkDate.nextDay(iPdate+19110000, -1)-19110000;
			} catch (SQLException e) {
				System.err.println(e);
			}
		}
		
		return preWorkDate;
	}

	/**R70455 
	* ���Ѻ�T���p?��|�ˤ��J�B�z�C
	* @param v �ݭn�|�ˤ��J���Ʀr
	* @param scale �p���I��O�d�X��
	* @return �|�ˤ��J�᪺?�G
	*/
	public double DoubleRound(double v, int scale) {
		if (scale < 0) {
			throw new IllegalArgumentException("The scale must be a positive integer or zero");
		}
		BigDecimal b = new BigDecimal(Double.toString(v));
		BigDecimal one = new BigDecimal("1");
		return b.divide(one, scale, BigDecimal.ROUND_HALF_UP).doubleValue();
	}

	/**R70455
	* ���Ѻ�T���[�k�B��C
	* @param v1 �Q�[��
	* @param v2 �[��
	* @return �G��?�ƪ��M
	*/
	public double DoubleAdd(double v1, double v2) {
		BigDecimal b1 = new BigDecimal(Double.toString(v1));
		BigDecimal b2 = new BigDecimal(Double.toString(v2));
		return b1.add(b2).doubleValue();
	}

	/**R70455
	* ���ѡ]�۹�^��T�����k�B��C��o�Ͱ����ɪ���?�ɡA��scale?�ƫ�
	* �w��סA�H�᪺�Ʀr�|�ˤ��J�C
	* @param v1 �Q����
	* @param v2 ����
	* @param scale ��ܪ�ܻݭn��T��p���I�H��X��C
	* @return �G��?�ƪ���
	*/
	public double DoubleDiv(double v1, double v2, int scale) {
		if (scale < 0) {
			throw new IllegalArgumentException("The scale must be a positive integer or zero");
		}
		BigDecimal b1 = new BigDecimal(Double.toString(v1));
		BigDecimal b2 = new BigDecimal(Double.toString(v2));
		return b1.divide(b2, scale, BigDecimal.ROUND_HALF_UP).doubleValue();
	}

	/**R70455
	* ���Ѻ�T��?�k�B��C
	* @param v1 �Q���
	* @param v2 ?��
	* @return �G��?�ƪ��t
	*/
	public double DoubleSub(double v1, double v2) {
		BigDecimal b1 = new BigDecimal(Double.toString(v1));
		BigDecimal b2 = new BigDecimal(Double.toString(v2));
		return b1.subtract(b2).doubleValue();
	}

	/**R70455
	* ���Ѻ�T�����k�B��C
	* @param v1 �Q����
	* @param v2 ����
	* @return �G��?�ƪ��M
	*/
	public double DoubleMul(double v1, double v2) {
		BigDecimal b1 = new BigDecimal(Double.toString(v1));
		BigDecimal b2 = new BigDecimal(Double.toString(v2));
		return b1.multiply(b2).doubleValue();
	}

	/**Q80223
	* �h�������\�Ÿ��H�����N���C
	* @param ��l�r��
	* @return �h����r��
	*/
	public String replacePunct(String strMemo) {
		char[] cPunct = { ',', '\'', '"' };
		for (int i = 0; i < cPunct.length; i++) {
			strMemo = strMemo.replace(cPunct[i], ';');
		}
		return strMemo;
	}

	/**
	 * �ǲΫ��~���O�� - �~���״ڤ���O��I�覡 ( R00386-P00026)
	 * 
	 * @param payCode ��I��]
	 * @param rBankCode �פJ�Ȧ�N�X
	 * @param pCurr �O����O
	 */
	/*public String getPayFeeType(String payCode, String rBankCode, String curr) throws SQLException {

		String feeType = getPayFeeType(payCode).trim();
		// �Y���O�ݭn�O��]�I�O�������^�ǡA�@�Y�ݭn�O��I�t���~��P�_�A�b�״ڻȦ�U�i�אּ���q��I
		if (!feeType.equals("BEN") && !feeType.equals("SHA"))
			return feeType;

		String sql = "SELECT FLD0004 FROM ORDUET WHERE FLD0002 = 'BNKFR' AND FLD0003 = ?";
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet result = null;

		try {
			conn = dbFactory.getConnection("DBSBBean.getPayFeeType()");
			stat = conn.prepareStatement(sql);
			stat.setString(1, curr + rBankCode);
			result = stat.executeQuery();
			if (result.next())
				return "OUR"; // �p�G�����A�N��O���q���w�Ȧ�A�אּ���q��I
			else
				return feeType; // �p�G�S���A�N���O���q���w�Ȧ�A�����즳����O�覡

		} finally {
			try { if (result != null) result.close(); } catch (Exception e) {}
			try { if (stat != null) stat.close(); } catch (Exception e) {}
			try { if (conn != null) dbFactory.releaseConnection(conn); } catch (Exception e) {}
		}
	}

	public String getPayFeeType(String payCode) throws SQLException {

		String payDesc = getPayCodeDesc(payCode);
		if (payDesc.length() > 8)
			return payDesc.substring(0, 8);

		return "";
	}

	public String[] getPayCodeDescArray(String payCode) throws SQLException {

		String payDesc = getPayCodeDesc(payCode);
		String[] res = new String[3];

		// 1
		if (payDesc.length() < 8)
			res[0] = payDesc;
		else
			res[0] = payDesc.substring(0, 8);

		// 2
		if (payDesc.length() > 8) {
			if (payDesc.length() < 16)
				res[1] = payDesc.substring(8);
			else
				res[1] = payDesc.substring(8, 16);
		} else
			res[1] = "";

		// 3
		if (payDesc.length() >= 16) {
			res[2] = payDesc.substring(16);
		} else
			res[2] = "";

		return res;
	}

	// R00386-P00026 �� ETAB - PAYCD ����I�y�z
	public String getPayCodeDesc(String payCode) throws SQLException {

		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet result = null;

		try {
			String sql = "SELECT FLD0004 FROM ORDUET WHERE FDL0002 = 'PAYCD' AND FLD0003 = ?";
			conn = dbFactory.getConnection("DBSBBean.getPayCodeDesc()");
			stat = conn.prepareStatement(sql);
			stat.setString(1, payCode);
			result = stat.executeQuery();
			if (result.next())
				return result.getString("FLD0004");

			return ""; // �䤣��^�Ŧr��

		} finally {
			try { if (result != null) result.close(); } catch (Exception e) {}
			try { if (stat != null) stat.close(); } catch (Exception e) {}
			try { if (conn != null) dbFactory.releaseConnection(conn); } catch (Exception e) {}
		}
	}*/

	/**
	 * �ǲΫ��~���O�� - �~���״ڤ���O ( R00386-P00026)
	 * @return
	 */
	public double[] getPayFees(String bankCode) throws SQLException {

		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet result = null;
		String sql = "SELECT FLD0004 FROM ORDUET WHERE FLD0002 = 'BNKFE' AND FLD0003 = ?";
		try {
			conn = dbFactory.getConnection("DISBBean.getPayFees()");
			log.info(sql);
			stat = conn.prepareStatement(sql);
			stat.setString(1, bankCode);
			result = stat.executeQuery();
			if (!result.next())
				throw new RemittanceFeeNotFoundException("�L�kŪ���~���״ڤ���O [" + bankCode + "]");

			String feeStr = result.getString("FLD0004");
			try {
				double[] res = new double[3];
				res[0] = Integer.parseInt(feeStr.substring(0, 5));
				res[1] = Integer.parseInt(feeStr.substring(6, 11));
				res[2] = Integer.parseInt(feeStr.substring(12, 17));
				return res;
			} catch (RuntimeException e) { // NULL, ���פ���, �榡���ŵ���
				throw new RuntimeException("[" + bankCode + "] ���~���״ڤ���O�榡�����T");
			}
		} finally {
			try { if (result != null) result.close(); } catch (Exception e) {}
			try { if (stat != null) stat.close(); } catch (Exception e) {}
			try { if (conn != null) dbFactory.releaseConnection(conn); } catch (Exception e) {}
		}
	}

	/**
	 * ���o�~���״ڤ���O. �Ѽ������C��Ȧ�N�X�P�״ڱb��
	 * 
	 * @param payBankCode �I�ڦ�N�X
	 * @param remitBankCode �״ڦ�N�X
	 * @param DBU:�P�@�Ȧ檺�Ҥ�(�x�W)����
	 * @param OBU:�P�@�Ȧ檺�ҥ~(�~��)����
	 * @return
	 * @throws SQLException
	 */
	public double getPayFee(String payBankCode, String remitBankCode, String remitAccount) throws SQLException {

		String payBank = payBankCode.substring(0, 3);
		String remitBank = remitBankCode.substring(0, 3);
		String obuCheckCode = "";
		double[] n = getPayFees(payBank);

		// ���P�Ȧ���ĤT�Ӧ^�ǭ�
		if (!payBank.equals(remitBank))
			return n[2];//������O				

		String strSql = "SELECT * FROM ORDUET WHERE FLD0001='  ' AND FLD0002='BNKFF' AND FLD0003 LIKE '" + remitBank + "%' ";
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rst = null;
		double dReturnValue = 0;
		int iPosStart = 0;
		int iPosEnd = 0;
		String strOBUCode = "";
		try {
			con = dbFactory.getAS400Connection("DISBBean.getPayFee");
			pstmt = con.prepareStatement(strSql);
			rst = pstmt.executeQuery();
			dReturnValue = n[0];//�p��DBU�ۦs
			while(rst.next()) {
				iPosStart = Integer.parseInt(rst.getString("FLD0003").substring(4, 5));
				iPosEnd = Integer.parseInt(rst.getString("FLD0003").substring(5, 6));
				strOBUCode = CommonUtil.AllTrim(rst.getString("FLD0003").substring(7));

				obuCheckCode = CommonUtil.AllTrim(remitAccount.substring(iPosStart-1, iPosEnd));
				System.out.println("remitBank=" + remitBank + " OBUCode=" + strOBUCode + " obuCheckCode=" + obuCheckCode);

				if(obuCheckCode.equals(strOBUCode)) {
					dReturnValue = n[1];//�p��DBU/OBU���s
					break;
				}
			}

			return dReturnValue;
		} catch(Exception ex) {
			System.err.println(ex.getMessage());
			return n[0];
		} finally {
			if(rst != null) rst.close();
			if(pstmt != null) pstmt.close();
			if(con != null) dbFactory.releaseAS400Connection(con);
		}
	}
	
	/**
	 * RD0440-�s�W�~�����w�Ȧ�-�x�W�Ȧ�
	 * 
	 * ���o�~���״ڤ���O. �Ѽ������C��Ȧ�N�X�P�״ڱb��
	 * 
	 * @param payBankCode �I�ڦ�N�X
	 * @param remitBankCode �״ڦ�N�X
	 * @param DBU:�P�@�Ȧ檺�Ҥ�(�x�W)����
	 * @param OBU:�P�@�Ȧ檺�ҥ~(�~��)����
	 */
	public double getPayFee004(String payBankCode, String remitBankCode, String remitAccount, double wsAMT, String PCSHCM, String wsPPAYCURR, double wsRPAYRATE) throws SQLException {
		log.info("getPayFee004(" + payBankCode + "," + remitBankCode + "," + remitAccount + "," + wsAMT + "," + PCSHCM + "," + wsPPAYCURR + "," + wsRPAYRATE + ")");
		String payBank = payBankCode.substring(0, 3);
		String remitBank = remitBankCode.substring(0, 3);
		String obuCheckCode = "";
		double[] n = getPayFees(payBank);
		
		//���o�x�W�Ȧ檺�����ײv,���y�H�صLOBU�ҥ~�Ȧ�b��,�G���|�o��OBU��DBU����������O
		int PCSHDT2 = Integer.parseInt(PCSHCM);
		String DateTemp1 = "";
		DateTemp1 = Integer.toString(1110000 + PCSHDT2 - 1);
		//���o�x�Ȫ������ײv
		double ERRate004 = 1;
		if(wsRPAYRATE==1){
			ERRate004 = getERRate004(wsPPAYCURR.trim(), DateTemp1);
		}		
		log.info("ERRate004:" + ERRate004);

		// ���P�Ȧ���ĤT�Ӧ^�ǭ�
		//log.info("payBank�O" + payBank + ",remitBank�O" + remitBank);
		if (!payBank.equals(remitBank)){
			double interBankFee = 0; //������O
			try{
				//n[2]���l�q�O
				//1:�p�������O
				interBankFee = interBankFee004(n[2], wsAMT, ERRate004);
			} catch(Exception e){
				System.out.println("interBankFee004 fail!");
			}
			//log.info("return interBankFee�O" + interBankFee);
			return interBankFee;
		}

		String strSql = "SELECT * FROM ORDUET WHERE FLD0001='  ' AND FLD0002='BNKFF' AND FLD0003 LIKE '" + remitBank + "%' ";
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rst = null;
		double dReturnValue = 0;
		int iPosStart = 0;
		int iPosEnd = 0;
		String strOBUCode = "";
		try {
			con = dbFactory.getAS400Connection("DISBBean.getPayFee");
			pstmt = con.prepareStatement(strSql);
			rst = pstmt.executeQuery();
			//log.info("dReturnValue�O" + dReturnValue);
			dReturnValue = n[0];//2:�p��DBU�ۦs
			while(rst.next()) {
				iPosStart = Integer.parseInt(rst.getString("FLD0003").substring(4, 5));
				iPosEnd = Integer.parseInt(rst.getString("FLD0003").substring(5, 6));
				//�x�W�Ȧ�OBU�b���P�_�X,�b���e�T�X��069(�]�w�bORDUET��FLD0002=BNKFEE & FLD0003���P�_�X)
				strOBUCode = CommonUtil.AllTrim(rst.getString("FLD0003").substring(7));

				//�O�᪺�״ڻȦ檺�P�_OBU�b��
				obuCheckCode = CommonUtil.AllTrim(remitAccount.substring(iPosStart-1, iPosEnd));				
				System.out.println("remitBank=" + remitBank + " OBUCode=" + strOBUCode + " obuCheckCode=" + obuCheckCode);
								
				//3:�p��DBU��OBU���s,�x�W�Ȧ榹����O�P��檺�p��W�h
				//log.info("obuCheckCode�O" + obuCheckCode + ",strOBUCode" + strOBUCode);
				if(obuCheckCode.equals(strOBUCode)) {
					try{
						//log.info("3:dReturnValue�O" + dReturnValue + ",interBankFee004(" + n[2] + "," + wsAMT + "," + ERRate004 + ")");
						dReturnValue = interBankFee004(n[2], wsAMT, ERRate004);
					} catch(Exception e){
						System.out.println("interBankFee004 fail!");
					}					
					break;
				}
			}
			//log.info("dReturnValue�O" + dReturnValue);
			return dReturnValue;
		} catch(Exception ex) {
			System.err.println(ex.getMessage());
			//log.info("return n[0]�O" + n[0]);
			return n[0];
		} finally {
			if(rst != null) rst.close();
			if(pstmt != null) pstmt.close();
			if(con != null) dbFactory.releaseAS400Connection(con);
		}
	}

	public double interBankFee004(double postalFee, double wsAMT, double ERRate004){
		double perRemitFee = 0; //�C����������O,�x���p��
		
		perRemitFee = wsAMT * 0.0005 * ERRate004;
		perRemitFee = Math.round(perRemitFee);
		log.info("perRemitFee:" + perRemitFee + ",wsAMT:" + wsAMT + ",ERRate004" + ERRate004);
		if(perRemitFee<100) perRemitFee = 100;
		if(perRemitFee>800) perRemitFee = 800;
		
		return perRemitFee + postalFee;
	}
	
	/**
	 * RD0382:OIU
	 * 
	 * ���o�~���״ڤ���O. �Ѽ������C��Ȧ�N�X�P�״ڱb��
	 * 
	 * @param payBankCode �I�ڦ�N�X
	 * @param remitBankCode �״ڦ�N�X
	 * @param DBU:�P�@�Ȧ檺�Ҥ�(�x�W)����
	 * @param OBU:�P�@�Ȧ檺�ҥ~(�~��)����
	 */
	public double getPayFeeOIU(String payBankCode, String remitBankCode, String remitAccount, double wsAMT, String swiftCode) throws SQLException {
		String payBank = payBankCode.substring(0, 3);
		String remitBank = remitBankCode.substring(0, 3);
		String obuCheckCode = "";
		double[] n = getPayFees(payBank + "6");

		// ���P�Ȧ���ĤT�Ӧ^�ǭ�
		if (!payBank.equals(remitBank))
			return n[2];//������O,BNKFE����3�ռƦr,����9���B�x�s10���B�Ͱ�7��	
		
		//�P�Ȧ�ۦs�BSWIFT CODE��5�B6�X����TW��,���H������O�p��
		if(swiftCode.length()>=8){
			if(!"TW".equals(swiftCode.substring(4, 6))){
				return n[2];//������O,BNKFE����3�ռƦr,����9���B�x�s10���B�Ͱ�7��	
			}
		}

		//�P�Ȧ�ۦs
		String strSql = "SELECT * FROM ORDUET WHERE FLD0001='  ' AND FLD0002='BNKFF' AND FLD0003 LIKE '" + remitBank + "%' ";//�d�ߦU�Ȧ檺OBU�b���ˮֱ���
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rst = null;
		double dReturnValue = 0;
		int iPosStart = 0;
		int iPosEnd = 0;
		String strOBUCode = "";
		try {
			con = dbFactory.getAS400Connection("DISBBean.getPayFee");
			log.info(strSql);
			pstmt = con.prepareStatement(strSql);
			rst = pstmt.executeQuery();
			dReturnValue = n[0];//�p��DBU�ۦs
			
			//�P�_�O�_��OBU�b��
			while(rst.next()) {
				iPosStart = Integer.parseInt(rst.getString("FLD0003").substring(4, 5));//OBU�b���ˮֽX���_�l��m
				iPosEnd = Integer.parseInt(rst.getString("FLD0003").substring(5, 6));//OBU�b���ˮֽX��������m
				strOBUCode = CommonUtil.AllTrim(rst.getString("FLD0003").substring(7));//OBU�b���ˮֽX

				obuCheckCode = CommonUtil.AllTrim(remitAccount.substring(iPosStart-1, iPosEnd));
				System.out.println("remitBank=" + remitBank + " OBUCode=" + strOBUCode + " obuCheckCode=" + obuCheckCode);

				if(obuCheckCode.equals(strOBUCode)) {
					dReturnValue = n[1];//�p��DBU/OBU���s
					break;
				}
			}
			
			//RE0189:�P�_�Ͱ�OBU�b��,
			//20161004,�X��Sophia�P�Ͱ�T�{�L���^��b��,��Cash�t�έn�O�d���P�_
			if("809".equals(remitBank) && remitAccount.substring(0, 4).matches("[a-zA-Z]{4}")) dReturnValue = n[1];
			
			return dReturnValue;
		} catch(Exception ex) {
			System.err.println(ex.getMessage());
			return n[0];
		} finally {
			if(rst != null) rst.close();
			if(pstmt != null) pstmt.close();
			if(con != null) dbFactory.releaseAS400Connection(con);
		}
	}
	
	/**
	 * Ū��CAPSIL�Ǹ��{�� (CALL NBMCASHB)
	 * 
	 * @param String �G �Ǹ����O(�Ҧp�GDISB�FGNFB)
	 * @return int �G�Ǹ�
	 */
	public synchronized int getSequenceNumber(String sequenceType, Connection conn) throws Exception {
		int iReturn = 0;
		long tmpBegin = System.currentTimeMillis();

		CallableStatement cstmt = null;
		try {
			cstmt = conn.prepareCall("CALL NBMRDSNB(?)");

			for(int i=CommonUtil.AllTrim(sequenceType).length(); i<10; i++) {
				sequenceType += " ";
			}
			DecimalFormat df = new DecimalFormat("00000000000");
			String param1 = sequenceType;	//CHAR(10)
			String param2 = df.format(0);	//CHAR(11)
			String param3 = "N";			//CHAR(1)
			cstmt.setString(1, param1+param2+param3);
			cstmt.registerOutParameter(1,java.sql.Types.CHAR);
			cstmt.execute();
			iReturn = Integer.parseInt(cstmt.getString(1).substring(10, 21));

			if(iReturn == 0)
				throw new Exception("Ū���Ǹ��ɦ����D!!");

		} catch (Exception e) {
			globalEnviron.writeDebugLog(Constant.DEBUG_ERROR, "DISBBean.getSequenceNumber", "SerialType="+sequenceType+", exception="+e.getMessage());
			e.printStackTrace();
			throw e;
		} finally {
			if(cstmt != null) cstmt.close();
		}

		long tmpDuration = (System.currentTimeMillis() - tmpBegin);
		globalEnviron.writeDebugLog(Constant.DEBUG_INFORMATION, "DISBBean.getSequenceNumber", "Duration="+tmpDuration+" mseconds");
		return iReturn;
	}

	/**
	 * R10190 ���ĵ��I�q���Ѥu�@��(ORCHLPPY)���@
	 * @param conn java.sql.Connection
	 * @param payno ��I�Ǹ�
	 * @param fincfmdt �]�ȷ|�p�T�{��
	 */
	public void callCAP0314O(Connection conn, LapsePaymentVO voObj) {

		long tmpBegin = System.currentTimeMillis();

		DecimalFormat df = new DecimalFormat("00000000000.00");
		DecimalFormat df1 = new DecimalFormat("00000000");
		String strParm01 = CommonUtil.AllTrim(voObj.getPNO());
		String strParm02 = CommonUtil.AllTrim(voObj.getPolicyNo());
		String strParm03 = CommonUtil.AllTrim(voObj.getReceiverId());
		String strParm04 = CommonUtil.AllTrim(voObj.getReceiverName());
		String strParm05 = CommonUtil.AllTrim(df.format(voObj.getPaymentAmt()));
		String strParm06 = CommonUtil.AllTrim(df1.format(voObj.getRemitDate()));
		String strParm07 = CommonUtil.AllTrim(voObj.getSendSwitch());
		String strParm08 = CommonUtil.AllTrim(voObj.getRemitFailed());
		String strParm09 = CommonUtil.AllTrim(df1.format(voObj.getSendDate()));
		String strParm10 = CommonUtil.AllTrim(voObj.getUpdatedUser());
		String strParm11 = CommonUtil.AllTrim(df1.format(voObj.getUpdatedDate()));

		for(int i=strParm01.length(); i<20; i++) {
			strParm01 += " ";
		}
		for(int i=strParm02.length(); i<10; i++) {
			strParm02 += " ";
		}
		for(int i=strParm03.length(); i<10; i++) {
			strParm03 += " ";
		}
		for(int i=strParm04.getBytes().length; i<60; i++) {
			strParm04 += " ";
		}
		for(int i=strParm10.length(); i<10; i++) {
			strParm10 += " ";
		}
		strParm05 = strParm05.substring(0,11) + strParm05.substring(12);


		CallableStatement cstmt = null;
		try {
			cstmt = conn.prepareCall("CALL CAP0314OSP (?,?,?,?,?,?,?,?,?,?,?)");
			cstmt.setString(1, strParm01);
			cstmt.setString(2, strParm02);
			cstmt.setString(3, strParm03);
			cstmt.setString(4, strParm04);
			cstmt.setString(5, strParm05);
			cstmt.setString(6, strParm06);
			cstmt.setString(7, strParm07);
			cstmt.setString(8, strParm08);
			cstmt.setString(9, strParm09);
			cstmt.setString(10, strParm10);
			cstmt.setString(11, strParm11);
			cstmt.execute();
		} catch(Exception e) {
            System.err.println(e.getLocalizedMessage());
            e.printStackTrace();
            System.err.println("*** Call to CAP0314O failed. ***");
        } finally {
        	try {if(cstmt != null) cstmt.close(); } catch(Exception e) {}
        }

		/*

	<program name="programCAP0314O" path="/QSYS.LIB/%libl%.lib/CAP0314O.PGM" timeout="20000">
		<data name="PayNo" type="char" length="20" usage="input" />
		<data name="PolicyNo" type="char" length="10" usage="input" />
		<data name="ReceiverId" type="char" length="10" usage="input" />
		<data name="ReceiverName" type="char" length="60" usage="input" />
		<data name="PaymentAmt" type="char" length="13" usage="input" />
		<data name="RemitDate" type="char" length="8" usage="input" />
		<data name="SendSwitch" type="char" length="1" usage="input" />
		<data name="RemitFailed" type="char" length="1" usage="input" />
		<data name="SendDate" type="char" length="8" usage="input" />
		<data name="UpdatedUser" type="char" length="10" usage="input" />
		<data name="UpdatedDate" type="char" length="8" usage="input" />
	</program>

		AS400 as400 = null;
		ProgramCallDocument pcml = null;
		boolean rc = false;
		try {
			if( globalEnviron.getActiveAS400DataSource().equals(globalEnviron.getAS400DataSourceNameAEGON400()) )
				as400 = new AS400(globalEnviron.getAS400SystemNameAEGON400(),globalEnviron.getAS400SystemUserNameAEGON400(),globalEnviron.getAS400SystemPasswordAEGON400());
			else
				as400 = new AS400(globalEnviron.getAS400SystemNameAEGON401(),globalEnviron.getAS400SystemUserNameAEGON401(),globalEnviron.getAS400SystemPasswordAEGON401());

			
			pcml = new ProgramCallDocument(as400, "CASH");
			pcml.setValue("programCAP0314O.PayNo",       strParm01);
			pcml.setValue("programCAP0314O.PolicyNo",    strParm02);
			pcml.setValue("programCAP0314O.ReceiverId",  strParm03);
			pcml.setValue("programCAP0314O.ReceiverName", strParm04);
			pcml.setValue("programCAP0314O.PaymentAmt",  strParm05);
			pcml.setValue("programCAP0314O.RemitDate",   strParm06);
			pcml.setValue("programCAP0314O.SendSwitch",  strParm07);
			pcml.setValue("programCAP0314O.RemitFailed", strParm08);
			pcml.setValue("programCAP0314O.SendDate",    strParm09);
			pcml.setValue("programCAP0314O.UpdatedUser", strParm10);
			pcml.setValue("programCAP0314O.UpdatedDate", strParm11);

			rc = pcml.callProgram("programCAP0314O");

			if(!rc) {
				AS400Message[] msgs = pcml.getMessageList("programCAP0314O");
				for (int m = 0; m < msgs.length; m++)
					System.err.println("CALL CAP0314O Fail. " + msgs[m].getID() + " - " + msgs[m].getText());
				System.err.println("** Call to CAP0314O failed. See messages above **");
			} else {
				System.err.println("** Call to CAP0314O Successfunl. **");
			}
		} catch(Exception e) {
            System.err.println(e.getLocalizedMessage());
            e.printStackTrace();
            System.err.println("*** Call to CAP0314O failed. ***");
        } finally {
        	if(as400 != null) as400.disconnectAllServices();
        }
		 */

		long tmpDuration = (System.currentTimeMillis() - tmpBegin);
		globalEnviron.writeDebugLog(Constant.DEBUG_INFORMATION, "DISBBean.callCAP0314O", "Duration="+tmpDuration+" mseconds");
	}

	/**
	 * RA0064  ��s ORGNPCNF(�T�w���I�Ȧs��)
	 * @param conn java.sql.Connection
	 * @param payno ��I�Ǹ�
	 * @param fincfmdt �]�ȷ|�p�T�{��
	 */
	public void callCAPDISB09(Connection conn, String payno, String fincfmdt) {
		AS400 as400 = null;
		ProgramCallDocument pcml = null;
		boolean rc = false;
		try {
			if( globalEnviron.getActiveAS400DataSource().equals(globalEnviron.getAS400DataSourceNameAEGON400()) )
				as400 = new AS400(globalEnviron.getAS400SystemNameAEGON400(),globalEnviron.getAS400SystemUserNameAEGON400(),globalEnviron.getAS400SystemPasswordAEGON400());
			else
				as400 = new AS400(globalEnviron.getAS400SystemNameAEGON401(),globalEnviron.getAS400SystemUserNameAEGON401(),globalEnviron.getAS400SystemPasswordAEGON401());

			CommonUtil commonUtil = new CommonUtil();
			fincfmdt = "0" + commonUtil.convertROCDate(fincfmdt);	//����~YYYY/MM/DD

			pcml = new ProgramCallDocument(as400, "CASH");
			pcml.setValue("programCAPDISB09.PAYNO", payno);
			pcml.setValue("programCAPDISB09.FINCFMDATE", fincfmdt);
			rc = pcml.callProgram("programCAPDISB09");

			if(!rc) {
				AS400Message[] msgs = pcml.getMessageList("programCAPDISB09");
				for (int m = 0; m < msgs.length; m++)
					System.err.println("CALL CAPDISB09 Fail. " + msgs[m].getID() + " - " + msgs[m].getText());
				System.err.println("** Call to CAPDISB09 failed. See messages above **");
			}
		} catch(PcmlException e) {
            System.err.println(e.getLocalizedMessage());
            e.printStackTrace();
            System.err.println("*** Call to CAPDISB09 failed. ***");
        } finally {
        	if(as400 != null) as400.disconnectAllServices();
        }
	}

	/**
	 * @param strCurr : ��X���O
	 * @return ���o�|�p������Ledger
	 */
	public String getLedger(String strCurr) {
		return CommonUtil.AllTrim(getETableDesc("ORAL1", strCurr)).substring(8);
	}

}