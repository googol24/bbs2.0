<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,com.googol24.bbs.*" %>
<%@ page import="com.googol24.bbs.DB" %>
<%@ page errorPage="Error.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String action = request.getParameter("action");

    int id = Integer.parseInt(request.getParameter("id"));

    // 处理修改请求
    Connection conn = DB.getConnection();
    if (action != null && action.trim().equals("modify")) {

        String title = request.getParameter("title");
        String cont = request.getParameter("cont");

        PreparedStatement pStmt = DB.preparedStatement(conn, "update article set title = ? , cont = ? where id = ?");
        pStmt.setString(1, title);
        pStmt.setString(2, cont);
        pStmt.setInt(3, id);
        pStmt.executeUpdate();

        DB.close(pStmt);
        DB.close(conn);

        response.sendRedirect("articleFlat.jsp");
        return;

    }

    // 查询渲染
    Statement stmt = DB.getStatement(conn);
    ResultSet rs = DB.executeQuery(stmt, "select * from article where id = " + id);

    // 查不到数据，直接返回
    if (!rs.next()) return;

    Article a = new Article(
            rs.getInt("id"),
            rs.getInt("pid"),
            rs.getInt("rootid"),
            rs.getString("title"),
            rs.getTimestamp("pdate"),
            rs.getInt("isleaf")
    );
    a.setCont(rs.getString("cont"));

    // 关闭资源
    DB.close(rs);
    DB.close(stmt);
    DB.close(conn);
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

    <link rel="alternate" type="application/rss+xml" title="RSS"
          href="#">
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
                    <a href="/articleFlat.jsp">首页</a> &#187;
                    &#187;
                    <a href="#">Web 2.0</a>
                </p>
                <p class="jive-page-title">
                    修改
                    <br>
                </p>
            </td>
            <td width="1%"><br>

                <br></td>
        </tr>
        </tbody>
    </table>
    <div class="jive-buttons">
        <br>
    </div>
    <br>
    <table border="0" cellpadding="0" cellspacing="0" width="930">
        <tbody>
        <tr valign="top">
            <td width="99%">
                <div id="jive-message-holder">
                    <div class="jive-message-list">
                        <div class="jive-table">
                            <div class="jive-messagebox">

                                <form action="modify.jsp" method="post">
                                    <input type="hidden" name="action" value="modify"/>
                                    <input type="hidden" name="id" value="<%=id %>"/>

                                    标题：
                                    <input type="text" name="title" value="<%=a.getTitle() %>">
                                    <br>
                                    内容：
                                    <textarea name="cont" rows="15" cols="80"><%=a.getCont() %></textarea>
                                    <br>
                                    <input type="submit" value="提交"/>
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
