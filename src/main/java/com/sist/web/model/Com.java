package com.sist.web.model;

import java.io.Serializable;

public class Com implements Serializable {

	private static final long serialVersionUID = 1L;
	private long comSeq;
	private String userId;
	private long bbsSeq;
	private String comContent;
	private long comGroup;
	private long comParent;
	private int comOrder;
	private short comIndent;
	private String comStatus;
	private String comRegDate;
	
	public Com() {
		comSeq = 0L;
		userId = "";
		bbsSeq = 0L;
		comContent = "";
		comGroup = 0L;
		comParent = 0L;
		comOrder = 0;
		comIndent = 0;
		comStatus = "";
		comRegDate = "";
	}

	public long getComSeq() {return comSeq;}
	public void setComSeq(long comSeq) {this.comSeq = comSeq;}
	public String getUserId() {return userId;}
	public void setUserId(String userId) {this.userId = userId;}
	public long getBbsSeq() {return bbsSeq;}
	public void setBbsSeq(long bbsSeq) {this.bbsSeq = bbsSeq;}
	public String getComContent() {return comContent;}
	public void setComContent(String comContent) {this.comContent = comContent;}
	public long getComGroup() {return comGroup;}
	public void setComGroup(long comGroup) {this.comGroup = comGroup;}
	public long getComParent() {return comParent;}
	public void setComParent(long comParent) {this.comParent = comParent;}
	public int getComOrder() {return comOrder;}
	public void setComOrder(int comOrder) {this.comOrder = comOrder;}
	public short getComIndent() {return comIndent;}
	public void setComIndent(short comIndent) {this.comIndent = comIndent;}
	public String getComStatus() {return comStatus;}
	public void setComStatus(String comStatus) {this.comStatus = comStatus;}
	public String getComRegDate() {return comRegDate;}
	public void setComRegDate(String comRegDate) {this.comRegDate = comRegDate;}
}
