package com.project.senior.skillcourt;

import android.app.ProgressDialog;
import android.widget.Button;
import android.widget.EditText;

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
 * Created by andymartinez on 2/10/15.
 */
public class dbInteraction {
    private String host = "http://skillcourt-dev.cis.fiu.edu/php/checkIfUnameExist.php";

    public dbInteraction()
    {

    }
    /*
    *Returns 0 if puname does not exist
    *Returns -1 if there is an error in the connection
    *Returns 1 if puname exists
     */
    int checkIfPunameExist(String puname)
    {
        return 0;
    }

    protected boolean checkCredentials(String username, String password) {
        String ret = "Invalid";
        HttpPost httppost;
        HttpResponse response;
        String resp;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        try {
            nameValuePairs = new ArrayList<NameValuePair>(2);
            nameValuePairs.add(new BasicNameValuePair("username", username));
            nameValuePairs.add(new BasicNameValuePair("password", password));
            // Link to skillcourt-dev myPHPAdmin server
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/mat_login/log_in.php");
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            // Execute HTTP Post Request
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            resp = httpclient.execute(httppost, responseHandler);
            System.out.println("Resp: " + resp);

        } catch (Exception e) {
            System.out.println("ERROR!" + e.getMessage());
        }
        return (ret.equalsIgnoreCase("Valid"));
    }
}
