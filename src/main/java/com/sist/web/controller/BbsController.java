package com.sist.web.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Bbs;
import com.sist.web.model.BbsFile;
import com.sist.web.model.BbsSearch;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.service.BbsService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller
public class BbsController {
	public static Logger logger = LoggerFactory.getLogger(BbsController.class);
	
	private static final int PAGE_COUNT = 5;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private BbsService bbsService;
	
	// 게시글 리스트 페이지
	@RequestMapping(value = "/bbs/list")
	public String list(Model model, HttpServletRequest request) {
		int listCount = HttpUtil.get(request, "listCount", 10);
		long curPage = HttpUtil.get(request, "curPage", 1L);
		
		String cateNum = HttpUtil.get(request, "cateNum", "");
		String cateFilter = HttpUtil.get(request, "cateFilter", "");
		String periodFilter = HttpUtil.get(request, "periodFilter", "");
		String orderBy = HttpUtil.get(request, "orderBy", "1");
		String isSecret = HttpUtil.get(request, "isSecret", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		
		BbsSearch bbsSearch = new BbsSearch();
		bbsSearch.setperiodFilter(periodFilter);
		bbsSearch.setCateFilter(cateFilter);
		bbsSearch.setOrderBy(orderBy);
		bbsSearch.setIsSecret(isSecret);
		bbsSearch.setSearchType(searchType);
		bbsSearch.setSearchValue(searchValue);

		long totalCnt = bbsService.bbsListCnt(bbsSearch);
		List<Bbs> bbsList = null;
		Paging paging = null;
		
		if (totalCnt > 0) {
			paging = new Paging("/bbs/list", totalCnt, listCount, PAGE_COUNT, curPage, "curPage");
			bbsSearch.setStartRow(paging.getStartRow());
			bbsSearch.setEndRow(paging.getEndRow());
			bbsList = bbsService.bbsList(bbsSearch);
		}
		
		model.addAttribute("listCount", listCount);
		model.addAttribute("curPage", curPage);
		
		model.addAttribute("cateNum", cateNum);
		model.addAttribute("cateFilter", cateFilter);
		model.addAttribute("periodFilter", periodFilter);
		model.addAttribute("orderBy", orderBy);
		model.addAttribute("isSecret", isSecret);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		
		model.addAttribute("bbsList", bbsList);

		return "/bbs/list";
	}
	
	// 게시글 보기 페이지
	@RequestMapping(value = "/bbs/view")
	public String view(Model model, HttpServletRequest request, HttpServletResponse response) {
		
		
		
		
		return "/bbs/view";
	}
	
	// 게시글 쓰기 페이지
	@RequestMapping(value = "/bbs/write")
	public String write(Model model, HttpServletRequest request) {
		int listCount = HttpUtil.get(request, "listCount", 10);
		long curPage = HttpUtil.get(request, "curPage", 1L);
		
		String cateNum = HttpUtil.get(request, "cateNum", "");
		String cateFilter = HttpUtil.get(request, "cateFilter", "");
		String periodFilter = HttpUtil.get(request, "periodFilter", "");
		String orderBy = HttpUtil.get(request, "orderBy", "1");
		String isSecret = HttpUtil.get(request, "isSecret", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");

		
		model.addAttribute("listCount", listCount);
		model.addAttribute("curPage", curPage);
		
		model.addAttribute("cateNum", cateNum);
		model.addAttribute("cateFilter", cateFilter);
		model.addAttribute("periodFilter", periodFilter);
		model.addAttribute("orderBy", orderBy);
		model.addAttribute("isSecret", isSecret);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		
		return "/bbs/write";
	}
	
	@RequestMapping(value = "/bbs/writeProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String subCateCombinedNum = HttpUtil.get(request, "subCateCombinedNum", "");
		String bbsTitle = HttpUtil.get(request, "bbsTitle", "");
		String bbsContent = HttpUtil.get(request, "bbsContent", "");
		
		logger.debug("bbsTitle : " + bbsTitle);
		logger.debug("bbsContent : "  + bbsContent);
		
		String bbsPwd = HttpUtil.get(request, "bbsPwd", "");
		
		if (!StringUtil.isEmpty(subCateCombinedNum) && !StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent)) {
			Bbs bbs = new Bbs();
			bbs.setUserId(cookieUserId);
			bbs.setSubCateCombinedNum(subCateCombinedNum);
			bbs.setBbsTitle(bbsTitle);
			bbs.setBbsContent(bbsContent);
			
			if (!StringUtil.isEmpty(bbsPwd)) {
				bbs.setBbsPwd(bbsPwd);
			}
			
			List<FileData> fileDataList = HttpUtil.getFiles(request, "bbsFile", UPLOAD_SAVE_DIR);
			
			if (fileDataList != null) {
				List<BbsFile> bbsFileList = new ArrayList<>();
				
				for (FileData fileData : fileDataList) {
					if (fileData.getFileSize() > 0) {
						BbsFile bbsFile = new BbsFile();
						bbsFile.setBbsFileExt(fileData.getFileExt());
						bbsFile.setBbsFileName(fileData.getFileName());
						bbsFile.setBbsFileOrgName(fileData.getFileOrgName());
						bbsFile.setBbsFileSize(fileData.getFileSize());
						bbsFileList.add(bbsFile);
					}
				}
				
				if (fileDataList.size() > 0) {
					bbs.setBbsFileList(bbsFileList);
				}

			}
			
			try {
				if (bbsService.bbsInsert(bbs)) {
					ajaxResponse.setResponse(200, "게시글 작성 성공");
					
				} else {
					ajaxResponse.setResponse(500, "DB 정합성 오류");
				}
				
			} catch (Exception e) {
				logger.error("[BbsController] writeProc Exception", e);
				ajaxResponse.setResponse(500, "DB 정합성 오류");
			}

		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
			
		}

		return ajaxResponse;
	}
	
	
	
	
}