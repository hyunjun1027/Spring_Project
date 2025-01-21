package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.util.FileUtil;
import com.sist.web.dao.BoardDao;
import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;


@Service("boardService")
public class BoardService {
	
	private static Logger logger = LoggerFactory.getLogger(BoardService.class);
	
	@Autowired
	private BoardDao boardDao;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	//게시글 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardInsert(Board board) throws Exception{
		
		int count = 0;
		
		count = boardDao.boardInsert(board);
		
		if(count > 0 && board.getBoardFile() != null) {
			
			BoardFile boardFile = board.getBoardFile();
			
			boardFile.setBrdSeq(board.getBrdSeq());
			boardFile.setFileSeq((short)1);
			
			boardDao.boardFileInsert(boardFile);
			
		}
		
		return count;
		
	}
	
	
	//게시물 리스트
	public List<Board> boardList(Board board){
		
		List<Board> list = null;
		
		try {
			
			list = boardDao.boardList(board);
			
		}catch(Exception e) {
			logger.error("[BoardService] boardList Exception", e);
		}
		
		return list;
		
	}
	
	//총 게시물 수
	public long boardListCount(Board board) {
		
		long count = 0;
		
		try {
			
			count = boardDao.boardListCount(board);
			
		}catch(Exception e) {
			logger.error("[BoardService] boardListCount Exception", e);
		}
		
		return count;
		
	}
	
	//게시물 조회
	public Board boardSelect(long brdSeq, int boardType) {
		
		Board board = null;
		
		try {
			
			board = boardDao.boardSelect(brdSeq, boardType);
			
		}catch(Exception e) {
			logger.error("[BoardService] boardSelect Exception", e);
		}
		
		return board;
		
	}
	
	//게시물 보기(조회) 첨부파일, 조회수증가 포함
	public Board boardView(long brdSeq, int boardType) {
		
		Board board = null;
		
		try {
			
			board = boardDao.boardSelect(brdSeq, boardType);
			
			if(board != null) {
				
				boardDao.boardReadCntPlus(brdSeq, boardType);
				
				BoardFile boardFile = boardDao.boardFileSelect(brdSeq, boardType);
				
				if(boardFile != null) {
					
					board.setBoardFile(boardFile);
					
				}	
			}
		
		}catch(Exception e) {
			logger.error("[BoardService] boardView Exception", e);
		}
		
		return board;
		
	}
	
	//게시물 답글등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardReplyInsert(Board board) throws Exception{
		
		int count = 0;
		
		boardDao.boardGroupOrderUpdate(board);
		
		count = boardDao.boardReplyInsert(board);
		
		if(count > 0 && board.getBoardFile() != null) {
			
			BoardFile boardFile = board.getBoardFile();
			boardFile.setBrdSeq(board.getBrdSeq());
			boardFile.setFileSeq((short)1);
			
			boardDao.boardFileInsert(boardFile);

		}
		
		return count;
		
	}

	//게시물 삭제관련
	//게시글 조회시 답변글수 조회
	public int boardAnswersCount(long brdSeq, int boardType) {
		
		int count = 0;
		
		try {
			
			count = boardDao.boardAnswersCount(brdSeq, boardType);
			
		}catch(Exception e) {
			logger.error("[BoardService] boardAnswersCount Exception", e);
		}
		
		return count;
		
	}
	//게시물 삭제관련
	//게시물 수정폼 조회(첨부파일 포함)
	public Board boardViewUpdate(long brdSeq, int boardType) {
		
		Board board = null;
		
		try {
			
			board = boardDao.boardSelect(brdSeq, boardType);
			
			if(board != null) {
				
				BoardFile boardFile = boardDao.boardFileSelect(brdSeq, boardType);
				
				if(boardFile != null) {
					
					board.setBoardFile(boardFile);;
					
				}
				
			}
			
		}catch(Exception e) {
			logger.error("[BoardService] boardViewUpdate Exception", e);
		}
		
		return board;
		
	}
	
	//게시물 삭제(첨부파일이 있으면 함께 삭제)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardDelete(long brdSeq, int boardType) throws Exception{
		
		int count = 0;
		
		//같은 클래스 안에있기때문에 new는 없어도 된다.
		Board board = boardViewUpdate(brdSeq, boardType);
		
		if(board != null) {
			
			if(board.getBoardFile() != null) {
				
				if(boardDao.boardFileDelete(brdSeq, boardType) > 0) {
				
					//첨부파일도 함께 삭제 처리
					FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator()
												+ board.getBoardFile().getFileName());
					
				}
				
			}
			
			count = boardDao.boardDelete(brdSeq, boardType);
			
		}
		
		return count;
		
	}
	

	//게시글 수정
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardUpdate(Board board, int boardType) throws Exception {
		
		int count = 0;
		
		count = boardDao.boardUpdate(board);
		
		if(count > 0 && board.getBoardFile() != null) {
			BoardFile delBoardFile = boardDao.boardFileSelect(board.getBrdSeq(), boardType);
			
			if(delBoardFile != null) {
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() 
															+ delBoardFile.getFileName());
				boardDao.boardFileDelete(board.getBrdSeq(), boardType);
			}
		
			BoardFile boardFile = board.getBoardFile();
			boardFile.setBrdSeq(board.getBrdSeq());
			boardFile.setFileSeq((short)1);
			
			boardDao.boardFileInsert(board.getBoardFile());
		}
		
		return count;
	}
	
	
	
	
	//첨부파일 조회
	public BoardFile boardFileSelect(long brdSeq, int boardType) {
		
		BoardFile boardFile = null;
		
		try {
			
			boardFile = boardDao.boardFileSelect(brdSeq, boardType);
			
		}catch(Exception e) {
			logger.error("[BoardService] boardFileSelect Exception", e);
		}
		
		return boardFile;
		
	}

	
	public List<Board> indexBestSelect(Board board){
		
		List<Board> list = null;
		
		try {
			
			list = boardDao.indexBestSelect(board);
			
		}catch(Exception e) {
			logger.error("[BoardService] indexBestSelect Exception", e);
		}
		
		return list;
		
	}
	
	
	
	

	
	
}
