package com.sist.web.model;

import java.io.Serializable;

public class MainCate implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String mainCateNum;
	private String mainCateName;
	
	public MainCate() {
		mainCateNum = "";
		mainCateName = "";
	}
	
	public String getMainCateNum() {return mainCateNum;}
	public void setMainCateNum(String mainCateNum) {this.mainCateNum = mainCateNum;}
	public String getMainCateName() {return mainCateName;}
	public void setMainCateName(String mainCateName) {this.mainCateName = mainCateName;}
}