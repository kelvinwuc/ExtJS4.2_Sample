import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Hashtable;
import java.util.Vector;
import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;

/**
 * @version 	1.0
 * @author
 */
public class CASHFileSaveS extends CASHServlet {

	//�U�ȫ�_
	 
	private DbFactory dbFactory = null;
	public void init() {
	    dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
	}
	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void performTask(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
			HttpSession session = req.getSession();
			//Ū�X�W���ɮ׸��
			Vector v = (Vector) session.getAttribute("UPLOADFILE");
			if (v == null) {
				throw new ServletException("�W���ɮ׸�ƺI�����A�Э��s����");
			}
			
			Connection conn = null;
			try {
				//�ǳ� JDBC �s�u����
				//Class.forName("com.ibm.as400.access.AS400JDBCDriver");
				//-------------------------------------------------------------------
				//�u�W����
				//String url =
				//	"jdbc:as400://10.67.0.32;poolType=JdbcOdbc;logtype=2;naming=system;errors=full;date format=iso;extended dynamic=true;package=JDBCPKG;transaction isolation=none;package library=CAPDCRF;";
				//conn = DriverManager.getConnection(url, "WEBDCR", "DCRWEB");
				//-------------------------------------------------------------------
				//������������
				//String url =
				//"jdbc:as400://10.67.0.32;poolType=JdbcOdbc;logtype=2;naming=system;errors=full;date format=iso;extended dynamic=true;package=JDBCPKG;transaction isolation=none;package library=CAPBASF;";
				//conn = DriverManager.getConnection(url, "MISBROKER", "BROKER");
				//-------------------------------------------------------------------
				
				//�U�ȫ�_
				//conn = dbFactory.getAS400ConnectionNoDS("CASHFileSaveS.performTask()");
				conn = dbFactory.getAS400Connection("CASHFileSaveS.performTask()");
				
				//�ϥΪ̿�ܤ��@�~�Ҧ� 1 : �s�W���, 2 : �л\���
				String typeValue = req.getParameter("WRITETYPE");
				if(typeValue.equals("2")) {
					 delCHKDEP(conn);
				}
			
				//�v��Ū�X�W�Ǹ��
				for (int i = 0; i < v.size(); i++) {
					Hashtable line = (Hashtable) v.elementAt(i);
					String strFLD0001 = (String) line.get("FLD0001"); //���ڦ������
					String strFLD0002 = (String) line.get("FLD0002"); //���ڸ��X
					String strFLD0003 = (String) line.get("FLD0003"); //�s�ڱb��
					String strFLD0004 = (String) line.get("FLD0004"); //���ڪ��B
					String strFLD0005 = (String) line.get("FLD0005"); //���ڦ��������
					String strFLD0006 = (String) line.get("FLD0006"); //���ڨ����
					String strFLD0007 = (String) line.get("FLD0007"); //�Ƶ�
					String strFLD0008 = (String) line.get("FLD0008"); //�P�b�O��
					//�P�b�O���ഫ�� CHKDEP FLD0001 ���N��
					if (strFLD0008.equals("1")) {
						strFLD0008 = "3";
					} else if (strFLD0008.equals("2")) {
						strFLD0008 = "5";
					} else if (strFLD0008.equals("3")) {
						strFLD0008 = "4";
					}
					//���ڪ��B�A�M���r��}�Y�� '0', �è� 2 ��p���I
					int s = 0;
					int e = s + 1;
					String value = "000";
					//�M���r��}�Y�� '0'
					while (value.length() > 2 && strFLD0004.substring(s, e).equals("0")) {
						value = strFLD0004.substring(e);
						s++;
						e++;
					}
					if (value.equals("00")) {
						value = "0.00";
					} else {
						//���G��p���I
						value =
							value.substring(0, value.length() - 2)
								+ "."
								+ value.substring(value.length() - 2);
					}

					//���o BANK-CODE
					String[] tmp = getFLD0006(conn, strFLD0002, strFLD0004, strFLD0006);
					String FLD0006 = "";
					String FLD0007 = "";
					if(tmp != null) {
						FLD0006 = tmp[0];
						FLD0007 = tmp[1];
					}
					if (!FLD0006.equals("")) {
						FLD0006 = FLD0006.substring(2);
					}

					//�ǳ� FLD0004 ����
					String FLD0004 = strFLD0007.substring(strFLD0007.length() - 1);
					if (!FLD0004.equals("1")
						&& !FLD0004.equals("2")
						&& !FLD0004.equals("3")) {
						FLD0004 = "";
					}

						String strCHKDEP =
							"INSERT INTO CHKDEP (FLD0001, FLD0002, FLD0003, FLD0004, FLD0005, FLD0006, FLD0007, FLD0008, FLD0009, FLD0010, FLD0011, FLD0012, FLD0013, FLD0014) VALUES ('"
								+ strFLD0008
								+ "', '"
								+ "09310120866', " //�@�ȱb��, �g��
			+value + ", '" //���B
		+FLD0004
			+ "', '"
			+ new Integer(strFLD0006)
			+ "', '"
			+ FLD0006
			+ "', '"
			+ FLD0007
			+ "', '"
			+ strFLD0002
			+ "', '"
			+ new Integer(strFLD0005)
			+ "', '"
			+ "', '"
			+ "', '"
			+ "0931', '"
			+ "', '"
			+ "')";
		        
					//�u�g�J strFLD0008 = 3 �����ơA��l����(3 �N��I�{���\�����)
					if(strFLD0008.equals("3")) {
						System.out.println("SQL INSERT :\n" + strCHKDEP);
						PreparedStatement stmCHKDEP = null;
						stmCHKDEP = conn.prepareStatement(strCHKDEP);
						stmCHKDEP.execute();
						stmCHKDEP.close();
						System.out.println("insert CHKDEP done...........");
					}
				}
				req.setAttribute("UPLOADFILE", v);
				//�U�ȫ�_
				//dbFactory.releaseAS400ConnectionNoDS(conn);
				dbFactory.releaseAS400Connection(conn);
				//conn.close();
				
				RequestDispatcher rd =
					req.getRequestDispatcher("/FileUpload/CASHFileUploadResult.jsp");
				rd.forward(req, resp);
			} catch (Exception e) {
				e.printStackTrace();
				try {
					if (conn != null) {
						dbFactory.releaseAS400Connection(conn);
						//dbFactory.releaseAS400ConnectionNoDS(conn);
						//conn.close();
					}
				} catch (Exception ee) {

				}
				throw new ServletException(e.getMessage());
			}
	}
	/**
	 * �H�䲼���X�Φs�ڱb���M�� ORNBTB �ɮסA���o BANK-CODE
	 * @param String  strFLD0002 �䲼���X
	 * @param String  strFLD0004 ���ڪ��B
	 * @param String  strFLD0006 ���ڨ����
	 * @return String[]�A�Ȭ� BANK-CODE, ACCOUNTCODE
	 */
	private String[] getFLD0006(
	    Connection conn,
		String strFLD0002,
	    String strFLD0004, 
	    String strFLD0006)
		throws Exception {
		String[] temp = null;
		String FLD0006 = "";
		String FLD0007 = "";
		try {
			PreparedStatement stmORNBTB = null;
			ResultSet resultORNBTB = null;
			String strORNBTB =
				"SELECT BANKCODE, ACCNTCODE FROM ORNBTB WHERE CHEQUECODE='"
					+ strFLD0002
					+ "' AND CHEQUEAMT="
			        + (float)Integer.parseInt(strFLD0004) / 100.0f
			        + " AND CHEQUEDATE="
			        + (Integer.parseInt(strFLD0006) + 1110000);
			System.out.println("Query : " + strORNBTB);
			
			stmORNBTB = conn.prepareStatement(strORNBTB);
			resultORNBTB = stmORNBTB.executeQuery();
			int records = 0;
			while (resultORNBTB.next()) {
				FLD0006 = resultORNBTB.getString("BANKCODE");
				FLD0007 = resultORNBTB.getString("ACCNTCODE");
				records++;
			}
			//System.out.println("records : "+records);
			temp = new String[2];
			temp[0] = FLD0006;
			temp[1] = FLD0007;
			stmORNBTB.close();
			resultORNBTB.close();
		} catch (Exception e) {
			throw e;
		}
		return temp;
	}
	/**
	 * �M�� CHKDEP ������ơA��ϥΪ̿�h�л\��Ƨ@�~�Ҧ�
	 * �ɡA���{�����M�� CHKDEP �������e�A�A�N�W���ɮפ���
	 * ��Ʒs�W�J CHKDEP
	 * @param Connection  conn ��Ʈw�s�u����
	 */
	 private void delCHKDEP(Connection conn) throws Exception {
		try {
			PreparedStatement stmCHKDEP = null;
			String strCHKDEP ="DELETE FROM CHKDEP";
			stmCHKDEP = conn.prepareStatement(strCHKDEP);
			System.out.println("SQL String : " + strCHKDEP);
			stmCHKDEP.execute();
			stmCHKDEP.close();
		} catch (Exception e) {
		    throw e;
	    }
	 }

}
