<%@ page pageEncoding="GB18030"%>
<%@ page import="java.sql.*, com.googol24.bbs.*, java.util.*" %>
<%@ page import="com.googol24.bbs.DB" %>
<%@ page errorPage="Error.jsp" %>

<%
String strId = request.getParameter("id");
if(strId == null || strId.trim().equals("")) {
	out.println("Error ID!");
	return;
}
int id;
try {
	id = Integer.parseInt(strId);
} catch (NumberFormatException e) {
	out.println("Error ID Again!");
	return;
} 


List<Article> articles = new ArrayList<>();
Connection conn = DB.getConnection();
String sql = "select * from article where rootid = " + id + " order by pdate asc";
Statement stmt = DB.getStatement(conn);
ResultSet rs = DB.executeQuery(stmt, sql);
while(rs.next()) {
	Article a = new Article(
            rs.getInt("id"),
            rs.getInt("pid"),
            rs.getInt("rootid"),
            rs.getString("title"),
            rs.getTimestamp("pdate"),
            rs.getInt("isleaf")
    );
    a.setCont(rs.getString("cont"));
	articles.add(a);
}


DB.close(rs);
DB.close(stmt);
DB.close(conn);

%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>BBS 2.0</title>
<meta http-equiv="content-type" content="text/html; charset=GBK">
<link rel="stylesheet" type="text/css" href="images/style.css" title="Integrated Styles">
<script language="JavaScript" type="text/javascript" src="images/global.js"></script>
<link rel="alternate" type="application/rss+xml" title="RSS" href="#">
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
<div id="jive-flatpage">
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
      <tr valign="top">
        <td width="99%"><p class="jive-breadcrumbs"> <a href="<%= request.getRequestURL() + "/articleFlat.jsp" %>">��ҳ</a> &#187; <a href="#">BBS v2.0</a> </p>
          <p class="jive-page-title"> ���� </p></td>
        <td width="1%"><div class="jive-accountbox"></div></td>
      </tr>
    </tbody>
  </table>
  <div class="jive-buttons">
    <table summary="Buttons" border="0" cellpadding="0" cellspacing="0">
      <tbody>
        <tr>
          <td class="jive-icon"><a href="http://bbs.chinajavaworld.com/post%21reply.jspa?threadID=744236"><img src="images/reply-16x16.gif" alt="�ظ�������" border="0" height="16" width="16"></a></td>
          <td class="jive-icon-label"><a id="jive-reply-thread" href="">�ظ�������</a> </td>
        </tr>
      </tbody>
    </table>
  </div>
  <br>
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
      <tr valign="top">
        <td width="99%"><div id="jive-message-holder">
            <div class="jive-message-list">
              <div class="jive-table">
                <div class="jive-messagebox">
				
				<!-- start -->
				<%
				for(int i=0; i<articles.size(); i++) {
					Article a = articles.get(i);
					String floor = i == 0 ? "¥��" : "��" + i + "¥";
				 %>
				
                  <table summary="Message" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tbody>
                      <tr id="jive-message-780144" class="jive-odd" valign="top">
                        <td class="jive-first" width="1%">
						<!-- ������Ϣ��table -->
						<table border="0" cellpadding="0" cellspacing="0" width="150">
                            <tbody>
                              <tr>
                                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tbody>
                                      <tr valign="top">
                                        <td style="padding: 0px;" width="1%"><nobr> <a href="http://bbs.chinajavaworld.com/profile.jspa?userID=215489" title="ŵ���׿�">ŵ���׿�</a> </nobr> </td>
                                        <td style="padding: 0px;" width="99%"><img class="jive-status-level-image" src="images/level3.gif" title="��������" alt="" border="0"><br>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                  <img class="jive-avatar" src="images/avatar-display.png" alt="" border="0"> <br>
                                  <br>
                                  <span class="jive-description"> ����:
                                  34 <br>
                                  ����: 100<br>
                                  ע��:
                                  07-5-10 <br>
                                  <a href="http://blog.chinajavaworld.com/u/215489" target="_blank"><font color="red">�����ҵ�Blog</font></a> </span> </td>
                              </tr>
                            </tbody>
                          </table>
						  <!--������Ϣtable����-->
						  
						  </td>
                        <td class="jive-last" width="99%"><table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tbody>
                              <tr valign="top">
                                <td width="1%"></td>
                                <td width="97%"><span class="jive-subject"><%=floor + "-------" + a.getTitle()%></span> </td>
                                <td class="jive-rating-buttons" nowrap="nowrap" width="1%"></td>
                                <td width="1%"><div class="jive-buttons">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                      <tbody>
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td class="jive-icon"><a href="http://bbs.chinajavaworld.com/post%21reply.jspa?messageID=780144" title="�ظ�������"><img src="images/reply-16x16.gif" alt="�ظ�������" border="0" height="16" width="16"></a> </td>
                                          <td class="jive-icon-label"><a href="reply.jsp?id=<%=a.getId() %>&rootId=<%=a.getRootId() %>" title="�ظ�������">�ظ�</a> </td>
                                        </tr>
                                      </tbody>
                                    </table>
                                  </div></td>
                              </tr>
                              <tr>
                                <td colspan="4" style="border-top: 1px solid rgb(204, 204, 204);"><br>
                                 <%=a.getCont() %> <br>
                                  <br>
                                </td>
                              </tr>
                              <tr>
                                <td colspan="4" style="font-size: 9pt;"><img src="images/sigline.gif"><br>
                                  <font color="#568ac2">�Ǵ󷨹�ʮ����Ǵ󷨹�ʮ�����</font> <br>
                                </td>
                              </tr>
                              <tr>
                                <td colspan="4" style="border-top: 1px solid rgb(204, 204, 204); font-size: 9pt; table-layout: fixed;"> ��<a href="http://www.bjsxt.com"><font color="#666666">http://www.baidu.com</font></a> </td>
                              </tr>
                            </tbody>
                          </table></td>
                      </tr>
                    </tbody>
                  </table>
				  
				  <!-- end -->
				  <%
				  }
				   %>
                </div>
              </div>
            </div>
            <div class="jive-message-list-footer">
              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tbody>
                  <tr>
                    <td nowrap="nowrap" width="1%"><br><br></td>
                    <td align="center" width="98%"><table border="0" cellpadding="0" cellspacing="0">
                        <tbody>
                          <tr>
                            <td><a href="articleFlat.jsp"><img src="images/arrow-left-16x16.gif" alt="���ص������б�" border="0" height="16" hspace="6" width="16"></a> </td>
                            <td><a href="articleFlat.jsp">���ص������б�</a> </td>
                          </tr>
                        </tbody>
                      </table></td>
                    <td nowrap="nowrap" width="1%">&nbsp;</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div></td>
        <td width="1%">&nbsp;</td>
      </tr>
    </tbody>
  </table>
</div>
</body>
</html>
