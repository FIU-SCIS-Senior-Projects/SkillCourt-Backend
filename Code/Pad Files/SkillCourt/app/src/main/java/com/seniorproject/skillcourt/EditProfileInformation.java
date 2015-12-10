package com.seniorproject.skillcourt;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;


public class EditProfileInformation extends ActionBarActivity {

    String allinfo[];
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_profile_information);

        Intent intent = getIntent();
        allinfo = intent.getStringArrayExtra("allinfo");
        showInfo();
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_edit_profile_information, menu);
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


    public void showInfo()
    {
        if(allinfo[3].length() != 0) {
            TextView name = (TextView) findViewById(R.id.name);
            name.setText(allinfo[3]);
        }

        if(allinfo[4].length() != 0)
        {
            TextView lastname = (TextView) findViewById(R.id.lastname);
            lastname.setText(allinfo[4]);
        }

        if(!allinfo[5].equals("0000-00-00"))
        {
            TextView dob = (TextView) findViewById(R.id.date);
            dob.setText(allinfo[5]);
        }


        TextView email = (TextView) findViewById(R.id.email);
        email.setText(allinfo[6]);

        if(allinfo[1].length() != 0)
        {
            TextView cuname = (TextView) findViewById(R.id.coach_uname);
            cuname.setText(allinfo[1]);
        }


        if(allinfo.length != 7) {
            TextView position = (TextView) findViewById(R.id.position);
            position.setText(allinfo[7]);
        }
    }

    public void done(View view)
    {
        allinfo[1] = ((TextView)findViewById(R.id.coach_uname)).getText().toString();
        allinfo[3] = ((TextView)findViewById(R.id.name)).getText().toString();
        allinfo[4] = ((TextView)findViewById(R.id.lastname)).getText().toString();
        allinfo[5] = ((TextView)findViewById(R.id.date)).getText().toString();


        if(allinfo.length == 8)
        {
            allinfo[7] = ((TextView)findViewById(R.id.position)).getText().toString();
        }

        dbInteraction db = new dbInteraction();
        char a = db.updateUser(allinfo);

        if(a == 'e')
        {
            genericWarning w = new genericWarning();
            w.setMessage("There was an internet connection error. Check your internet connection and try again");
            w.setPossitive("OK");
            w.show(getFragmentManager(), "internet connection problem");
        }
        else {
            Intent intent = new Intent(this, Profile.class);
            intent.putExtra("result", allinfo);
            this.setResult(this.RESULT_OK, intent);
            this.finish();
        }

    }
}
