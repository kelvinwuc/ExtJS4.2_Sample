import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.softwarementors.extjs.djn.config.annotations.DirectAction;
import com.softwarementors.extjs.djn.config.annotations.DirectMethod;


@DirectAction(action="Customer")
public class Customer {

	@DirectMethod
	public ArrayList<Object> TreeList(JsonArray data){
        String connectionUrl = "jdbc:sqlserver://192.168.0.254:1433;" +
        "databaseName=Northwind;;user=sa;password=abcd-1234";
	    Connection con = null;
	    Statement stmt = null;
	    ResultSet rs = null;
	    ResultSet rscount=null;
	    try {
	    	
		       Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		       con = DriverManager.getConnection(connectionUrl);
		       stmt = con.createStatement();
		       rs = stmt.executeQuery("select CustomerID,CompanyName from Customers order by CompanyName");
		        
		       //返回JOSN格式数据
		       ArrayList<Object> array=new ArrayList<Object>();
	    	   Map<String, Object> objAll= new HashMap<String, Object>();
	    	   objAll.put("id", "-1");
	    	   objAll.put("text", "全部");
	    	   objAll.put("leaf", true);
	    	   array.add(objAll);
		       while (rs.next()) {
			    	Map<String, Object> obj=new HashMap<String, Object>();
		    	    obj.put("id", rs.getString("CustomerID"));
		    	    obj.put("text", rs.getString("CompanyName"));
		    	    obj.put("leaf", true);
		    	    array.add(obj);
		       }	       
		       
		       rs.close();
		       return array;

		    }
		    catch (Exception e) {
		    	throw new RuntimeException(e.getMessage());
		    }
		    finally {
		        if (rscount != null) try { rscount.close(); } catch(Exception e) {}
		        if (rs != null) try { rs.close(); } catch(Exception e) {}
		        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
		        if (con != null) try { con.close(); } catch(Exception e) {}
		    }
		
	}
}
