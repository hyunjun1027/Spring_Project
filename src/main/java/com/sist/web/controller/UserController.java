package com.sist.web.controller;


import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BoardService;
import com.sist.web.service.MailService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;


@Controller("userController")
public class UserController {
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	public UserService userService;
	
	@Autowired
	public BoardService boardService;
	
	@Autowired
	private MailService mailService;

	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	//로그인
	@RequestMapping(value="/user/login", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> login(HttpServletRequest request, HttpServletResponse response) {
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {
			
			User user = userService.userSelect(userId);
			
			if(user != null) {
				
				if(StringUtil.equals(user.getUserPwd(), userPwd)){
					
					if(StringUtil.equals(user.getStatus(), "Y")) {
						
						CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
						ajaxResponse.setResponse(0, "success");
					
					}else {
						
						if(StringUtil.equals(user.getStatus(), "D")) {
							ajaxResponse.setResponse(-98, "status error(2)");
							
						}else {
							ajaxResponse.setResponse(-99, "status error");
						}
	
					}
					
				}else {
					ajaxResponse.setResponse(-1, "password mismatch");
				}
				
			}else {
				ajaxResponse.setResponse(404, "not found");
			}
			
		}else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
		
	}
	
	//로그아웃
	@RequestMapping(value="/user/loginOut", method=RequestMethod.GET)
	public String loginOut(HttpServletRequest request, HttpServletResponse response) {
		
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) {
		
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			
		}
		
		return "redirect:/";	//재접속하라는 명령(URL을 다시 가리킴)
		
	}
	
	
	//회원가입 페이지
	@RequestMapping(value = "/user/userForm", method=RequestMethod.GET)
	public String userForm(HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/userForm";
	}
	
