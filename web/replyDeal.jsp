<%@ page language="java" import="java.util.*, java.sql.*, com.googol24.bbs.*" pageEncoding="UTF-8" %>
<%@ page import="com.googol24.bbs.DB" %>
<%@ page errorPage="Error.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    int pid = Integer.parseInt(request.getParameter("pid"));
    int rootId = Integer.parseInt(request.getParameter("rootId"));
    String title = request.getParameter("title");
    String cont = request.getParameter("cont");

    Connection conn = DB.getConnection();

    // 获取原有的自动提交状态
    boolean autoCommit = conn.getAutoCommit();

    // 事务开启
    conn.setAutoCommit(false);

    String sql = "insert into article values (null, ?, ?, ?, ?, now(), ?)";
    PreparedStatement pStmt = DB.preparedStatement(conn, sql);
    pStmt.setInt(1, pid);
    pStmt.setInt(2, rootId);
    pStmt.setString(3, title);
    pStmt.setString(4, cont);
    pStmt.setInt(5, 0);
    pStmt.executeUpdate();

    Statement stmt = DB.getStatement(conn);
    stmt.executeUpdate("UPDATE article SET isleaf = 1 WHERE id = " + pid);

    conn.commit();

    // 恢复现场
    conn.setAutoCommit(autoCommit);

    // 关闭资源
    // pStmt是Statement的子类
    DB.close(pStmt);
    DB.close(stmt);
    DB.close(conn);
%>

<span id="time" style="background:red">5</span>秒钟后自动跳转，如果不跳转，请点击下面链接

<script language="JavaScript1.2" type="text/javascript">
    <!--
    //  Place this in the 'head' section of your page.

    function delayURL(url) {
        var delay = document.getElementById("time").innerHTML;
//alert(delay);
        if (delay > 0) {
            delay--;
            document.getElementById("time").innerHTML = delay;
        } else {
            window.top.location.href = url;
        }
        setTimeout("delayURL('" + url + "')", 1000); //delayURL(http://wwer)
    }

    //-->

</script>


<a href="article.jsp">主题列表</a>
<script type="text/javascript">
    delayURL("article.jsp");
</script>