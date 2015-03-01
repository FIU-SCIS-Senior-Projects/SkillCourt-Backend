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
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/checkIfUnameExist.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", username));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
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
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;

        try
        {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/checkIfEmailExist.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("email", email));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
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
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        nameValuePairs = new ArrayList<>(2);
        nameValuePairs.add(new BasicNameValuePair("username", username));
        nameValuePairs.add(new BasicNameValuePair("password", password));
        try {

            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/log_in.php");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            // Execute HTTP Post Request
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

    public String getRoutine(String rname)
    {
        HttpPost httppost;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        nameValuePairs = new ArrayList<>(2);
        nameValuePairs.add(new BasicNameValuePair("rname", rname));
        try {
            System.out.println("Connecting to db");
            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/get_routine.php");
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

    public String listRoutines()
    {
        HttpPost httppost;
        String resp;
        HttpClient httpclient;
        try {
            System.out.println("Connecting to db");
            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/list_routines.php");

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

    public String getRoutineDescription(String routine)
    {
        HttpPost httppost;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs = new ArrayList<>(1);
        nameValuePairs.add(new BasicNameValuePair("rname", routine));
        try {
            System.out.println("Connecting to db with routine = " + routine);
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

    public String retrieveUnPw(String email)
    {
        HttpPost httppost;
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
}
