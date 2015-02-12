package com.project.senior.skillcourt;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.StrictMode;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
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


public class logIn extends ActionBarActivity {

    EditText unTxt, pwTxt;
    HttpPost httppost;
    HttpResponse response;
    String resp;
    HttpClient httpclient;
    List<NameValuePair> nameValuePairs;
    ProgressDialog dialog = null;
    Button loginBtn;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_log_in);

        unTxt = (EditText) findViewById(R.id.editText);
        pwTxt = (EditText) findViewById(R.id.editText2);
        loginBtn = (Button) findViewById(R.id.button4);

        if (android.os.Build.VERSION.SDK_INT > 9) {
            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder()
                    .permitAll().build();
            StrictMode.setThreadPolicy(policy);
        }
    }

    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_log_in, menu);
        return true;
    }

    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void performLogin(View view) {
        // Structure to hold username/password combination
        nameValuePairs = new ArrayList<NameValuePair>(2);
        nameValuePairs.add(new BasicNameValuePair("username", unTxt.getText().toString().trim()));
        nameValuePairs.add(new BasicNameValuePair("password", pwTxt.getText().toString()));
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
                loginSuccess();
            else
                loginFail();
        } catch (Exception e) {
            System.out.println("ERROR!" + e.getMessage());
        }
    }
//        dbInteraction interact = new dbInteraction();
//        // Login Response
//        if (interact.checkCredentials(unTxt.getText().toString().trim(),
//                pwTxt.getText().toString()))
//            loginSuccess();
//        else
//            loginFail();
//    }

    public void loginSuccess() {
        // Send user to Home screen with his account logged in
        Intent intent = new Intent(this, home.class);
        intent.putExtra("username", unTxt.getText().toString().trim());
        startActivity(intent);
    }

    public void loginFail() {
        // Display dialog to user that authentication failed
        AlertDialog.Builder builder = new AlertDialog.Builder(logIn.this);
        builder.setTitle("Login Error");
        builder.setMessage("Username/Password combination is incorrect")
                .setCancelable(false)
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                    }
                });
        AlertDialog alert = builder.create();
        alert.show();
    }
}
