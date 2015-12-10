package com.seniorproject.skillcourt;

/**
 * Created by msant080 on 4/16/2015.
 */
public class Routine {

    private String name;
    private String description;
    private int rounds;
    private int timer;
    private int timebased;
    private char type;
    private boolean lock;
    private String username;
    private char usertype;
    private char difficulty;
    private boolean ground;

    public Routine(String name) {
        this.name = name;
    }

    public char getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(char difficulty) {
        this.difficulty = difficulty;
    }

    public int getRounds() {
        return rounds;
    }

    public void setRounds(int rounds) {
        this.rounds = rounds;
    }

    public int getTimer() {
        return timer;
    }

    public void setTimer(int timer) {
        this.timer = timer;
    }

    public int getTimebased() {
        return timebased;
    }

    public void setTimebased(int timebased) {
        this.timebased = timebased;
    }

    public char getType() {
        return type;
    }

    public void setType(char type) {
        this.type = type;
    }

    public boolean isLock() {
        return lock;
    }

    public void setLock(boolean lock) {
        this.lock = lock;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public char getUsertype() {
        return usertype;
    }

    public void setUsertype(char usertype) {
        this.usertype = usertype;
    }

    public String getName() {
        return name;
    }

    public boolean getGround() {
        return ground;
    }

    public void setGround(boolean ground) {
        this.ground = ground;
    }

    public void setName(String name) {

        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
