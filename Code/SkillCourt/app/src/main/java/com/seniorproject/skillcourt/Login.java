package com.seniorproject.skillcourt;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;


public class Login extends ActionBarActivity {

    public final static String EXTRA_MESSAGE = "Pusername";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_login, menu);
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
    * Action of login button
    * */
    public void logIn(View view)
    {
        String puname = ((EditText) findViewById(R.id.user_name)).getText().toString();
        String password = ((EditText) findViewById(R.id.password)).getText().toString();

        dbInteraction dbi = new dbInteraction();
        char resp = dbi.checkUnamePasswCombination(puname, password);

        if(resp == 'y')
        {
            Intent intent = new Intent(this, Home.class);
            intent.putExtra(EXTRA_MESSAGE, puname);
            startActivity(intent);
        }
        else if(resp == 'n')
        {
            genericWarning w = new genericWarning();
            w.setMessage(getString(R.string.warning_uname_passw_combination_message));
            w.setPossitive(getString(R.string.warning_uname_passw_combination_possitive));
            w.show(getFragmentManager(),"warning_dialog");

            return;
        }
        else
        {
            genericWarning w = new genericWarning();
            w.setMessage(getString(R.string.warning_connection_error_message));
            w.setPossitive(getString(R.string.warning_connection_error_possitive));
            w.show(getFragmentManager(),"warning_dialog");

            return;
        }
    }

    /*
    * Action of trouble loggin in button
    * */
    public void logInTrouble(View view)
    {

    }
}
