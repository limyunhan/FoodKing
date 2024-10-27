/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.view
 * 파일명     : FileDownloadView.java
 * 작성일     : 2021. 1. 22.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.view.AbstractView;

import com.sist.common.util.StringUtil;
import com.sist.web.util.HttpUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.view
 * 파일명     : FileDownloadView.java
 * 작성일     : 2021. 1. 22.
 * 작성자     : daekk
 * 설명       : 파일 다운로드 뷰
 * </pre>
 */
public class FileDownloadView extends AbstractView {
	private static Logger logger = LoggerFactory.getLogger(FileDownloadView.class);

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.springframework.web.servlet.view.AbstractView#renderMergedOutputModel(
	 * java.util.Map, javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse)
	 */

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		File file = (File) model.get("file");
		String fileName = (String) model.get("fileName");

		// 파일이 존재하면
		if (file.exists() && file.isFile()) {
			// 파일명이 없으면 파일 객체의 파일명 사용
			if (StringUtil.isEmpty(fileName)) {
				fileName = file.getName();
			}

			// 다운로드 파일명 설정
			String downloadFileName = getDownloadFileName(request, fileName);

			response.setContentType("application/octet-stream");
			response.setContentLength((int) file.length());
			response.setHeader("Content-Disposition", "attachment; filename=\"" + downloadFileName + "\";");
			response.setHeader("Content-Transfer-Encoding", "binary");

			// try-with-resources 구문 사용으로 자동 리소스 해제
			try (FileInputStream inputStream = new FileInputStream(file);
					OutputStream outputStream = response.getOutputStream()) {

				byte[] buffer = new byte[4096];
				int byteRead;

				while ((byteRead = inputStream.read(buffer)) != -1) {
					outputStream.write(buffer, 0, byteRead);
				}
			} catch (Exception e) {
				logger.error("[FileDownloadView] Exception", e);
				throw e;
			}
		} else {
			logger.error("[FileDownloadView] file not found");
			throw new Exception("[FileDownloadView] file not found");
		}
	}

	private String getDownloadFileName(HttpServletRequest request, String fileName) throws Exception {
		String userAgent = HttpUtil.getHeader(request, "User-Agent");

		if (userAgent.contains("MSIE") || userAgent.contains("Trident")) {
			// IE 브라우저 처리
			return StringUtil.replace(HttpUtil.getUrlEncode(fileName, "UTF-8"), "\\+", "%20");
		} else if (userAgent.contains("Chrome")) {
			// 크롬 브라우저 처리
			StringBuilder sb = new StringBuilder();
			for (char c : fileName.toCharArray()) {
				if (c > '~') {
					sb.append(HttpUtil.getUrlEncode(String.valueOf(c), "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			return sb.toString();
		} else {
			// 기타 브라우저 처리
			return new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
		}
	}
}
