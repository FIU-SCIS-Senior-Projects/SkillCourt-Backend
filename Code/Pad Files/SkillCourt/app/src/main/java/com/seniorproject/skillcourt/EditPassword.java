package com.seniorproject.skillcourt;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;


public class EditPassword extends ActionBarActivity {

    String puname;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_password);

        Intent intent = getIntent();
        puname = intent.getStringExtra("puname");
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_edit_password, menu);
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

    public void reset(View view)
    {
        String p1 = ((EditText) findViewById(R.id.new_password)).getText().toString();
        String p2 = ((EditText) findViewById(R.id.repeat_new_password)).getText().toString();

        if(p1.equals(p2))
        {
            dbInteraction db = new dbInteraction();
            //call reset password function from db interaction
            char a = db.updatePassword(puname, p1);

            if(a == 'e')
            {
                genericWarning w = new genericWarning();
                w.setMessage("There was an internet connection error. Check your internet connection and try again");
                w.setPossitive("OK");
                w.show(getFragmentManager(), "internet connection problem");
            }
            else {
                Intent intent = new Intent(this, Profile.class);
                String[] str = null;
                intent.putExtra("result", str);
                this.setResult(this.RESULT_OK, intent);
                finish();
            }
        }
        else
        {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("The 2 passwors you entered do not match");
            w.show(getFragmentManager(), "wrong_combination");
            ((EditText)findViewById(R.id.new_password)).setText("");
            ((EditText)findViewById(R.id.repeat_new_password)).setText("");

        }
    }
}
