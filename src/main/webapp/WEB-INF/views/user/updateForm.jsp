<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/userPage.css"
	type="text/css">
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>
<script>
	$(function() {
		//회원정보 수정 버튼 클릭 시
		$("#updateBtn").on("click", function() {
			fn_UpdateCheck();
		});
		
		//회원탈퇴 버튼 클릭 시
		$("#withdrawalBtn").on("click", function() {
			fn_DeleteCheck();
		});
		
		//이름 입력 후(엔터)
		$("#userName").on("keypress", function(e) {
			if (e.which == 13)
				fn_UpdateCheck();
		});
		//비밀번호 입력 후(엔터)
		$("#userPwd").on("keypress", function(e) {
			if (e.which == 13)
				fn_UpdateCheck();
		});
		//우편번호 입력 후(엔터)
		$("#addrCode").on("keypress", function(e) {
			if (e.which == 13)
				fn_UpdateCheck();
		});
		//주소 입력 후(엔터)
		$("#addrBase").on("keypress", function(e) {
			if (e.which == 13)
				fn_UpdateCheck();
		});
		//상세주소 입력 후(엔터)
		$("#addrDetail").on("keypress", function(e) {
			if (e.which == 13)
				fn_UpdateCheck();
		});
		

	});
	
	//input 하단의 안내 메세지 모두 숨김
	function fn_displayNone() {
		$("#userNameMsg").css("display", "none");
		$("#userPwdMsg").css("display", "none");
		$("#addrCodeMsg").css("display", "none");
		$("#addrBaseMsg").css("display", "none");
		$("#addrDetailMsg").css("display", "none");

	}
	
	function fn_UpdateCheck(){
		
		 fn_displayNone();
		
	     // 모든 공백 체크 정규식
	      var emptCheck = /\s/g;
	      
			if($.trim($("#userName").val()).length <= 0){
				
				$("#userNameMsg").text("사용자 이름을 입력하세요.");
				$("#userNameMsg").css("display", "inline");
				$("#userName").val("");
				$("#userName").focus();
				return;
				
			}
	      
			if($.trim($("#userPwd").val()).length <= 0){
				
				$("#userPwdMsg").text("사용자 비밀번호를 입력하세요.");
				$("#userPwdMsg").css("display", "inline");
				$("#userPwd").val("");
				$("#userPwd").focus();
				return;
				
			}
			
			if(emptCheck.test($("#userPwd").val())){
				
				$("#userPwdMsg").text("사용자 비밀번호는 공백을 포함할 수 없습니다.");
				$("#userPwdMsg").css("display", "inline");
				$("#userPwd").val("");
				$("#userPwd").focus();
				return;
			}

			
			if($.trim($("#addrCode").val()).length <= 0){
				
				$("#addrCodeMsg").text("우편번호를 입력하세요.");
				$("#addrCodeMsg").css("display", "inline");
				$("#addrCode").val("");
				$("#addrCode").focus();
				return;
				
			}
			if($.trim($("#addrBase").val()).length <= 0){
				
				$("#addrBaseMsg").text("주소를 입력하세요.");
				$("#addrBaseMsg").css("display", "inline");
				$("#addrBase").val("");
				$("#addrBase").focus();
				return;
				
			}
			if($.trim($("#addrDetail").val()).length <= 0){
				
				$("#addrDetailMsg").text("상세주소를 입력하세요.");
				$("#addrDetailMsg").css("display", "inline");
				$("#addrDetail").val("");
				$("#addrDetail").focus();
				return;
				
			}


	      $.ajax({
			type:"POST",
			url:"/user/updateProc",
			data:{
				userId:$("#userId").val(),
				userPwd:$("#userPwd").val(),
				userName:$("#userName").val(),
				userEmail:$("#userEmail").val(),
				addrCode:$("#addrCode").val(),
				addrBase:$("#addrBase").val(),
				addrDetail:$("#addrDetail").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				
				  if(response.code == 0){
					  
					  alert("회원 정보가 수정되었습니다.");
					  location.href="/user/updateForm";
					  
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
					  
					  alert("비밀번호 일치하지 않습니다.");					  
					  $("#userPwd").val("");
					  $("#userPwd").focus();
					  
				  }else if(response.code == 500){
					  
					  alert("회원정보 수정 중 오류가 발생하였습니다.");
					  $("#userPwd").focus();
					  
				  }else{
					  
					  alert("회원정보 수정 중 오류 발생");
					  $("#userPwd").focus();
					  
				  }
				
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
	    	  
	      });
		
	}
	
	
	
	
	
	
	//회원탈퇴///////////////////////////////////////////////////////////////////////////////////////
	function fn_DeleteCheck() {
	  
  	    if(!confirm("확인을 누르시면 탈퇴가 됩니다. 정말 탈퇴하시겠습니까?")){
  		  
			alert("취소되었습니다.");
			location.href = "/user/updateForm";
			return;
  		  
  	    }else{
  		  
			$.ajax({
				type:"POST",
				url:"/user/userDeleteProc",
				data:{
					userId:$("#userId").val()
				},
				datatype:"JSON",
	 			beforeSend:function(xhr){
	     			xhr.setRequestHeader("AJAX", "true");
	 			},
	 			success:function(response){
	    
	        	if(response.code == 0){
					alert("회원 탈퇴가 완료되었습니다.");
					location.href="/";
	           
	        	}else{
	           	alert("회원정보 탈퇴 중 오류 발생");
	        	}
			       
				},
				error:function(xhr, status, error){
					icia.common.error(error);
				}
			 			  
			 			  
			});
  		  
		}
		
	}
</script>
</head>
<body>
	<div class="wrapper updateWrap">
		<div class="container">
			<div class="sign-in-container">
				<form>
					<a href="/index" style="margin-bottom: 20px; opacity: 0.8;"><img
						alt="" src="/resources/images/logo4.png"></a>
					<h1 style="margin-bottom: 30px;">Modifying Personal info</h1>

					<input type="text" id="userId" name="userId" value="${user.userId}" readonly> 
					<input type="email" id="userEmail" name="userEmail" value="${user.userEmail}" readonly>
					<input type="text" id="userName" name="userName" placeholder="Name" value="${user.userName}">
					<div class="msgBox">
						<span id="userNameMsg" class="msgText"></span>
					</div>


					<input type="password" id="userPwd" name="userPwd"
						value="" placeholder="Password">
					<div class="msgBox">
						<span id="userPwdMsg" class="msgText"></span>
					</div>
					<!-- 
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
 					-->
					<div class="inputBtn-container">
						<input type="text" id="addrCode" name="addrCode" class="leftBox" placeholder="Postal Code" value="${user.addrCode}" maxlength="5">
						<button type="button" id="addrBtn"
							class="form_btn emailBtn rightBtn" onclick="checkPost()">
							<span>우편번호 검색</span>
						</button>
					</div>
					<div class="msgBox">
						<span id="addrCodeMsg" class="msgText"></span>
					</div>
					
					<input type="text" id="addrBase" name="addrBase" placeholder="Address" value="${user.addrBase}"> 
					<div class="msgBox">
						<span id="addrBaseMsg" class="msgText"></span>
					</div>
					<input type="text" id="addrDetail" name="addrDetail" placeholder="Detailed Address" value="${user.addrDetail}">

					<div class="msgBox">
						<span id="addrDetailMsg" class="msgText"></span>
					</div>
					
					<input type="hidden" id="userPwd" name="userPwd" value="">
					
					<div class="find-link">
						<span><a href="/user/passwordUpdateForm">Do you want to change your password?</a></span>
					</div>

					<button type="button" id="updateBtn" class="form_btn">Update</button>
			        <input type="hidden" name="boardType" value="${boardType}">
     				<input type="hidden" name="brdSeq" value="">
				</form>
			</div>
			<div class="overlay-container">
				<div class="overlay-right">
					<h1>
						Would you like to<br>leave the membership?
					</h1>
					<p>You can sign up again later!</p>
					<button id="withdrawalBtn" class="overlay_btn">Withdrawal</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>