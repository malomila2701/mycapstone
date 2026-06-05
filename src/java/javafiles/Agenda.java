/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

import java.sql.Date;
import java.sql.Time;

/**
 *
 * @author JeanSamuel
 */
public class Agenda {
    private int agenda_id;
    private String title;
    private Date start_date;
    private Date end_date;
    private String type;
    private Time start_time;
    private Time end_time;
    private String event;


    public Agenda(int agenda_id, String title, Date startDate, Date endDate, String type, Time start_time, Time end_time, String event) {
        this.agenda_id = agenda_id;
        this.title = title;
        this.start_date = startDate;
        this.end_date = endDate;
        this.type = type;
        this.start_time = start_time;
        this.end_time = end_time;
        this.event = event;
    }
    
    public Integer getAgendaId() { return agenda_id; }
    public String getTitle() { return title; }
    public Date getStartDate() { return start_date; }
    public Date getEndDate() { return end_date; }
    public String getType() { return type; }
    public Time getStartTime() { return start_time; }
    public Time getEndTime() { return end_time; }
    public String getEvent() { return event; }

}
