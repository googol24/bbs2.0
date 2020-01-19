<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<html>
<head>
    <title>Error Page</title>
</head>
<body>
<h2>
    Sorry, The page encoded a error: <%= exception.getMessage() %>
</h2>
<h3>
    Stack Trace:
    <p>
        <%= exception.getStackTrace() %>
    </p>
</h3>
</body>
</html>
