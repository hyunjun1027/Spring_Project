package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;

@Repository("boardDao")
public interface BoardDao {
	
	//게시글 등록
	public int boardInsert(Board board);
	
	//게시글 첨부파일 등록
	public int boardFileInsert(BoardFile boardFile);
	
	//게시물 리스트
	public List<Board> boardList(Board board);
	
	//총 게시물 수
	public long boardListCount(Board board);
	
	//게시글 상세조회
	public Board boardSelect(@Param("brdSeq")long brdSeq, @Param("boardType")int boardType);
	
	//첨부파일 상세조회
	public BoardFile boardFileSelect(@Param("brdSeq")long brdSeq, @Param("boardType")int boardType);
	
	//게시글 조회수 증가
	public long boardReadCntPlus(@Param("brdSeq")long brdSeq, @Param("boardType")int boardType);
	
	//게시물 그룹내 순서 변경
	public int boardGroupOrderUpdate(Board board);
	
	//게시물 답글 등록
	public int boardReplyInsert(Board board);
	
	//게시글 조회시 답변글수 조회
	public int boardAnswersCount(@Param("brdParent")long brdParent, @Param("boardType")int boardType);
	
	//게시물 삭제
	public int boardDelete(@Param("brdSeq")long brdSeq, @Param("boardType")int boardType);
	
	//게시물 첨부파일 삭제
	public int boardFileDelete(@Param("brdSeq")long brdSeq, @Param("boardType")int boardType);
	
	//게시물 수정
	public int boardUpdate(Board Board);
	
	
	public List<Board> indexBestSelect(Board board);
	
	
	
	
	
	
	
}
