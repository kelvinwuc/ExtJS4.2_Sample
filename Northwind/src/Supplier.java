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

@DirectAction(action="Supplier")
public class Supplier {

	@DirectMethod
	public Map<String, Object> ComboList(JsonArray data){
		JsonObject joData = data.get(0).getAsJsonObject();
		String query = joData.has("query")?joData.get("query").getAsString():"";
        String connectionUrl = "jdbc:sqlserver://192.168.0.254:1433;" +
        "databaseName=Northwind;;user=sa;password=abcd-1234";
	    Connection con = null;
	    Statement stmt = null;
	    ResultSet rs = null;
	    try {
	    	Map<String, Object> resutl=new HashMap<String, Object>();
	        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	        con = DriverManager.getConnection(connectionUrl);
	        stmt = con.createStatement();

	        rs = stmt.executeQuery("select SupplierID,CompanyName from Suppliers" +
	       	 	(query.length()>0 ? " where CompanyName like '%" + query +"%'" : "")   
	       	 	+" order by CompanyName");
	       
	        ArrayList<Object> array=new ArrayList<Object>();
	        while (rs.next()) {
		    	Map<String, Object> obj=new HashMap<String, Object>();
	    	    obj.put("SupplierID", rs.getInt("SupplierID"));
	    	    obj.put("CompanyName", rs.getString("CompanyName"));
	    	    array.add(obj);
	        }
	        rs.close();
	    	resutl.put("success", true);
	    	resutl.put("data", array);
	    	return resutl;
	    } 
	    catch (Exception e) {
	    	throw new RuntimeException(e.getMessage());
	    }
	    finally {
	        if (rs != null) try { rs.close(); } catch(Exception e) {}
	        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
	        if (con != null) try { con.close(); } catch(Exception e) {}
	    }
		
	}
}
