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

      // 글수정 버튼 클릭 시
      $("#updateBtn").on("click", function() {
    	  fn_update();
      });

      // 목록 버튼 클릭 시
      $("#listBtn").on("click", function() {
         document.bbsForm.action = "/board/list";
         document.bbsForm.submit();
      });
      
      // 첨부파일 첨부 시
       $('#brdFile').on('change', function() {
           var fileName = $(this).prop('files')[0].name;  // 선택된 파일 이름 가져오기
           $('.fileLabel').html('<img alt="" src="/resources/images/file.png" style="height: 20px;"> 첨부파일 업로드 : ' + fileName);
       });
   });

   function fn_update() {
      $("#updateBtn").prop("disabled", true);

      if ($.trim($("#brdTitle").val()).length <= 0) {
         alert("제목을 입력하세요!");
         $("#brdTitle").val();
         $("#brdTitle").focus();
         $("#writeBtn").prop("disabled", false);
         return;
      }

      if ($.trim($("#brdContent").val()).length <= 0) {
         alert("내용을 입력하세요!");
         $("#brdContent").val("");
         $("#brdContent").focus();
         $("#writeBtn").prop("disabled", false);
         return;
      }

      //ajax
		var form = $("#updateForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
		   type:"POST",
		   enctype:"multipart/form-data",
		   url:"/board/updateProc",
		   data:formData,
		   processData:false,
		   contentType:false,
		   cache:false,
		   beforeSend:function(xhr){
		      xhr.setRequestHeader("AJAX", "true");
		   },
		   success:function(response){
		      if(response.code == 0){
		         alert("게시물이 수정되었습니다.");
		         document.updateForm.action="/board/view";
		         document.updateForm.submit();
		      }
		      else if(response.code == 400){
		         alert("파라미터 값이 올바르지 않습니다.");
		         $("#updateBtn").prop("disabled", false);
		      }else if(response.code == 403){
		         alert("본인 게시물이 아닙니다.");
		         $("#updateBtn").prop("disabled", false);
		      }else if(response.code == 404){
		         alert("게시물을 찾을수 없습니다.");
		         location.href = "/board/list";
		      }else{
		         alert("게시물 수정 중 오류가 발생하였습니다.(2)");
		         $("#updateBtn").prop("disabled", false);
		      }
		      
		   },
		   error:function(error){
		      icia.common.error(error);
		      alert("게시물 수정 중 오류가 발생했습니다.");
		      $("#updateBtn").prop("disabled", flase);
		   }
		
		});
   }

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
      <div class="title-container">
         <h1><span onclick="fn_list(${boardType})">${boardTitle}</span></h1>
      </div>

      <div class="list-container">
         <div class="write-title-container">
            <span>글수정</span>
         </div>
         <form name="updateForm" id="updateForm" method="post" enctype="multipart/form-data">
            <div class="write-container">
               <input type="text" id="userName" name="userName" class="write-input" value="${board.userName}" readonly>
               <input type="text" id="userEmail" name="userEmail" class="write-input" value="${board.userEmail}" readonly>
               <input type="text" id="brdTitle" name="brdTitle" class="write-input" value="${board.brdTitle}" placeholder="제목을 입력하세요">
               <div class="write-input file-input">
                  <label for="brdFile" class="fileLabel"><img alt="" src="/resources/images/file.png" style="height: 20px;">첨부파일 업로드 (${board.fileOrgName})</label>
               </div>
               <input type="file" id="brdFile" name="brdFile" class="write-input" placeholder="파일을 선택하세요." required />
               <textarea id="brdContent" name="brdContent" class="write-input" placeholder="내용을 입력하세요">${board.brdContent}</textarea>
			   
			   <c:if test="${boardType eq 4}">
			   		<c:if test="${board.brdPwd ne null}">
			       <!-- 비밀글 체크박스 -->
			       <div class="secret-container" style="display: flex; align-items: center; gap: 10px;">
			       		<c:if test="${empty board.brdPwd}">
			            <input type="checkbox" id="isSecret" name="isSecret" onclick="togglePasswordField()">
			            </c:if>
			            <c:if test="${!empty board.brdPwd}">
			            	<input type="checkbox" id="isSecret" name="isSecret" onclick="togglePasswordField()" checked>
			            </c:if>
			            <label for="isSecret" style="padding: 0px;">비밀글 설정</label>
			       </div>
			       </c:if>
			   </c:if>
	           <c:if test="${!empty board.brdPwd}">
		           <div class="password-container" style="margin-top: 10px;">
		               <input type="password" id="brdPwd" name="brdPwd" class="write-input" value="${board.brdPwd}">
		           </div>
			   </c:if>
	           <c:if test="${empty baord.brdPwd}">
		           <div class="password-container" style="margin-top: 10px; display: none;">
		               <input type="password" id="brdPwd" name="brdPwd" class="write-input" placeholder="비밀번호를 입력하세요">
		           </div>
			   </c:if>
			   
			   <input type="hidden" name="brdSeq" value="${board.brdSeq}">
               <input type="hidden" name="boardType" value="${boardType}">
            </div>
            <div class="write-btn-container">
               <button type="button" id="updateBtn" class="writeBtn">수정</button>
               <button type="button" id="listBtn" class="writeBtn">목록</button>
            </div>
         </form>
      </div>
   </div>

   <!-- 푸터 영역 -->
   <%@ include file="/WEB-INF/views/include/footer.jsp"%>

   <form id="bbsForm" name=bbsForm method="post">
      <input type="hidden" name="boardType" value="${boardType}">
      <input type="hidden" name="brdSeq" value="${brdSeq}">
      <input type="hidden" name="searchType" value="${searchType}">
      <input type="hidden" name="searchValue" value="${searchValue}">
      <input type="hidden" name="curPage" value="${curPage}">
   </form>
</body>
</html>