<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	javax.servlet.RequestDispatcher requestDispatcher = request.getRequestDispatcher("/index");

	requestDispatcher.forward(request, response);
%>
