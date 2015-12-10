package com.seniorproject.skillcourt;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;


public class Welcome extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_welcome, menu);
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

    /*
    * Action for the log_in_button
    */
    public void logIn(View view)
    {
        Intent intent = new Intent(this, Login.class);
        startActivity(intent);

    }

    /*
    * Action for the guess_button
    */
    public void enterAsGuest(View view)
    {
        guestWarningDialog w = new guestWarningDialog();
        w.show(getFragmentManager(),"warning_dialog");

    }

    /*
    * Action for the create_account_button
    */
    public void createAccount(View view)
    {
        Intent intent = new Intent(this, CreateAccount1.class);
        startActivity(intent);

    }
}
