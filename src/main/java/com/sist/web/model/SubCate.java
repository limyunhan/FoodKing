package com.sist.web.model;

import java.io.Serializable;

public class SubCate implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String subCateCombinedNum;
	private String subCateNum;
	private String subCateName;
	private String mainCateNum;
	
	public SubCate() {
		subCateCombinedNum = "";
		subCateNum = "";
		subCateName = "";
		mainCateNum = "";
	}

	public String getSubCateCombinedNum() {return subCateCombinedNum;}
	public void setSubCateCombinedNum(String subCateCombinedNum) {this.subCateCombinedNum = subCateCombinedNum;}
	public String getSubCateNum() {return subCateNum;}
	public void setSubCateNum(String subCateNum) {this.subCateNum = subCateNum;}
	public String getSubCateName() {return subCateName;}
	public void setSubCateName(String subCateName) {this.subCateName = subCateName;}
	public String getMainCateNum() {return mainCateNum;}
	public void setMainCateNum(String mainCateNum) {this.mainCateNum = mainCateNum;}
}
