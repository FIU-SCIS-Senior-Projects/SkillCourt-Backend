package com.seniorproject.skillcourt;

import android.os.StrictMode;
import android.util.Log;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import java.util.ArrayList;
import java.util.List;
import java.util.LinkedList;
/**
 * Created by Andy on 2/15/2015.
 */
public class dbInteraction {
    public dbInteraction()
    {
        if (android.os.Build.VERSION.SDK_INT > 9) {

            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);

        }
    }

    public char checkIfUserNameExists(String username)
    {
        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/checkIfUnameExist.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", username));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);

            if(resp.equals("y"))//the username exist
            {
                return 'y';
            }
            else//the username does not exist
            {
                return 'n';
            }
        }
        catch (Exception e)//error in connection
        {
            return 'e';
        }
    }

    public char checkIfEmailExists(String email)
    {
        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/checkIfEmailExist.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("email", email));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);
            return resp.charAt(0);
        }
        catch (Exception e)//error in connection
        {
            return 'e';
        }
    }


    public char addUser(String Credentials[])
    {
        HttpPost httppost;
        HttpClient httpclient;
        //HttpResponse response;

        List<NameValuePair> nameValuePairs;
        try {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php_query/create_account.php");
            nameValuePairs = new ArrayList<>(8);
            nameValuePairs.add(new BasicNameValuePair("firstName", Credentials[3]));
            nameValuePairs.add(new BasicNameValuePair("lastName", Credentials[4]));
            nameValuePairs.add(new BasicNameValuePair("dateOfBirth", Credentials[5]));

            nameValuePairs.add(new BasicNameValuePair("email", Credentials[2]));

            nameValuePairs.add(new BasicNameValuePair("coachUserName", Credentials[6]));
            nameValuePairs.add(new BasicNameValuePair("position", Credentials[7]));

            nameValuePairs.add(new BasicNameValuePair("userName", Credentials[0]));
            nameValuePairs.add(new BasicNameValuePair("password", Credentials[1]));

            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            //final String resp = httpclient.execute(httppost, responseHandler);
            return 'y';

        }
        catch (Exception e)
        {
            //show error
            return 'e';
        }
    }

    public char checkUnamePasswCombination(String username, String password)
    {
        HttpPost httppost;
        HttpResponse response;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        nameValuePairs = new ArrayList<NameValuePair>(2);
        nameValuePairs.add(new BasicNameValuePair("username", username));
        nameValuePairs.add(new BasicNameValuePair("password", password));
        try {

            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/log_in.php");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            // Execute HTTP Post Request
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            resp = httpclient.execute(httppost, responseHandler);
            System.out.println("Resp: " + resp);

            // Login Response
            if (resp.trim().equalsIgnoreCase("Valid"))
                return 'y';
            else
                return 'n';
        } catch (Exception e) {
            return 'e';
        }
    }

    /**
     * returns string array of vars
     * @param rname name of routine to be fetched
     * @param user username of the routine creator
     * @param usertype usertype of routine creator
     * @return String[rname, descr, rounds, timer, timebased, type, lock, username, usertype, difficulty]
     */
    public Routine getRoutine(String rname, String user, String usertype)
    {
        HttpPost httppost;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        nameValuePairs = new ArrayList<>(3);
        nameValuePairs.add(new BasicNameValuePair("rname", rname));
        nameValuePairs.add(new BasicNameValuePair("uname", user));
        nameValuePairs.add(new BasicNameValuePair("utype", usertype));
        try {
            System.out.println("Connecting to db");
            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/get_routine_info.php");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            System.out.println("Executing post");
            // Execute HTTP Post Request
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            resp = httpclient.execute(httppost, responseHandler);
            System.out.println("Post executed");
            System.out.println("Resp: " + resp);
            String[] vars = new String[7];
            int i = 0;
            while (resp.contains("|")) {
                vars[i] = resp.substring(0, resp.indexOf("|"));
                resp = resp.substring(resp.indexOf("|") + 1);
                System.out.println("added " + vars[i] + " to index " + i);
                i++;
            }
            vars[i] = resp;

            // Create new routine with vars obtained
            Routine routine = new Routine(rname);
            routine.setUsername(user);
            routine.setUsertype(usertype.charAt(0));
            routine.setDescription(vars[0]);
            routine.setRounds(Integer.parseInt(vars[1]));
            routine.setTimer(Integer.parseInt(vars[2]));
            routine.setTimebased(Integer.parseInt(vars[3]));
            routine.setType(vars[4].charAt(0));
            if (Integer.parseInt(vars[5]) == 1)
                routine.setLock(true);
            else
                routine.setLock(false);
            routine.setDifficulty(vars[6].charAt(0));

            return routine;
        } catch (Exception e) {
            System.out.println(e);
            return null;
        }
    }

    public String listCustomRoutines(String player, String userType) {
        HttpPost httppost;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        nameValuePairs = new ArrayList<>(2);
        nameValuePairs.add(new BasicNameValuePair("puname", player));
        nameValuePairs.add(new BasicNameValuePair("usertype", userType));
        try {
            System.out.println("Connecting to db");
            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/list_custom_routines.php");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            System.out.println("Executing post");
            // Execute HTTP Post Request
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            resp = httpclient.execute(httppost, responseHandler);
            System.out.println("Post executed");

            // Login Response
            System.out.println("Resp: " + resp);
            return resp;
        } catch (Exception e) {
            System.out.println(e);
            return "Error";
        }
    }

    public String getRoutineDescription(String routine, String username, String userType)
    {
        HttpPost httppost;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs = new ArrayList<>(3);
        nameValuePairs.add(new BasicNameValuePair("rname", routine));
        nameValuePairs.add(new BasicNameValuePair("uname", username));
        nameValuePairs.add(new BasicNameValuePair("usertype", userType));
        try {
            System.out.println("Connecting to db with routine = " + routine + " " + username + " " + userType);
            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/get_description.php");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            System.out.println("Executing post");
            // Execute HTTP Post Request
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            resp = httpclient.execute(httppost, responseHandler);
            System.out.println("Post executed");

            // Login Response
            System.out.println("Resp: " + resp);
            return resp;
        } catch (Exception e) {
            System.out.println(e);
            return "Error";
        }
    }

    public String getCoach(String username) {
        HttpPost httppost;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs = new ArrayList<>(1);
        nameValuePairs.add(new BasicNameValuePair("username", username));
        try {
            System.out.println("Getting coach for " + username);
            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/get_coach.php");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            System.out.println("Executing post");
            // Execute HTTP Post Request
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            resp = httpclient.execute(httppost, responseHandler);
            System.out.println("Post executed");

            // Login Response
            System.out.println("Resp: " + resp);
            return resp;
        } catch (Exception e) {
            System.out.println(e);
            return "Error";
        }
    }

    public String retrieveUnPw(String email)
    {
        HttpPost httppost;
        //HttpResponse response;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        nameValuePairs = new ArrayList<NameValuePair>(1);
        nameValuePairs.add(new BasicNameValuePair("email", email));
        try {
            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/get_user_pass.php");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            // Execute HTTP Post Request
            //response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            resp = httpclient.execute(httppost, responseHandler);

            // Login Response
            System.out.println("Resp: " + resp);
            return resp;
        } catch (Exception e) {
            System.out.println(e);
            return "Error";
        }
    }

    public String[] getAllPlayerInfo(String puname)
    {
        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/getAllPlayerInfo.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", puname));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);
            return resp.split(" ");
        }
        catch (Exception e)//error in connection
        {
            return null;
        }
    }


    public char updateUser(String Credentials[]) {
        HttpPost httppost;
        HttpClient httpclient;
        //HttpResponse response;

        List<NameValuePair> nameValuePairs;
        try {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/updateAccount.php");
            nameValuePairs = new ArrayList<>(8);
            nameValuePairs.add(new BasicNameValuePair("firstName", Credentials[3]));
            nameValuePairs.add(new BasicNameValuePair("lastName", Credentials[4]));
            nameValuePairs.add(new BasicNameValuePair("dateOfBirth", Credentials[5]));

            nameValuePairs.add(new BasicNameValuePair("email", Credentials[6]));

            nameValuePairs.add(new BasicNameValuePair("coachUserName", Credentials[1]));

            if (Credentials.length == 8)
                nameValuePairs.add(new BasicNameValuePair("position", Credentials[7]));
            else
                nameValuePairs.add(new BasicNameValuePair("position", ""));

            nameValuePairs.add(new BasicNameValuePair("userName", Credentials[0]));
            nameValuePairs.add(new BasicNameValuePair("password", Credentials[2]));

            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            //final String resp = httpclient.execute(httppost, responseHandler);
            return 'y';

        } catch (Exception e) {
            //show error
            return 'e';
        }
    }

    public char updatePassword(String username, String password)
    {
        HttpPost httppost;
        HttpResponse response;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        nameValuePairs = new ArrayList<NameValuePair>(2);
        nameValuePairs.add(new BasicNameValuePair("userName", username));
        nameValuePairs.add(new BasicNameValuePair("password", password));
        try {

            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/updatePassword.php");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            // Execute HTTP Post Request
            response = httpclient.execute(httppost);
            return 'y';

        } catch (Exception e) {
            return 'e';
        }
    }

    public boolean addStat(Statistic s) {//String puname, String level, String dateTime, String points,
        //String streak, String tbs, String shots, String force, String shotsOT) {
        HttpPost httppost;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        nameValuePairs = new ArrayList<>(9);
        nameValuePairs.add(new BasicNameValuePair("username", s.getUsername()));
        nameValuePairs.add(new BasicNameValuePair("level", s.getLevel()));
        nameValuePairs.add(new BasicNameValuePair("date", s.getDateTime()));
        nameValuePairs.add(new BasicNameValuePair("points", s.getPoints()));
        nameValuePairs.add(new BasicNameValuePair("streak", s.getlStrike()));
        nameValuePairs.add(new BasicNameValuePair("tbs", s.getAvgTimeBtwShots()));
        nameValuePairs.add(new BasicNameValuePair("shots", s.getShots()));
        nameValuePairs.add(new BasicNameValuePair("force", s.getAvgForce()));
        nameValuePairs.add(new BasicNameValuePair("shotOT", s.getOnTarget()));

        try {

            System.out.println("username " + s.getUsername() + " level " + s.getLevel() + " date " + s.getDateTime() + " points " + s.getPoints() + " streak " + s.getlStrike() + " tbs " + s.getAvgTimeBtwShots() + " shots " + s.getShots() + " force " + s.getAvgForce() + " shotsOT " + s.getOnTarget());
            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php_query/store_stat.php");
            System.out.println("http posted");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            // Execute HTTP Post Request
            System.out.println("Executing httppost");
            httpclient.execute(httppost);
            //ResponseHandler<String> responseHandler = new BasicResponseHandler();
            //String resp = httpclient.execute(httppost, responseHandler);
            System.out.println("Post executed");
            return true;

        } catch (Exception e) {
            return false;
        }
    }

    //get stats
    public String getMaxForce(String puname)
    {
        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/maxForce.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", puname));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);
            return resp;
        }
        catch (Exception e)//error in connection
        {
            return null;
        }
    }


    public String getMaxStreak(String puname)
    {
        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/maxStrike.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", puname));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);
            return resp;
        }
        catch (Exception e)//error in connection
        {
            return null;
        }
    }

    public String getMaxPoints(String puname)
    {
        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/maxPoints.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", puname));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);
            return resp;
        }
        catch (Exception e)//error in connection
        {
            return null;
        }
    }

    public String getMinReaction(String puname)
    {
        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/minReaction.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", puname));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);
            return resp;
        }
        catch (Exception e)//error in connection
        {
            return null;
        }
    }

    public String getMaxAccuracy(String puname)
    {
        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/maxAccuracy.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", puname));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);
            return resp;
        }
        catch (Exception e)//error in connection
        {
            return null;
        }
    }

    public LinkedList<LinkedList<String>> getAllStats(String puname)
    {
        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/getAllStats.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", puname));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            String resp = httpclient.execute(httppost, responseHandler);

            Log.w("AAAAAAA", resp);
            LinkedList<LinkedList<String>> ret = new LinkedList<>();

            String []str1 = resp.split("\n");
            for(int i = 0; i < str1.length; i++)
            {
                String [] str2 = str1[i].split(" ");
                LinkedList<String> l = new LinkedList();
                for(int j = 0; j < str2.length; j++)
                {
                    l.push(str2[j]);
                }
                Log.w("AAAAAA", l.toString());
                ret.push(l);
            }

            return ret;
        }
        catch (Exception e)//error in connection
        {
            return null;
        }
    }
}
