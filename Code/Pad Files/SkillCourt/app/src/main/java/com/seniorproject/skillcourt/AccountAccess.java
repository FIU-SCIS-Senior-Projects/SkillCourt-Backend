package com.seniorproject.skillcourt;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

/**
 * Created by msant080 on 2/21/2015.
 */
public class AccountAccess extends ActionBarActivity {

    EditText email;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_account_access);

        email = (EditText) findViewById(R.id.editText);
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

    public void getUnPw(View view) {
        final dbInteraction dbi = new dbInteraction();
        final String eAddr = email.getText().toString().trim();
        final String value = dbi.retrieveUnPw(eAddr);
        final genericWarning w = new genericWarning();
        System.out.println("Here are your SkillCourt account credentials:\nUsername: " + value.substring(0, value.indexOf(" ")) + "\nPassword: " + value.substring(value.indexOf(" ") + 1, value.length()));
        Runnable r = new Runnable() {
            public void run() {
                try {
                    if (value.trim().isEmpty())
                        w.setMessage("There is no account associated with that email address: \n" + eAddr);
                    else if (value.trim().equalsIgnoreCase("Error"))
                        w.setMessage("Trouble contacting database.  \nTry again later");
                    else {
                        email e = new email();
                        char sent = e.sendMail("SkillCourt account recovery",
                                               "Here are your account credentials:\nUsername: "
                                                       + value.substring(0, value.indexOf(" ")) + "\nPassword: "
                                                       + value.substring(value.indexOf(" ") + 1, value.length()),
                                               "skillcourtbackend@gmail.com",
                                               eAddr);
                        if(sent == 'y')
                            w.setMessage("Your credentials have been sent to your email address : \n" + eAddr);
                        else if (sent == 'e')
                            w.setMessage("Error!");
                    }
                } catch (Exception e1) {
                    w.setMessage("Unable to send email to your email address" + eAddr);
                    e1.printStackTrace();
                }
                w.setPossitive("Ok");
                w.show(getFragmentManager(),"warning_dialog");
            }
        };
        Thread myThread = new Thread(r);
        myThread.start();
    }
}