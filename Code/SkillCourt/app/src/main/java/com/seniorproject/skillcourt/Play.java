package com.seniorproject.skillcourt;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

/**
 * Created by msant080 on 2/17/2015.
 */
public class Play extends ActionBarActivity {

    EditText routineName;
    EditText routineDescription;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_play);

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_home, menu);
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
        else if(id == R.id.action_logout)
        {
            Intent intent = new Intent(this, Welcome.class);
            startActivity(intent);
        }

        return super.onOptionsItemSelected(item);
    }

    public void createRoutine(View view) {
        routineName = (EditText) findViewById(R.id.editText3);
        routineDescription = (EditText) findViewById(R.id.editText4);

        String rName = routineName.getText().toString();
        String rDescription = routineDescription.getText().toString();

        if (rName.equals("")) {
            genericWarning w = new genericWarning();
            w.setMessage(getString(R.string.warning_empty_field_message));
            w.setPossitive(getString(R.string.warning_empty_field_positive));
            w.show(getFragmentManager(),"warning_dialog");
        }
        else {
            dbInteraction dbi = new dbInteraction();
            dbi.addRoutine(rName, rDescription);
        }
    }
}
