<%--用户账号Session信息检查--%>
<%
String adminLogined = (String)session.getAttribute("adminLogined");
if(adminLogined == null || !adminLogined.trim().equals("true")) {
	response.sendRedirect("login.jsp");
	// return 让剩余的脚本不要再继续执行了，否则得话剩余脚本还需要继续执行
	return;
} 
 %>

