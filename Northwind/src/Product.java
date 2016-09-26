
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.management.RuntimeErrorException;

import org.apache.commons.fileupload.FileItem;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.softwarementors.extjs.djn.config.annotations.DirectAction;
import com.softwarementors.extjs.djn.config.annotations.DirectFormPostMethod;
import com.softwarementors.extjs.djn.config.annotations.DirectMethod;


@DirectAction(action="Product")
public class Product {

	@DirectMethod
	public Map<String, Object> List(JsonArray data){
		JsonObject joData=(JsonObject)data.get(0).getAsJsonObject();
		int page= joData.has("page")? joData.get("page").getAsInt(): 1;
		int start= joData.has("start")? joData.get("start").getAsInt(): 0;
		int limit= joData.has("limit")? joData.get("limit").getAsInt(): 20;
	    String sort="ProductID";
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
	    String filter="";
	    if(joData.has("filter")){
	    	filter="";
	    	JsonArray jaArray=(JsonArray)joData.get("filter").getAsJsonArray();
	        for (JsonElement je : jaArray) {
	        	JsonObject jo = je.getAsJsonObject();
	        	filter+=jo.get("property").getAsString()+ " like '%" 
       	 		+ jo.get("value").getAsString()+"%',";
	        }
	        filter=filter.substring(0,filter.length()-1);
	    }
        String connectionUrl = "jdbc:sqlserver://192.168.0.254:1433;" +
        "databaseName=Northwind;;user=sa;password=abcd-1234";
	    Connection con = null;
	    Statement stmt = null;
	    ResultSet rs = null;
	    ResultSet rscount=null;
        Map<String, Object> result = new HashMap<String, Object>();
	    try {
	    	
		       Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		       con = DriverManager.getConnection(connectionUrl);
		       
		       int count = 0;
		       stmt = con.createStatement();
		       rscount=stmt.executeQuery("select count(ProductID) as count from products"+ 
		    		   (filter.length()>0 ? " where " + filter : ""));
		       rscount.next();
		       count=rscount.getInt(1);
		       if(start>count){
		    	   start=0;
		       }
		       StringBuilder sb = new StringBuilder();
		       sb.append("select top 20 *,Categories.CategoryName,   ");
		       sb.append(" Suppliers.CompanyName ");
		       sb.append(" from products LEFT OUTER JOIN");
		       sb.append(" Categories ON Products.CategoryID = Categories.CategoryID LEFT ");
		       sb.append(" OUTER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID");
		       sb.append(" where Products.ProductID not in (select top ");
		       sb.append(start);
		       sb.append(" ProductID from products  ");
		       if(filter.length()>0){
		    	   sb.append(" where ");
		    	   sb.append(filter);
		       }
		       sb.append(" order by ");
		       sb.append(sort);
		       sb.append(")");
		       if(filter.length()>0){
		    	   sb.append(" and ");
		    	   sb.append(filter);
		       }
		       sb.append("  order by ");
		       sb.append(sort);
		       
		       rscount.close();
		       rs = stmt.executeQuery(sb.toString());
		        
		       //返回JOSN格式数据
		       ArrayList<Object> array =new ArrayList<Object>();
		       while (rs.next()) {
		    	   Map<String, Object> obj= new HashMap<String, Object>();
		    	   obj.put("ProductID", rs.getInt("ProductID"));
		    	   obj.put("ProductName", rs.getString("ProductName"));
		    	   obj.put("CompanyName", rs.getString("CompanyName"));
		    	   obj.put("CategoryName", rs.getString("CategoryName"));
		    	   obj.put("SupplierID", rs.getInt("SupplierID"));
		    	   obj.put("CategoryID", rs.getInt("CategoryID"));
		    	   obj.put("QuantityPerUnit", rs.getString("QuantityPerUnit"));
		    	   obj.put("UnitPrice", rs.getInt("UnitPrice"));
		    	   obj.put("UnitsInStock", rs.getInt("UnitsInStock"));
		    	   obj.put("UnitsOnOrder", rs.getInt("UnitsOnOrder"));
		    	   obj.put("ReorderLevel", rs.getInt("ReorderLevel"));
		    	   obj.put("Discontinued", rs.getBoolean("Discontinued"));
		    	   array.add(obj);
		       }
		       result.put("total", count);
		       result.put("success", true);
		       result.put("data", array);
		       
		       rs.close();

		       return result;
		    }
		    catch (Exception e) {
		        result.put("success", false);
		        result.put("msg", e.getMessage());
				return result;
		    }
		    finally {
		        if (rscount != null) try { rscount.close(); } catch(Exception e) {}
		        if (rs != null) try { rs.close(); } catch(Exception e) {}
		        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
		        if (con != null) try { con.close(); } catch(Exception e) {}
		    }
		
	}
	
