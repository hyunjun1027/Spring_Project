package com.sist.web.controller;

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
import org.springframework.web.multipart.MultipartHttpServletRequest;


import com.sist.common.util.StringUtil;

import com.sist.web.model.Comment;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.CommentService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;


@Controller("commentController")
public class CommentController {
	
	private static Logger logger = LoggerFactory.getLogger(CommentController.class);
	
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	public UserService userService;
	
	@Autowired
	private CommentService commentService;
	
	
	public String boardTitle(int boardType) {
		if (boardType == 1)
			return "공지사항";
		else if (boardType == 2)
			return "자유게시판";
		else if (boardType == 3)
			return "전시게시판";
		else if (boardType == 4)
			return "문의사항";
		else
			return "그외";
   }
	
	//댓글 쓰기
	@RequestMapping(value="/comment/commentProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> commentProc (HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String commContent = HttpUtil.get(request, "commContent");
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		if(brdSeq > 0 && !StringUtil.isEmpty(commContent)) {
			
			Comment comment = new Comment();
			comment.setUserId(cookieUserId);
			comment.setBrdSeq(brdSeq);
			comment.setCommContent(commContent);
			comment.setBoardType(boardType);
	
			logger.debug("BRD_SEQ 값: " + brdSeq); // 로그로 값 확인
			
			try {
				
				if(commentService.commentInsert(comment) > 0) {
					
					ajaxResponse.setResponse(0, "success");
					
				}else {
					ajaxResponse.setResponse(500, "internal server error");
				}
				
			}catch(Exception e) {
				logger.error("[CommentController] commentProc Exception", e);
				ajaxResponse.setResponse(500, "internal server error(2)");
			}
			
			
			
		}else {
			ajaxResponse.setResponse(400, "bad request");
		}
		
		
		return ajaxResponse;
		
	}
	
	//댓글 답글
	@RequestMapping(value="/comment/commentreplyProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> commentreplyProc (HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String commContent = HttpUtil.get(request, "comreplyinput");
		int boardType = HttpUtil.get(request, "boardType", 1);
		long commSeq = HttpUtil.get(request, "commSeq", (long)0);
				
		
		if(brdSeq > 0 && !StringUtil.isEmpty(commContent)) {
			
			Comment parentComment = commentService.commentSelect(commSeq, boardType);
			
			if(parentComment != null) {
				
				Comment comment = new Comment();
				comment.setUserId(cookieUserId);
				comment.setCommContent(commContent);
				comment.setBrdGroup(parentComment.getBrdGroup());
				comment.setBrdOrder(parentComment.getBrdOrder() + 1);
				comment.setBrdIndent(parentComment.getBrdIndent() + 1);
				comment.setBoardType(boardType);
				comment.setBrdSeq(brdSeq);
				
				comment.setBrdParent(commSeq);

				
				
				try {
					
					if(commentService.commentReplyInsert(comment) > 0) {
						
						ajaxResponse.setResponse(0, "success");
						
					}else {
						ajaxResponse.setResponse(500, "internal server error(2)");
					}
					
				}catch(Exception e) {
					logger.error("[CommentController] commentreplyProc Exception", e);
					ajaxResponse.setResponse(500, "internal server error");
				}
				
			}else {
				ajaxResponse.setResponse(404, "not found");
			}
			
		}else {
			ajaxResponse.setResponse(400, "bad request");
		}
		
		
		return ajaxResponse;
		
	}
	
	
	//댓글 삭제
	@RequestMapping(value="/comment/commentDelete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> commentDelete (HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUSerId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long commSeq = HttpUtil.get(request, "commSeq", (long)0);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long )0);
		int boardType = HttpUtil.get(request, "boardType", 1);

		
		if(brdSeq > 0 && commSeq > 0) {
			
			Comment comment = commentService.commentSelect(commSeq, boardType);
			
			User user = userService.userSelect(cookieUSerId);
			
			if(StringUtil.equals(cookieUSerId, comment.getUserId()) || StringUtil.equals(user.getRating(), "1")) {
				
				if(commentService.commentDelete(commSeq, boardType) > 0) {
					
					ajaxResponse.setResponse(0, "success");
					
				}else {
					
					ajaxResponse.setResponse(500, "internal server error");
					
				}
				
			}else {
				ajaxResponse.setResponse(403, "server error");
			}
			
		}else {
			ajaxResponse.setResponse(404, "not found");
		}
		
		return ajaxResponse;
		
	}
	
	
	
	
}
