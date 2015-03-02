package com.seniorproject.skillcourt;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import org.w3c.dom.Text;


public class Profile extends ActionBarActivity {

    public final static String EXTRA_MESSAGE = "Credentials";
    String puname;
    String allinfo[];

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);

        Intent intent = getIntent();
        puname = intent.getStringExtra(Home.EXTRA_MESSAGE);

        dbInteraction dbi = new dbInteraction();
        allinfo = dbi.getAllPlayerInfo(puname);

        showInfo();
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


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_profile, menu);
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
        if(id == R.id.action_goHome)
        {
            Intent intent = new Intent(this, Home.class);
            String[] str = new String[1];
            str[0] = "Profile";
            intent.putExtra("result", str);
            this.setResult(this.RESULT_OK, intent);
            finish();
        }

        return super.onOptionsItemSelected(item);
    }


    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        if(resultCode == RESULT_OK && data.getStringArrayExtra("result") != null)
        {
            allinfo = data.getStringArrayExtra("result");
            showInfo();
        }

    }


    public void editInfo(View view)
    {
        Intent editprofile = new Intent(this, EditProfileInformation.class);
        editprofile.putExtra("allinfo", allinfo);
        startActivityForResult(editprofile, 1);
    }

    public void resetPass(View view)
    {
        Intent editpassword = new Intent(this, EditPassword.class);
        editpassword.putExtra("puname", puname);
        startActivityForResult(editpassword, 1);
    }
}
