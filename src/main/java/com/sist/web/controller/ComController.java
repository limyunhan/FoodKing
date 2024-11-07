package com.sist.web.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Bbs;
import com.sist.web.model.Com;
import com.sist.web.model.ComSearch;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.service.BbsService;
import com.sist.web.service.ComService;
import com.sist.web.util.HttpUtil;

@Controller
public class ComController {
	public static Logger logger = LoggerFactory.getLogger(ComController.class);
	
	private static final int COM_PAGE_COUNT = 100;
	private static final int COM_LIST_COUNT = 5;
	
	@Autowired
	private ComService comService;
	
	@Autowired
	private BbsService bbsService;
	
	// indent가 0인 댓글 작성
	@RequestMapping(value = "/bbs/writeCom", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeCom(Model model, HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId", "");
		long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
		String comContent = HttpUtil.get(request, "comContent", "");
		String comOrderBy = HttpUtil.get(request, "comOrderBy", "1");
		long comCurPage = HttpUtil.get(request, "comCurPage", 1L);
		
		if (bbsSeq > 0 && !StringUtil.isEmpty(userId) && !StringUtil.isEmpty(comContent)) {
			HashMap<String, Object> hashMap = new HashMap<>();
			hashMap.put("userId", userId);
			hashMap.put("bbsSeq", bbsSeq);
			
			Bbs bbs = bbsService.bbsSelect(hashMap);
			
			if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
				Com com = new Com();
				com.setBbsSeq(bbsSeq);
				com.setComContent(comContent);
				com.setUserId(userId);
				
				if (comService.comInsert(com)) {
					ajaxResponse.setResponse(200, "댓글 작성 완료");
					
					ComSearch comSearch = new ComSearch();
					comSearch.setBbsSeq(bbsSeq);
					comSearch.setComOrderBy(comOrderBy);
					
					long totalCnt = comService.comListCnt(comSearch);
					Paging comPaging = null;
					
					if (totalCnt > 0) {
						comPaging = new Paging("/bbs/view", totalCnt, COM_LIST_COUNT, COM_PAGE_COUNT, comCurPage, "comCurPage");
					}
					
					ajaxResponse.setData(comPaging.getEndPage());
					
				} else {
					ajaxResponse.setResponse(500, "DB 정합성 오류");
				}
				
			} else {
				ajaxResponse.setResponse(404, "삭제된 게시글");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
}
