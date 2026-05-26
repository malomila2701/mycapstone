/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.sql.Date;

/**
 *
 * @author HP
 */
public class UserLeave {
    private int id;
    private int holidays_id;
    private String fullname;
    private Date start_date;
    private Date end_date;
    private String type;
    private String status;
    private String motif;

    public UserLeave(int id, int holidays_id, String fullName, Date startDate, Date endDate, String type, String status, String motif) {
        this.id = id;
        this.holidays_id = holidays_id;
        this.fullname = fullName;
        this.start_date = startDate;
        this.end_date = endDate;
        this.type = type;
        this.status = status;
        this.motif = motif;
    }
    
    public Integer getUserId() { return id; }
    public Integer getHolidayId() { return holidays_id; }
    public String getFullName() { return fullname; }
    public Date getStartDate() { return start_date; }
    public Date getEndDate() { return end_date; }
    public String getType() { return type; }
    public String getStatus() { return status; }
    public String getMotif() { return motif; }
}

