package com.seniorproject.skillcourt;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;


public class CreateAccount4 extends ActionBarActivity {

    public final static String EXTRA_MESSAGE = "Credentials";
    String[] Credentials;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account4);

        //getting message from create account 3
        Intent intent = getIntent();
        Credentials = intent.getStringArrayExtra(CreateAccount3.EXTRA_MESSAGE);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_create_account4, menu);
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
        Credentials[6] = ((EditText) findViewById(R.id.coach_username)).getText().toString();
        Credentials[7] = ((EditText) findViewById(R.id.position)).getText().toString();
        nexSkipHelper();

    }

    public void skip(View view)
    {
        Credentials[6] = "";
        Credentials[7] = "";


        nexSkipHelper();
    }

    public void nexSkipHelper()
    {
        dbInteraction dbi = new dbInteraction();
        char resp = dbi.addUser(Credentials);

        if(resp == 'e')
        {
            genericWarning w = new genericWarning();
            w.setMessage(getString(R.string.warning_connection_error_message));
            w.setPossitive(getString(R.string.warning_connection_error_possitive));
            w.show(getFragmentManager(),"warning_dialog");
            return;
        }
        else
        {

            Intent intent = new Intent(this, CreateAccount5.class);
            intent.putExtra(EXTRA_MESSAGE, Credentials);
            for(int i = 0; i < Credentials.length; i++)
            {
                Log.w("AAAAAAAA", Credentials[i]);
            }
            startActivity(intent);
        }
    }
}
