import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;

import com.softwarementors.extjs.djn.config.annotations.DirectAction;
import com.softwarementors.extjs.djn.config.annotations.DirectFormPostMethod;
import com.softwarementors.extjs.djn.config.annotations.DirectMethod;
import com.softwarementors.extjs.djn.servlet.ssm.WebContext;
import com.softwarementors.extjs.djn.servlet.ssm.WebContextManager;
import com.sun.org.apache.bcel.internal.generic.NEW;

@DirectAction(action="Login")
public class Login {

	@DirectFormPostMethod
	public Map<String, Object> Check(Map<String, String> formParameters,
			Map<String, FileItem> fileFields){
		String vcode= formParameters.containsKey("vcode")?
				formParameters.get("vcode"):"";
		String username= formParameters.containsKey("username")?
				formParameters.get("username"):"";
		String password= formParameters.containsKey("password")?
				formParameters.get("password"):"";
		WebContext context = WebContextManager.get();
		HttpSession session=context.getSession();
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> errors = new HashMap<String, Object>();
		if(session.getAttribute("vcode")==null){
			result.put("success", false);
			errors.put("vcode", "错误的验证码。");
			result.put("errors", errors);
		}else{
			if(vcode.equals(session.getAttribute("vcode").toString())){
				Map<String, Object> userinfo = new HashMap<String, Object>();
				Cookie cookie = new Cookie("hasLogin", "true");
				cookie.setMaxAge(1200);
				if(username.equals("admin") && password.equals("123456")){
					userinfo.put("role", "管理员");
					result.put("success", true);
					result.put("msg","登录成功");
					result.put("userInfo",userinfo);
					context.getResponse().addCookie(cookie);
				}else if(username.equals("user1") && password.equals("123456")){
					userinfo.put("role", "用户");
					result.put("success", true);
					result.put("msg","登录成功");
					result.put("userInfo",userinfo);
					context.getResponse().addCookie(cookie);
				}else{
					result.put("success", false);
					errors.put("username", "用户名或密码错误。");
					errors.put("password", "用户名或密码错误。");
					result.put("errors", errors);
				}
			}else{
				result.put("success", false);
				errors.put("vcode", "错误的验证码。");
				result.put("errors", errors);
			}
		}
		System.out.println("Login.java被執行了");
		return result;
	}
	
	@DirectMethod
	public Boolean Quit(){
		Cookie cookie = new Cookie("hasLogin", null);
		cookie.setMaxAge(0);
		WebContext context = WebContextManager.get();
		context.getResponse().addCookie(cookie);
		return true;
	}
}
