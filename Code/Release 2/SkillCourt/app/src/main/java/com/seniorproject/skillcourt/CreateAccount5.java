package com.seniorproject.skillcourt;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;


public class CreateAccount5 extends ActionBarActivity {

    String[] Credentials;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account5);

        //getting message from create account 3
        Intent intent = getIntent();
        Credentials = intent.getStringArrayExtra(CreateAccount4.EXTRA_MESSAGE);
        for(int i = 0; i < Credentials.length; i++)
        {
            Log.w("BBBBBBB", Credentials[i]);
        }

        ((TextView) findViewById(R.id.account_created_message)).setText(Credentials[0]+" "+getString(R.string.account_created_message));
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_create_account5, menu);
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

    public void goToLogIn(View view)
    {
        Intent intent = new Intent(this, Login.class);
        startActivity(intent);
    }

    public void goToWelcome(View view)
    {
        Intent intent = new Intent(this, Welcome.class);
        startActivity(intent);
    }
}
