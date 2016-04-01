<!doctype html>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
    <meta charset="utf-8" />
    <meta contain="telephone=no" name="format-detection" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no"/>
    <title>申请开户</title>
    <link type="text/css" rel="stylesheet"  href="http://s.xnimg.cn/external/matrix/css/signup.css?ver=$revxxx$">
</head>
<body>
    <div class="poster">
        <img src="http://s.xnimg.cn/external/matrix/images/poster.jpg" alt="">
    </div>
    <div class="form">
        <div class="title">欢迎使用MATRIX</div>
        <div class="applyForm">
            <div class='line'>
                <span>真实姓名：</span>
                <input class="name" type="text" placeholder="">            
            </div>
            <div class='line'>
                <span>手机号码：</span>
                <input onkeydown="onlyNum();" class="tel" type="tel" name="num" maxlength="11"  placeholder="">         
            </div>
            <div class='line'>
                <span>协助申请人代码：</span>
                <input class="assist" type="password" placeholder="">          
            </div>
            <div class='line'>
                <span>公司邮箱：</span>
                <input class="email" type="email" placeholder="">            
            </div>
            <div class='line noline'>
                <span>机构名称：</span>
                <input class="organization" type="text" placeholder="">            
            </div>
            
        </div>
        <div class="apply"><p>申请开户</p></div>
        <p>已有Matrix账户？请登录<a href="javascript:void(0)">Matrix.sofund.com</a>体验我们的服务</p>
    </div>
    <div class="footer">
       <p>客服热线:400-818-1788</p>
    </div>
    <script src='http://s.xnimg.cn/ajax/zepto/zepto-1.1.0.all.min.js'></script>
    <script type="text/javascript">
    ;(function(){
    window.onresize = r;
    function r(resizeNum){
        var winW = window.innerWidth;
        document.getElementsByTagName("html")[0].style.fontSize=winW*0.15625+"px";
        if(winW>window.screen.width&&resizeNum<=10){
            setTimeout(function(){
                r(++resizeNum)
            }, 100);
        }
        else{
            document.getElementsByTagName("body")[0].style.opacity = 1;
        }
    }
    setTimeout(function(){r(0)}, 100);
    apply();
    })();
    function apply(){
        $('.apply').tap(function(){
        	var realName=$('.name').val();
	        var mobile=$('.tel').val();
	        var assistManager=$('.assist').val();
	        var email=$('.email').val();
	        var organization=$('.organization').val();
	        if (realName==''){
	        	$.toast('请输入真实姓名')
	        	return false;
	        }
	        if(!$(".tel").val().match(/^(((13[0-9]{1})|(14[0-9]{1})|(18[0-9]{1})|(15[0-9]{1}))+\d{8})$/)){ 
			    $.toast("手机号码格式不正确！");  
			    return false;
		  	}
		  	if(assistManager==''){
		  		$.toast('请输入协助申请人');
		  		return false;
		  	}
		  	if(email==''){
		  		$.toast('邮箱不能为空');
		  		return false;
		  	}
		  	if(organization==''){
		  		$.toast('机构名称不能为空');
		  		return false;
		  	}
	        $.ajax({
			    url:"/account/signup",
			    type:"post",
			    data:{
			      realName:realName,
			      mobile:mobile,
			      email:email,
			      assistManager:assistManager,
			      organization:organization
			    },
			    dataType: "json",
			    success:function(result){
			      if(result.code==0){
			        $.toast('开户成功！用户名为您的公司邮箱，密码为您的手机号.'); 
                    window.location.reload();
			      }
			      if(result.code!=0){
			        $.toast(result.msg); 
			      }
			    } 
			})
        })       
    }
    $.toast=function(_text,_delay){
	  $(".toast").remove();
	  $("body").append("<div class='toast'>"+_text+"</div>");
	  clearTimeout(toastTime);
	  var toastTime = setTimeout(function(){
	    $(".toast").remove();
	  },_delay||2000);
	}
    function onlyNum()
    {
     if(!(event.keyCode==8))
      if(!(event.keyCode>=48&&event.keyCode<=57))
        event.returnValue=false;
    }
    </script>
</body>
</html>