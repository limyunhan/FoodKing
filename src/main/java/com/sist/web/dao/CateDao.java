package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.MainCate;
import com.sist.web.model.SubCate;

@Repository("cateDao")
public interface CateDao {
	public abstract List<MainCate> mainCateList();
	public abstract List<SubCate> subCateList();
}
