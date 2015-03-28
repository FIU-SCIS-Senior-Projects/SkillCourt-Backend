package com.seniorproject.skillcourt;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
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

import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

/**
 * Created by msant080 on 2/17/2015.
 */
public class Play extends ActionBarActivity {
    //test
    TextView descriptionText;
    Spinner routines;
    dbInteraction dbi;
    ArrayAdapter<String> adapter;

    //Bluetooth
    public final static String EXTRA_PAD = "pad";
    BluetoothAdapter ba;
    HashMap<String, BluetoothDevice> devices;
    private OutputStream outStream;
    private InputStream inStream;
    BluetoothSocket btSocket;

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

    public void getRoutine(View view) {
        String rname = routines.getSelectedItem().toString();
        dbInteraction dbi = new dbInteraction();
        String routine = dbi.getRoutine(rname);
        descriptionText.setText(descriptionText.getText() + "\n" + routine);

        sendRoutine(routine);
    }

    public void sendRoutine(String routine) {
        Intent intent = getIntent();
        BluetoothDevice dev = intent.getParcelableExtra(Scan.EXTRA_PAD);
        try {
            btSocket = dev.createRfcommSocketToServiceRecord(Scan.MY_UUID);
            btSocket.connect();
            outStream = btSocket.getOutputStream();
            outStream.write(routine.getBytes());
        } catch (Exception e) {
            System.out.println("Error connecting to Bluetooth:\n\t" + e);
        }
    }
}

