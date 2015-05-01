package com.seniorproject.skillcourt;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;


public class CreateAccount3 extends ActionBarActivity {

    public final static String EXTRA_MESSAGE = "Credentials";
    String[] Credentials;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account3);

        //getting credentials from activity 2
        Intent intent = getIntent();
        Credentials = intent.getStringArrayExtra(CreateAccount2.EXTRA_MESSAGE);
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
        Credentials[3] = ((EditText) findViewById(R.id.first_name)).getText().toString();
        Credentials[4] = ((EditText) findViewById(R.id.last_name)).getText().toString();
        Credentials[5] = ((EditText) findViewById(R.id.date_of_birdth)).getText().toString();

        Intent intent = new Intent(this, CreateAccount4.class);
        intent.putExtra(EXTRA_MESSAGE, Credentials);
        startActivity(intent);
    }


    public void skip(View view)
    {
        Credentials[3] = "";
        Credentials[4] = "";
        Credentials[5] = "";

        Intent intent = new Intent(this, CreateAccount4.class);
        intent.putExtra(EXTRA_MESSAGE, Credentials);
        startActivity(intent);
    }

}
