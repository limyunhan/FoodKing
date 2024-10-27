/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.view
 * 파일명     : ZipFileDownloadView.java
 * 작성일     : 2021. 1. 22.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.view.AbstractView;

import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.util.HttpUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.view
 * 파일명     : ZipFileDownloadView.java
 * 작성일     : 2021. 1. 22.
 * 작성자     : daekk
 * 설명       : zip 파일 다운로드 뷰
 * </pre>
 */
public class ZipFileDownloadView extends AbstractView {
    private static final Logger logger = LoggerFactory.getLogger(ZipFileDownloadView.class);
	
    
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

        @SuppressWarnings("unchecked")
        Map<String, File> fileMap = (Map<String, File>) model.get("fileMap");
        String zipFileName = (String) model.get("zipFileName");
        
        if (fileMap == null || fileMap.isEmpty()) {
            logger.error("[ZipFileDownloadView] No files found for download");
            throw new Exception("[ZipFileDownloadView] No files found for download");
        }

        // 파일명이 없다면 기본 이름 지정
        if (StringUtil.isEmpty(zipFileName)) {
            zipFileName = "download.zip";
        }

        String downloadFileName = getEncodedFileName(request, zipFileName);

        response.setContentType("application/zip");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + downloadFileName + "\";");
        response.setHeader("Content-Transfer-Encoding", "binary");

        try (OutputStream outputStream = response.getOutputStream();
             ZipOutputStream zipOut = new ZipOutputStream(outputStream)) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            for (Map.Entry<String, File> entry : fileMap.entrySet()) {
                String originalFileName = entry.getKey();
                File file = entry.getValue();

                if (FileUtil.isFile(file)) {
                    try (FileInputStream inputStream = new FileInputStream(file)) {
                        ZipEntry zipEntry = new ZipEntry(originalFileName);
                        zipOut.putNextEntry(zipEntry);

                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            zipOut.write(buffer, 0, bytesRead);
                        }
                        zipOut.closeEntry();
                    }
                }
            }

            zipOut.finish();
        } catch (Exception e) {
            logger.error("[ZipFileDownloadView] Exception", e);
            throw e;
        }
    }

    /**
     * 브라우저에 맞는 파일명 인코딩 처리
     */
    private String getEncodedFileName(HttpServletRequest request, String fileName) throws Exception {
        String userAgent = HttpUtil.getHeader(request, "User-Agent");
        String downloadFileName;

        if (userAgent.contains("MSIE") || userAgent.contains("Trident")) {
            downloadFileName = StringUtil.replace(HttpUtil.getUrlEncode(fileName, "UTF-8"), "\\+", "%20");
        } else if (userAgent.contains("Chrome")) {
            StringBuilder sb = new StringBuilder();
            for (char c : fileName.toCharArray()) {
                if (c > '~') {
                    sb.append(HttpUtil.getUrlEncode(String.valueOf(c), "UTF-8"));
                } else {
                    sb.append(c);
                }
            }
            downloadFileName = sb.toString();
        } else {
            downloadFileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
        }
        return downloadFileName;
    }
}