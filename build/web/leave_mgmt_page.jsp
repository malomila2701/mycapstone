<%-- 
    Document   : leave_mgmt_page
    Created on : 19 nov. 2025, 14:58:28
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Leave Management</title>
        
        <link rel="stylesheet" 
              href="css/lm_styles.css">
        
    </head>
    
    <body>
        <h1>Hello World!</h1>
        
       <div class="accordion">

  <div class="item">
    <input type="checkbox" id="acc1">
    <label for="acc1" class="title">Section 1 – Introduction</label>
    <div class="content">
      <p>Voici le contenu de la première section, animé lors de l’ouverture.</p>
    </div>
  </div>

  <div class="item">
    <input type="checkbox" id="acc2">
    <label for="acc2" class="title">Section 2 – Détails</label>
    <div class="content">
      <p>Contenu de la deuxième section avec une transition fluide.</p>
    </div>
  </div>

  <div class="item">
    <input type="checkbox" id="acc3">
    <label for="acc3" class="title">Section 3 – Conclusion</label>
    <div class="content">
      <p>Dernière section du dépliant.</p>
    </div>
  </div>

</div>
        
    </body>
</html>
