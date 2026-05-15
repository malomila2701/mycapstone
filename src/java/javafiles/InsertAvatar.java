/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

/**
 *
 * @author HP
 */
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class InsertAvatar {

    public static void main(String[] args) {

        try {

            Connection con = DBConnection.connect();

            // USER 1
            byte[] img1 = Files.readAllBytes(
                    Paths.get("C:/images/user1.png")
            );

            PreparedStatement pst1 = con.prepareStatement(
                    "UPDATE users SET avatar = ?, avatar_type = ? WHERE user_id = ?"
            );

            pst1.setBytes(1, img1);
            pst1.setString(2, "image/png");
            pst1.setInt(3, 1);

            pst1.executeUpdate();

            // USER 2
            byte[] img2 = Files.readAllBytes(
                    Paths.get("C:/images/user2.jpg")
            );

            PreparedStatement pst2 = con.prepareStatement(
                    "UPDATE users SET avatar = ?, avatar_type = ? WHERE user_id = ?"
            );

            pst2.setBytes(1, img2);
            pst2.setString(2, "image/jpeg");
            pst2.setInt(3, 2);

            pst2.executeUpdate();

            System.out.println("Images insérées.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
