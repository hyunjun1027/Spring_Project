<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/navigation.css" type="text/css">
<link rel="stylesheet" href="/resources/css/footer.css" type="text/css">
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">
<script type="text/javascript">
	$(document).ready(function() {
		
      // 첨부파일 첨부 시
       $('#brdFile').on('change', function() {
           var fileName = $(this).prop('files')[0].name;  // 선택된 파일 이름 가져오기
           $('.fileLabel').html('<img alt="" src="/resources/images/file.png" style="height: 20px;"> 첨부파일 업로드 : ' + fileName);
       });
	      
		// 햄버거 버튼 클릭 이벤트
		$('nav ul li a img[alt="햄버거버튼"]').on('click', function(event) {
			event.preventDefault();
			$('.dropdown-menu').toggle();
		});
	
		// 메뉴 외부를 클릭했을 때 드롭다운 메뉴 숨기기
		$(document).on('click', function(event) {
			if (!$(event.target).closest('nav').length) {
				$('.dropdown-menu').hide();
			}
		});
		
		//목록 버튼 클릭 시
		$("#listBtn").on("click", function() {
			document.bbsForm.action = "/board/list";
			document.bbsForm.submit();
		});

		$("#brdTitle").focus();
		  
		//완료 버튼 클릭 시
		<c:choose>
		<c:when test="${empty board}">
	   		alert("답변할 게시물이 존재하지 않습니다.");
	   		location.href = "/board/list";
		</c:when>
		
		<c:otherwise>
		
			$("#brdTitle").focus();
		   
		   	$("#replyBtn").on("click", function() {
		      
				$("#replyBtn").prop("disabled", true);  // 답변 버튼 비활성화
				
				if($.trim($("#brdTitle").val()).length <= 0){
					
					alert("제목을 입력하세요.");
					$("#replyBtn").prop("disabled", false);
					$("#brdTitle").val("");
					$("#brdTitle").focus();
					return;
					
				}
				
				if($.trim($("#brdContent").val()).length <= 0){
					
					alert("내용을 입력하세요.");
					$("#replyBtn").prop("disabled", false);
					$("#brdContent").val("");
					$("#brdContent").focus();
					return;
					
				}
				
				var form = $("#replyForm")[0];
				var formData = new FormData(form);
				
				$.ajax({
					type:"POST",
					enctype:"multipart/form-data",
					url:"/board/replyProc",
					data:formData,
					processData:false,
					contentType:false,
					cache:false,
					beforeSend:function(xhr){
					  	xhr.setRequestHeader("AJAX", "true");
					},
					success:function(response){
						
						if(response.code == 0){
							alert("답변이 완료되었습니다.");
							document.bbsForm.action="/board/list";
							document.bbsForm.submit();
						}else if(response.code == 400){
							alert("파라미터 값이 올바르지 않습니다.");
							$("#replyBtn").prop("disabled", false);
							$("#brdTitle").focus();
						}else if(response.code == 404){
							alert("해당 게시물을 찾을수 없습니다.");
							location.href = "/board/list";
						}else{
							alert("게시물 답변 중 오류가 발생하였습니다.");
							$("#replyBtn").prop("disabled", false);
							$("#brdTitle").focus();
						}
						
					},
					error:function(error){
						icia.common.error(error);
						alert("게시물 답변 중 오류가 발생하였습니다.");
						$("#replyBtn").prop("disabled", false);
					}
					
				});
		
		   	});
		   
		   	$("#btnList").on("click", function() {
				
		   		document.bbsForm.action="/board/list";
		   		document.bbsForm.submit();
		   		
		   	});
		   	
	   	</c:otherwise>
	</c:choose>   
		
		
	});
	
	function fn_list(boardType) {
	   document.bbsForm.action = "/board/list";
	   document.bbsForm.boardType.value = boardType;
	   document.bbsForm.submit();
	}
	
   function togglePasswordField() {
	  const isSecret = document.getElementById('isSecret');
	  const passwordContainer = document.querySelector('.password-container');
	  if (isSecret.checked) {
	      passwordContainer.style.display = 'block';  // 비밀번호 필드를 보이도록 설정
	  } else {
	      passwordContainer.style.display = 'none';   // 비밀번호 필드를 숨김
	  }
   }
</script>
</head>
<body>
   <!-- 헤더 영역 -->
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <!-- 배너 사진 -->
   <div class="banner-container">
      <img alt="" src="/resources/images/list_banner.jpg">
   </div>

   <!-- 메인 컨테이너 -->
   <div class="main-container write-main-cont">
   <form name="replyForm" id="replyForm" method="post" enctype="multipart/form-data">
      <div class="title-container">
         <h1><span onclick="fn_list(${boardType})">${boardTitle}</span></h1>
      </div>

      <div class="list-container">
         <div class="write-title-container">
            <span>답글</span>
         </div>
         <div class="write-container">
            <input type="text" id="mainbrdTitle" name="mainbrdTitle" class="write-input" value="${board.brdTitle}" readonly>
            <input type="text" id="userName" name="userName" class="write-input" value="${user.userName}" readonly>
            <input type="text" id="userEmail" name="userEmail" class="write-input" value="${user.userEmail}" readonly>
            <input type="text" id="brdTitle" name="brdTitle" class="write-input" placeholder="제목을 입력하세요" value="문의주신 내용의 답변입니다.">
            <div class="write-input file-input">
               <label for="brdFile" class="fileLabel"><img alt="" src="/resources/images/file.png" style="height: 20px;"> 첨부파일 업로드</label>
            </div>
            <input type="file" id="brdFile" name="brdFile" class="write-input" placeholder="파일을 선택하세요." required />
            <textarea id="brdContent" name="brdContent" class="write-input" placeholder="내용을 입력하세요"></textarea>
         
			<c:if test="${boardType eq 4}">
		        <!-- 비밀글 체크박스 -->
		        <div class="secret-container" style="display: flex; align-items: center; gap: 10px;">
		            <input type="checkbox" id="isSecret" name="isSecret" onclick="togglePasswordField()">
		            <label for="isSecret" style="padding: 0px;">비밀글 설정</label>
		            
		        </div>
			</c:if>
	        
	        <div class="password-container" style="margin-top: 10px; display: none;">
	            <input type="password" id="brdPwd" name="brdPwd" class="write-input" placeholder="비밀번호를 입력하세요">
	        </div>
         </div>
         
         
         
         <input type="hidden" name="boardType" value="${boardType}">
         <input type="hidden" name="brdSeq" value="${board.brdSeq}">
         <div class="write-btn-container" style="clear: both;">
            <button type="button" id="replyBtn" class="writeBtn">완료</button>
            <button type="button" id="listBtn" class="writeBtn">목록</button>
         </div>
      </div>
      </form>
   </div>

   <!-- 푸터 영역 -->
   <%@ include file="/WEB-INF/views/include/footer.jsp"%>

   <form id="bbsForm" name=bbsForm method="post">
      <input type="hidden" name="boardType" value="${boardType}">
      <input type="hidden" name="brdSeq" value="">
      <input type="hidden" name="searchType" value="${searchType}">
      <input type="hidden" name="searchValue" value="${searchValue}">
      <input type="hidden" name="curPage" value="${curPage}">
   </form>
</body>
</html>