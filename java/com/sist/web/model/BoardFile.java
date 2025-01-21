package com.sist.web.model;

import java.io.Serializable;

public class BoardFile implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private short fileSeq;	    	//파일번호
	private String fileOrgName;		//원본파일명
	private String fileName;	    //서버파일명
	private String fileExt;	    	//파일확장자
	private long fileSize;	    	//파일크기
	private String regDate;    		//등록날짜
	private long brdSeq;	    	//게시물번호
	
	private int boardType;
	
	public BoardFile() {
		fileSeq = 0;	    	//파일번호
		fileOrgName = "";		//원본파일명
		fileName = "";	    	//서버파일명
		fileExt = "";	    	//파일확장자
		fileSize = 0;	    	//파일크기
		regDate = "";    		//등록날짜
		brdSeq = 0;	    		//게시물번호
		
		boardType = 1;
	}

	
	
	public int getBoardType() {
		return boardType;
	}



	public void setBoardType(int boardType) {
		this.boardType = boardType;
	}



	public short getFileSeq() {
		return fileSeq;
	}


	public void setFileSeq(short fileSeq) {
		this.fileSeq = fileSeq;
	}


	public String getFileOrgName() {
		return fileOrgName;
	}


	public void setFileOrgName(String fileOrgName) {
		this.fileOrgName = fileOrgName;
	}


	public String getFileName() {
		return fileName;
	}


	public void setFileName(String fileName) {
		this.fileName = fileName;
	}


	public String getFileExt() {
		return fileExt;
	}


	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}


	public long getFileSize() {
		return fileSize;
	}


	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}


	public String getRegDate() {
		return regDate;
	}


	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}


	public long getBrdSeq() {
		return brdSeq;
	}


	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}

	
	
	
	
	
}
