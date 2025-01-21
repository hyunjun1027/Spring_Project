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

	var sendMail = null;
	var authCheck = false;
	
	$(function() {
		//로그인 화면으로 이동
		$("#signUpBtn").on("click", function() {
			$(".container").addClass("right-panel-active");
		});

		//회원가입 화면으로 이동
		$("#signInBtn").on("click", function() {
			$(".container").removeClass("right-panel-active");
		});

		//아이디 입력 후 엔터
		$("#userIdLogin").on("keypress", function(e) {
			if (e.which == 13)
				fn_loginCheck();
		});

		//비밀번호 입력 후 엔터
		$("#userPwdLogin").on("keypress", function(e) {
			if (e.which == 13)
				fn_loginCheck();
		});

		//아이디 중복 체크(엔터)
		$("#userId").on("keypress", function(e) {
			if (e.which == 13)
				fn_idCheck();
		});

		//아이디 중복 체크(버튼)
		$("#idBtn").on("click", function() {
			fn_idCheck();
		});

		//로그인 버튼 클릭 시
		$("#realSignInBtn").on("click", function() {
			fn_loginCheck();
		});

		//회원가입 버튼 클릭 시
		$("#realSignUpBtn").on("click", function() {
			fn_joinCheck();
		});

		//회원가입(엔터)
		$("#userName").on("keypress", function(e) {
			if (e.which == 13)
				fn_joinCheck();
		});
		$("#userPwd1").on("keypress", function(e) {
			if (e.which == 13)
				fn_joinCheck();
		});
		$("#userPwd2").on("keypress", function(e) {
			if (e.which == 13)
				fn_joinCheck();
		});
		$("#addrCode").on("keypress", function(e) {
			if (e.which == 13)
				fn_joinCheck();
		});
		$("#addrBase").on("keypress", function(e) {
			if (e.which == 13)
				fn_joinCheck();
		});
		$("#addrDetail").on("keypress", function(e) {
			if (e.which == 13)
				fn_joinCheck();
		});
		
		//이메일 인증 전송 엔터
		$("#userEmail").on("keypress", function(e) {
			if (e.which == 13)
				fn_emailCheck();
		});
		
		//이메일 인증 전송
		$("#emailBtn").on("click", function() {
			fn_emailCheck();
		});
		
		//이메일 인증 체크(엔터)
		$("#authNum").on("keypress", function(e) {
			if (e.which == 13)
				fn_authCheck();
		});
		
		//이메일 인증 체크
		$("#authBtn").on("click", function() {
			fn_authCheck();
		});
		

	});

	//input 하단의 안내 메세지 모두 숨김
	function fn_displayNone() {
		$("#userIdMsg").css("display", "none");
		$("#userIdLoginMsg").css("display", "none");
		$("#userEmailMsg").css("display", "none");
		$("#userNameMsg").css("display", "none");
		$("#addrCodeMsg").css("display", "none");
		$("#addrBaseMsg").css("display", "none");
		$("#addrDetailMsg").css("display", "none");
		$("#authNumMsg").css("display", "none");
		$("#userPwd1Msg").css("display", "none");
		$("#userPwd2Msg").css("display", "none");
		$("#userPwdLoginMsg").css("display", "none");
	}

	//로그인///////////////////////////////////////////////////////////////////////////////////////
	function fn_loginCheck() {
		//공백 체크
		var emptCheck = /\s/g;

		fn_displayNone();

		if ($.trim($("#userIdLogin").val()).length <= 0) {
			$("#userIdLoginMsg").text("사용자 아이디를 입력하세요.");
			$("#userIdLoginMsg").css("display", "inline");
			$("#userIdLogin").val("");
			$("#userIdLogin").focus();
			return;
		}

		if (emptCheck.test($("#userIdLogin").val())) {
			$("#userIdLoginMsg").text("사용자 아이디는 공백을 포함할 수 없습니다.");
			$("#userIdLoginMsg").css("display", "inline");
			$("#userIdLogin").val("");
			$("#userIdLogin").focus();
			return;
		}

		if ($.trim($("#userPwdLogin").val()).length <= 0) {
			$("#userPwdLoginMsg").text("비밀번호를 입력하세요.");
			$("#userPwdLoginMsg").css("display", "inline");
			$("#userPwdLogin").val("");
			$("#userPwdLogin").focus();
			return;
		}

		if (emptCheck.test($("#userPwdLogin").val())) {
			$("#userPwdLoginMsg").text("사용자 비밀번호는 공백을 포함할 수 없습니다.");
			$("#userPwdLoginMsg").css("display", "inline");
			$("#userPwdLogin").val("");
			$("#userPwdLogin").focus();
			return;
		}

		//로그인 ajax
		$.ajax({
			type : "POST",
			url : "/user/login",
			data : {
				userId : $("#userIdLogin").val(),
				userPwd : $("#userPwdLogin").val()
			},
			datatype : "JSON",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				if (!icia.common.isEmpty(response)) {

					icia.common.log(response);

					var code = icia.common.objectValue(response, "code", -500);

					if (code == 0) {
						Swal.fire({
							icon: "success",
							title: "로그인 성공"
						}).then( function(){
							location.href = "/"
						});

					} else {

						if (code == -1) {

							alert("비밀번호가 올바르지 않습니다.");
							$("#userPwd").focus();

						} else if (code == -99) {

							alert("정지된 사용자 입니다.");
							$("#userId").focus();

						} else if (code == -98) {

							alert("아이디와 일치하는 사용자 정보가 없습니다.(2)");
							$("#userId").focus();

						} else if (code == 404) {

							alert("아이디와 일치하는 사용자 정보가 없습니다.");
							$("#userId").focus();

						} else if (code == 400) {

							alert("파라미터 값이 올바르지 않습니다.");
							$("#userId").focus();

						} else {

							alert("오류가 발생하였습니다.(1)");
							$("#userId").focus();

						}
					}
				} else {
					alert("오류가 발생하였습니다.");
					$("#userId").focus();
				}
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
			}
		});

	}
	
	
	// 중복확인 상태 변수
	var isIdChecked = false;

	// 아이디 중복 체크
	function fn_idCheck() {

	    // 중복확인 여부에 따라 처리
	    if (isIdChecked) {
	        return;  // 중복확인 이미 했으면 더 이상 진행하지 않음
	    }

	    // 중복 체크 요청 전 초기화
	    isIdChecked = false; 

	    // 공백 체크
	    var emptCheck = /\s/g;
	    // 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
	    var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;

	    if ($.trim($("#userId").val()).length <= 0) {
	        $("#userIdMsg").text("사용자 아이디를 입력하세요.");
	        $("#userIdMsg").css("display", "inline");
	        $("#userId").val("");
	        $("#userId").focus();
	        return;
	    }

	    if (!idPwCheck.test($("#userId").val())) {
	        $("#userIdMsg").text("사용자 아이디는 4~12자의 영문 대소문자와 숫자로만 입력가능합니다.");
	        $("#userIdMsg").css("display", "inline");
	        $("#userId").val("");
	        $("#userId").focus();
	        return;
	    }

	    if (emptCheck.test($("#userId").val())) {
	        $("#userIdMsg").text("사용자 아이디는 공백을 포함할 수 없습니다.");
	        $("#userIdMsg").css("display", "inline");
	        $("#userId").val("");
	        $("#userId").focus();
	        return;
	    }

	    $.ajax({
	        type: "POST",
	        url: "/user/idCheck",
	        data: {
	            userId: ($("#userId").val())
	        },
	        datatype: "JSON",
	        beforeSend: function(xhr) {
	            xhr.setRequestHeader("AJAX", "true");
	        },
	        success: function(response) {

	            if (response.code == 0) {
	                // 사용 가능한 아이디
	                $("#userIdMsg").text("사용 가능한 아이디 입니다.");
	                $("#userIdMsg").css("display", "inline");
	                $("#userId").attr("readonly", true);
	                $("#idBtn").attr("disabled", true);

	                // 중복 확인 완료 상태로 변경
	                isIdChecked = true;
	            } else if (response.code == 100) {
	                // 사용할 수 없는 아이디
	                $("#userIdMsg").text("사용할 수 없는 아이디입니다. 다른 아이디를 입력해 주세요.");
	                $("#userIdMsg").css("display", "inline");
	                $("#userId").focus();
	            } else if (response.code == 400) {
	                // 파라미터 오류
	                $("#userIdMsg").text("파라미터 값이 올바르지 않습니다.");
	                $("#userIdMsg").css("display", "inline");
	                $("#userId").focus();
	            } else {
	                // 기타 오류
	                $("#userIdMsg").text("오류가 발생하였습니다.");
	                $("#userIdMsg").css("display", "inline");
	                $("#userId").focus();
	            }
	        },
	        error: function(xhr, status, error) {
	            icia.common.error(error);
	        }
	    });
	}

	
	
	
	
	//이메일 인증번호///////////////////////////////////////////////////////////////////////////////////////
	function fn_emailCheck(){
		
		fn_displayNone();
		
		if ($.trim($("#userEmail").val()).length <= 0) {
			$("#userEmailMsg").text("사용자 이메일을 입력하세요.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}
		
		//인증번호 전송 후 중복 전송 방지를 위한 input, button 비활성화
		$("#userEmail").attr("readonly", true);
		$("#emailBtn").attr("disabled", true);

		$.ajax({
			type:"POST",
			url:"/sendMail",
			data:{
				userEmail:$("#userEmail").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				
				
				if(response.code == 0){
					
					sendMail = response.data;
					alert("인증번호를 발송하였습니다.");
					
				}else{
					alert("인증번호 발송 중 알수없는 오류가 발생하였습니다.");
					$("#userEmail").focus();
				}
				
			},
			error:function(xhr, status, error){
				icia.common.error(error);
				alert("error");
			}
			
		});
		
	}
	
	
	
	
	//인증번호 체크///////////////////////////////////////////////////////////////////////////////////////
	function fn_authCheck(){

		fn_displayNone();
		
		if ($.trim($("#authNum").val()).length <= 0) {
			$("#authNumMsg").text("인증번호를 입력하세요.");
			$("#authNumMsg").css("display", "inline");
			$("#authNum").val("");
			$("#authNum").focus();
			return;
		}
		
		if(sendMail == $("#authNum").val()){
			$("#authNumMsg").text("인증이 완료되었습니다.");
			$("#authNumMsg").css("display", "inline");
			authCheck = true;
			//인증번호 체크 중일 때 오류 발생 방지를 위한 input, button 비활성화
			$("#authNum").attr("readonly", true);
			$("#authBtn").attr("disabled", true);
		}
		
		if(sendMail != $("#authNum").val()){
			$("#authNumMsg").text("인증번호가 일치하지 않습니다.");
			$("#authNumMsg").css("display", "inline");
			$("#authNum").val("");
			$("#authNum").focus();
			return;
		}
		
	}
	

	
	
	//회원가입///////////////////////////////////////////////////////////////////////////////////////////
	function fn_joinCheck() {
		//공백 체크
		var emptCheck = /\s/g;
		//영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
		var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
	
		var addrBaseCheck = /^(서울|부산|대구|인천|광주|대전|울산|세종|경기|강원|충북|충남|전북|전남|경북|경남|제주)[\s]*(시|도)[\s]*([가-힣]+(구|군))[\s]*([가-힣]+(읍|면))?[\s]*([가-힣0-9]+(로|길))[\s]*([0-9]+)(-([0-9]+))?$/;
		
		var addrBaseCheck2 = /^(서울|부산|대구|인천|광주|대전|울산|세종|경기|강원|충북|충남|전북|전남|경북|경남|제주)[\s]*(시|도)[\s]*([가-힣]+(구|군))[\s]*([가-힣]+(읍|면|동))[\s]*([0-9]+)(-([0-9]+))?번지$/;
		
		fn_displayNone();

		//아이디
		if ($.trim($("#userId").val()).length <= 0) {
			$("#userIdMsg").text("사용자 아이디를 입력하세요.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").val("");
			$("#userId").focus();
			return;
		}

		if (!idPwCheck.test($("#userId").val())) {

			$("#userIdMsg").text("사용자 아이디는 4~12자의 영문 대소문자와 숫자로만 입력가능합니다.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").val("");
			$("#userId").focus();
			return;

		}

		if (emptCheck.test($("#userId").val())) {
			$("#userIdMsg").text("사용자 아이디는 공백을 포함할 수 없습니다.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").val("");
			$("#userId").focus();
			return;
		}
		
	    // 중복체크 여부 확인
	    if (!isIdChecked) {
	        alert("아이디가 사용 가능한지 확인해 주세요.");
	        $("#userId").focus();
	        return;
	    }

		//이름
		if ($.trim($("#userName").val()).length <= 0) {
			$("#userNameMsg").text("사용자 이름을 입력하세요.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}

		if (emptCheck.test($("#userName").val())) {
			$("#userNameMsg").text("사용자 이름에는 공백을 포함할 수 없습니다.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}

		//비밀번호
		if ($.trim($("#userPwd1").val()).length <= 0) {
			$("#userPwd1Msg").text("비밀번호를 입력하세요.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}

		if (!idPwCheck.test($("#userPwd1").val())) {

			$("#userPwd1Msg").text("사용자 비밀번호는 4~12자의 영문 대소문자와 숫자로만 입력가능합니다.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;

		}

		if (emptCheck.test($("#userPwd1").val())) {
			$("#userPwd1Msg").text("사용자 비밀번호는 공백을 포함할 수 없습니다.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}

		//비밀번호 확인
		if ($.trim($("#userPwd2").val()).length <= 0) {
			$("#userPwd2Msg").text("비밀번호 확인을 입력하세요.");
			$("#userPwd2Msg").css("display", "inline");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
		}

		if ($("#userPwd1").val() != $("#userPwd2").val()) {
			$("#userPwd2Msg").text("비밀번호가 일치하지 않습니다.");
			$("#userPwd2Msg").css("display", "inline");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
		}

		$("#userPwd").val($("#userPwd1").val());
		
		//이메일
		if ($.trim($("#userEmail").val()).length <= 0) {
			$("#userEmailMsg").text("사용자 이메일을 입력하세요.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}
		
		//이메일 인증
		if ($.trim($("#authNum").val()).length <= 0) {
			$("#authNumMsg").text("인증번호를 입력하세요.");
			$("#authNumMsg").css("display", "inline");
			$("#authNum").val("");
			$("#authNum").focus();
			return;
		}

		if(!authCheck){
			
			$("#authNumMsg").text("인증번호 체크를 눌러주세요.");
			$("#authNumMsg").css("display", "inline");
			return;
		}

		//우편번호
		if ($.trim($("#addrCode").val()).length <= 0) {
			$("#addrCodeMsg").text("우편번호를 입력하세요.");
			$("#addrCodeMsg").css("display", "inline");
			$("#addrCode").val("");
			$("#addrCode").focus();
			return;
		}

		//주소
		if ($.trim($("#addrBase").val()).length <= 0) {
			$("#addrBaseMsg").text("주소를 입력하세요.");
			$("#addrBaseMsg").css("display", "inline");
			$("#addrBase").val("");
			$("#addrBase").focus();
			return;
		}
/*		
		if(!addrBaseCheck.test($("#addrBase").val()) && !addrBaseCheck2.test($("#addrBase").val())){
			$("#addrBaseMsg").text("주소를 잘못입력하셨습니다.");
			$("#addrBaseMsg").css("display", "inline");
			$("#addrBase").val("");
			$("#addrBase").focus();
			return;
		}
*/
		//상세주소
		if ($.trim($("#addrDetail").val()).length <= 0) {
			$("#addrDetailMsg").text("상세주소를 입력하세요.");
			$("#addrDetailMsg").css("display", "inline");
			$("#addrDetail").val("");
			$("#addrDetail").focus();
			return;
		}
		
		//회원가입 ajax
		$.ajax({
			type:"POST",
			url:"/user/regProc",
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
					
					alert("회원가입이 완료 되었습니다.");
					location.href = "/";
					
				}else if(response.code == 100){
					
					alert("회원 아이디가 중복되었습니다.");
					$("#userId").focus();
					
				}else if(response.code == 400){
					
					alert("파라미터 값이 올바르지 않습니다.");
					$("#userId").focus();
					
				}else if(response.code == 500){
					
					alert("회원 가입 중 오류가 발생하였습니다.");
					$("#userId").focus();
					
				}else{
					alert("회원 가입 중 알수없는 오류가 발생하였습니다.");
					$("#userId").focus();
				}
				
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
			
		});
	}
		
		

	
		

</script>
</head>
<body>
	<div class="wrapper">
		<div class="container">
			<div class="sign-up-container">
				<form>
					<a href="/index"><img alt="" src="/resources/images/logo4.png"
						style="margin-bottom: 20px; opacity: 0.8;"></a>
					<h1>Create Account</h1>
					<div class="social-links">
						<!-- <div>
							<a href="#"><i class="fa fa-google" aria-hidden="true"></i></a>
						</div> -->
					</div>

					<div class="inputBtn-container">
						<input type="text" id="userId" name="userId" class="leftBox"
							placeholder="ID">
						<button type="button" id="idBtn" class="form_btn idBtn rightBtn">
							<span class="idCheckMsg">아이디 중복 체크</span>
						</button>
					</div>
					<div class="msgBox">
						<span id="userIdMsg" class="msgText"></span>
					</div>

					<!-- 이메일 인증 추가하실 분은 아래의 div를 사용하시면 됩니다. -->
					<div class="inputBtn-container">
						<input type="email" id="userEmail" name="userEmail" class="leftBox" placeholder="Email">
						<button type="button" id="emailBtn" class="form_btn emailBtn rightBtn">
							<span class="authSendMsg">인증번호 전송</span>
						</button>
					</div>
					<div class="msgBox">
						<span id="userEmailMsg" class="msgText"></span>
					</div>

					<div class="inputBtn-container">
						<input type="text" id="authNum" name="authNum" class="emailInput leftBox" value="" placeholder="Authentication Number" maxlength="6">
						<button type="button" id="authBtn" class="form_btn authBtn rightBtn">
							<span class="authCheckMsg">인증번호 체크</span>
						</button>
					</div>
					<div class="msgBox">
						<span id="authNumMsg" class="msgText"></span>
					</div>

					<input type="text" id="userName" name="userName" placeholder="Name">
					<div class="msgBox">
						<span id="userNameMsg" class="msgText"></span>
					</div>

					<input type="password" id="userPwd1" name="userPwd1"
						placeholder="Password">
					<div class="msgBox">
						<span id="userPwd1Msg" class="msgText"></span>
					</div>

					<input type="password" id="userPwd2" name="userPwd2"
						placeholder="Password Check">
					<div class="msgBox">
						<span id="userPwd2Msg" class="msgText"></span>
					</div>

					<div class="inputBtn-container">
						<input type="text" id="addrCode" name="addrCode" class="leftBox"
							placeholder="Postal Code" maxlength="5">
						<button type="button" id="addrBtn"
							class="form_btn emailBtn rightBtn" onclick="checkPost()">
							<span>우편번호 검색</span>					
						</button>					
					</div>
					<div class="msgBox">
						<span id="addrCodeMsg" class="msgText"></span>
					</div>	
					<input type="text" id="addrBase" name="addrBase" placeholder="Address">
					<div class="msgBox">
						<span id="addrBaseMsg" class="msgText"></span>
					</div>
					<input type="text" id="addrDetail" name="addrDetail" placeholder="Detailed Address">
					<div class="msgBox">
						<span id="addrDetailMsg" class="msgText"></span>
					</div>
					<input type="hidden" id="userPwd" name="userPwd" value="">

					<button type="button" id="realSignUpBtn" class="form_btn">Sign Up</button>
				</form>
			</div>
			<div class="sign-in-container">
				<form>
					<a href="/index"><img alt="" src="/resources/images/logo4.png"
						style="margin-bottom: 20px; opacity: 0.8;"></a>
					<h1>Sign In</h1>
					<div class="social-links">
						<!-- 소셜 로그인을 하실 분은 아래의 div를 사용하시면 됩니다 -->
						<!-- <div onclick="fn_naverLogin()">
							<img alt="" src="/resources/images/naver.png">
						</div> -->
					</div>
					<input type="text" id="userIdLogin" name="userIdLogin"
						placeholder="ID">
					<div class="msgBox">
						<span id="userIdLoginMsg" class="msgText"></span>
					</div>

					<input type="password" id="userPwdLogin" name="userPwdLogin"
						placeholder="Password" style="margin-top: 30px;">
					<div class="msgBox">
						<span id="userPwdLoginMsg" class="msgText"></span>
					</div>

					<div class="find-link">
						<span><a href="/user/findForm">Forgot your Account?</a></span>
					</div>

					<button type="button" id="realSignInBtn" class="form_btn">SignIn</button>
				</form>
			</div>
			<div class="overlay-container">
				<div class="overlay-left">
					<h1>Welcome Back</h1>
					<p>To keep connected with us please login with your personal
						info</p>
					<button id="signInBtn" class="overlay_btn">Sign In</button>
				</div>
				<div class="overlay-right">
					<h1>Hello, Friend</h1>
					<p>Enter your personal details and start journey with us</p>
					<button id="signUpBtn" class="overlay_btn">Sign Up</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>