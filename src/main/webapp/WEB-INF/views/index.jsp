<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/navigation.css" type="text/css">
<link rel="stylesheet" href="/resources/css/footer.css" type="text/css">
<link rel="stylesheet" href="/resources/css/index.css" type="text/css">
<script type="text/javascript">
	$(document).ready(function() {
		
		const children = document.querySelectorAll('.placeholder');
	      const children2 = document.querySelectorAll('.caption2 div');
	      var index = 0;
	      setInterval(function(){
	         children[index].style.opacity = '0';
	         children2[index].style.opacity = '0';
	         index = (index + 1) % children.length;
	         children[index].style.opacity = '1';
	         children2[index].style.opacity = '1';
	         $("#index").val(index);
	      }, 3000);
		
		setInterval(function(){
	        const slides = document.querySelectorAll('.work-item');
	        document.querySelector('.work-grid').append(slides[0]);
	     }, 3000);
		
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
		
		//조회버튼 클릭시
		$("#btnSearch").on("click", function() {
			
			if($.trim($("#_searchValue").val()).length <= 0){
				alert("검색어를 입력해주세요.");
				return;
			}else{
				 document.bbsForm.brdSeq.value = "";
				 document.bbsForm.boardType.value = "3";
				 document.bbsForm.searchType.value = "2";
				 document.bbsForm.searchValue.value = $("#_searchValue").val();
				 document.bbsForm.curPage.value = "1";
				 document.bbsForm.action = "/board/list";
				 document.bbsForm.submit();
			}
		

			 
		});
	});

	function fn_list(boardType) {
		document.bbsForm.boardType.value = boardType;
		document.bbsForm.action = "/board/list";
		document.bbsForm.submit();
	}
	
	function fn_view(brdSeq){
		document.bbsForm.brdSeq.value = brdSeq;
		document.bbsForm.boardType.value = 3; //보드타입
		console.log("brdSeq 값:", document.bbsForm.brdSeq.value);
		document.bbsForm.action = "/board/view";
		document.bbsForm.submit();
	}
	

</script>

</head>
<body>
	<form class="form-signin">
		<!-- 헤더 영역 -->
		<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

		<!-- 메인 배너 영역 -->
		<section class="hero">
			<div class="overlay"></div>
			<h1>쌍용교육센터</h1>
			<div class="search-bar">
				<input type="text" name="_searchValue" id="_searchValue" placeholder="검색어를 입력하세요">
				<button type="button" id="btnSearch" style="cursor: pointer"><img alt="검색 버튼" src="/resources/images/search.png" style="height: 22px;"></button>
			</div>
		</section>

		<!-- 이미지 설명 영역 -->
      <section class="image-description">
         <div class="image-container">
            <div class="image-container1" onclick="fn_href()">
               <div class="placeholder">
                  <img alt="" src="/resources/images/ex1.jpg">
               </div>
               <div class="placeholder">
                  <img alt="" src="/resources/images/ex2.jpg">
               </div>
               <div class="placeholder">
                  <img alt="" src="/resources/images/ex4.jpg">
               </div>
            </div>
            <div class="caption">
            <div class="caption2">
            <div>
               <h3>Art & Culture</h3>
               <p>
                  여러 아티스트의 작품을 감상할 수 있는 <br /> 특별한 공간 쌍용미니프로젝트 전시회에 <br /> 여러분들을 초대합니다.
               </p>
            </div>
            <div >
               <h3>서울 예술의 전당</h3>
               <p>
                  서울특별시 서초구 서초동 700번지 <br /> 불멸의 화가 반 고흐, 미셸 앙리등 <br /> 다양한 전시회를 관람하세요.
               </p>
            </div>
            <div>
               <h3>K현대 미술관</h3>
               <p>
                  서울특별시 강남구 선릉로 807 <br /> 파리의 휴일, 디즈니 특별전등 <br /> 다양한 전시회를 관람하세요.
               </p>
            </div>

            </div>
            </div>
         </div>
      </section>

		<!-- 베스트 작업물 영역 -->
		<section class="best-work">
			<h2>BEST WORK</h2>
			<div class="work-grid">
			<c:if test='${!empty list}'>
				<c:forEach var="Board" items="${list}" varStatus="status">
					<div class="work-item" onclick="fn_view(${Board.brdSeq})" style="cursor: pointer">
						<div class="placeholder1">
							<img alt="" src="/resources/upload/${Board.fileName}">
						</div>
						<p>${Board.brdTitle}</p>
					</div>
				</c:forEach>	
			</c:if>
			</div>

		</section>

		<!-- 푸터 영역 -->
		<%@ include file="/WEB-INF/views/include/footer.jsp"%>

	</form>

	<form id="bbsForm" name=bbsForm method="post">
		<input type="hidden" name="boardType" value="${boardType}">
		<input type="hidden" name="brdSeq" value="">
   		<input type="hidden" name="searchType" value="${searchType}">
   		<input type="hidden" name="searchValue" value="${searchValue}">
   		<input type="hidden" name="curPage" value="${curPage}">
	</form>
</body>

</html>
