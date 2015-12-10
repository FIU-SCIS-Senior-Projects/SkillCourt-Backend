package com.seniorproject.skillcourt;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.ComponentName;
import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;


public class Home extends ActionBarActivity {

    public final static String EXTRA_PAD_NAME = "pad_name";
    public final static String EXTRA_PAD_ADDR = "pad_address";
    public final static String EXTRA_PAD = "pad";

    String dev_name;
    String dev_addr;

    String puname = "";
    public final static String EXTRA_MESSAGE = "Credentials";
    int REQUEST_PAD_INFO = 1;
    boolean connected = false;

    Boolean bluetoothSupported = true;
    BluetoothDevice dev;
    BluetoothSocket btSocket;

    protected static final UUID MY_UUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        System.out.println("In home activity");

        TextView tv = (TextView) findViewById(R.id.no_bluetooth);
        tv.setText("Your device is not currently connected to any SkillCourt pad");

        Intent intent = getIntent();
        puname = intent.getStringExtra(Login.EXTRA_MESSAGE);

        if(puname == null) {
            puname = "Guest";
        }

        ((TextView) findViewById(R.id.home_message)).setText(puname);
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
            if(connected) {
                try {
                    btSocket = dev.createRfcommSocketToServiceRecord(MY_UUID);
                    btSocket.connect();
                    OutputStream outStream = btSocket.getOutputStream();
                    InputStream inStream = btSocket.getInputStream();
                    outStream.write("disc\n".getBytes());
                    //btSocket.close();//delete this
                    //
                    long startTime = System.currentTimeMillis();
                    while ((System.currentTimeMillis() - startTime) / 1000 < 1) {
                    }

                    btSocket.close();
                    Intent intent = new Intent(this, Welcome.class);
                    startActivity(intent);

                } catch (Exception e) {
                    genericWarning w = new genericWarning();
                    w.setPossitive("OK");
                    w.setMessage("It looks like there is an issue in the bluetooth connection. Make sure that your pad is on....");
                    w.show(getFragmentManager(), "no_bluetooth");
                }
            }
            else
            {
                Intent intent = new Intent(this, Welcome.class);
                startActivity(intent);
            }

        }
        else if(id == R.id.profile)
        {
            if(puname.equals("Guest"))
            {
                Intent intent = new Intent(this, CreateAccount1.class);
                startActivity(intent);
            }
            else
            {
                Intent intent = new Intent(this, Profile.class);
                intent.putExtra(EXTRA_MESSAGE, puname);
                startActivityForResult(intent, 1);
            }
        }


        return super.onOptionsItemSelected(item);
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        if(resultCode == RESULT_OK)
        {
            if (data.getStringArrayExtra("result")[0].equals("Profile")) {
                // Player came from Profile
                findViewById(R.id.start_playing).setEnabled(true);
            }
            else if(data.getStringArrayExtra("result")[0].equals("Display")){
                // Player came from Display Stats
            }
            else {
                // Player came from Scan
                //get the name and address of device that was touched by the user in the list
                TextView tv = (TextView) findViewById(R.id.no_bluetooth);
                if(data.getStringArrayExtra("result")[0] != null) {
                    dev_name = data.getStringArrayExtra("result")[0];
                    dev_addr = data.getStringArrayExtra("result")[1];
                    tv.setText("You are connected to " + dev_name);

                    dev = data.getExtras().getParcelable(Scan.EXTRA_PAD);
                }
                else {
                    //it will never hit here
                    tv.setText("You are connected to " + data.getStringArrayExtra("result")[1]);
                }
                connected = true;
                findViewById(R.id.start_playing).setEnabled(true);
            }
        }
        else if(data.getStringArrayExtra("result") == null)
        {
            // Device has no bluetooth support
            bluetoothSupported = false;
            TextView tv = (TextView) findViewById(R.id.no_bluetooth);
            tv.setText("Your device does not support bluetooth connection");
            connected = false;
            findViewById(R.id.start_playing).setEnabled(false);
        }
        else
        {
            //nothing was found
        }
    }

    public void scan(View view){
        BluetoothAdapter ba =BluetoothAdapter.getDefaultAdapter();
        if(ba == null)
        {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("Your device does not have Bluetooth capabilities");
            w.show(getFragmentManager(),"no_bluetooth");
        }
        else {
            Intent scan = new Intent(this, Scan.class);
            scan.putExtra(Login.EXTRA_MESSAGE, puname);
            startActivityForResult(scan, REQUEST_PAD_INFO);
            //finish();//not sure
        }
    }


    public void play(View view){

        if(!connected)
        {
            BluetoothAdapter ba =BluetoothAdapter.getDefaultAdapter();
            if(ba == null)
            {
                genericWarning w = new genericWarning();
                w.setPossitive("OK");
                w.setMessage("Your device does not have Bluetooth capabilities");
                w.show(getFragmentManager(),"no_bluetooth");
            }
            else {
                Intent scan = new Intent(this, Scan.class);
                scan.putExtra(Login.EXTRA_MESSAGE, puname);
                startActivityForResult(scan, REQUEST_PAD_INFO);
                //finish();//not sure
            }
        }
        else {
            Intent intent = new Intent(this, Play.class);
            intent.putExtra(EXTRA_PAD_NAME, dev_name);
            intent.putExtra(EXTRA_PAD_ADDR, dev_addr);
            intent.putExtra(EXTRA_PAD, dev);

            intent.putExtra(Login.EXTRA_MESSAGE, puname);
            startActivity(intent);
        }
    }

    public void stats(View view)
    {
        if(puname.equals("Guest"))
        {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("As a guest you can't access any previous performances");
            w.show(getFragmentManager(),"no_performance_guest");
        }
        else {
            Intent stats = new Intent(this, DisplayStats.class);
            stats.putExtra(Login.EXTRA_MESSAGE, puname);
            startActivityForResult(stats, REQUEST_PAD_INFO);
        }
    }
}
