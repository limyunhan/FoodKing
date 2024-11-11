package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sist.web.model.Bbs;
import com.sist.web.model.BbsSearch;
import com.sist.web.service.BbsService;

@Controller
public class IndexController {
	public static Logger logger = LoggerFactory.getLogger(IndexController.class);
	
	@Autowired
	private BbsService bbsService;
	
	@RequestMapping(value = "/index", method=RequestMethod.GET)
	public String index(Model model, HttpServletRequest request) {
		BbsSearch bbsSearch = new BbsSearch();
		bbsSearch.setStartRow(1L);
		bbsSearch.setEndRow(8L);
		
		bbsSearch.setCateFilter("02");
		List<Bbs> communityList = bbsService.bbsListForIndex(bbsSearch);
		
		bbsSearch.setCateFilter("03");
		List<Bbs> restoListByRegion = bbsService.bbsListForIndex(bbsSearch);
		
		bbsSearch.setCateFilter("04");
		List<Bbs> restoListByTheme = bbsService.bbsListForIndex(bbsSearch);
		
		bbsSearch.setCateFilter("05");
		List<Bbs> noticeList = bbsService.bbsListForIndex(bbsSearch);
		
		model.addAttribute("communityList", communityList);
		model.addAttribute("restoListByRegion", restoListByRegion);
		model.addAttribute("restoListByTheme", restoListByTheme);
		model.addAttribute("noticeList", noticeList);
		
		return "/index";
	}
}