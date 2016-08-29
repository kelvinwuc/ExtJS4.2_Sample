
package com.mossle.student;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class GzipFilter implements Filter {
    public void init(FilterConfig filterConfig)
          throws ServletException {
    }

    public void destroy() {
    }

    public void doFilter(ServletRequest request,
                     ServletResponse response,
                     FilterChain chain)
              throws IOException,
                     ServletException {

        String url = ((HttpServletRequest) request).getServletPath();
        if (url.endsWith(".gz.js")) {
            ((HttpServletResponse)response).setHeader("Content-Encoding", "gzip");
        }

        chain.doFilter(request, response);
    }
}
