package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.CateDao;
import com.sist.web.model.MainCate;
import com.sist.web.model.SubCate;

@Service("cateService")
public class CateService {
	public static Logger logger = LoggerFactory.getLogger(CateService.class);
	
	@Autowired
	private CateDao cateDao;
	
	public List<MainCate> mainCateList() {
		List<MainCate> list = null;
		
		try {
			list = cateDao.mainCateList();
		} catch (Exception e) {
			logger.error("[CateService] mainCateList Exception", e);
		}
		
		return list;
	}
	
	public List<SubCate> subCateList() {
		List<SubCate> list = null;
		
		try {
			list = cateDao.subCateList();
		} catch (Exception e) {
			logger.error("[CateService] subCateList Exception", e);
		}
		
		return list;
	}
}
