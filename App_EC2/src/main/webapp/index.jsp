<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>🚀 Welcome to My Java DevOps Project | 2025</title>
  <style>
      body {
          margin: 0;
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background: linear-gradient(135deg, #0f172a, #1e3a8a, #2563eb, #38bdf8);
          background-size: 400% 400%;
          animation: gradientBG 12s ease infinite;
          color: #f8fafc;
          text-align: center;
          display: flex;
          flex-direction: column;
          justify-content: center;
          min-height: 100vh;
          padding: 20px;
      }

      @keyframes gradientBG {
          0% {background-position: 0% 50%;}
          50% {background-position: 100% 50%;}
          100% {background-position: 0% 50%;}
      }

      h1 {
          font-size: 3rem;
          margin-bottom: 10px;
          color: #38bdf8;
      }

      h2 {
          font-size: 1.5rem;
          margin-bottom: 30px;
          font-weight: 400;
          color: #e2e8f0;
      }

      .highlight {
          font-weight: bold;
          color: #22d3ee;
      }

      .tech-stack {
          margin-top: 30px;
          display: flex;
          flex-wrap: wrap;
          justify-content: center;
          gap: 15px;
      }

      .badge {
          background: rgba(255,255,255,0.1);
          padding: 10px 20px;
          border-radius: 25px;
          font-size: 16px;
          border: 1px solid rgba(255,255,255,0.2);
          transition: transform 0.3s;
      }

      .badge:hover {
          transform: scale(1.1);
          background: rgba(255,255,255,0.2);
      }

      .footer {
          margin-top: 50px;
          font-size: 14px;
          color: #cbd5e1;
      }
  </style>
</head>
<body>
    <h1>✨ Assalamu Alaikum Warahmatullah ✨</h1>
    <h2>It Works! 🚀 Successfully Deployed via <span class="highlight">Jenkins CI/CD</span> on <span class="highlight">Apache Tomcat</span></h2>
    
    <div class="tech-stack">
        <div class="badge">☁️ AWS</div>
        <div class="badge">⚙️ Jenkins</div>
        <div class="badge">📦 Docker</div>
        <div class="badge">🌍 Tomcat</div>
        <div class="badge">☕ Java</div>
        <div class="badge">🛠 Terraform</div>
    </div>

    <div class="footer">
        <p>&copy; <%= java.time.Year.now() %> MyApp | Built with ❤️ and Automation</p>
    </div>
</body>
</html>
