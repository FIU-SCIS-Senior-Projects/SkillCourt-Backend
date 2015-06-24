package com.seniorproject.skillcourt;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.EditText;
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
import java.util.List;
import java.util.UUID;

/**
 * Created by msant080 on 2/17/2015.
 */
public class Play extends ActionBarActivity {
    Spinner defa, cust, coac;
    Spinner wallRemove ;
    dbInteraction dbi;
    TabHost tabHost;
    String puname, coach;
    TextView tv ;

    // Bluetooth Related Vars
    private OutputStream outStream;
    private InputStream inStream;
    BluetoothSocket btSocket;
    BluetoothDevice dev;
    protected static final UUID MY_UUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");

    // Routine Related Vars
    Switch playBySwitch;
    String rname, user, usertype;
    int missingWall = 1 ;
    boolean isRoundTimeBased = false ;
    boolean isWallRemoved = false ;
    boolean roundsAreDisabled = false ;
    boolean isCustomRoomDisabled = false ;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        setContentView(R.layout.activity_play_2);

        Intent intent = getIntent();
        puname = intent.getStringExtra(Login.EXTRA_MESSAGE);
        dev = intent.getExtras().getParcelable(Home.EXTRA_PAD);

        coach = (new dbInteraction()).getCoach(puname);

        // Set Spinners
        setSpinnerDefault();
        wallRemove.setVisibility(View.GONE);
        setSpinnerCustom();
        setSpinnerCoach();

        // Set Tabs
        setTabs();

        //getActionBar().setDisplayOptions(0, ActionBar.DISPLAY_SHOW_HOME);
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
        if (id == R.id.action_settings) return true;

