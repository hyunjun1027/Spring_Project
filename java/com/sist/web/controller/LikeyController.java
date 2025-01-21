package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Board;
import com.sist.web.model.Likey;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BoardService;
import com.sist.web.service.LikeyService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("likeyController")
public class LikeyController {
	
	private static Logger logger = LoggerFactory.getLogger(LikeyController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	public UserService userService;
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private LikeyService likeyService;
	
	
	@RequestMapping(value="/likey/likeyInsertProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> likeyInsertProc (HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		int boardType = HttpUtil.get(request, "boardType", 1);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			
			if(brdSeq > 0) {
			
				Board board = boardService.boardSelect(brdSeq, boardType);
				
				if(board != null) {
					
					Likey likey = new Likey();
					
					likey.setUserId(cookieUserId);
					likey.setBrdSeq(brdSeq);
					likey.setBoardType(boardType);

					List<Likey> list = likeyService.likeySelect(likey);
					
					if(list == null || list.size() <= 0) {
						
						if(likeyService.likeyInsert(likey) > 0) {
							
							long count = likeyService.likeySelect2(likey);
							ajaxResponse.setResponse(0, "success", count);
							
						}else {
							ajaxResponse.setResponse(-99, "error(2)");
						}
						
						
						
					}else {
						
						likeyService.likeyDelete(likey);
						long count = likeyService.likeySelect2(likey);			
						ajaxResponse.setResponse(-1, "success", count);
					}
					
					
				}else {
					ajaxResponse.setResponse(404, "not found");
				}
				
			}else {
				ajaxResponse.setResponse(400, "bad request");
			}

		}else {
			ajaxResponse.setResponse(500, "error");
		}
		
		
		return ajaxResponse;
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
