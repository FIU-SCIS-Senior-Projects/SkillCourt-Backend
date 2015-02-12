package com.project.senior.skillcourt;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.StrictMode;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
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


public class createAccount1 extends ActionBarActivity {

    public final static String EXTRA_MESSAGE = "Credentials";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account1);

        if (android.os.Build.VERSION.SDK_INT > 9) {

            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);

        }
        //((EditText) findViewById(R.id.editTextPassword)).setHint("Missing Password");
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_create_account1, menu);
        //((EditText) findViewById(R.id.editTextPassword)).setText("");
        //((EditText) findViewById(R.id.editTextPuname)).setText("");
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

    public void checkCredentials(View view)
    {
        ((EditText) findViewById(R.id.editTextPassword)).setHint("Password");
        ((EditText) findViewById(R.id.editTextPassword)).setHintTextColor(Color.GRAY);

        ((EditText) findViewById(R.id.editTextPuname)).setHint("Missing Username");
        ((EditText) findViewById(R.id.editTextPuname)).setHintTextColor(Color.GRAY);

        HttpPost httppost;
        StringBuffer buffer;
        HttpResponse response;
        HttpClient httpclient;
        List<NameValuePair> nameValuePairs;
        String password = ((EditText) findViewById(R.id.editTextPassword)).getText().toString();
        String puname = ((EditText) findViewById(R.id.editTextPuname)).getText().toString();
        String email = ((EditText) findViewById(R.id.editTextEmail)).getText().toString();

        if(password.isEmpty() && puname.isEmpty())
        {
            ((EditText) findViewById(R.id.editTextPassword)).setHint("Missing Password");
            ((EditText) findViewById(R.id.editTextPassword)).setHintTextColor(Color.RED);

            ((EditText) findViewById(R.id.editTextPuname)).setHint("Missing Username");
            ((EditText) findViewById(R.id.editTextPuname)).setHintTextColor(Color.RED);

            return;

        }
        else if (password.isEmpty())
        {

            ((EditText) findViewById(R.id.editTextPassword)).setHint("Missing Password");
            ((EditText) findViewById(R.id.editTextPassword)).setHintTextColor(Color.RED);

            return;
        }
        else if (puname.isEmpty())
        {

            ((EditText) findViewById(R.id.editTextPuname)).setHint("Missing Username");
            ((EditText) findViewById(R.id.editTextPuname)).setHintTextColor(Color.RED);

            return;
        }


        try{
            httpclient = new DefaultHttpClient();
            httppost = new HttpPost("http://skillcourt-dev.cis.fiu.edu/php/checkIfUnameExist.php");
            nameValuePairs = new ArrayList<>(1);
            nameValuePairs.add(new BasicNameValuePair("puname", puname));
            httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            response = httpclient.execute(httppost);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            final String resp = httpclient.execute(httppost, responseHandler);

            if(resp.equals("y"))
            {

                ((EditText) findViewById(R.id.editTextPuname)).setText("");
                ((EditText) findViewById(R.id.editTextPuname)).setHint("Username");//Username already exists
                ((EditText) findViewById(R.id.editTextPuname)).setHighlightColor(Color.GRAY);
                showDialogUserNameExists();

            }
            else
            {

                String credentials[] = new String[8];
                credentials[0] = puname;
                credentials[1] = password;
                credentials[2] = email;
                Intent intent = new Intent(this, createAccount2.class);
                intent.putExtra(EXTRA_MESSAGE, credentials);
                startActivity(intent);
            }

        }
        catch (Exception e)
        {
            showConnectionErrorDialog();
        }



    }

    public void showDialogUserNameExists()
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(createAccount1.this);
        builder.setTitle("Wrong Username");
        builder.setMessage("Username already exists")
                .setCancelable(false)
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                    }
                });
        AlertDialog alert = builder.create();
        alert.show();
    }

    public void showConnectionErrorDialog()
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(createAccount1.this);
        builder.setTitle("Connection Error");
        builder.setMessage("There was an error in the connection. Try again")
                .setCancelable(false)
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                    }
                });
        AlertDialog alert = builder.create();
        alert.show();
    }


}
