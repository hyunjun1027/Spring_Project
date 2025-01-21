<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%
if (com.sist.web.util.CookieUtil.getCookie(request, (String) request.getAttribute("AUTH_COOKIE_NAME")) == null) {
%>
<header>
	<div class="header-content">
		<div class="logo">
			<a href="/index"><img src="/resources/images/logo.png" alt="로고"></a>
		</div>
		<nav>
			<ul>
				<li><a href="/user/userForm">로그인</a></li>
				<li class="nav-item-dropdown"><a href="#"><img alt="햄버거버튼" src="/resources/images/menu.png"></a> <!-- 드롭다운 메뉴 -->
					<ul class="dropdown-menu">
						<li><a href="#" onclick="fn_list(1)">공지사항</a></li>
						<li><a href="#" onclick="fn_list(2)">자유 게시판</a></li>
						<li><a href="#" onclick="fn_list(3)">전시 게시판</a></li>
						<li><a href="#" onclick="fn_list(4)">문의 사항</a></li>
					</ul></li>
			</ul>
		</nav>
	</div>
</header>
<%
} else {
%>
<header>
	<div class="header-content">
		<div class="logo">
			<a href="/index"><img src="/resources/images/logo.png" alt="로고"></a>
		</div>
		<nav>
			<ul>
				<li style="color: #fff;"><%= com.sist.web.util.CookieUtil.getHexValue(request, (String)request.getAttribute("AUTH_COOKIE_NAME")) %> 님</li>
				<li><a href="/user/loginOut">로그아웃</a></li>
				<li><a href="/user/updateForm">회원정보수정</a></li>
				<li class="nav-item-dropdown"><a href="#"><img alt="햄버거버튼" src="/resources/images/menu.png"></a> <!-- 드롭다운 메뉴 -->
					<ul class="dropdown-menu">
						<li><a href="#" onclick="fn_list(1)">공지사항</a></li>
						<li><a href="#" onclick="fn_list(2)">자유 게시판</a></li>
						<li><a href="#" onclick="fn_list(3)">전시 게시판</a></li>
						<li><a href="#" onclick="fn_list(4)">문의 사항</a></li>
					</ul></li>
			</ul>
		</nav>
	</div>
</header>
<%
}
%>