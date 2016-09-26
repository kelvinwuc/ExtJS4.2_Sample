

import java.awt.Color;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.patchca.color.ColorFactory;
import org.patchca.color.SingleColorFactory;
import org.patchca.filter.predefined.CurvesRippleFilterFactory;
import org.patchca.filter.predefined.DiffuseRippleFilterFactory;
import org.patchca.filter.predefined.DoubleRippleFilterFactory;
import org.patchca.filter.predefined.MarbleRippleFilterFactory;
import org.patchca.filter.predefined.WobbleRippleFilterFactory;
import org.patchca.service.ConfigurableCaptchaService;
import org.patchca.utils.encoder.EncoderHelper;
import org.patchca.word.RandomWordFactory;

/**
 * Servlet implementation class Vcode
 */
@WebServlet("/Vcode")
public class Vcode extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Vcode() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		long serialVersionUID = 3796351198097771007L;

		ConfigurableCaptchaService cs = new ConfigurableCaptchaService();
		ColorFactory cf = new SingleColorFactory(new Color(25, 60, 170));
		RandomWordFactory wf = new RandomWordFactory();
		Random r = new Random();
		CurvesRippleFilterFactory crff = new CurvesRippleFilterFactory(cs.getColorFactory());
		MarbleRippleFilterFactory mrff = new MarbleRippleFilterFactory();
		DoubleRippleFilterFactory drff = new DoubleRippleFilterFactory();
		WobbleRippleFilterFactory wrff = new WobbleRippleFilterFactory();
		DiffuseRippleFilterFactory dirff =  new DiffuseRippleFilterFactory();
		cs.setWordFactory(wf);
		cs.setColorFactory(cf);
		cs.setWidth(270);
		cs.setHeight(80);
		cs.setColorFactory(cf);
		response.setContentType("image/png");
		response.setHeader("cache", "no-cache");
		wf.setMaxLength(6);
		wf.setMinLength(6);
		HttpSession session = request.getSession(true);
		OutputStream os = response.getOutputStream();
		switch (r.nextInt(5)) {
		case 0:
			cs.setFilterFactory(crff);
			break;
		case 1:
			cs.setFilterFactory(mrff);
			break;
		case 2:
			cs.setFilterFactory(drff);
			break;
		case 3:
			cs.setFilterFactory(wrff);
			break;
		case 4:
			cs.setFilterFactory(dirff);
			break;
		}
		String captcha = EncoderHelper.getChallangeAndWriteImage(cs, "png", os);
		session.setAttribute("vcode", captcha);
		os.flush();
		os.close();
	}

}
