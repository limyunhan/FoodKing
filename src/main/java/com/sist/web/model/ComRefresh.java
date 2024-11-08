package com.sist.web.model;

import java.io.Serializable;
import java.util.List;

public class ComRefresh implements Serializable {
	private static final long serialVersionUID = 1L;
	private long comCurPage;
	private String comOrderBy;
	// private Bbs bbs;
	private Paging comPaging;
	private List<Com> comList;	
	private int bbsComCnt;
	
	public ComRefresh() {
		comCurPage = 0L;
		comOrderBy = "";
		comList = null;
		comPaging = null;
		bbsComCnt = 0;
	}

	public long getComCurPage() {return comCurPage;}
	public void setComCurPage(long comCurPage) {this.comCurPage = comCurPage;}
	public List<Com> getComList() {return comList;}
	public void setComList(List<Com> comList) {this.comList = comList;}
	public String getComOrderBy() {return comOrderBy;}
	public void setComOrderBy(String comOrderBy) {this.comOrderBy = comOrderBy;}
	public Paging getComPaging() {return comPaging;}
	public void setComPaging(Paging comPaging) {this.comPaging = comPaging;}

	public int getBbsComCnt() {
		return bbsComCnt;
	}

	public void setBbsComCnt(int bbsComCnt) {
		this.bbsComCnt = bbsComCnt;
	}
	

}