	@DirectFormPostMethod
	public Map<String, Object> Add(Map<String, String> formParameters,
			Map<String, FileItem> fileFields){
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> errors =new HashMap<String, Object>();
		int errCount=0;
        int supplierId = 0;
        if(formParameters.containsKey("SupplierID")){
	        try {
	        	supplierId=Integer.parseInt(formParameters.get("SupplierID"));
			} catch (Exception e) {
				errCount++;
				errors.put("SupplierID", "错误的供应商编号"+ 
						formParameters.get("SupplierID"));
			}
        }else{
			errCount++;
			errors.put("SupplierID", "错误的供应商编号"); 
        }
        int categoryid = 0;
        if(formParameters.containsKey("CategoryID")){
	        try {
	           categoryid=Integer.parseInt(formParameters.get("CategoryID"));
			} catch (Exception e) {
				errCount++;
				errors.put("CategoryID", "错误的类别编号"+ 
						formParameters.get("CategoryID"));        
			}
        }else{
			errCount++;
			errors.put("CategoryID", "错误的类别编号");
        }
        boolean discontinued = false;
        if(formParameters.containsKey("Discontinued")){
        	if(formParameters.get("Discontinued").equals("true"))
        		discontinued=true;
        }
        String productName = "";
        if(formParameters.containsKey("ProductName")){
        	productName=formParameters.get("ProductName");
        }
        if (productName.length() <= 0)
        {
			errCount++;
            errors.put("ProductName", "该输入项为必输项");
        }
        float unitPrice = 0;
        if(formParameters.containsKey("UnitPrice")){
        		unitPrice=Float.parseFloat(formParameters.get("UnitPrice"));
				
        }        
        String quantityPerUnit = "";
        if(formParameters.containsKey("QuantityPerUnit")){
        	quantityPerUnit=formParameters.get("QuantityPerUnit");
        }
        String connectionUrl = "jdbc:sqlserver://192.168.0.254:1433;" +
        "databaseName=Northwind;;user=sa;password=abcd-1234";
	    Connection con = null;
	    Statement stmt = null;
	    CallableStatement callstmt=null;
	    ResultSet rs = null;
	    ResultSet rscount=null;
	    try {
	    	
		       Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		       con = DriverManager.getConnection(connectionUrl);
		       
		       int count = 0;
		       stmt = con.createStatement();
		       rscount=stmt.executeQuery("select count(SupplierID) as count from Suppliers where SupplierID="+
		    		   String.valueOf(supplierId)); 
		       rscount.next();
		       count=rscount.getInt(1);
		       if(count<=0){
		    	   errCount++;
		    	   errors.put("SupplierID", String.format("编号为%1$d的供应商不存在。",supplierId));
		       }
		       rscount=stmt.executeQuery("select count(CategoryID) as count from Categories where CategoryID="
		    		   +String.valueOf(categoryid)); 
		       rscount.next();
		       count=rscount.getInt(1);
		       if(count<=0){
		    	   errCount++;
		    	   errors.put("CategoryID", String.format("编号为%1$d的类别不存在。",categoryid));
		       }
		       if(errCount>0){
		    	   Map<String, Object> jo=new HashMap<String, Object>();
		    	   jo.put("success", new JsonPrimitive(false));
		    	   jo.put("errors", errors);
		    	   return jo;        
		       }
		       callstmt=con.prepareCall("INSERT INTO Products " +
		       		" (CategoryID,Discontinued,ProductName,QuantityPerUnit" +
		       		" ,SupplierID,UnitPrice) VALUES (?,?,?,?,?,?);SELECT @@IDENTITY;");
	    	   callstmt.setInt(1, categoryid);
	    	   callstmt.setBoolean(2,discontinued);
	    	   callstmt.setNString(3,productName);
	    	   callstmt.setNString(4, quantityPerUnit);
	    	   callstmt.setInt(5, supplierId);
	    	   callstmt.setFloat(6, unitPrice);
	    	   callstmt.execute();
		       int iUpdCount =0; 
		       boolean bMoreResults = true;
	    	   iUpdCount=callstmt.getUpdateCount();
	    	   bMoreResults=true;
	    	   rs=null;
	    	   int productId=0;
		       while (bMoreResults || iUpdCount!=-1)
		       {			
		    	   rs = callstmt.getResultSet();
		    	   if (rs != null)
		    	   {
		    		   rs.next();
		    		   productId = rs.getInt(1);
		    	   }
		    	   
		    	   bMoreResults = callstmt.getMoreResults();
		    	   iUpdCount = callstmt.getUpdateCount();
				}
		       Map<String, Object> json=new HashMap<String, Object>();
		       json.put("success",true);
		       json.put("msg", "保存成功");	       
		       json.put("ProductID", productId);	       
		       return json;
		    }
		    catch (Exception e) {
		    	throw new RuntimeException(e.getMessage());
		    }
		    finally {
		        if (rscount != null) try { rscount.close(); } catch(Exception e) {}
		        if (rs != null) try { rs.close(); } catch(Exception e) {}
		        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
		        if (callstmt != null) try { callstmt.close(); } catch(Exception e) {}
		        if (con != null) try { con.close(); } catch(Exception e) {}
		    }
	}

