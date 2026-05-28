/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.sql.Date;
import java.sql.Time;

/**
 *
 * @author HP
 */
public class UserPermission {
    private int id;
    private int permission_id;
    private String fullname;
    private String email;
    private Date start_date;
    private Date end_date;
    private Time start_time;
    private Time end_time;
    private String status;
    private String motif;
    private String response_message;

    public UserPermission(int id, int permission_id, String fullName, String email, Date startDate, Date endDate, Time start_time, Time end_time, String status, String motif, String response_message) {
        this.id = id;
        this.permission_id = permission_id;
        this.fullname = fullName;
        this.email = email;
        this.start_date = startDate;
        this.end_date = endDate;
        this.start_time = start_time;
        this.end_time = end_time;
        this.status = status;
        this.motif = motif;
        this.response_message = response_message;
    }
    
    public Integer getUserId() { return id; }
    public Integer getPermissionId() { return permission_id; }
    public String getFullName() { return fullname; }
    public String getEmail() { return email; }
    public Date getStartDate() { return start_date; }
    public Time getStartTime() { return start_time; }
    public Time getEndTime() { return end_time; }
    public Date getEndDate() { return end_date; }
    public String getStatus() { return status; }
    public String getMotif() { return motif; }
    public String getResponseMessage() { return response_message; }
}

