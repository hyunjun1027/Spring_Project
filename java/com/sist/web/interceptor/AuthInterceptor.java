/**
 * <pre>
 * 프로젝트명 : HBoard
 * 패키지명   : com.icia.web.interceptor
 * 파일명     : AuthInterceptor.java
 * 작성일     : 2021. 1. 19.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
//import com.sist.web.model.User;
//import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.interceptor
 * 파일명     : AuthInterceptor.java
 * 작성일     : 2021. 1. 19.
 * 작성자     : daekk
 * 설명       :
 * </pre>
 */
public class AuthInterceptor extends HandlerInterceptorAdapter
{
	private static Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);
	
	private String AUTH_COOKIE_NAME;
	
	private String AJAX_HEADER_NAME;
	
//	@Autowired
//	private UserService userService;
	
	// 인증체크 안해도 되는 url 리스트
	private List<String> authExcludeUrlList;
	
	/**
	 * 생성자
	 */
	public AuthInterceptor()
	{
		this(null, null, null);
	}
	
	/**
	 * 생성자
	 * 
	 * @param authExcludeUrlList 인증 체크에서 제외될 URL 리스트
	 */
	public AuthInterceptor(String authCookieName, String ajaxHeaderName, List<String> authExcludeUrlList)
	{
		this.AUTH_COOKIE_NAME = authCookieName;
		this.AJAX_HEADER_NAME = ajaxHeaderName;
		this.authExcludeUrlList = authExcludeUrlList;
		
		if(logger.isDebugEnabled())
		{
			logger.debug("############################################################################");
			logger.debug("# AuthInterceptor                                                          #");
			logger.debug("############################################################################");
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("// Auth Cookie Name                             //");
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("// " + AUTH_COOKIE_NAME);
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("// Ajax Header Name                             //");
			logger.debug("//////////////////////////////////////////////////");
			logger.debug("// " + AJAX_HEADER_NAME);
			logger.debug("//////////////////////////////////////////////////");
			
		}
		
		if(this.authExcludeUrlList != null && this.authExcludeUrlList.size() > 0)
		{
			if(logger.isDebugEnabled())
			{
				logger.debug("//////////////////////////////////////////////////");
				logger.debug("// Auth Exclude Url                             //");
				logger.debug("//////////////////////////////////////////////////");
				
				for(int i=0; i<this.authExcludeUrlList.size(); i++)
				{
					logger.debug("// " + StringUtil.nvl(this.authExcludeUrlList.get(i)));
				}
				
				logger.debug("//////////////////////////////////////////////////");
			}
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("############################################################################");
		}
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception
    {
		boolean bFlag = true;
		boolean ajaxFlag = false;
		
		// 쿠키명 입력
		request.setAttribute("AUTH_COOKIE_NAME", AUTH_COOKIE_NAME);
		
		String url = request.getRequestURI();
		
		if(!StringUtil.isEmpty(AJAX_HEADER_NAME))
		{
			ajaxFlag = HttpUtil.isAjax(request, AJAX_HEADER_NAME);
		}
		else
		{
			ajaxFlag = HttpUtil.isAjax(request);
		}
		
		if(logger.isDebugEnabled())
		{
			request.setAttribute("_http_logger_start_time", String.valueOf(System.currentTimeMillis()));
			
			logger.debug("############################################################################");
			logger.debug("# Logging start ["+url+"]");
			logger.debug("############################################################################");
			logger.debug(HttpUtil.requestLogString(request));
        	logger.debug("############################################################################");
		}
		
		if(!isExcludeUrl(url))
		{
			if(logger.isDebugEnabled())
			{
				logger.debug("# [" + url + "] : [인증체크] ");
			}
			
			// 인증 체크
			if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null)
			{
				String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
				
				if(!StringUtil.isEmpty(cookieUserId))
				{
					if(logger.isDebugEnabled())
					{
						logger.debug("# [Cookie] : [" + cookieUserId + "]");
					}
					
					if(!StringUtil.isEmpty(cookieUserId))
					{
//						User user = userService.userSelect(cookieUserId);
//						
//						if(user != null && StringUtil.equals(user.getStatus(), "Y"))
//						{
//							bFlag = true;
//						}
//						else
//						{
//							// 인증된 사용자가 아니면 쿠키 삭제
//							CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
//							bFlag = false;
//						}
					}
					else
					{
						CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
						bFlag = false;
					}
				}
				else
				{
					CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
					
					bFlag = false;
				}
			}
			else
			{
				bFlag = false;
			}
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("############################################################################");
		}
		
		if(bFlag == false) 
		{
			if(ajaxFlag == true)
			{
				response.setContentType("application/json");
				response.setCharacterEncoding("UTF-8");
				
				response.getWriter().write(JsonUtil.toJson(new Response<Object>(HttpStatus.BAD_REQUEST.value(), "인증된 사용자가 아닙니다")));
			}
			else
			{
				response.sendRedirect("/");
			}
		}
		
		return bFlag;
    }

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception
	{
		if(logger.isDebugEnabled())
        {
        	long start_time = StringUtil.stringToLong((String)request.getAttribute("_http_logger_start_time"), 0);
        	long end_time = System.currentTimeMillis() - start_time;
        	
        	logger.debug("############################################################################");
        	logger.debug("# Logging end                                                              #");
        	logger.debug("############################################################################");
        	logger.debug("# [request url]          : [" + request.getRequestURI() + "]");
        	logger.debug("# [elapse time (second)] : [" + String.format("%.3f", (end_time / 1000.0f)) + "]");
        	logger.debug("############################################################################");
        }
	}
	
	/**
	 * <pre>
	 * 메소드명   : isExcludeUrl
	 * 작성일     : 2021. 1. 19.
	 * 작성자     : daekk
	 * 설명       : 인증하지 않아도 되는 URL 인지 체크 한다.
	 *              (true-인증체크 안함, false: 인증체크 해야됨)
	 * </pre>
	 * @param url 호출 url
	 * @return boolean
	 */
	private boolean isExcludeUrl(String url)
	{
		/*
		if(authExcludeUrlList != null && authExcludeUrlList.size() > 0 && !StringUtil.isEmpty(url))
		{
			for(int i=0; i<authExcludeUrlList.size(); i++)
			{
				String chkUrl = StringUtil.trim(StringUtil.nvl(authExcludeUrlList.get(i)));
				
				if(!StringUtil.isEmpty(chkUrl) && chkUrl.length() <= url.length())
				{
					if(url.startsWith(chkUrl))
					{
						return true;
					}
				}
			}
			
			return false;
		}
		*/
		
		return true;
	}
}
