package com.seniorproject.skillcourt;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v7.app.ActionBarActivity;
import android.text.InputType;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Adapter;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.BaseExpandableListAdapter;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TabHost;
import android.widget.TextView;

import java.io.InputStream;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
    Switch s;
    String rname, user, usertype;



    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_play_2);

        Intent intent = getIntent();
        puname = intent.getStringExtra(Login.EXTRA_MESSAGE);
//        //Commented out for testing purposes only
//        pad_name = intent.getStringExtra(Home.EXTRA_PAD_NAME);
//        pad_addr = intent.getStringExtra(Home.EXTRA_PAD_ADDR);

        dev = intent.getExtras().getParcelable(Home.EXTRA_PAD);


        coach = (new dbInteraction()).getCoach(puname);

        // Set Spinners
        setSpinnerDefault();
        setSpinnerCustom();
        setSpinnerCoach();

        // Set Tabs
        setTabs();
        s = (Switch) findViewById(R.id.rtSwitch);
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
        // Set Default routines into a list
        List<String> list = new ArrayList<>();
        list.add("Chase Me");
        list.add("Fly Me");

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
                String description = "";
                // Get routine type
                description = defa.getSelectedItem().toString();
                // Check if ground pads are used
                if (((CheckBox) findViewById(R.id.groundCheck)).isChecked())
                    description = "Ground " + description;
                // Set Description based on description variable
                switch (description) {
                    case "Chase Me":
                        defaDesc.setText(R.string.chase_me_desc); break;
                    case "Fly Me":
                        defaDesc.setText(R.string.fly_me_desc); break;
                    case "Ground Chase Me":
                        defaDesc.setText(R.string.ground_chase_desc); break;
                    case "Ground Fly Me":
                        defaDesc.setText(R.string.ground_fly_desc); break;
                    default :
                        defaDesc.setText("defChoose a routine from the list above to see its description.");
                }
            }

            public void onNothingSelected(AdapterView<?> parent) {
                defaDesc.setText("Choose a routine from the list above to see its description.");
            }
        });
    }

    public void setSpinnerCustom() {
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
        // Get Custom Routines from Database
        dbi = new dbInteraction();
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
        final String username;
        if (which == "C")
            username = coach;
        else
            username = puname;


        spin.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String routine = spin.getItemAtPosition(position).toString().trim();
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

    /**
     * Switch for selecting playing timer or rounds for a default routine
     * @param view the Switch object
     */
    public void switchChange(View view) {
        TextView tv = (TextView) findViewById(R.id.rtText);

        if (s.isChecked()) {
            // on for rounds
            tv.setText("rounds");
        } else {
            // off for timer
            tv.setText("minutes");
        }
    }

    public void addGround(View view) {
        genericWarning w = new genericWarning();
        w.setPossitive("OK");
        w.setMessage("Ground targeting is not yet available");
        w.show(getFragmentManager(),"Unavailable");
        ((CheckBox) view).setChecked(false);
    }

    /**
     * Player clicked on a Default routine to play
     * @param view the button object which was clicked on
     */
    public void playDef(View view) {
        //difficulty, rounds, timer, timebased, type, user, usertype;
        Spinner spin = (Spinner) findViewById(R.id.defRoutinesSpin);
        RadioGroup radGrp = ((RadioGroup) findViewById(R.id.difficultyRadGrp));
        RadioButton rad = (RadioButton) findViewById(radGrp.getCheckedRadioButtonId());
        Routine r = new Routine("SkillCourtDefault");
        String input = ((EditText) findViewById(R.id.rtEdit)).getText().toString();
        if (input == "") {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("You must set a timer or number of rounds.");
            w.show(getFragmentManager(), "no_bluetooth");
        } else {
            if (s.isChecked()) {
                r.setRounds(Integer.parseInt(input));
                r.setTimer(0);
            } else {
                r.setTimer(Integer.parseInt(input)*60);
                r.setRounds(0);
            }
            if (((CheckBox) findViewById(R.id.groundCheck)).isChecked())
                r.setGround(true);
            switch ((String) spin.getSelectedItem()) {
                case "Fly Me":
                    r.setType('F');
                    break;
                case "Chase Me":
                    r.setType('C');
                    break;
            }

            r.setDifficulty(rad.getText().toString().toUpperCase().charAt(0));
            r.setUsername("SkillCourt");
            r.setUsertype('A');

            startRoutine(r);
        }
    }

    /**
     * Player clicked on a Player-made custom routine to play
     * Pass variables to playcustom for db-fetch
     * @param view the button object which was clicked on
     */
    public void playPlayer(View view) {
        Spinner spin = (Spinner) findViewById(R.id.custRoutinesSpin);
        rname = (String) spin.getSelectedItem();
        user = puname;
        usertype = "P";

        playCustom(rname, user, usertype);
    }

    /**
     * Player clicked on a Coach's custom routine to play
     * Pass variables to playcustom for db-fetch
     * @param view the button object which was clicked on
     */
    public void playCoach(View view) {
        Spinner spin = (Spinner) findViewById(R.id.coachRoutinesSpin);
        rname = (String) spin.getSelectedItem();
        user = (new dbInteraction()).getCoach(puname);
        usertype = "C";

        playCustom(rname, user, usertype);
    }

    /**
     * Get vars for custom routine
     * @param rname the name of the routine selected
     * @param user the name of the user which the routine belongs
     * @param usertype the usertype of the creator of the routine
     */
    public void playCustom(String rname, String user, String usertype) {
        // get info from database
        dbInteraction dbi = new dbInteraction();
        Routine r = dbi.getRoutine(rname, user, usertype);

        startRoutine(r);
    }

    /**
     * Send routine vars to pad
     * @param r the routine to be played
     */
    public void startRoutine(Routine r) {
        String name = r.getName();
        String type = String.valueOf(r.getType());
        String difficulty = String.valueOf(r.getDifficulty());
        String rounds = String.valueOf(r.getRounds());
        String timer = String.valueOf(r.getTimer());
        String timebased = String.valueOf(r.getTimebased());
        String ground; if (r.getGround()) ground = "y"; else ground = "n";

        // To Do:
        //   Send routine via Bluetooth to master pad
        Log.w("QQQQQ", name);
        Log.w("QQQQQ", difficulty);
        Log.w("QQQQQ", type);
        Log.w("QQQQQ", ground);
        Log.w("QQQQQ", rounds);
        Log.w("QQQQQ", timer);
        Log.w("QQQQQ", timebased);

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        System.out.println(dateFormat.format(date));
        //Testing stat storage
        dbInteraction dbi = new dbInteraction();
        dbi.addStat(puname, difficulty, dateFormat.format(date), "10", "5", "12.32", "17.22", "12", "10.12", rounds);
        String message = buildMessage(type, difficulty, rounds, timer, timebased);
        //try {
            /*btSocket = dev.createRfcommSocketToServiceRecord(MY_UUID);                                                      //Changed
            btSocket.connect();
            outStream = btSocket.getOutputStream();
            inStream = btSocket.getInputStream();
            outStream.write(message.getBytes());
            //btSocket.close();//delete this
            //
            int Availablebytes = inStream.available();

            //long startTime = System.currentTimeMillis();
            while(Availablebytes < 40)//(System.currentTimeMillis() - startTime)/1000 <= 10)
            {
                Availablebytes = inStream.available();
            }

            byte[] packetBytes = new byte[Availablebytes];
            inStream.read(packetBytes);

            message = getMessage(packetBytes);*/
            message = "p10s12o8l8t3.32f12.16";
            //message = message.substring(0, message.indexOf('n'));
            //********************************************************call Mathews function
            Statistic s = parseMessage(message, puname, difficulty, date);
            //btSocket.close();
            Intent intent = new Intent(this, GameResults.class);
            intent.putExtra(Home.EXTRA_PAD, dev);
            intent.putExtra("stats", s);
            intent.putExtra(Login.EXTRA_MESSAGE, puname);
            startActivity(intent);

        /*}catch (Exception e)
        {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("It looks like there is an issue in the bluetooth connection. Make sure that your pad is on....");
            w.show(getFragmentManager(),"no_bluetooth");
        }*/

    }

    public String buildMessage(String type, String difficulty, String rounds, String timer, String timebased) {
        type = type.toLowerCase();
        difficulty = difficulty.toLowerCase();


        String add = "";
        for (int i = 0; i < 3 - rounds.length(); i++) {
            add = add + "z";
        }
        rounds = add + rounds;

        add = "";
        for (int i = 0; i < 4 - timer.length(); i++) {
            add = add + "z";
        }
        timer = add + timer;

        String message = "S" + type + difficulty + rounds + timer + "zzE";
        String finalmsg = "";
        for (int i = 0; i < message.length(); i++) {
            if (message.charAt(i) == 'f')
                finalmsg = finalmsg + "h";
            else if (message.charAt(i) == '0')
                finalmsg = finalmsg + "z";
            else
                finalmsg = finalmsg + message.substring(i, i + 1);
        }

        return finalmsg;//need to fix this
    }

    String getMessage(byte[] bytes) {
        try{
            String str = new String(bytes, "US-ASCII");

            return str.split("\n")[0];
        }
        catch(Exception e)
        {
            return null;
        }
    }

    public Statistic parseMessage(String m, String username, String diff, Date date) {
        // "p"+Integer.toString(points)+
        // "s"+Integer.toString(tNumbShots)+
        // "o"+Integer.toString(onTarget)+
        // "l"+Integer.toString(lStrike)+
        // "t"+Double.toString(avgTimeBetwShots)+
        // "f"+Double.toString(avgForce)
        String points = m.substring(m.indexOf("p"+1), m.indexOf("s"));
        String shots = m.substring(m.indexOf("s"+1), m.indexOf("o"));
        String onTarget = m.substring(m.indexOf("o"+1), m.indexOf("l"));
        String lStrike = m.substring(m.indexOf("l"+1), m.indexOf("t"));
        String avgTimeBtwShots = m.substring(m.indexOf("t"+1), m.indexOf("f"));
        String avgForce = m.substring(m.indexOf("f"+1));
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Statistic s = new Statistic(username, diff, points, shots, onTarget, lStrike, avgTimeBtwShots, avgForce, dateFormat.format(date).toString());

        return s;
    }
}

