package com.sist.web.controller;

import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.web.model.Response;
import com.sist.web.service.MailService;
import com.sist.web.util.HttpUtil;

//이메일 인증
@Controller("mailController")
public class MailController {
	
	private static Logger logger = LoggerFactory.getLogger(MailController.class);
	
	@Autowired
	private MailService mailService;
	
	@RequestMapping(value = "/sendMail", method= RequestMethod.POST)
	@ResponseBody
	public Response<Object> sendSimpleMail(HttpServletRequest request,HttpServletResponse response) throws Exception{
		
		Response<Object> ajaxResponse = new Response<Object>();
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		String userEmail = HttpUtil.get(request, "userEmail");
		
		
		if(userEmail != null) {
			Random random = new Random();
			int checkNum = random.nextInt(888888) + 111111;
			logger.info("인증번호" + checkNum);
	        
			String text = "";
	        text += "안녕하세요. miniproject3입니다.";
	        text += "\n";
	        text += "인증코드 입니다.";
	        text += "\n";
	        text += "인증코드 : " + checkNum + " 입니다.";
	        
	        mailService.sendMail(userEmail, "이메일 인증코드 발송 메일입니다.", text);
	        
	        ajaxResponse.setResponse(0, "success", checkNum);
			
		}else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		return ajaxResponse;
	}

}
