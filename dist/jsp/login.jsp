<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>MATRIX - 登陆</title>
	<%@ include file="inc/meta.inc" %>
	<link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/login.css?ver=$revxxx$">
</head>
<body>
	<div class="login-box clearfix">
		<div class="left"></div>
		<div class="right">
			<div class="text">登陆</div>
			<input type="text" class="user-name png" placeholder="请输入您的用户名">
			<input type="password" class="password png" placeholder="请输入您的密码">
			<div class="submit-login">登陆</div>
		</div>
		<div class="connect">联系我们：400-818-1818 | 邮件沟通：chao.lin@renren-inc.com</div>
	</div>
</body>
<script type="text/javascript">
$(function(){
	require(["login"],function(login){
		login.init();
	})
})
</script>
</html>
