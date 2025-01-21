package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;
import com.sist.web.model.Comment;
import com.sist.web.model.Likey;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BoardService;
import com.sist.web.service.CommentService;
import com.sist.web.service.LikeyService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("boardController")
public class BoardController {
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	public UserService userService;
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private LikeyService likeyService;
	
	@Autowired
	private CommentService commentService;
	
	private static final int LIST_COUNT = 8;	
	private static final int PAGE_COUNT = 8;
	
   // 게시물 종류 별 타이틀
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
	
	
	// ========================================================================================================================================================================================================
	// 게시글 목록 화면
	@RequestMapping(value = "/board/list")
	public String list(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		logger.debug("111111111111111111111111111111");
		int boardType = HttpUtil.get(request, "boardType", 1);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
				
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		long totalCount = 0;
		User user = userService.userSelect(cookieUserId);
		List<Board> list = null;
		
		Board search = new Board();
		
		Paging paging = null;
		
		search.setBoardType(boardType);
		
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
			
		}
		
		totalCount = boardService.boardListCount(search);
		
		logger.debug("================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("================================");
		
		
		if(totalCount > 0) {
			
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT,
																		curPage, "curPage");
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = boardService.boardList(search);
			
		}
		

		model.addAttribute("boardTitle", boardTitle(boardType));
		model.addAttribute("boardType", boardType);		
		model.addAttribute("list", list);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		model.addAttribute("user", user);

