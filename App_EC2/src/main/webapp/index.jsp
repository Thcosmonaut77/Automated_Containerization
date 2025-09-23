<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Welcome to my New java project this year 2025</title>
  
  <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background: #f4f6f8;
            color: #333;
            margin: 0;
            padding: 50px;
        }
        h1 {
            color: #0066cc;
        }
        p {
            font-size: 18px;
        }
        .footer {
            margin-top: 50px;
            font-size: 14px;
            color: #777;
        }
    </style>
</head>
<body>
    <h1>Hello from Ibrahim</h1>
    <h1>🚀 MyApp is Running Successfully!</h1>
    <p>Deployed on <b>Apache Tomcat</b> through <b>Jenkins CI/CD</b>.</p>
    <p>This is the default <code>index.jsp</code> landing page.</p>

    <div class="footer">
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> MyApp</p>
    </div>
</body>
</html>