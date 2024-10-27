package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("indexConroller2")
public class IndexController2 {
	public static Logger logger = LoggerFactory.getLogger(IndexController2.class);
	
	
	@RequestMapping(value = "/index2", method=RequestMethod.GET)
	public String index2(HttpServletRequest request, HttpServletResponse response) {
		return "/index2";
	}
}