		return "/board/list";
	}
	
	//게시글 쓰기 화면
	@RequestMapping(value="/board/write")
	public String write (Model model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		int boardType = HttpUtil.get(request, "boardType", 1);	
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		User user = userService.userSelect(cookieUserId);
		
		
		model.addAttribute("user", user);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("boardTitle", boardTitle(boardType));
		model.addAttribute("boardType", boardType);
		
		return "/board/write";
		
	}
	
	//게시글 쓰기
	@RequestMapping(value="/board/writeProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc (MultipartHttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String brdTitle = HttpUtil.get(request, "brdTitle");
		String brdContent = HttpUtil.get(request, "brdContent");
		FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);
		String brdPwd = HttpUtil.get(request, "brdPwd");
		
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		if(!StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
			
			Board board = new Board();
			board.setUserId(cookieUserId);
			board.setBrdTitle(brdTitle);
			board.setBrdContent(brdContent);
			board.setBoardType(boardType);
			board.setBrdPwd(brdPwd);
			
			if(fileData != null && fileData.getFileSize() > 0) {
				
				BoardFile boardFile = new BoardFile();
				boardFile.setFileName(fileData.getFileName());
				boardFile.setFileOrgName(fileData.getFileOrgName());
				boardFile.setFileExt(fileData.getFileExt());
				boardFile.setFileSize(fileData.getFileSize());
				boardFile.setBoardType(boardType);

				board.setBoardFile(boardFile);
				
			}
			
			try {

				if(boardService.boardInsert(board) > 0) {
					
					ajaxResponse.setResponse(0, "success");
					
				}else {
					ajaxResponse.setResponse(500, "internal server error");
				}
				
			}catch(Exception e) {
				logger.error("[BoardController] writeProc Exception", e);
				ajaxResponse.setResponse(500, "internal server error(2)");
			}
			
			
			
		}else {
			ajaxResponse.setResponse(400, "bad request");
		}
		
		
		return ajaxResponse;
		
	}
	
	//게시물 상세보기
	@RequestMapping(value="/board/view")
	public String view (ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		int boardType = HttpUtil.get(request, "boardType", 1);
		String commContent = HttpUtil.get(request, "commContent");
		long commSeq = HttpUtil.get(request, "commSeq", (long)1);
		
		User user = userService.userSelect(cookieUserId);
		//본인글 여부 
		String boardMe = "N";
		
		logger.debug("===============================");
		logger.debug("brdSeq : " + brdSeq);
		logger.debug("===============================");
		
		Board board = null;
		
		if(brdSeq > 0) {
			
			board = boardService.boardView(brdSeq, boardType);
			
			if(board != null && StringUtil.equals(cookieUserId, board.getUserId())) {
				
				boardMe = "Y";
				
			}
			
		}
		
		if(boardType == 2 || boardType == 3) {
		    List<Comment> commentList = null;
		    long commentTotalCount = 0;  // 댓글 총 갯수
		    if (brdSeq > 0) {
		        Comment comment = new Comment();
		        comment.setCommSeq(commSeq);
		        comment.setBrdSeq(brdSeq);
		        comment.setBoardType(boardType);
		        comment.setStatus("Y");

		        commentList = commentService.commentList(comment);

		        commentTotalCount = commentService.commentTotalCount(comment);
		        
				model.addAttribute("commentList", commentList);
				model.addAttribute("commentTotalCount", commentTotalCount);
		    }
		    

		}
		


		
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("boardMe", boardMe);
		model.addAttribute("board", board);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("boardType", boardType);
		model.addAttribute("user", user);
		model.addAttribute("boardTitle", boardTitle(boardType));
		model.addAttribute("commContent", commContent);



		return "/board/view";
		
	}
	
	//게시물 삭제
	@RequestMapping(value="/board/delete", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response) {
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		if(brdSeq > 0) {
			
			Board board = boardService.boardSelect(brdSeq, boardType);
			
			if(board != null) {
				
				User user = userService.userSelect(cookieUserId);
				
				if(StringUtil.equals(cookieUserId, board.getUserId()) || StringUtil.equals(user.getRating(), "1")) {
					
	

					if(boardService.boardAnswersCount(brdSeq, boardType) > 0) {
						
						ajaxResponse.setResponse(-999, "answer exist and cannot be deleted");
						
					}else {
						
						if(boardType == 2 || boardType == 3) {
							Comment comment = new Comment();
							
							comment.setBoardType(boardType);
							comment.setBrdSeq(brdSeq);
							
							if(commentService.commentTotalCount2(comment) > 0) {
								ajaxResponse.setResponse(-998, "answer exist and cannot be deleted(2)");
								return ajaxResponse;
							}
							
						}

						try {

							Likey likey = new Likey();
							
							if(likey != null){
								
								likey.setUserId(cookieUserId);
								likey.setBrdSeq(brdSeq);
								likey.setBoardType(boardType);
								List<Likey> list = likeyService.likeySelect(likey);

								if(list != null) {
									
									likeyService.likeyDelete(likey);

									if(boardService.boardDelete(brdSeq, boardType) > 0) {

										ajaxResponse.setResponse(0, "success");		

									}else {
										
										ajaxResponse.setResponse(500, "server error(2)");
									}
								}
								
							}
							
						}catch(Exception e) {
							
							logger.error("[BoardController] delete Exception", e);
							ajaxResponse.setResponse(500, "server error(1)");
							
						}
						
					}
					
				}else {
					ajaxResponse.setResponse(403, "server error");
				}
				
			}else {
				ajaxResponse.setResponse(404, "not found");
			}
			
		}else {
			ajaxResponse.setResponse(400, "bad request");
		}
		
		return ajaxResponse;
		
	}
	
	
	//게시글 수정 화면
	@RequestMapping(value="/board/update")
	public String update (ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		int boardType = HttpUtil.get(request, "boardType", 1);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		String brdPwd = HttpUtil.get(request, "brdPwd", "");
		
		Board board = null;
		
		if(brdSeq > 0) {
			
			board = boardService.boardViewUpdate(brdSeq, boardType);
			
			if(board != null) {
				if(!StringUtil.equals(cookieUserId, board.getUserId())){
					board = null;
				}
			}
		}
		
		if(boardType == 4) {
			model.addAttribute("brdPwd", brdPwd);	
		}
		
		
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("board", board);
		model.addAttribute("curPage", curPage);
		model.addAttribute("boardType", boardType);
		model.addAttribute("boardTitle", boardTitle(boardType));
		
		return "/board/update";
		
	}
	
	//게시글 수정
	@RequestMapping(value="/board/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc (MultipartHttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookiUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String brdTitle = HttpUtil.get(request, "brdTitle", "");
		String brdContent = HttpUtil.get(request, "brdContent", "");
		String brdPwd = HttpUtil.get(request, "brdPwd", "");
		FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		if(brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
			
			Board board = boardService.boardSelect(brdSeq, boardType);
			
			if(board != null) {
				
				if(StringUtil.equals(cookiUserId, board.getUserId())) {
					
					board.setBrdTitle(brdTitle);
					board.setBrdContent(brdContent);
					board.setBoardType(boardType);
					
					if(boardType == 4) {
						board.setBrdPwd(brdPwd);
					}
					
					
					if(fileData != null && fileData.getFileSize() > 0) {
						
						BoardFile boardFile = new BoardFile();
						boardFile.setFileName(fileData.getFileName());
						boardFile.setFileOrgName(fileData.getFileOrgName());
						boardFile.setFileExt(fileData.getFileExt());
						boardFile.setFileSize(fileData.getFileSize());
						
						boardFile.setBoardType(boardType);
						
						board.setBoardFile(boardFile);
						
					}
					
	               try{
	                   if(boardService.boardUpdate(board, boardType) > 0){
	                	   ajaxResponse.setResponse(0, "success");
	                   }else{
	                       ajaxResponse.setResponse(500, "internal server error2");
	                   }
	                }
	                catch(Exception e){
	                   logger.error("[BoardController] updateProc Exception", e);
	                   ajaxResponse.setResponse(500, "internal server error");
	                }
					
				}else {
					ajaxResponse.setResponse(403, "server error");
				}
				
			}else {
				ajaxResponse.setResponse(404, "not found");
			}
			
		}else {
			ajaxResponse.setResponse(400, "bad request");
		}
		
		return ajaxResponse;
		
	}
	
	
	//답글 화면
	@RequestMapping(value="/board/replyForm", method=RequestMethod.POST)
	public String replyForm (ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		int boardType = HttpUtil.get(request, "boardType", 1);
		String brdTitle = HttpUtil.get(request, "brdTitle", "");
		
		Board board = null;
		User user = null;
		
		if(brdSeq > 0) {
			
			board = boardService.boardSelect(brdSeq, boardType);
			
			if(board != null) {
				
				user = userService.userSelect(cookieUserId);
				
			}
			
		}
		
		model.addAttribute("user", user);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("board", board);
		model.addAttribute("curPage", curPage);
		model.addAttribute("brdTitle", brdTitle);
		model.addAttribute("boardType", boardType);
		model.addAttribute("boardTitle", boardTitle(boardType));

		return "/board/replyForm";
		
	}
	
	
	//게시글 답글
	@RequestMapping(value="/board/replyProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> replyProc (MultipartHttpServletRequest request, HttpServletResponse response){
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String brdTitle = HttpUtil.get(request, "brdTitle", "");
		String brdContent = HttpUtil.get(request, "brdContent", "");
		FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);
		int boardType = HttpUtil.get(request, "boardType", 1);
		String brdPwd = HttpUtil.get(request, "brdPwd");
		
		if(brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
			
			Board parentBoard = boardService.boardSelect(brdSeq, boardType);
			
			if(parentBoard != null) {
				
				Board board = new Board();
				board.setUserId(cookieUserId);
				board.setBrdTitle(brdTitle);
				board.setBrdContent(brdContent);
				board.setBrdGroup(parentBoard.getBrdGroup());
				board.setBrdOrder(parentBoard.getBrdOrder() + 1);
				board.setBrdIndent(parentBoard.getBrdIndent() + 1);
				board.setBoardType(boardType);
				board.setBrdPwd(brdPwd);
				
				board.setBrdParent(brdSeq);
				
				if(fileData != null && fileData.getFileSize() > 0) {
					
					BoardFile boardFile = new BoardFile();
					boardFile.setFileName(fileData.getFileName());
					boardFile.setFileOrgName(fileData.getFileOrgName());
					boardFile.setFileExt(fileData.getFileExt());
					boardFile.setFileSize(fileData.getFileSize());
					boardFile.setBoardType(boardType);
					
					board.setBoardFile(boardFile);

				}
				
				try {
					
					if(boardService.boardReplyInsert(board) > 0) {
						
						ajaxResponse.setResponse(0, "success");
						
					}else {
						ajaxResponse.setResponse(500, "internal server error(2)");
					}
					
				}catch(Exception e) {
					logger.error("[BoardController] replyProc Exception", e);
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
	
	
	
}
