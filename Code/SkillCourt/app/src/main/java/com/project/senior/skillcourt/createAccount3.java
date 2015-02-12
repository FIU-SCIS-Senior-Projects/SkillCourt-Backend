package com.project.senior.skillcourt;

import android.content.Intent;
import android.os.StrictMode;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import java.util.ArrayList;

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
import android.content.Intent;

public class createAccount3 extends ActionBarActivity {
    String[] credentials;
    public final static String EXTRA_MESSAGE = "Credentials";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        if (android.os.Build.VERSION.SDK_INT > 9) {

            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);

        }
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        credentials = intent.getStringArrayExtra(createAccount2.EXTRA_MESSAGE);
        setContentView(R.layout.activity_create_account3);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_create_account3, menu);
        return true;
    }

    @Override
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

    public void next(View view)
    {
        credentials[6] = ((EditText) findViewById(R.id.editTextCoachUn)).getText().toString();
        credentials[7] = ((EditText) findViewById(R.id.editTextPosition)).getText().toString();

        createAccount();

        Intent intent = new Intent(this, accountCreated.class);
        intent.putExtra(EXTRA_MESSAGE, credentials);
        startActivity(intent);

    }

    public void createAccount()
    {
        HttpPost httppost;
        HttpClient httpclient;
        HttpResponse response;

        List<NameValuePair> nameValuePairs;
        try {
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php_query/create_account.php");
            nameValuePairs = new ArrayList<>(8);
            nameValuePairs.add(new BasicNameValuePair("firstName", credentials[3]));
            nameValuePairs.add(new BasicNameValuePair("lastName", credentials[4]));
            nameValuePairs.add(new BasicNameValuePair("dateOfBirth", credentials[5]));

            nameValuePairs.add(new BasicNameValuePair("email", credentials[2]));

            nameValuePairs.add(new BasicNameValuePair("coachUserName", credentials[6]));
            nameValuePairs.add(new BasicNameValuePair("position", credentials[7]));

            nameValuePairs.add(new BasicNameValuePair("userName", credentials[0]));
            nameValuePairs.add(new BasicNameValuePair("password", credentials[1]));

            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);


        }
        catch (Exception e)
        {
            //show error
        }
    }
}
