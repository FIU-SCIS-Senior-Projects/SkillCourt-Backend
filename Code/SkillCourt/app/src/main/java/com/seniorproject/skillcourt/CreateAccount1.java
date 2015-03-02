package com.seniorproject.skillcourt;

import android.content.Intent;
import android.os.StrictMode;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

import java.util.Random;


public class CreateAccount1 extends ActionBarActivity {

    public final static String EXTRA_MESSAGE = "Credentials";
    int code;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account1);


    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_create_account1, menu);
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

    void produceCode()
    {
        int max = 99999;
        int min = 10000;
        Random rdng = new Random();
        code = rdng.nextInt((max - min) +1 ) + min;

    }


    public void next(View view)
    {
        String puname = ((EditText) findViewById(R.id.user_name)).getText().toString();
        String password = ((EditText) findViewById(R.id.password)).getText().toString();
        String email = ((EditText) findViewById(R.id.email)).getText().toString();


        if(puname.isEmpty() || password.isEmpty() || email.isEmpty())
        {

            genericWarning w = new genericWarning();
            w.setMessage(getString(R.string.warning_empty_field_message));
            w.setPossitive(getString(R.string.warning_empty_field_positive));
            w.show(getFragmentManager(),"warning_dialog");

            return;
        }

        dbInteraction dbi =new dbInteraction();
        char resp = dbi.checkIfUserNameExists(puname);

        if(resp == 'y')//the username already exist
        {

            genericWarning w = new genericWarning();
            w.setMessage(getString(R.string.warning_username_exists_message));
            w.setPossitive(getString(R.string.warning_username_exists_possitive));
            w.show(getFragmentManager(),"warning_dialog");
            return;
        }
        else if(resp == 'n')//the username does not exist
        {


            resp = dbi.checkIfEmailExists(email);

            if(resp == 'y')//email already exist
            {

                genericWarning w2 = new genericWarning();
                w2.setMessage(getString(R.string.warning_email_exists_message));
                w2.setPossitive(getString(R.string.warning_email_exists_positive));
                w2.show(getFragmentManager(),"warning_dialog");

                return;
            }
            else {

                produceCode();

                try {

                    email e = new email();
                    char sent = e.sendMail("SkillCourt Account Creation Code",
                            puname + " use this code in order to continue your SkillCourt account creation process:\nCODE: "
                                    + Integer.toString(code),
                            "skillcourtbackend@gmail.com",
                            email);


                } catch (Exception e1) {
                    genericWarning w = new genericWarning();
                    w.setMessage("Unable to send email to your email address " + email + ". Make sure that you have internet connection and that the provided email address is correct");
                    w.setPossitive("OK");
                    w.show(getFragmentManager(),"warning_dialog");

                    return;
                }

                //---------------------------------

                String Credentials[] = new String[8];
                Credentials[0] = puname;
                Credentials[1] = password;
                Credentials[2] = email;
                Credentials[3] = Integer.toString(code);
                Intent intent = new Intent(this, CreateAccount2.class);
                intent.putExtra(EXTRA_MESSAGE, Credentials);
                startActivity(intent);
            }

        }
        else//error in connection
        {
            genericWarning w = new genericWarning();
            w.setMessage(getString(R.string.warning_connection_error_message));
            w.setPossitive(getString(R.string.warning_connection_error_possitive));
            w.show(getFragmentManager(),"warning_dialog");

            return;
        }
    }
}
