import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.softwarementors.extjs.djn.config.annotations.DirectAction;
import com.softwarementors.extjs.djn.config.annotations.DirectMethod;
import com.sun.org.apache.bcel.internal.generic.NEW;


@DirectAction(action="Order")
public class Order {
	
	@DirectMethod
	public Map<String, Object> List(JsonArray data) {
        String connectionUrl = "jdbc:sqlserver://192.168.0.254:1433;" +
        "databaseName=Northwind;;user=sa;password=abcd-1234";
	    Connection con = null;
	    Statement stmt = null;
	    ResultSet rs = null;
	    ResultSet rscount=null;
	    ResultSet rs1 = null;
		JsonObject joData=(JsonObject)data.get(0).getAsJsonObject();
		int page= joData.has("page")? joData.get("page").getAsInt(): 1;
		int start= joData.has("start")? joData.get("start").getAsInt(): 0;
		int limit= joData.has("limit")? joData.get("limit").getAsInt(): 20;
		String id= joData.has("CustomerID")? joData.get("CustomerID").getAsString(): "";
	    String sort="OrderID";
	    if(joData.has("sort")){
	    	sort="";
	    	JsonArray jaArray=(JsonArray)joData.get("sort").getAsJsonArray();
	        for (JsonElement je : jaArray) {
	        	JsonObject jo = je.getAsJsonObject();
	        	sort+=jo.get("property").getAsString()+ " " 
	       	 		+ jo.get("direction").getAsString()+",";
	        }
	        sort=sort.substring(0,sort.length()-1);
	    }
	    try {
	
		       Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		       con = DriverManager.getConnection(connectionUrl);
		       
		       int count = 0;
		       stmt = con.createStatement();
		       rscount=stmt.executeQuery("select count(OrderID) as count from Orders "
		    		   + ((id.equals("-1") || id.equals("")) ? "" : ("where CustomerID='"+id +"'")));
		       rscount.next();
		       count=rscount.getInt(1);
		       if(start>count){
		    	   start=0;
		       }
		       StringBuilder sb = new StringBuilder();
		       sb.append("select top 50 OrderID,CustomerID,OrderDate,");
		       sb.append("CustomerName=(select CompanyName from Customers");
		       sb.append(" where Customers.CustomerID=Orders.CustomerID)");
		       sb.append(" from Orders where OrderID ");
		       sb.append(" not in (select top ");
		       sb.append(start);
		       sb.append(" OrderID from Orders  ");
		       if(!(id.equals("-1") || id.equals(""))){
		    	   sb.append(" where CustomerID='");
		    	   sb.append(id);
		    	   sb.append("' ");
		       }
		       sb.append(" order by ");
		       sb.append(sort);
		       sb.append(")");
		       if(!(id.equals("-1") || id.equals(""))){
		    	   sb.append(" and CustomerID='");
		    	   sb.append(id);
		    	   sb.append("' ");
		       }
		       sb.append("  order by ");
		       sb.append(sort);

		       StringBuilder subSQL=new StringBuilder();
		       subSQL.append("select *,ProductName=");
		       subSQL.append("(select ProductName from Products ");
		       subSQL.append("where Products.ProductID=[Order Details].ProductID) ");
		       subSQL.append("from [Order Details] where OrderID in (");
		       subSQL.append("select top 50 OrderID from Orders where OrderID ");
		       subSQL.append(" not in (select top ");
		       subSQL.append(start);
		       subSQL.append(" OrderID from Orders  ");
		       if(!(id.equals("-1") || id.equals(""))){
		    	   subSQL.append(" where CustomerID='");
		    	   subSQL.append(id);
		    	   subSQL.append("' ");
		       }
		       subSQL.append(" order by ");
		       subSQL.append(sort);
		       subSQL.append(")");
		       if(!(id.equals("-1") || id.equals(""))){
		    	   subSQL.append(" and CustomerID='");
		    	   subSQL.append(id);
		    	   subSQL.append("' ");
		       }
		       subSQL.append(" ) order by OrderID");
		       rs1 = stmt.executeQuery(subSQL.toString());
		       Map<String, Object> subs =new HashMap<String, Object>();
		       String ids = ""; 
		       while (rs1.next()) {
		    	   ids=rs1.getString("OrderID");
		    	   if(!subs.containsKey(ids)){
		    		   subs.put(ids, new ArrayList<Map<String,Object>>());
		    	   }
		    	   Map<String, Object> jd=new HashMap<String, Object>();
		    	   jd.put("OrderID", rs1.getInt("OrderID"));
		    	   jd.put("ProductID", rs1.getInt("ProductID"));
		    	   jd.put("Quantity", rs1.getInt("Quantity"));
		    	   jd.put("UnitPrice", rs1.getFloat("UnitPrice"));
		    	   jd.put("Discount", rs1.getFloat("Discount"));
		    	   jd.put("ProductName", rs1.getString("ProductName"));
		    	    ((ArrayList<Map<String, Object>>)subs.get(ids)).add(jd);
		       }
		       rs1.close();
		       rs = stmt.executeQuery(sb.toString());
		       //返回JOSN格式数据
			   java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd");
		       ArrayList<Object> array=new ArrayList<Object>();
		       while (rs.next()) {
		    	   id=rs.getString("OrderID");
		    	   Map<String, Object> obj= new HashMap<String, Object>();
		    	   obj.put("OrderID", rs.getString("OrderID"));
		    	   obj.put("CustomerID", rs.getString("CustomerID"));
		    	   obj.put("OrderDate", df.format(rs.getDate("OrderDate")));
		    	   obj.put("CustomerName", rs.getString("CustomerName"));
		    	   if (subs.containsKey(id)) {
			    	   obj.put("OrderDetails", subs.get(id));
		    	   }else{
			    	   obj.put("OrderDetails", new ArrayList<Object>());		    		   
		    	   }
		    	   array.add(obj);
		       }
		       Map<String, Object> json=new HashMap<String, Object>();
		       json.put("total", count);
		       json.put("success",true);
		       json.put("data", array);	       
		       return json;
	    } 
	    catch (Exception e) {
	    	throw new RuntimeException(e.getMessage());
	    }
	    finally {
	        if (rscount != null) try { rscount.close(); } catch(Exception e) {}
	        if (rs != null) try { rs.close(); } catch(Exception e) {}
	        if (rs1 != null) try { rs1.close(); } catch(Exception e) {}
	        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
	        if (con != null) try { con.close(); } catch(Exception e) {}
	    }
		
	}
}
