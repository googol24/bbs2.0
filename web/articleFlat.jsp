<%@ page import="java.sql.Connection" %>
<%@ page import="com.googol24.bbs.DB" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="com.googol24.bbs.Article" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@page pageEncoding="UTF-8" %>
<%@page errorPage="Error.jsp" %>
<%
    // 登录检查
    boolean logined = false;
    String sessionAdmin = (String) session.getAttribute("adminLogined");
    if (sessionAdmin != null && sessionAdmin.trim().equals("true")) {
        logined = true;
    }
%>
<%
    Connection connection = DB.getConnection();
    Statement statement = DB.getStatement(connection);

    // 分页控制
    int pageSize = 3;
    int pageNo = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.trim().equals("")) {
        // 页码合法性校验
        try {
            pageNo = Integer.parseInt(pageParam.trim());
        } catch (NumberFormatException e) {
            pageNo = 1;
        }
    }

    // 取总页数
    ResultSet resultSet = DB.executeQuery(statement, "SELECT COUNT(*) FROM article WHERE pid=0");
    resultSet.next();
    int totalRecords = resultSet.getInt(1);
    int totalPages = (totalRecords % pageSize == 0) ? totalRecords / pageSize : totalRecords / pageSize + 1;

    if (pageNo > totalPages) {
        pageNo = totalPages;
    } else if (pageNo <= 0) {
        pageNo = 1;
    }

    int startPos = (pageNo - 1) * pageSize;
    resultSet = DB.executeQuery(statement, "SELECT * FROM article WHERE pid=0 ORDER BY pdate DESC limit " + startPos + "," + pageSize);
    List<Article> articleList = new ArrayList<>();
    while (resultSet.next()) {
        Article article = new Article(
                resultSet.getInt("id"),
                resultSet.getInt("pid"),
                resultSet.getInt("rootid"),
                resultSet.getString("title"),
                resultSet.getTimestamp("pdate"),
                resultSet.getInt("isleaf")
        );
        articleList.add(article);
    }

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>BBS 2.0</title>
    <meta http-equiv="content-type" content="text/html; charset=utf8">
    <link rel="stylesheet" type="text/css" href="images/style.css" title="Integrated Styles">
    <script language="JavaScript" type="text/javascript" src="images/global.js"></script>
    <link rel="alternate" type="application/rss+xml" title="RSS"
          href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?forumID=20">
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
            <td width="98%"><p class="jive-breadcrumbs">论坛: BBS 2.0</p></td>
        </tr>
        </tbody>
    </table>
    <div class="jive-buttons">
        <table summary="Buttons" border="0" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td class="jive-icon"><a href="post.jsp"><img src="images/post-16x16.gif" alt="发表新主题" border="0"
                                                              height="16" width="16"></a></td>
                <td class="jive-icon-label"><a id="jive-post-thread" href="post.jsp">发表新主题</a></td>
            </tr>
            </tbody>
        </table>
    </div>
    <br>
    <table border="0" cellpadding="3" cellspacing="0" width="100%">
        <tbody>
        <tr valign="top">
            <td><span class="nobreak"> 页:
          第<%= pageNo %>页,共<%= totalPages %>页 - <span class="jive-paginator"> [</span></span>

                <span class="nobreak"><span class="jive-paginator">
          <a href="articleFlat.jsp?page=1">第一页</a></span></span>


                <span class="nobreak"><span class="jive-paginator">|</span></span>
                <span class="nobreak"><span class="jive-paginator">
          <a href="articleFlat.jsp?page=<%=  pageNo - 1 %>">上一页</a>
          </span></span>

                <span class="nobreak"><span class="jive-paginator">| </span></span>
                <span class="nobreak"><span class="jive-paginator">
         <a href="articleFlat.jsp?page=<%= pageNo + 1 %>">下一页</a>
          |&nbsp; 
          <a href="articleFlat.jsp?page=<%= totalPages %>">最末页</a> ] </span> </span></td>
        </tr>
        </tbody>
    </table>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tbody>
        <tr valign="top">
            <td width="99%">
                <div class="jive-thread-list">
                    <div class="jive-table">
                        <table summary="List of threads" cellpadding="0" cellspacing="0" width="100%">
                            <thead>
                            <tr>
                                <th class="jive-first" colspan="3"> 主题</th>
                                <th class="jive-author">
                                    <nobr> 作者
                                        &nbsp;
                                    </nobr>
                                </th>
                                <th class="jive-view-count">
                                    <nobr> 浏览
                                        &nbsp;
                                    </nobr>
                                </th>
                                <th class="jive-msg-count" nowrap="nowrap"> 回复</th>
                                <th class="jive-last" nowrap="nowrap"> 最新帖子</th>
                            </tr>
                            </thead>
                            <tbody>

                            <%
                                int i = 0;
                                for (Article article : articleList) {
                                    String classStr = (i % 2 == 0) ? "jive-even" : "jive-odd";
                            %>
                            <tr class="<%= classStr %>">
                                <td class="jive-first" nowrap="nowrap" width="1%">
                                    <div class="jive-bullet"><img src="images/read-16x16.gif" alt="已读" border="0"
                                                                  height="16" width="16">
                                        <!-- div-->
                                    </div>
                                </td>

                                <td nowrap="nowrap" width="1%">
                                    <%
                                        // 获取当前页面的地址
                                        String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + request.getServletPath() + (request.getQueryString() == null ? "" : "?" + request.getQueryString());
                                        String url2 = request.getRequestURL() + (request.getQueryString() == null ? "" : "?" + request.getQueryString());
//                                        System.out.println(url);
//                                        System.out.println(url2);
                                    %>
                                    <% if (logined) { %>
                                    <a href="delete.jsp?id=<%= article.getId() %>&isLeaf=<%= article.getIsLeaf() %>&pid=<%= article.getPid() %>&from=<%= URLEncoder.encode(url, "UTF-8") %>">DEL</a>
                                    &nbsp;
                                    <a href="modify.jsp?id=<%= article.getId() %>">MOD</a>
                                    <% } %>
                                </td>

                                <td class="jive-thread-name" width="95%"><a id="jive-thread-1"
                                                                            href="articleDetailFlat.jsp?id=<%=article.getId() %>"><%=article.getTitle() %>
                                </a></td>
                                <td class="jive-author" nowrap="nowrap" width="1%"><span class=""> <a
                                        href="http://bbs.chinajavaworld.com/profile.jspa?userID=226030">admin</a> </span>
                                </td>
                                <td class="jive-view-count" width="1%"> 10000</td>
                                <td class="jive-msg-count" width="1%"> 0</td>
                                <td class="jive-last" nowrap="nowrap" width="1%">
                                    <div class="jive-last-post"><%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(article.getPdate()) %>
                                        <br>
                                        by: <a href="http://bbs.chinajavaworld.com/thread.jspa?messageID=780182#780182"
                                               title="jingjiangjun" style="">admin &#187;</a></div>
                                </td>
                            </tr>
                            <%
                                    i++;
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="jive-legend"></div>
            </td>
        </tr>
        </tbody>
    </table>
    <br>
    <br>
</div>
</body>
</html>
