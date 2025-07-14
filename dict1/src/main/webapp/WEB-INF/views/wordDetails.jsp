<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="com.example.demo.model.Word" %>
<%
    Word wordDetail = (Word) request.getAttribute("wordDetail");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Word Details - <%= (wordDetail != null) ? wordDetail.getWord() : "Not Found" %></title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            margin: 0;
            padding: 0;
            color: #34495e;
        }
        .container {
            max-width: 700px;
            margin: 3rem auto;
            padding: 2rem 2.5rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }
        h1 {
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1.2rem;
            border-bottom: 3px solid #3498db;
            padding-bottom: 0.5rem;
        }
        p {
            font-size: 1.25rem;
            line-height: 1.6;
            margin: 1rem 0;
        }
        strong {
            color: #2980b9;
        }
        .not-found {
            color: #e74c3c;
            font-weight: 600;
            font-size: 1.2rem;
        }
        a {
            display: inline-block;
            margin-top: 2rem;
            font-weight: 600;
            color: #3498db;
            text-decoration: none;
            border: 2px solid #3498db;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        a:hover {
            background-color: #3498db;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Word Details</h1>

        <% if (wordDetail != null) { %>
            <p><strong>Word:</strong> <%= wordDetail.getWord() %></p>
            <p><strong>Meaning:</strong> <%= wordDetail.getMeaning() %></p>
        <% } else { %>
            <p class="not-found">Sorry, the word you are looking for was not found.</p>
        <% } %>

        <a href="<%= request.getContextPath() %>/api/dictionary/ui">← Back to Dictionary</a>
    </div>
</body>
</html>
