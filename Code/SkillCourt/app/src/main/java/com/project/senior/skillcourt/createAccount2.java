package com.project.senior.skillcourt;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

import java.util.HashMap;


public class createAccount2 extends ActionBarActivity {

    String[] credentials;
    public final static String EXTRA_MESSAGE = "Credentials";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        credentials = intent.getStringArrayExtra(createAccount1.EXTRA_MESSAGE);


        setContentView(R.layout.activity_create_account2);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_create_account2, menu);
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
        credentials[3] = ((EditText) findViewById(R.id.editTextFName)).getText().toString();
        credentials[4] = ((EditText) findViewById(R.id.editTextLastName)).getText().toString();
        credentials[5] = ((EditText) findViewById(R.id.editTextdateOdBirth)).getText().toString();
        Intent intent = new Intent(this, createAccount3.class);
        intent.putExtra(EXTRA_MESSAGE, credentials);
        startActivity(intent);


    }
}
