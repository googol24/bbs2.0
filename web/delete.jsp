<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.googol24.bbs.*, java.util.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page errorPage="Error.jsp" %>

<%--权限校验检查--%>
<%@ include file="_SessionCheck.jsp" %>

<%!
	private void delete(Connection connection, int id) {
	    // 1 首先递归删除该节点的所有子节点
		String sql = "SELECT * FROM article WHERE pid=" + id;
		Statement statement = DB.getStatement(connection);
		ResultSet resultSet = DB.executeQuery(statement, sql);

		try {
			// 递归删除该节点的所有子节点（如果有孩子节点）
			while (resultSet.next()) {
				delete(connection, resultSet.getInt("id"));
			}
		} catch (SQLException e) {
		    e.printStackTrace();
		} finally {
		    DB.close(resultSet);
		    DB.close(statement);
		}

		// 2 然后再删除自身
		DB.executeUpdate(connection, "DELETE FROM article WHERE id=" + id);
	}
%>

<%
int id = Integer.parseInt(request.getParameter("id"));
int pid = Integer.parseInt(request.getParameter("pid"));

String url = URLDecoder.decode(request.getParameter("from"), "UTF-8");

Connection conn = null;
boolean autoCommit = true;
Statement stmt = null;
ResultSet rs = null;

try {
	conn = DB.getConnection();
	autoCommit = conn.getAutoCommit();
	conn.setAutoCommit(false);

	delete(conn, id);

	stmt = DB.getStatement(conn);
	rs = DB.executeQuery(stmt, "select count(*) from article where pid = " + pid);
	rs.next();
	int count = rs.getInt(1);

	if(count <= 0) {
		DB.executeUpdate(conn, "update article set isleaf = 0 where id = " + pid);
	}

	conn.commit();
} finally {
    if (conn != null) {
		conn.setAutoCommit(autoCommit);
	}
	DB.close(rs);
	DB.close(stmt);
	DB.close(conn);
}

// 跳转
response.sendRedirect(url);

		out.println("删除成功！");
%>

