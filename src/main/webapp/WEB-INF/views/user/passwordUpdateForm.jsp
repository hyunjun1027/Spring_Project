<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/passwordPage.css" type="text/css">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>
<script>
	$(function() {
		
		//기존비밀번호 입력 후(엔터)
		$("#userPwd").on("keypress", function(e) {
			if (e.which == 13)
				fn_UpdatePwdCheck();
		});
		
		//새로운 비밀번호 입력 후 (엔터)
		$("#userPwd1").on("keypress", function(e) {
			if (e.which == 13)
				fn_UpdatePwdCheck();
		});
		
		//새로운 비밀번호 확인 입력 후 (엔터)
		$("#userPwd2").on("keypress", function(e) {
			if (e.which == 13)
				fn_UpdatePwdCheck();
		});
		
		//비밀번호 변경(버튼)
		$("#realPwdUpdateBtn").on("click", function() {
			fn_UpdatePwdCheck();
		});
		
   
	});
	
	function fn_displayNone() {
		//비밀번호
		$("#userPwdMsg").css("display", "none");
		$("#userPwd1Msg").css("display", "none");
		$("#userPwd2Msg").css("display", "none");
	}
   
   //비밀번호 변경
   function fn_UpdatePwdCheck(){
	   
		fn_displayNone();
	   
		if($.trim($("#userPwd").val()).length <= 0){
			
			$("#userPwdMsg").text("기존 비밀번호를 입력하세요.");
			$("#userPwdMsg").css("display", "inline");
			$("#userPwd").val("");
			$("#userPwd").focus();
			return;
			
		}
		
		if($.trim($("#userPwd1").val()).length <= 0){
			
			$("#userPwd1Msg").text("새로운 비밀번호를 입력하세요.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
			
		}
		
		if($.trim($("#userPwd2").val()).length <= 0){
			
			$("#userPwd2Msg").text("새로운 비밀번호 확인을 입력하세요.");
			$("#userPwd2Msg").css("display", "inline");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
			
		}
		
		if($("#userPwd1").val() != $("#userPwd2").val()){
			
			$("#userPwd2Msg").text("비밀번호가 일치하지 않습니다.");
			$("#userPwd2Msg").css("display", "inline");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
			
		}
		
		$("#userPwd1").val($("#userPwd2").val());
		
		$.ajax({
			type:"POST",
			url:"/user/passwordUpdateProc",
			data:{
				userId:$("#userId").val(),
				userPwd:$("#userPwd").val(),
				userNewPwd:$("#userPwd1").val()
			},
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				  if(response.code == 0){
					  
					  alert("비밀번호가 수정되었습니다.");
					  location.href="/";
					  
				  }else if(response.code == 400){
					  
					  alert("파라미터 값이 올바르지 않습니다.");
					  $("#userPwd1").focus();
					  
				  }else if(response.code == 404){
					  
					  alert("회원정보가 존재하지 않습니다.");
					  location.href="/";
					  
				  }else if(response.code == 410){
					  
					  alert("로그인을 먼저 하세요.");
					  location.href="/";
					  
				  }else if(response.code == 430){
					  
					  alert("아이디 정보가 다릅니다.");
					  location.href="/";
					  
				  }else if(response.code == 431){
					  
					  alert("기존 비밀번호 일치하지 않습니다.");					  
					  $("#userPwd").val("");
					  $("#userPwd").focus();
					  
				  }else if(response.code == 500){
					  
					  alert("비밀번호 수정 중 오류가 발생하였습니다.");
					  $("#userPwd").focus();
					  
				  }else{
					  
					  alert("비밀번호 수정 중 오류 발생");
					  $("#userPwd").focus();
					  
				  }
				
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
   }
   
   
   
   

   function fn_validateEmail(value) {
      var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

      return emailReg.test(value);
   }
</script>
</head>
<body>
   <div class="wrapper findWrap">
      <div class="container">
         <div class="sign-in-container">
            <form>
               <a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
               <h1>Change your Password</h1>
               <input type="text" id="userId" name="userId" value="${user.userId}" readonly>
               
			   <input type="password" id="userPwd" name="userPwd"
				   value="" placeholder="Password">
			   <div class="msgBox">
				   <span id="userPwdMsg" class="msgText"></span>
			   </div>
			
			   <input type="password" id="userPwd1" name="userPwd1"
				   placeholder="New Password">
			   <div class="msgBox">
				   <span id="userPwd1Msg" class="msgText"></span>
			   </div>
			
			   <input type="password" id="userPwd2" name="userPwd2"
				   placeholder="New Password Check">
			   <div class="msgBox">
				   <span id="userPwd2Msg" class="msgText"></span>
			   </div>
			   
			   <input type="hidden" id="userPwd" name="userPwd" value="">

               <button type="button" id="realPwdUpdateBtn" class="form_btn">Password Update</button>
            </form>
         </div>
         <div class="overlay-container">
            <div class="overlay-left">
               <h1>Forgot your ID?</h1>
               <p>Finding Account Information</p>
               <button id="findIdBtn" class="overlay_btn">Find ID</button>
            </div>
            <div class="overlay-right">
               <h1>Hello, Friend</h1>
               <p>Change your password and keep it secure.</p>
            </div>
         </div>
      </div>
   </div>
   
   <form id="userForm" name="userForm" method="post">
      <input type="hidden" name="userEmailInput" value="" >
   </form>
</body>
</html>