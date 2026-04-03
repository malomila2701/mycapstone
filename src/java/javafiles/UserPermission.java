/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.util.Date;
import java.sql.Time;

/**
 *
 * @author HP
 */
public class UserPermission {
    private int id;
    private int permission_id;
    private String fullname;
    private Date start_date;
    private Date end_date;
    private Time start_time;
    private Time end_time;
    private String status;
    private String motif;

    public UserPermission(int id, int permission_id, String fullName, Date startDate, Date endDate, Time start_time, Time end_time, String status, String motif) {
        this.id = id;
        this.permission_id = permission_id;
        this.fullname = fullName;
        this.start_date = startDate;
        this.end_date = endDate;
        this.start_time = start_time;
        this.end_time = end_time;
        this.status = status;
        this.motif = motif;
    }
    
    public Integer getUserId() { return id; }
    public Integer getPermissionId() { return permission_id; }
    public String getFullName() { return fullname; }
    public Date getStartDate() { return start_date; }
    public Date getStartTime() { return start_time; }
    public Date getEndTime() { return end_time; }
    public Date getEndDate() { return end_date; }
    public String getStatus() { return status; }
    public String getMotif() { return motif; }
}

