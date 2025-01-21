package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.CommentDao;
import com.sist.web.model.Board;
import com.sist.web.model.Comment;

@Service("commentService")
public class CommentService {
	
	private static Logger logger = LoggerFactory.getLogger(CommentService.class);
	
	@Autowired
	private CommentDao commentDao;
	
	//댓글 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int commentInsert(Comment comment) throws Exception{
		
		int count = 0;
		count = commentDao.commentInsert(comment);
		
		return count;
		
	}
	
	//댓글 리스트 조회
	public List<Comment> commentList(Comment comment){
		
		List<Comment> list = null;
		
		try {
			
			list = commentDao.commentList(comment);
			
		}catch(Exception e) {
			logger.error("[CommentService] commentList Exception", e);
		}
		
		return list;
		
	}
	
	//댓글 총갯수 조회
	public long commentTotalCount(Comment comment) {
		
		long count = 0;
		
		try {
			
			count = commentDao.commentTotalCount(comment);
			
		}catch(Exception e) {
			logger.error("[CommentService] commentTotalCount Exception", e);
		}
		
		return count;
		
	}
	
	//nostatus댓글 총갯수 조회
	public long commentTotalCount2(Comment comment) {
		
		long count = 0;
		
		try {
			
			count = commentDao.commentTotalCount2(comment);
			
		}catch(Exception e) {
			logger.error("[CommentService] commentTotalCount Exception", e);
		}
		
		return count;
		
	}
	
	
	//댓글의 댓글 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int commentReplyInsert(Comment commnet) throws Exception {
		
		int count = 0;
		
		commentDao.commentGroupOrderUpdate(commnet);
		count = commentDao.commentReplyInsert(commnet);
		
		return count;
		
	}
	
	//댓글 조회
	public Comment commentSelect(long commSeq, int boardType) {
		
		Comment comment = null;
		
		try {
			
			comment = commentDao.commentSelect(commSeq, boardType);
			
		}catch(Exception e) {
			logger.error("[CommentService] commentSelect Exception", e);
		}
		
		return comment;
		
	}
	
	//댓글 삭제
	public int commentDelete(long commSeq, int boardType) {
		
		int count = 0;
		
		try {
			
			count = commentDao.commentDelete(commSeq, boardType);
			
		}catch(Exception e) {
			logger.error("[CommentService] commentDelete Exception", e);
		}
		
		return count;
		
	}
	
	
	
	
	
	
	
	
	
	
}
