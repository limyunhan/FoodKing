package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sist.web.service.BbsService;
import com.sist.web.util.HttpUtil;

@Controller
public class BbsController {
	public static Logger logger = LoggerFactory.getLogger(BbsController.class);
	
	@Autowired
	private BbsService bbsService;
	
	@RequestMapping(value = "/bbs/list")
	public String list(Model model, HttpServletRequest request, HttpServletResponse response) {
		String cateNum = HttpUtil.get(request, "cateNum", "");



		model.addAttribute("mainCateNum", cateNum.substring(0, 2));
		model.addAttribute("subCateCombinedNum", cateNum);
		
		return "/bbs/list";
	}
	
	@RequestMapping(value = "/bbs/view")
	public String view(Model model, HttpServletRequest request, HttpServletResponse response) {
		
		
		return "/bbs/view";
	}
	
	@RequestMapping(value = "/bbs/write")
	public String write(Model model, HttpServletRequest request, HttpServletResponse response) {
		
		
		
		return "/bbs/write";
	}
	
}