	//회원가입
	@RequestMapping(value="/user/regProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> regProc(HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		String addrCode = HttpUtil.get(request, "addrCode");
		String addrBase = HttpUtil.get(request, "addrBase");
		String addrDetail = HttpUtil.get(request, "addrDetail");
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)
					&& !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)
							&& !StringUtil.isEmpty(addrCode) && !StringUtil.isEmpty(addrBase)
																&& !StringUtil.isEmpty(addrDetail)) {
			
			if(userService.userSelect(userId) == null) {
				
				User user = new User();
				
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setUserEmail(userEmail);
				user.setStatus("Y");
				user.setAddrCode(addrCode);
				user.setAddrBase(addrBase);
				user.setAddrDetail(addrDetail);
				
				if(userService.userInsert(user) > 0) {
					
					ajaxResponse.setResponse(0, "success");
					
				}else {
					ajaxResponse.setResponse(500, "insert server error");
				}
				
			}else {
				ajaxResponse.setResponse(100, "duplicate id");
			}
			
		}else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled()) {
			logger.debug("[UserController] /user/regProc response \n" +
											JsonUtil.toJsonPretty(ajaxResponse));
		}
			
		
		return ajaxResponse;
		
	}
	
	//아이디 중복 체크
	@RequestMapping(value="/user/idCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		
		if(!StringUtil.isEmpty(userId)) {
			
			
			if(userService.userSelect(userId) == null) {
				
				//사용가능한 아이디
				ajaxResponse.setResponse(0, "success");
				
			}else {
				ajaxResponse.setResponse(100, "deplicate id");
			}
			
		}else{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		if(logger.isDebugEnabled()) {
			logger.debug("[UserController] /user/idCheck response \n" +
											JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
		
	}
	
	//아이디 찾기 화면
	@RequestMapping(value="/user/findForm", method=RequestMethod.GET)
	public String findForm(HttpServletRequest request, HttpServletResponse response) {
		
		return "/user/findForm";
		
	}
	
	//아이디찾기
	@RequestMapping(value="/user/findIdProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> findIdProc(String userName, String userEmail){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) {
			
			User user = userService.userFindId(userName, userEmail);
			
			if(user != null) {
				
				if(StringUtil.equals(userName, user.getUserName())
											&& StringUtil.equals(userEmail, user.getUserEmail())) {
					
					ajaxResponse.setResponse(0, "success", user.getUserId());
					
				}else {
					ajaxResponse.setResponse(-1, "user mismatch");
				}
				
			}else {
				ajaxResponse.setResponse(404, "Not Found");
			}
			
		}else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
		
	}
	
	//비밀번호 찾기
	@RequestMapping(value="/user/findPwdProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> findPwdProc (String userId, String userName, String userEmail){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) {
			
			User user = userService.userFindPwd(userId, userName, userEmail);
			
			if(user != null) {
				
				if(StringUtil.equals(userId, user.getUserId())
									&& StringUtil.equals(userName, user.getUserName())
											&& StringUtil.equals(userEmail, user.getUserEmail())) {
					

						Random random = new Random();
						int tmpPwd = random.nextInt(888888) + 111111;
						String tmpPwd2 = String.format("%06d", tmpPwd);
						logger.info("임시비밀번호" + tmpPwd);

						String text = "";
						text += "안녕하세요. miniproject3입니다.";
						text += "\n";
						text += "임시비밀번호 발급해드렸습니다. 계정보안을 위해 비밀번호를 변경해주세요.";
						text += "\n";
						text += "임시비밀번호 : " + tmpPwd + " 입니다.";
						
						mailService.sendMail(userEmail, "이메일 임시비밀번호 발송 메일입니다.", text);
						
						user.setUserPwd(tmpPwd2);
						
						if(userService.userPasswordUpdate(user) > 0) {
						
							ajaxResponse.setResponse(0, "success");
						
						}else {
							ajaxResponse.setResponse(-2, "error");
						}
				}else {
					ajaxResponse.setResponse(-1, "user mismatch");
				}
				
			}else {
				ajaxResponse.setResponse(404, "Not Found");
			}
			
		}else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
		
	}

	
	//회원정보 수정 페이지
	@RequestMapping(value = "/user/updateForm", method=RequestMethod.GET)
	public String updateForm(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);

		
		model.addAttribute("user", user);
			
		return "/user/updateForm";
	}
	
	//회원정보 수정
	@RequestMapping(value="/user/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc (HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		String addrCode = HttpUtil.get(request, "addrCode");
		String addrBase = HttpUtil.get(request, "addrBase");
		String addrDetail = HttpUtil.get(request, "addrDetail");
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			
			if(StringUtil.equals(userId, cookieUserId)) {
				
				User user = userService.userSelect(cookieUserId);
				
				if(user != null) {
					
					if(StringUtil.equals(userPwd, user.getUserPwd())) {
						
						if(!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName)
								&& !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(addrCode)
								&& !StringUtil.isEmpty(addrBase) && !StringUtil.isEmpty(addrDetail)) {
								
								user.setUserName(userName);
								user.setAddrCode(addrCode);
								user.setAddrBase(addrBase);
								user.setAddrDetail(addrDetail);
							
							
							if(userService.userUpdate(user) > 0) {
								
								ajaxResponse.setResponse(0, "success");
								
							}else {
								
								ajaxResponse.setResponse(500, "internal server error");
								
							}
							
							
						}else {
							ajaxResponse.setResponse(400, "bad request");
						}
						
					}else {
						
						ajaxResponse.setResponse(431, "Password information is different");
						
					}
					
				}else {
					
					CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
					ajaxResponse.setResponse(404, "not found");
					
				}
				
			}else {			

				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(430, "id information is different");
				
			}
			
		}else {

			ajaxResponse.setResponse(410, "loing failed");
		}
		
		
		return ajaxResponse;
		
	}

	
	//회원 탈퇴
	@RequestMapping(value="/user/userDeleteProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> userDeleteProc (HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		int boardType = HttpUtil.get(request, "boardType", 1);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			
			if(StringUtil.equals(userId, cookieUserId)) {
				
				User user = new User();
				
				user.setUserId(cookieUserId);
				
				int result = userService.userDelete(user);

				if(result > 0) {
					ajaxResponse.setResponse(0, "success");
	                CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				}else {
					ajaxResponse.setResponse(500, "회원 탈퇴 처리 중 오류 발생");
				}

				
			}else {
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
	            ajaxResponse.setResponse(430, "id information is different");
			}
			
		}else {
			ajaxResponse.setResponse(410, "login failed");
		}
		
		
		return ajaxResponse;
		
	}
	
	//비밀번호 수정
	@RequestMapping(value="/user/passwordUpdateForm", method = RequestMethod.GET)
	public String passwordUpdateForm (Model model, HttpServletRequest request, HttpServletResponse response) {
		
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user", user);
		
		return "/user/passwordUpdateForm";
		
	}
	
	//비밀번호 변경
	@RequestMapping(value="/user/passwordUpdateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> passwordUpdateProc (HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			
			if(StringUtil.equals(userId, cookieUserId)) {
				
				User user = userService.userSelect(cookieUserId);
				
				if(user != null) {

					if(StringUtil.equals(userPwd, user.getUserPwd())) {
						
						//변경할 비밀번호 변수
						String userNewPwd = HttpUtil.get(request, "userNewPwd");
						
						//변결할 비밀번호가 비어있는지 확인
						if(!StringUtil.isEmpty(userNewPwd)) {
							
							//변경할비밀번호 셋팅
							user.setUserPwd(userNewPwd);
						
							if(userService.userPasswordUpdate(user) > 0) {
								
								CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
								ajaxResponse.setResponse(0, "success");
								
							}else {
								ajaxResponse.setResponse(500, "internal server error");
							}
						}else {
							
							ajaxResponse.setResponse(400, "bad request");
							
						}
					}else {
						ajaxResponse.setResponse(431, "Password information is different");
					}

				}else {
					CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
					ajaxResponse.setResponse(404, "not found");
				}
			}else {
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
	            ajaxResponse.setResponse(430, "id information is different");
			}
			
		}else {
			ajaxResponse.setResponse(410, "loing failed");
		}
		
		return ajaxResponse;
		
	}
	
	
	
}
