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
	
	// 댓글 정렬을 위한 멤버, 1 : 등록 순, 2 : 최신 순, 3 : 답글 순
	private String comOrderBy;
	
	public ComSearch() {
		bbsSeq = 0L;
		myPageUserId = "";
		startRow = 0L;
		endRow = 0L;
		comOrderBy = "";
	}
	
	public String getMyPageUserId() {return myPageUserId;}
	public void setMyPageUserId(String myPageUserId) {this.myPageUserId = myPageUserId;}
	public long getBbsSeq() {return bbsSeq;}
	public void setBbsSeq(long bbsSeq) {this.bbsSeq = bbsSeq;}
	public long getStartRow() {return startRow;}
	public void setStartRow(long startRow) {this.startRow = startRow;}
	public long getEndRow() {return endRow;}
	public void setEndRow(long endRow) {this.endRow = endRow;}
	public String getComOrderBy() {return comOrderBy;}
	public void setComOrderBy(String comOrderBy) {this.comOrderBy = comOrderBy;}
}