	@DirectFormPostMethod
	public Map<String, Object> Edit(Map<String, String> formParameters,
			Map<String, FileItem> fileFields){
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> errors =new HashMap<String, Object>();
		int errCount=0;
		int id=0;
        if(formParameters.containsKey("ProductID")){
	        try {
	        	id=Integer.parseInt(formParameters.get("ProductID"));
			} catch (Exception e) {
				errCount++;
				errors.put("ProductID", "错误的供应商编号"+ 
						formParameters.get("ProductID"));
			}
        }else{
			errCount++;
			errors.put("ProductID", "错误的供应商编号"); 
        }
        int supplierId = 0;
        if(formParameters.containsKey("SupplierID")){
	        try {
	        	supplierId=Integer.parseInt(formParameters.get("SupplierID"));
			} catch (Exception e) {
				errCount++;
				errors.put("SupplierID", "错误的供应商编号"+ 
						formParameters.get("SupplierID"));
			}
        }else{
			errCount++;
			errors.put("SupplierID", "错误的供应商编号"); 
        }
        int categoryid = 0;
        if(formParameters.containsKey("CategoryID")){
	        try {
	           categoryid=Integer.parseInt(formParameters.get("CategoryID"));
			} catch (Exception e) {
				errCount++;
				errors.put("CategoryID", "错误的类别编号"+ 
						formParameters.get("CategoryID"));        
			}
        }else{
			errCount++;
			errors.put("CategoryID", "错误的类别编号");
        }
        boolean discontinued = false;
        if(formParameters.containsKey("Discontinued")){
        	if(formParameters.get("Discontinued").equals("true"))
        		discontinued=true;
        }
        String productName = "";
        if(formParameters.containsKey("ProductName")){
        	productName=formParameters.get("ProductName");
        }
        if (productName.length() <= 0)
        {
			errCount++;
            errors.put("ProductName", "该输入项为必输项");
        }
        float unitPrice = 0;
        if(formParameters.containsKey("UnitPrice")){
        		unitPrice=Float.parseFloat(formParameters.get("UnitPrice"));
				
        }        
        String quantityPerUnit = "";
        if(formParameters.containsKey("QuantityPerUnit")){
        	quantityPerUnit=formParameters.get("QuantityPerUnit");
        }
        String connectionUrl = "jdbc:sqlserver://192.168.0.254:1433;" +
        "databaseName=Northwind;;user=sa;password=abcd-1234";
	    Connection con = null;
	    Statement stmt = null;
	    Statement stmtUpdate=null;
	    CallableStatement callstmt=null;
	    ResultSet rs = null;
	    ResultSet rscount=null;
	    try {
	    	
		       Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		       con = DriverManager.getConnection(connectionUrl);
		       
		       int count = 0;
		       stmt = con.createStatement();
		       rscount=stmt.executeQuery("select count(SupplierID) as count from Suppliers where SupplierID="+
		    		   String.valueOf(supplierId)); 
		       rscount.next();
		       count=rscount.getInt(1);
		       if(count<=0){
		    	   errCount++;
		    	   errors.put("SupplierID", String.format("编号为%1$d的供应商不存在。",supplierId));
		       }
		       rscount=stmt.executeQuery("select count(CategoryID) as count from Categories where CategoryID="
		    		   +String.valueOf(categoryid)); 
		       rscount.next();
		       count=rscount.getInt(1);
		       if(count<=0){
		    	   errCount++;
		    	   errors.put("CategoryID", String.format("编号为%1$d的类别不存在。",categoryid));
		       }
		       if(errCount>0){
		    	   Map<String, Object> jo=new HashMap<String, Object>();
		    	   jo.put("success", new JsonPrimitive(false));
		    	   jo.put("errors", errors);
		    	   return jo;        
		       }
		       stmtUpdate=con.createStatement(
		    		   ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE
		       );
		       rs=stmtUpdate.executeQuery("select * from products where productid="+
		    		   String.valueOf(id));
		       rs.first();
		       rs.updateInt("CategoryID", categoryid); 
		       rs.updateBoolean("Discontinued", discontinued); 
		       rs.updateString("ProductName", productName); 
		       rs.updateInt("SupplierID", supplierId); 
		       rs.updateString("QuantityPerUnit", quantityPerUnit); 
		       rs.updateFloat("UnitPrice", unitPrice); 
		       rs.updateRow();
		       Map<String, Object> json=new HashMap<String, Object>();
		       json.put("success",true);
		       json.put("msg", "保存成功");	       
		       return json;
		    }
		    catch (Exception e) {
		    	throw new RuntimeException(e.getMessage());
		    }
		    finally {
		        if (rscount != null) try { rscount.close(); } catch(Exception e) {}
		        if (rs != null) try { rs.close(); } catch(Exception e) {}
		        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
		        if (callstmt != null) try { callstmt.close(); } catch(Exception e) {}
		        if (stmtUpdate != null) try { stmtUpdate.close(); } catch(Exception e) {}
		        if (con != null) try { con.close(); } catch(Exception e) {}
		    }
	}

