<%@ page import="java.sql.*" %>
<%@ page import="com.googol24.bbs.DB" %>
<%@ page import="com.googol24.bbs.Article" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page errorPage="Error.jsp" %>
<%!
    // 方法定义
    // 树状结构递归获取主题
    private void tree(List<Article> articles, Connection conn, int id, int level) {
        Statement statement = DB.getStatement(conn);
        ResultSet resultSet = DB.executeQuery(statement, "SELECT * FROM article WHERE pid=" + id);
        try {
            while (resultSet.next()) {
                Article a = new Article(
                        resultSet.getInt("id"),
                        resultSet.getInt("pid"),
                        resultSet.getInt("rootid"),
                        resultSet.getString("title"),
                        resultSet.getTimestamp("pdate"),
                        resultSet.getInt("isleaf")
                );
                a.setLevel(level);
                articles.add(a);
                if (a.getIsLeaf() != 0) {
                    tree(articles, conn, a.getId(), level + 1);
                }
            }
        } catch (SQLException e) {
            // 方法定义(声明语句)里面是要抛异常的
            e.printStackTrace();
        } finally {
            DB.close(resultSet);
            DB.close(statement);
        }
    }
%>
<%
    List<Article> articleList = new ArrayList<>();

    // 获取连接
    Connection connection = DB.getConnection();
    // 递归输出树状结构
    tree(articleList, connection, 0, 0);
    DB.close(connection);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>BBS 2.0</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="images/style.css" title="Integrated Styles">
<script language="JavaScript" type="text/javascript" src="images/global.js"></script>
<link rel="alternate" type="application/rss+xml" title="RSS" href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?forumID=20">
<script language="JavaScript" type="text/javascript" src="images/common.js"></script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tbody>
    <tr>
      <td width="40%"><img src="images/header-stretch.gif" alt="" border="0" height="57" width="100%">
     	</td>
      <td width="1%"><img src="images/header-right.gif" alt="" height="57" border="0"></td>
    </tr>
  </tbody>
</table>
<br>
<div id="jive-forumpage">
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
      <tr valign="top">
        <td width="98%"><p class="jive-breadcrumbs">论坛: BBS 2.0</p>
          <p class="jive-description"> 简易的BBS </p>
          </td>
      </tr>
    </tbody>
  </table>
  <div class="jive-buttons">
    <table summary="Buttons" border="0" cellpadding="0" cellspacing="0">
      <tbody>
        <tr>
          <td class="jive-icon"><a href="post.jsp"><img src="images/post-16x16.gif" alt="发表新主题" border="0" height="16" width="16"></a></td>
          <td class="jive-icon-label"><a id="jive-post-thread" href="post.jsp">发表新主题</a> <a href="http://bbs.chinajavaworld.com/forum.jspa?forumID=20&amp;isBest=1"></a></td>
        </tr>
      </tbody>
    </table>
  </div>
  <br>
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
      <tr valign="top">
        <td width="99%"><div class="jive-thread-list">
            <div class="jive-table">
              <table summary="List of threads" cellpadding="0" cellspacing="0" width="100%">
                <thead>
                  <tr>
                    <th class="jive-first" colspan="3"> 主题 </th>
                    <th class="jive-author"> <nobr> 作者
                      &nbsp; </nobr> </th>
                    <th class="jive-view-count"> <nobr> 浏览
                      &nbsp; </nobr> </th>
                    <th class="jive-msg-count" nowrap="nowrap"> 回复 </th>
                    <th class="jive-last" nowrap="nowrap"> 最新帖子 </th>
                  </tr>
                </thead>
                <tbody>
                <%
                    for (Iterator<Article> iterator = articleList.iterator(); iterator.hasNext(); ) {
                        Article article = iterator.next();
                        String preStr = "";
                        for (int i = 0; i < article.getLevel(); i++) {
                            preStr += "----";
                        }

                %>
                  <tr class="jive-even">
                    <td class="jive-first" nowrap="nowrap" width="1%"><div class="jive-bullet"> <img src="images/read-16x16.gif" alt="已读" border="0" height="16" width="16">
                        <!-- div-->
                      </div></td>

                    <td nowrap="nowrap" width="1%">
                    	<a href="delete.jsp?id=<%= article.getId() %>&isLeaf=<%= article.getIsLeaf() %>&pid=<%= article.getPid() %>">DEL</a>
                    </td>
                    <td class="jive-thread-name" width="95%"><a id="jive-thread-1" href="articleDetail.jsp?id=<%= article.getId() %>"><%= preStr + article.getTitle() %></a></td>
                    <td class="jive-author" nowrap="nowrap" width="1%"><span class=""> <a href="http://bbs.chinajavaworld.com/profile.jspa?userID=226030">admin</a> </span></td>
                    <td class="jive-view-count" width="1%"> 10000</td>
                    <td class="jive-msg-count" width="1%"> 0</td>
                    <td class="jive-last" nowrap="nowrap" width="1%"><div class="jive-last-post"> <%= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(article.getPdate()) %> <br>
                        by: <a href="http://bbs.chinajavaworld.com/thread.jspa?messageID=780182#780182" title="jingjiangjun" style="">admin &#187;</a> </div></td>
                  </tr>
                <%
                    }
                %>
                </tbody>
              </table>
            </div>
          </div>
          <div class="jive-legend"></div></td>
      </tr>
    </tbody>
  </table>
  <br>
  <br>
</div>
</body>
</html>
