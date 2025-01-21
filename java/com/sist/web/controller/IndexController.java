/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 1. 21.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.resource.HttpResource;

import com.sist.web.model.Board;
import com.sist.web.model.User;
import com.sist.web.service.BoardService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 1. 21.
 * 작성자     : daekk
 * 설명       : 인덱스 컨트롤러
 * </pre>
 */
@Controller("indexController")
public class IndexController
{
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	public UserService userService;
	
	@Autowired
	private BoardService boardService;
	
	
	
	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	/**
	 * <pre>
	 * 메소드명   : index
	 * 작성일     : 2021. 1. 21.
	 * 작성자     : daekk
	 * 설명       : 인덱스 페이지 
	 * </pre>
	 * @param request  HttpServletRequest
	 * @param response HttpServletResponse
	 * @return String
	 */
	@RequestMapping(value = "/index", method=RequestMethod.GET)
	public String index(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

	    int boardType = HttpUtil.get(request, "boardType", 1);    
	    String searchType = HttpUtil.get(request, "searchType", "");
	    String searchValue = HttpUtil.get(request, "searchValue", "");
	    long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
	    long curPage = HttpUtil.get(request, "curPage", (long)1);
	    
	    List<Board> list = null;
	    
	    Board board = new Board();
	
	    list = boardService.indexBestSelect(board);
	    
	    model.addAttribute("list", list);
	    model.addAttribute("brdSeq", brdSeq);
	    model.addAttribute("searchType", searchType);
	    model.addAttribute("searchValue", searchValue);
	    model.addAttribute("curPage", curPage);
	    model.addAttribute("boardType", boardType);
	
		return "/index";
	}


	
	
	
	
	
	
	
}
