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

import java.util.Random;


public class CreateAccount2 extends ActionBarActivity {

    public final static String EXTRA_MESSAGE = "Credentials";
    String[] Credentials;
    int code;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account2);
        //Getting message passed from previous
        Intent intent = getIntent();
        Credentials = intent.getStringArrayExtra(CreateAccount1.EXTRA_MESSAGE);

        //generate global code
        produceCode();
        ((TextView) findViewById(R.id.provitional_text)).setText(Integer.toString(code));//delete this
        //send email with code
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

    void produceCode()
    {
        int max = 99999;
        int min = 10000;
        Random rdng = new Random();
        code = rdng.nextInt((max - min) +1 ) + min;



    }

    public void verify(View view)
    {
        if(((EditText) findViewById(R.id.code)).getText().toString().equals(Integer.toString(code)))
        {
            Intent intent = new Intent(this, CreateAccount3.class);
            intent.putExtra(EXTRA_MESSAGE, Credentials);
            startActivity(intent);
        }
        else
        {
            genericWarning w = new genericWarning();
            w.setMessage(getString(R.string.warning_invalid_code_message));//add this to string
            w.setPossitive(getString(R.string.warning_invalid_code_possitive));//add this to string
            w.show(getFragmentManager(),"warning_dialog");
            return;
        }
    }

    public void changeEmail(View view)
    {

    }
}
