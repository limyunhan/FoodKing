package com.sist.web.model;

import java.io.Serializable;

public class ComSearch implements Serializable {
	private static final long serialVersionUID = 1L;
	
	// 내가 작성한 댓글 보기를 위한 멤버 
	private String myPageUserId;
	
	// 게시글 댓글 보기를 위한 멤버
	private long bbsSeq;
	
	// 페이징 처리를 위한 멤버
	private long startRow;
	private long endRow;
	
	public ComSearch() {
		bbsSeq = 0L;
		myPageUserId = "";
		startRow = 0L;
		endRow = 0L;
	}
	
	public String getMyPageUserId() {return myPageUserId;}
	public void setMyPageUserId(String myPageUserId) {this.myPageUserId = myPageUserId;}
	public long getBbsSeq() {return bbsSeq;}
	public void setBbsSeq(long bbsSeq) {this.bbsSeq = bbsSeq;}
	public long getStartRow() {return startRow;}
	public void setStartRow(long startRow) {this.startRow = startRow;}
	public long getEndRow() {return endRow;}
	public void setEndRow(long endRow) {this.endRow = endRow;}
}