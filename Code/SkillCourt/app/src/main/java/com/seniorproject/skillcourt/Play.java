package com.seniorproject.skillcourt;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
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
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TabHost;
import android.widget.TextView;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.UUID;

/**
 * Created by msant080 on 2/17/2015.
 */
public class Play extends ActionBarActivity {
    TextView descriptionText;
    Spinner defa, cust, coac;
    dbInteraction dbi;
    ArrayAdapter<String> adapter;
    TabHost tabHost;
    String puname, coach;

    // Bluetooth Related Vars
    String pad_name;
    String pad_addr;

    BluetoothAdapter ba;
    private OutputStream outStream;
    private InputStream inStream;
    BluetoothSocket btSocket;
    BluetoothDevice dev;

    protected static final UUID MY_UUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");
    // Routine Related Vars
    String rname, difficulty, rounds, timer, timebased, type, user, usertype;



    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_play_2);

        Intent intent = getIntent();
        puname = intent.getStringExtra(Login.EXTRA_MESSAGE);
        pad_name = intent.getStringExtra(Home.EXTRA_PAD_NAME);
        pad_addr = intent.getStringExtra(Home.EXTRA_PAD_ADDR);

        dev = intent.getExtras().getParcelable(Home.EXTRA_PAD);
        Log.w("DDDDDDD", dev.getName());


        coach = (new dbInteraction()).getCoach(puname);

        // Set Spinners
        setSpinnerDefault();
        setSpinnerCustom();
        setSpinnerCoach();

        // Set Tabs
        setTabs();
    }

    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_home, menu);
        return true;
    }

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

    /********************** Start Spinner setup methods  **********************/
    public void setSpinnerDefault() {
        System.out.println("setting up default routines");

        // Set Default routines into a list
        List<String> list = new ArrayList<>();
        list.add("Chase");

        // Attach list to adapter
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this,android.R.layout.simple_spinner_item, list);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        // Set Spinner
        defa = (Spinner) findViewById(R.id.defRoutinesSpin);

        // Set Description
        final TextView defaDesc = (TextView) findViewById(R.id.defDesc);

        // Set adapter for spinner
        defa.setAdapter(adapter);

        // Set listener for spinner
        //setSpinnerListener(defa, (TextView) findViewById(R.id.defDesc), "Default");
        defa.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String routine = defa.getItemAtPosition(position).toString().trim();
                System.out.println(routine);
                if (routine == "Chase") {
                    defaDesc.setText("Chase the light around the room being careful to " +
                            "avoid hitting the inactive ones!");
                }
                else
                    defaDesc.setText("Choose a routine from the list above to see its description.");
            }

            public void onNothingSelected(AdapterView<?> parent) {
                defaDesc.setText("Choose a routine from the list above to see its description.");
            }
        });
    }

    public void setSpinnerCustom() {
        System.out.println("setting up custom routines");

        // Get Custom Routines from Database
        dbi = new dbInteraction();
        String routinesList = "," + dbi.listCustomRoutines(puname, "P");
        List<String> list = new ArrayList<>();

        // Parse each routine into list
        while (routinesList.lastIndexOf(",") != 0) {
            routinesList = routinesList.substring(1);
            list.add(routinesList.substring(0,routinesList.indexOf(",")));
            routinesList = routinesList.substring(routinesList.indexOf(","));
        }

        // Set Spinner
        cust = (Spinner) findViewById(R.id.custRoutinesSpin);

        // Set adapter for spinner
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, list);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        cust.setAdapter(adapter);

        // Set listener for spinner
        setSpinnerListener(cust, (TextView) findViewById(R.id.custDesc), "P");
    }

    public void setSpinnerCoach() {
        System.out.println("setting up coach routines");

        // Get Custom Routines from Database
        dbi = new dbInteraction();
        System.out.println("Coach for " + puname + " is " + coach);
        String routinesList = "," + dbi.listCustomRoutines(coach, "C");
        List<String> list = new ArrayList<>();

        // Parse each routine into list
        while (routinesList.lastIndexOf(",") != 0) {
            routinesList = routinesList.substring(1);
            list.add(routinesList.substring(0,routinesList.indexOf(",")));
            routinesList = routinesList.substring(routinesList.indexOf(","));
        }

        // Set Spinner
        coac = (Spinner) findViewById(R.id.coachRoutinesSpin);

        // Set adapter for spinner
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, list);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        coac.setAdapter(adapter);

        // Set listener for spinner
        setSpinnerListener(coac, (TextView) findViewById(R.id.coachDesc), "C");
    }

    public void setSpinnerListener(final Spinner spin, final TextView desc, final String which) {
        System.out.println("setting on item selected listener for " + which);
        final String username;
        if (which == "C")
            username = coach;
        else
            username = puname;


        spin.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String routine = spin.getItemAtPosition(position).toString().trim();
                System.out.println(routine);
                dbi = new dbInteraction();
                desc.setText(dbi.getRoutineDescription(routine, username, which));
            }

            public void onNothingSelected(AdapterView<?> parent) {
                desc.setText("Choose a routine from the list above to see its description.");
            }
        });
    }
    /********************** End Spinner setup methods  **********************/

    /*********************** Start Tab setup methods  ***********************/
    public void setTabs() {
        tabHost = (TabHost) findViewById(R.id.tabHost);
        TabHost.TabSpec tabSpec;
        tabHost.setup();

        // Set Default Routines Tab
        tabSpec = tabHost.newTabSpec("defaultRoutines");
        tabSpec.setContent(R.id.defaultRoutinesTab);
        tabSpec.setIndicator("Default Routines");
        tabHost.addTab(tabSpec);

        // Set Custom Routines Tab
        tabSpec = tabHost.newTabSpec("customRoutines");
        tabSpec.setContent(R.id.customRoutinesTab);
        tabSpec.setIndicator("Custom Routines");
        tabHost.addTab(tabSpec);

        //Set Coach Routines Tab
        tabSpec = tabHost.newTabSpec("coachRoutines");
        tabSpec.setContent(R.id.coachRoutinesTab);
        tabSpec.setIndicator("Coach Routines");
        tabHost.addTab(tabSpec);
        ((TextView) findViewById(R.id.textView8)).setText("Coach " + coach + "'s Routines");
    }
    /************************ End Tab setup methods  ************************/

    public void playDef(View view) {
        //difficulty, rounds, timer, timebased, type, user, usertype;
        Spinner spin = (Spinner) findViewById(R.id.defRoutinesSpin);
        RadioGroup radGrp = ((RadioGroup) findViewById(R.id.difficultyRadGrp));
        RadioButton rad = (RadioButton) findViewById(radGrp.getCheckedRadioButtonId());

        difficulty = rad.getText().toString();
        type = (String) spin.getSelectedItem();
        rname = "null";
        rounds = "null";
        timer = "null";
        timebased = "null";
        user = "null";
        usertype = "null";

        startRoutine(rname ,difficulty, type, rounds, timer, timebased, user, usertype);
    }

    public void playPlayer(View view) {
        Spinner spin = (Spinner) findViewById(R.id.custRoutinesSpin);
        rname = (String) spin.getSelectedItem();
        user = puname;
        usertype = "P";

        playCustom(rname, user, usertype);
    }

    public void playCoach(View view) {
        Spinner spin = (Spinner) findViewById(R.id.coachRoutinesSpin);
        rname = (String) spin.getSelectedItem();
        user = (new dbInteraction()).getCoach(puname);
        usertype = "C";

        playCustom(rname, user, usertype);
    }

    public void playCustom(String rname, String user, String usertype) {
        // get info from database
        dbInteraction dbi = new dbInteraction();
        String routineInfo = dbi.getRoutine(rname, user, usertype);

        // Parse routine info to Vars
        rounds = routineInfo.substring(0, routineInfo.indexOf(" "));
        routineInfo.substring(rounds.length());
        timer = routineInfo.substring(0, routineInfo.indexOf(" "));
        routineInfo.substring(timer.length());
        timebased = routineInfo.substring(0, routineInfo.indexOf(" "));
        routineInfo.substring(timebased.length());
        type =  routineInfo.substring(0, routineInfo.indexOf(" "));

        System.out.println("Routine = " + rname);
        System.out.println("User = " + user);
        System.out.println("User Type = " + usertype);
        System.out.println("Rounds = " + rounds);
        System.out.println("Timer = " + timer);
        System.out.println("Time Based = " + timebased);
        System.out.println("Type = " + type);

        startRoutine(rname, "null", type, rounds, timer, timebased, user, usertype);

    }

    public void startRoutine(String name, String difficulty, String type, String rounds, String timer,
                             String timebased, String user, String usertype) {
        // To Do:
        //   Send routine via Bluetooth to master pad
        Log.w("QQQQQ", name);
        Log.w("QQQQQ", difficulty);
        Log.w("QQQQQ", type);
        Log.w("QQQQQ", rounds);
        Log.w("QQQQQ", timer);
        Log.w("QQQQQ", timebased);

        String message = buildMessage(type, difficulty, rounds, timer, timebased);
            try {
                btSocket = dev.createRfcommSocketToServiceRecord(MY_UUID);
                btSocket.connect();
                outStream = btSocket.getOutputStream();
                inStream = btSocket.getInputStream();
                outStream.write(message.getBytes());
                //btSocket.close();//delete this
                //
            }catch (Exception e)
            {
                genericWarning w = new genericWarning();
                w.setPossitive("OK");
                w.setMessage("It looks like there is an issue in the bluetooth connection. Make sure that your pad is on....");
                w.show(getFragmentManager(),"no_bluetooth");
            }

    }

    String buildMessage(String type, String difficulty, String rounds, String timer, String timebased)
    {
        //except for type and difficulty/level all values are null we nned to handle that
        return "Shazz6zzzzzzE\n";//need to fix this
    }

//    public void sendRoutine(String routine) {
//        Intent intent = getIntent();
//        BluetoothDevice dev = intent.getParcelableExtra(Scan.EXTRA_PAD);
//        try {
//            btSocket = dev.createRfcommSocketToServiceRecord(Scan.MY_UUID);
//            btSocket.connect();
//            outStream = btSocket.getOutputStream();
//            outStream.write(routine.getBytes());
//        } catch (Exception e) {
//            System.out.println("Error connecting to Bluetooth:\n\t" + e);
//        }
//    }
}

