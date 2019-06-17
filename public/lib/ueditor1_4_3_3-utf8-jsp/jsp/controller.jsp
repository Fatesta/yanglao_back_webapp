<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="
		java.util.HashMap,
		java.util.Map,
		java.io.File,
		org.springframework.web.multipart.MultipartFile,
		org.springframework.web.multipart.MultipartHttpServletRequest,
        org.springframework.web.multipart.commons.CommonsMultipartResolver,
        org.springframework.web.multipart.commons.CommonsMultipartFile,
        org.apache.commons.fileupload.disk.DiskFileItem,
        it.sauronsoftware.jave.MultimediaInfo,
        it.sauronsoftware.jave.Encoder,
		com.fasterxml.jackson.databind.ObjectMapper,
		com.baidu.ueditor.ActionEnter,
		com.xtxk.hb.framework.model.Result,
		com.xtxk.hb.info.InfoService"
    pageEncoding="UTF-8"%>
    
<%@ page trimDirectiveWhitespaces="true" %>

<%
	String action = request.getParameter("action");
	request.setCharacterEncoding( "utf-8" );
    response.setHeader("Content-Type" , "text/html");
    
	if ("uploadvideo".equals(action) || "uploadfile".equals(action)) {
	    CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());
        MultipartHttpServletRequest multipartRequest = multipartResolver.resolveMultipart(request);
        MultipartFile file = multipartRequest.getFile("upfile");
        Result ret = InfoService.uploadFile(file);
        
        CommonsMultipartFile cf= (CommonsMultipartFile)file;
        DiskFileItem fi = (DiskFileItem)cf.getFileItem();
        File source = fi.getStoreLocation();
        Encoder encoder = new Encoder();
        MultimediaInfo m = encoder.getInfo(source);

        long duration = m.getDuration()/1000; //时长,单位秒

        Map<String, Object> retMap = new HashMap<String, Object>();
        retMap.put("state", ret.isSuccess() ? "SUCCESS" : "");
        retMap.put("url", ret.getData());
        retMap.put("title", file.getOriginalFilename());
        retMap.put("original", file.getOriginalFilename());
        retMap.put("duration", duration);
        String retJSON = new ObjectMapper().writeValueAsString(retMap);
        out.write(retJSON);
	} else if ("uploadimage".equals(action)) {
        CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());
        MultipartHttpServletRequest multipartRequest = multipartResolver.resolveMultipart(request);
        MultipartFile file = multipartRequest.getFile("upfile");
        Result ret = InfoService.uploadFile(file);
        
        Map<String, Object> retMap = new HashMap<String, Object>();
        retMap.put("state", ret.isSuccess() ? "SUCCESS" : "");
        retMap.put("url", ret.getData());
        retMap.put("title", file.getOriginalFilename());
        retMap.put("original", file.getOriginalFilename());
        String retJSON = new ObjectMapper().writeValueAsString(retMap);
        out.write(retJSON);
    } else if ("config".equals(action)) {
	    String rootPath = application.getRealPath( "/" );
	    String configJSON = new ActionEnter( request, rootPath ).exec();
	    configJSON = configJSON.replaceAll("urlPath/",
	        request.getServletContext().getAttribute("urlPath").toString());
	    out.write( configJSON );
	} else {
        String rootPath = application.getRealPath( "/" );
        out.write( new ActionEnter( request, rootPath ).exec() );
    }
%>