        return super.onOptionsItemSelected(item);
    }

    /********************** Start Spinner setup methods  **********************/
    public void setSpinnerDefault() {
        // Set Spinners
        wallRemove = (Spinner) findViewById(R.id.removeWallSpin) ;
        defa = (Spinner) findViewById(R.id.defRoutinesSpin);
        // Attach arrays to adapters
        ArrayAdapter<CharSequence> adapter =  ArrayAdapter.createFromResource(this, R.array.routine_array, android.R.layout.simple_spinner_item) ;
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        ArrayAdapter<CharSequence> wallAdapter =  ArrayAdapter.createFromResource(this, R.array.wall_to_remove_array, android.R.layout.simple_spinner_item) ;
        wallAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        // Set adapters for spinner
        defa.setAdapter(adapter);
        wallRemove.setAdapter(wallAdapter);

        // Set Description
        final TextView defaDesc = (TextView) findViewById(R.id.defDesc);


        // Set listener for spinner
        defa.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String routine = defa.getItemAtPosition(position).toString().trim();
                String[] routines = getResources().getStringArray(R.array.routine_array) ;
                // Set Description based on description variable

                if(routine.equals(routines[0])) //three wall chase
                {
                    defaDesc.setText(R.string.three_wall_desc) ;
                    disableRounds(false);
                    disableCustomRoom(false);
                }
                else if(routine.equals(routines[1])) //chase
                {
                    defaDesc.setText(R.string.chase_desc);
                    disableRounds(true);
                    disableCustomRoom(false);
                }
                else if(routine.equals(routines[2])) //fly
                {
                    defaDesc.setText(R.string.fly_desc);
                    disableRounds(true);
                    disableCustomRoom(false);
                }
                else if(routine.equals(routines[3])) //home chase
                {
                    defaDesc.setText(R.string.home_chase_desc);
                    disableRounds(false);
                    disableCustomRoom(false);
                }
                else if(routine.equals(routines[4])) //home fly
                {
                    defaDesc.setText(R.string.home_fly_desc);
                    disableRounds(false);
                    disableCustomRoom(false);
                }
                else if(routine.equals(routines[5])) //ground chase
                {
                    defaDesc.setText(R.string.ground_chase_desc);
                    disableRounds(false);
                    disableCustomRoom(false);
                }
                else if(routine.equals(routines[6])) //xcue
                {
                    defaDesc.setText(R.string.xcue_desc) ;
                    disableRounds(false) ;
                    disableCustomRoom(true);
                }
            }

            public void onNothingSelected(AdapterView<?> parent) {}
        });

        wallRemove.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                missingWall = position + 1;
                isWallRemoved = true ;
            }

            public void onNothingSelected(AdapterView<?> parent) {}
        });
    }
    private void disableCustomRoom(boolean disable)
    {
        if(disable ^ !isCustomRoomDisabled)
        {
            findViewById(R.id.removeWallCheck).setVisibility((disable) ? View.GONE : View.VISIBLE);
            findViewById(R.id.removeWallSpin).setVisibility((disable) ? View.GONE : View.VISIBLE);
            if(!disable) defa.setSelection(0);
            missingWall = (disable) ? -1 : 1 ;
            isWallRemoved = !disable ;
            isCustomRoomDisabled = !isCustomRoomDisabled ;
        }
    }

    private void disableRounds(boolean disable)
    {
        if(disable ^ !roundsAreDisabled)
        {
            findViewById(R.id.timedRoundsGroup).setVisibility((disable) ? View.GONE : View.VISIBLE) ;
            findViewById(R.id.rtSwitch).setPressed(!disable) ;
            tv = (TextView) findViewById(R.id.rtText) ;
            tv.setText((disable) ? R.string.minutes : R.string.rounds) ;
            findViewById(R.id.timePerRoundTitle).setVisibility((disable) ? View.GONE : View.VISIBLE) ;
            findViewById(R.id.rtSwitch).setEnabled(!disable);
            isRoundTimeBased = !disable ;
            roundsAreDisabled = !roundsAreDisabled ;
        }
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

    public void wallCheckboxClicked(View view)
    {
        findViewById(R.id.removeWallSpin).setVisibility((((CheckBox) view).isChecked()) ? View.VISIBLE : View.GONE);
    }

    public void roundsCheckboxClicked(View view)
    {
        findViewById(R.id.timePerRoundInput).setEnabled(((CheckBox)view).isChecked());
    }

    /**
     * Switch for selecting playing timer or rounds for a default routine
     * @param view the Switch object
     */
    public void switchChange(View view)
    {
        tv = (TextView) findViewById(R.id.rtText);
        if (((Switch)view).isChecked()) tv.setText(R.string.rounds); // on for rounds
        else tv.setText(R.string.minutes);// off for timer
    }

    public void playDef1(View view)
    {
        if(isInputProper())
        {
            char [] command = new char[11] ;

            //Routine type - 1 char - Index in command: 0
            int routineIndex = defa.getSelectedItemPosition() ;
            String [] codes = getResources().getStringArray(R.array.routine_codes) ;
            command[0] = codes[routineIndex].charAt(0) ;

            //Diffculty - 1 char - Index in command: 1
            RadioGroup rg = (RadioGroup)findViewById(R.id.difficultyRadGrp) ;
            String difficulty = ((RadioButton)findViewById(rg.getCheckedRadioButtonId())).getText().toString() ;
            command[1] = Character.toLowerCase(difficulty.charAt(0)) ;

            //Rounds - 2 chars - Indices in command: 2-3
            //Minutes - 3 chars - Indices in command: 6-8
            boolean isPlayByRounds = ((Switch)findViewById(R.id.rtSwitch)).isChecked() ;
            String playByInput = ((EditText)findViewById(R.id.rtEdit)).getText().toString() ;
            int inputValue = Integer.parseInt(playByInput) ;
            if(isPlayByRounds) //set rounds properly and time to "000"
            {
                command[2] = (inputValue > 9) ? playByInput.charAt(0) : '0' ;
                command[3] = playByInput.charAt(1) ;
                command[6] = command[7] = command[8] = 0 ;
            }
            else //set minutes properly and rounds to "00"
            {
                command[2] = command[3] = 0 ;
                command[7] = (inputValue > 99) ? playByInput.charAt(0) : '0' ;
                command[7] = (inputValue > 9) ? playByInput.charAt(1) : '0' ;
                command[8] = playByInput.charAt(2) ;
            }

            //Missing Wall - 2 chars - Indices in command 4-5
            

        }
    }

    private boolean isInputProper()
    {
        return true ;
    }
    /**
     * Player clicked on a Default routine to play
     * @param view the button object which was clicked on
     */
    public void playDef(View view) {
        //difficulty, rounds, timer, timebased, type, user, usertype;
        String routineType = (String)defa.getSelectedItem() ;
        RadioGroup radGrp = ((RadioGroup) findViewById(R.id.difficultyRadGrp));
        RadioButton rad = (RadioButton) findViewById(radGrp.getCheckedRadioButtonId());
        Routine r = new Routine("SkillCourtDefault");
        String input = ((EditText) findViewById(R.id.rtEdit)).getText().toString();
        if (input.equals(""))
        {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("You must set a timer or number of rounds.");
            w.show(getFragmentManager(), "no_bluetooth");
        }
        else
        {
            if (playBySwitch.isChecked())
            {
                r.setRounds(Integer.parseInt(input));
                r.setTimer(0);
            }
            else
            {
                r.setTimer(Integer.parseInt(input));
                r.setRounds(0);
            }
            switch (routineType)
            {
                case "Three Wall Chase": r.setType('t'); break;
                case "Chase": r.setType('c'); break;
                case "Fly": r.setType('h'); break;
                case "Home Chase": r.setType('g'); break;
                case "Home Fly": r.setType('j'); break;
                case "Ground Chase": r.setType('m'); break;
                case "xCue": r.setType('x'); break;
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

        // To Do:
        //   Send routine via Bluetooth to master pad
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        System.out.println(dateFormat.format(date));
        //Testing stat storage
        String message = buildMessage(type, difficulty, rounds, timer, timebased);
        try {
            btSocket = dev.createRfcommSocketToServiceRecord(MY_UUID);
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

            message = getMessage(packetBytes);
            message = message.substring(0, message.indexOf('n'));
            //********************************************************call Mathews function
            Statistic s = parseMessage(message, puname, difficulty, date);
            dbInteraction dbi = new dbInteraction();
            dbi.addStat(s);
            btSocket.close();
            Intent intent = new Intent(this, GameResults.class);
            intent.putExtra(Home.EXTRA_PAD, dev);
            intent.putExtra("stats", s);
            intent.putExtra(Login.EXTRA_MESSAGE, puname);
            startActivity(intent);

        }catch (Exception e)
        {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("It looks like there is an issue in the bluetooth connection. Make sure that your pad is on....");
            w.show(getFragmentManager(),"no_bluetooth");
        }

    }

    public String buildMessage(String type, String difficulty, String rounds, String timer, String timebased) {
        type = type.toLowerCase();
        difficulty = difficulty.toLowerCase();


        String add = "";
        for (int i = 0; i < 3 - rounds.length(); i++) add = add + "z";

        rounds = add + rounds;

        add = "";
        for (int i = 0; i < 4 - timer.length(); i++) add = add + "z";

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
        try
        {
            String str = new String(bytes, "US-ASCII");

            return str.split("\n")[0];
        }
        catch(Exception e)
        {
            return null;
        }
    }

    public Statistic parseMessage(String m, String username, String diff, Date date) {
        String points = m.substring(m.indexOf("p")+1, m.indexOf("s"));
        String shots = m.substring(m.indexOf("s")+1, m.indexOf("o"));
        String onTarget = m.substring(m.indexOf("o")+1, m.indexOf("l"));
        String lStrike = m.substring(m.indexOf("l")+1, m.indexOf("t"));
        String avgTimeBtwShots = m.substring(m.indexOf("t")+1, m.indexOf("f"));
        String avgForce = m.substring(m.indexOf("f")+1);
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Statistic s = new Statistic(username, diff, points, shots, onTarget, lStrike, avgTimeBtwShots, avgForce, dateFormat.format(date).toString());

        return s;
    }
}

