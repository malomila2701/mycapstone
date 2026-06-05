When pulling project on MAC:
  in nbproject --> build-impl.xml 
  Add <target name="-post-compile">
        <copy todir="build/web/META-INF">
        <fileset dir="web/META-INF"/>
        </copy>
        <!-- Empty placeholder for easier customization. -->
        <!-- You can override this target in the ../build.xml file. -->
    </target>



Insert AVATAR
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.nio.file.*;
import java.sql.*;

public class InsertAvatar {

    public static void main(String[] args) throws Exception {
        // Change these for each user
        int userId = 106;
        String imagePath = "/Users/JeanSamuel/Documents/PRIME_internship/lulu-meyers.png";
        String mimeType = "image/png";

        byte[] imageBytes = Files.readAllBytes(Paths.get(imagePath));

        try (java.sql.Connection con = DriverManager.getConnection(
                "jdbc:mysql://capstone-prototype.i.aivencloud.com:13324/defaultdb?ssl-mode=REQUIRED",
                "avnadmin",
                ""
        )) {
            PreparedStatement ps = con.prepareStatement(
                    "UPDATE users SET avatar = ?, avatar_type = ? WHERE user_id = ?"
            );
            ps.setBytes(1, imageBytes);
            ps.setString(2, mimeType);
            ps.setInt(3, userId);
            ps.executeUpdate();

            System.out.println("Avatar inserted for user " + userId);
        }
    }
}

