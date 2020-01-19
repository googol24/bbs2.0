<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.googol24.bbs.*"%>

<%
	request.setCharacterEncoding("UTF-8");
	String action = request.getParameter("action");
	String username = "";
	if (action != null && action.trim().equals("login")) {
		username = request.getParameter("username");
		//check username whether valid or not!
		String password = request.getParameter("password");
		if(username == null || !username.trim().equals("admin")) {
			out.println("username not correct!");
		} else if(password == null || !password.trim().equals("admin123")) {
			out.println("password not correct!");
		} else {
			session.setAttribute("adminLogined" , "true");
			response.sendRedirect("articleFlat.jsp");
		}
	}
%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>管理员登录</title>
		<script type="javascript">
			function check() {
				var username = document.getElementById("username").value;alert(username);
				var password = document.getElementById("password").value;
				if (username == "") {
				    alert("用户名不能为空！");
				    document.getElementById("username").focus();
				    return false;
				}

				return true;
            }
		</script>
	</head>
	<body>

		<form action="login.jsp" method="post" onsubmit="return check()">
			<input type="hidden" name="action" value="login"/>
			用户名：
			<input type="text" id="username" name="username" value="<%=username %>"/>
			<br>
			密码：
			<input type="password" id="password" name="password" />
			<br>
			<input type="submit" value="login" />
		</form>


	</body>
</html>
