package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Comment;

@Repository("commentDao")
public interface CommentDao {
	
	//댓글등록
	public int commentInsert(Comment comment);
	
	//댓글리스트
	public List<Comment> commentList(Comment comment);
	//댓글총갯수
	public long commentTotalCount(Comment commnet);
	
	//삭제여부 상관없는 댓글총갯수
	public long commentTotalCount2(Comment commnet); 
	
	public int commentGroupOrderUpdate(Comment commnet);
	//댓글의 답글 등록
	public int commentReplyInsert(Comment commnet);
	
	//댓글조회
	public Comment commentSelect(@Param("commSeq")long commSeq, @Param("boardType")int boardType);
	
	//댓글 삭제
	public int commentDelete(@Param("commSeq")long commSeq, @Param("boardType")int boardType);
	
}
