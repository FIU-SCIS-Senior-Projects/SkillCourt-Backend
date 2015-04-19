package com.seniorproject.skillcourt;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by msant080 on 4/19/2015.
 */
public class Statistic implements Parcelable {
    private String username;    //Strings
    private String points, shots, onTarget, lStrike, avgTimeBtwShots, avgForce; //Ints
    private String dateTime;    //dateTime
    private String level; //Chars

    public Statistic(String username, String level, String points, String shots, String onTarget,
                     String lStrike, String avgTimeBtwShots, String avgForce, String dateTime) {
        this.username = username;
        this.points = points;
        this.dateTime = dateTime;
        this.shots = shots;
        this.onTarget = onTarget;
        this.lStrike = lStrike;
        this.avgTimeBtwShots = avgTimeBtwShots;
        this.avgForce = avgForce;
        this.level = level;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    // Parcelling part
    public Statistic(Parcel in){
        String[] data = new String[3];

        in.readStringArray(data);
        this.username = data[0];
        this.points = data[1];
        this.shots = data[2];
        this.onTarget = data[3];
        this.lStrike = data[4];
        this.avgTimeBtwShots = data[5];
        this.avgForce = data[6];
        this.level = data[7];
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeStringArray(new String[] {this.username,
                        this.points,
                        this.shots,
                        this.onTarget,
                        this.lStrike,
                        this.avgTimeBtwShots,
                        this.avgForce,
                        this.level});
    }

    public static final Parcelable.Creator CREATOR = new Parcelable.Creator() {
        public Statistic createFromParcel(Parcel in) {
            return new Statistic(in);
        }

        public Statistic[] newArray(int size) {
            return new Statistic[size];
        }
    };

    public String getUsername() {
        return username;
    }

    public String getPoints() {
        return points;
    }

    public String getShots() {
        return shots;
    }

    public String getOnTarget() {
        return onTarget;
    }

    public String getlStrike() {
        return lStrike;
    }

    public String getAvgTimeBtwShots() {
        return avgTimeBtwShots;
    }

    public String getAvgForce() {
        return avgForce;
    }

    public String getDateTime() {
        return dateTime;
    }

    public String getLevel() {
        return level;
    }
}
