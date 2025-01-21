<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/userPage.css" type="text/css">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>
<script>
	$(function() {
		
		//비밀번호 찾기 화면으로 이동
		$("#findPwdBtn").on("click", function() {
		   $(".container").addClass("right-panel-active");
		});
		
		//아이디 찾기 화면으로 이동
		$("#findIdBtn").on("click", function() {
		   $(".container").removeClass("right-panel-active");
		});


		
		//아이디 이름 입력 후(엔터)
		$("#userNameId").on("keypress", function(e) {
			if (e.which == 13)
				fn_FindIdCheck();
		});
		
		//아이디 이메일 입력 후(엔터)
		$("#userEmailId").on("keypress", function(e) {
			if (e.which == 13)
				fn_FindIdCheck();
		});
		
		//아이디 찾기 버튼 (엔터)
		$("#realFindIdBtn").on("keypress", function(e) {
			if (e.which == 13)
				fn_FindIdCheck();
		});
		
		//아이디찾기(버튼)
		$("#realFindIdBtn").on("click", function() {
			fn_FindIdCheck();
		});
		
		
		
		//비밀번호 아이디 입력 후(엔터)
		$("#userIdPwd").on("keypress", function(e) {
			if (e.which == 13)
				fn_FindPwdCheck();
		});
		//비밀번호 이름 입력 후(엔터)
		$("#userNamePwd").on("keypress", function(e) {
			if (e.which == 13)
				fn_FindPwdCheck();
		});
		
		//비밀번호 이메일 입력 후(엔터)
		$("#userEmailPwd").on("keypress", function(e) {
			if (e.which == 13)
				fn_FindPwdCheck();
		});
		
		//비밀번호 찾기 버튼 (엔터)
		$("#realFindPwdBtn").on("keypress", function(e) {
			if (e.which == 13)
				fn_FindPwdCheck();
		});
		
		//비밀번호 찾기(버튼)
		$("#realFindPwdBtn").on("click", function() {
			fn_FindPwdCheck();
		});
   
	});
	
	function fn_displayNone() {
		//아이디
		$("#userNameIdMsg").css("display", "none");
		$("#userEmailIdMsg").css("display", "none");
		//비밀번호
		$("#userIdPwdMsg").css("display", "none");
		$("#userNamePwdMsg").css("display", "none");
		$("#userEmailPwdMsg").css("display", "none");
	}
   
   //아이디 찾기
   function fn_FindIdCheck(){
	   
	   fn_displayNone();
	   
		if($.trim($("#userNameId").val()).length <= 0){	
			$("#userNameIdMsg").text("사용자 이름을 입력하세요.");
			$("#userNameIdMsg").css("display", "inline");
			$("#userNameId").val("");
			$("#userNameId").focus();
			return;	
		}
		
		if($.trim($("#userEmailId").val()).length <= 0){
			$("#userEmailIdMsg").text("사용자 이메일을 입력하세요.");
			$("#userEmailIdMsg").css("display", "inline");
			$("#userEmailId").val("");
			$("#userEmailId").focus();
			return;
			
		}
		
		$.ajax({
			type:"POST",
			url:"/user/findIdProc",
			data:{
				userName:$("#userNameId").val(),
				userEmail:$("#userEmailId").val()
			},
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(!icia.common.isEmpty(response)){
					icia.common.log(response);
					
					var code = icia.common.objectValue(response, "code", -500);
					var data = icia.common.objectValue(response, "data");
					if(code == 0){
						
						alert("회원님의 아이디는 : " + data + " 입니다.");
						location.href="/user/userForm";
						
					}else{
						
						if(code == -1){

							alert("입력값이 올바르지 않습니다.");
							$("#userEmailId").focus();
							
						}else if(code == 404){
							
							alert("일치하는 사용자 정보가 없습니다.");
							$("#userNameId").focus();
							
						}else if(code == 400){
							
							alert("파라미터 값이 올바르지 않습니다.");
							$("#userNameId").focus();
							
						}else{	
							
							alert("오류가 발생하였습니다.(1)");
							$("#userNameId").focus();
							
						}
						
					}
				}else{
					alert("오류가 발생하였습니다.");
					$("#userNameId").focus();
				}
			},
			complete:function(data){
				icia.common.log(data);
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});   
   }
   
   //비밀번호 찾기
   function fn_FindPwdCheck(){
	   
		fn_displayNone();
	   
		if($.trim($("#userIdPwd").val()).length <= 0){
			
			$("#userIdPwdMsg").text("사용자 아이디를 입력하세요.");
			$("#userIdPwdMsg").css("display", "inline");
			$("#userIdPwd").val("");
			$("#userIdPwd").focus();
			return;
			
		}
		
		if($.trim($("#userNamePwd").val()).length <= 0){
			
			$("#userNamePwdMsg").text("사용자 이름을 입력하세요.");
			$("#userNamePwdMsg").css("display", "inline");
			$("#userNamePwd").val("");
			$("#userNamePwd").focus();
			return;
			
		}
		
		if($.trim($("#userEmailPwd").val()).length <= 0){
			
			$("#userEmailPwdMsg").text("사용자 이메일을 입력하세요.");
			$("#userEmailPwdMsg").css("display", "inline");
			$("#userEmailPwd").val("");
			$("#userEmailPwd").focus();
			return;
			
		}
		
		$.ajax({
			type:"POST",
			url:"/user/findPwdProc",
			data:{
				userId:$("#userIdPwd").val(),
				userName:$("#userNamePwd").val(),
				userEmail:$("#userEmailPwd").val()
			},
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(!icia.common.isEmpty(response)){
					icia.common.log(response);
					
					var code = icia.common.objectValue(response, "code", -500);
					
					if(code == 0){
						alert("회원님의 이메일로 임시비밀번호를 발급해드렸습니다.");
						location.href="/user/userForm";
					}else{
						
						if(code == -1){
							
							alert("입력값이 올바르지 않습니다.");
							$("#userEmailPwd").focus();
							
						}else if(code == 404){
							
							alert("일치하는 사용자 정보가 없습니다.");
							$("#userIdPwd").focus();
							
						}else if(code == 400){
							
							alert("파라미터 값이 올바르지 않습니다.");
							$("#userIdPwd").focus();
							
						}else{	
							
							alert("오류가 발생하였습니다.(1)");
							$("#userIdPwd").focus();
							
						}
						
					}
				}else{
					alert("오류가 발생하였습니다.");
					$("#userIdPwd").focus();
				}
			},
			complete:function(data){
				icia.common.log(data);
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
         <div class="sign-up-container">
            <form>
               <a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
               <h1>Find your Password</h1>
               <input type="text" id="userIdPwd" name="userIdPwd" placeholder="Id" style="margin: 30px 0px 6px;">
               <div class="msgBox"><span id="userIdPwdMsg" class="msgText"></span></div>
               
               <input type="text" id="userNamePwd" name="userNamePwd" placeholder="Name">
               <div class="msgBox"><span id="userNamePwdMsg" class="msgText"></span></div>

               <input type="email" id="userEmailPwd" name="userEmailPwd" placeholder="Email">
               <div class="msgBox"><span id="userEmailPwdMsg" class="msgText"></span></div>

               <button type="button" id="realFindPwdBtn" class="form_btn">Find</button>
            </form>
         </div>
         <div class="sign-in-container">
            <form>
               <a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
               <h1>Find your ID</h1>
               <input type="text" id="userNameId" name="userNameId" placeholder="Name" style="margin: 30px 0px 6px;">
               <div class="msgBox"><span id="userNameIdMsg" class="msgText"></span></div>

               <input type="email" id="userEmailId" name="userEmailId" placeholder="Email">
               <div class="msgBox"><span id="userEmailIdMsg" class="msgText"></span></div>

               <div class="find-link">
                  <span><a href="/user/userForm">Are you sure you want to Sign In?</a></span>
               </div>

               <button type="button" id="realFindIdBtn" class="form_btn">Find</button>
            </form>
         </div>
         <div class="overlay-container">
            <div class="overlay-left">
               <h1>Forgot your ID?</h1>
               <p>Finding Account Information</p>
               <button id="findIdBtn" class="overlay_btn">Find ID</button>
            </div>
            <div class="overlay-right">
               <h1>Forgot your Password?</h1>
               <p>Finding Account Information</p>
               <button id="findPwdBtn" class="overlay_btn">Find Pwd</button>
            </div>
         </div>
      </div>
   </div>
   
   <form id="userForm" name="userForm" method="post">
      <input type="hidden" name="userEmailInput" value="" >
   </form>
</body>
</html>