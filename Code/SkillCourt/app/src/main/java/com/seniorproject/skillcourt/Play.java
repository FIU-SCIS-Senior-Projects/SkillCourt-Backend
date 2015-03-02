package com.seniorproject.skillcourt;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Adapter;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.BaseExpandableListAdapter;
import android.widget.EditText;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.Spinner;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by msant080 on 2/17/2015.
 */
public class Play extends ActionBarActivity {

    TextView descriptionText;
    Spinner routines;
    dbInteraction dbi;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_play);
        descriptionText = (TextView) findViewById(R.id.routineDescription);
        routines = (Spinner) findViewById(R.id.spinner);

        setSpinner();
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

    public void getRoutine(View view) {
        String rname = routines.getSelectedItem().toString();
        dbInteraction dbi = new dbInteraction();
        descriptionText.setText(dbi.getRoutine(rname));
    }

    public void setSpinner() {
        System.out.println("setting up routines");
        dbi = new dbInteraction();
        String routinesList = "," + dbi.listRoutines();
        List<String> list = new ArrayList<>();
        while (routinesList.lastIndexOf(",") != 0) {
            routinesList = routinesList.substring(1);
            list.add(routinesList.substring(0,routinesList.indexOf(",")));
            routinesList = routinesList.substring(routinesList.indexOf(","));
        }
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this,
                android.R.layout.simple_spinner_item, list);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        routines.setAdapter(adapter);
        setSpinnerListener();
    }

    public void setSpinnerListener() {
        System.out.println("setting on item selected listener");
        routines.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String routine = routines.getItemAtPosition(position).toString().trim();
                System.out.println(routine);
                dbi = new dbInteraction();
                descriptionText.setText(dbi.getRoutineDescription(routine));
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                descriptionText.setText("Choose a routine from the list above to see its description.");
            }
        });
    }
}