	@DirectMethod
	public Map<String, Object> Delete(String data){
		String[] ids=data.split(",");
		String sql="";
		if(ids.length>0){
			for (String id : ids) {
				if (id.matches("\\d*")) {
					sql=sql + id+",";
				}
			}
			sql=sql.substring(0,sql.length()-1);
		}else {
	       Map<String, Object> jo=new HashMap<String, Object>();
    	   jo.put("success", false);
    	   jo.put("msg", "没有要删除的产品。");
    	   return jo;
		}
        String connectionUrl = "jdbc:sqlserver://192.168.0.254:1433;" +
        "databaseName=Northwind;;user=sa;password=abcd-1234";
	    Connection con = null;
	    Statement stmt = null;
	    ResultSet rs = null;
	    try {
	    	
		       Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		       con = DriverManager.getConnection(connectionUrl);
		       stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
		       
		       rs=stmt.executeQuery("select * from products where productid in ("+
		    		   sql +")");
		       ArrayList<String> delList= new ArrayList<String>();
		       while (rs.next()) {
		    	   delList.add(String.format("[%1$s]%2$s", rs.getString("ProductID"),rs.getString("ProductName")));
		    	   rs.deleteRow();
		       }
		       Map<String,Object> json=new HashMap<String, Object>();
		       json.put("success",new JsonPrimitive(true));
		       json.put("msg", delList);	       
		       return json;
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
