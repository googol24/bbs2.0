<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.googol24.bbs.*"%>
<%@ page errorPage="Error.jsp" %>

<%
	// 设置对客户端请求和数据库取值时的编码，不指定的话request对象提交的数据默认使用的编码为iso-8859-1
	request.setCharacterEncoding("UTF-8");

	String action = request.getParameter("action");
	if (action != null && action.trim().equals("post")) {
	    // 请求提交过来的
		String title = request.getParameter("title");
		String content = request.getParameter("cont");

		Connection connection = DB.getConnection();
		boolean autoCommit = connection.getAutoCommit();

		String sql = "INSERT INTO article(`pid`,`rootid`,`title`,`cont`,`pdate`,`isleaf`) VALUES (0, -1, ?, ?, NOW(), 0)";
		PreparedStatement preparedStatement = DB.preparedStatement(connection, sql, Statement.RETURN_GENERATED_KEYS);
		preparedStatement.setString(1, title);
		preparedStatement.setString(2, content);

		connection.setAutoCommit(false);
		preparedStatement.executeUpdate();
		ResultSet resultSet = preparedStatement.getGeneratedKeys();
		resultSet.next();
		int rootId = resultSet.getInt(1);
		Statement statement = DB.getStatement(connection);
		statement.executeUpdate("UPDATE article SET rootid=" + rootId + " WHERE id=" + rootId);

		connection.commit();
		connection.setAutoCommit(autoCommit);

		// 关闭资源
		DB.close(statement);
		DB.close(resultSet);
		DB.close(preparedStatement);
		DB.close(connection);

		// 跳转到首页
		response.sendRedirect("article.jsp");
	} else {
	    // 链接跳转过来的
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>发表新主题</title>
		<meta http-equiv="content-type" content="text/html; charset=GBK">
		<link rel="stylesheet" type="text/css" href="images/style.css"
			title="Integrated Styles">
		<script language="JavaScript" type="text/javascript"
			src="images/global.js"></script>
		<!-- fckeditor -->
		<!-- 为了速度而没有使用fckeditor -->
		<!-- end of fckeditor -->

		<link rel="alternate" type="application/rss+xml" title="RSS"
			href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?threadID=744236">
	</head>
	<body>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr>
					<td width="40%">
						<img src="images/header-stretch.gif" alt="" border="0" height="57"
							width="100%">
					</td>
					<td width="1%">
						<img src="images/header-right.gif" alt="" height="57" border="0">
					</td>
				</tr>
			</tbody>
		</table>
		<br>
		<div id="jive-flatpage">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>
					<tr valign="top">
						<td width="99%">
							<p class="jive-breadcrumbs">
								<a
									href="/article.jsp">BBS 2.0</a>
							</p>
							<p class="jive-page-title">
								发表新主题
								<br>
							</p>
						</td>
						<td width="1%">
							<div class="jive-accountbox"></div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="jive-buttons">
				<br>
			</div>
			<br>
			<table border="0" cellpadding="0" cellspacing="0" width="930"
				height="61">
				<tbody>
					<tr valign="top">
						<td width="99%">
							<div id="jive-message-holder">
								<div class="jive-message-list">
									<div class="jive-table">
										<div class="jive-messagebox">

											<form action="post.jsp" method="post">
												<input type="hidden" name="action" value="post" />
												
												标题：
												<input type="text" name="title">
												<br>
												内容：
												<textarea name="cont" rows="15" cols="80"></textarea>
												<br>
												<input type="submit" value="submit" />
											</form>

										</div>
									</div>
								</div>
								<div class="jive-message-list-footer">
									<br>
								</div>
							</div>
						</td>
						<td width="1%">
							&nbsp;
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</body>
</html>
