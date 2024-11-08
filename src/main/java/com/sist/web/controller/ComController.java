package com.sist.web.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Bbs;
import com.sist.web.model.Com;
import com.sist.web.model.ComRefresh;
import com.sist.web.model.Response;
import com.sist.web.service.BbsService;
import com.sist.web.service.ComService;
import com.sist.web.util.HttpUtil;

@Controller
public class ComController {
	public static Logger logger = LoggerFactory.getLogger(ComController.class);

	@Autowired
	private ComService comService;
	
	@Autowired
	private BbsService bbsService;
	
	// indent가 0인 댓글 작성
	@RequestMapping(value = "/bbs/writeCom", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeCom(HttpServletRequest request) {
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
					ComRefresh comRefresh = comService.getComRefresh(bbsSeq, comOrderBy, comCurPage);
					bbs = bbsService.bbsSelect(hashMap);
		            comRefresh.setBbsComCnt(bbs.getBbsComCnt());
		            
					ajaxResponse.setResponse(200, "댓글 작성 완료", comRefresh);
					
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
	
	@RequestMapping(value = "/bbs/refreshCom", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> refreshCom(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId", "");
		long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
		String comOrderBy = HttpUtil.get(request, "comOrderBy", "1");
		long comCurPage = HttpUtil.get(request, "comCurPage", 1L);
		
		if (bbsSeq > 0 && !StringUtil.isEmpty(userId)) {
			HashMap<String, Object> hashMap = new HashMap<>();
			hashMap.put("userId", userId);
			hashMap.put("bbsSeq", bbsSeq);
			
			Bbs bbs = bbsService.bbsSelect(hashMap);

			if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
				ComRefresh comRefresh = comService.getComRefresh(bbsSeq, comOrderBy, comCurPage);
				bbs = bbsService.bbsSelect(hashMap);
	            comRefresh.setBbsComCnt(bbs.getBbsComCnt());
				
	            ajaxResponse.setResponse(200, "댓글 작성 완료", comRefresh);
	            
			} else {
				ajaxResponse.setResponse(404, "삭제된 게시글");
			}

		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/bbs/writeComReply", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeComReply(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		long comSeq = HttpUtil.get(request, "comSeq", -1L);
		long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
		String userId = HttpUtil.get(request, "userId", "");
		String comContent = HttpUtil.get(request, "comContent", "");
		
		if (comSeq > 0 && bbsSeq > 0 && !StringUtil.isEmpty(userId) && !StringUtil.isEmpty(comContent)) {
			HashMap<String, Object> hashMap = new HashMap<>();
			hashMap.put("userId", userId);
			hashMap.put("bbsSeq", bbsSeq);
			
			Bbs bbs = bbsService.bbsSelect(hashMap);
			if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
				Com parentCom = comService.comSelect(comSeq);
				
				if (parentCom != null && StringUtil.equals(parentCom.getComStatus(), "Y")) {
					Com childCom = new Com();
					childCom.setBbsSeq(bbsSeq);
					childCom.setUserId(userId);
					childCom.setComContent(comContent);
					childCom.setComGroup(parentCom.getComGroup());
					childCom.setComIndent((short)(parentCom.getComIndent() + 1));
					childCom.setComOrder(parentCom.getComOrder() + 1);
					childCom.setComParent(comSeq);
					
					try {
						if(comService.comReplyInsert(childCom)) {
							ajaxResponse.setResponse(200, "자식 댓글 삽입 성공");
							
						} else {
							ajaxResponse.setResponse(500, "DB 정합성 오류");
						}
						
					} catch (Exception e) {
						logger.error("[ComController] writeComReply Exception", e);
						ajaxResponse.setResponse(500, "DB 정합성 오류");
					}
					
				} else {
					ajaxResponse.setResponse(410,"삭제되거나 존재하지 않는 댓글");
				}
				
			} else {
				ajaxResponse.setResponse(404, "삭제되거나 존재하지 않는 게시글");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
	
}
