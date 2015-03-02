package com.seniorproject.skillcourt;

import android.app.ProgressDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;


public class Scan extends ActionBarActivity {


    String puname;

    //List view
    ListView pads_list_view;
    ArrayAdapter<String> adapter;
    ArrayList<String> values;

    //Bluethood
    BluetoothAdapter ba;
    SingBroadcastReceiver mReceiver;
    HashMap<String,BluetoothDevice> devices;
    private static final UUID MY_UUID = UUID.fromString("1e0ca4ea-299d-4335-93eb-27fcfe7fa848");
    private OutputStream outStream;
    private InputStream inStream;
    //Progress dialog
    ProgressDialog progressDoalog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scan);

        Intent intent = getIntent();
        puname = intent.getStringExtra("puname");

        TextView tv = (TextView) findViewById(R.id.scanning_message_textview);

        if(!puname.equals("Guest"))
            tv.setText(puname + " select your SkillCourt Pads from the following list");
        else
            tv.setText("Select your SkillCourt Pads from the following list");

        pads_list_view = (ListView) findViewById(R.id.pads_list);
        values = new ArrayList<String>();

        adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
        pads_list_view.setAdapter(adapter);


        pads_list_view.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            public void onItemClick(AdapterView<?> parentAdapter, View view, int position, long id) {

                String []arr = new String[2];
                arr[0] = devices.get(adapter.getItem(position)).getName();
                arr[1] = devices.get(adapter.getItem(position)).getAddress();
                returnToHome(arr);
            }
        });




        ba = BluetoothAdapter.getDefaultAdapter();
        if(ba.isDiscovering())
            ba.cancelDiscovery();

        if(ba == null)
        {
            noBluetoothDialog nb = new noBluetoothDialog();
            nb.show(getFragmentManager(),"no_bluetooth");
        }
        else if(!ba.isEnabled())
        {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(enableBtIntent, 1);
        }
        else
        {
            startSearching();
        }


    }

    public void returnToHome(String[] arr)
    {
        Intent intent = new Intent(this, Home.class);
        intent.putExtra("result", arr);
        this.setResult(this.RESULT_OK, intent);

        if(ba.isDiscovering())
            ba.cancelDiscovery();

        this.finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        if(resultCode == RESULT_OK) {
            startSearching();
        }
        else
        {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("There was a problem turning up blutooth connection. Try to do it manually.");
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_scan, menu);
        return true;
    }

    @Override
    public void onDestroy() {
        unregisterReceiver(mReceiver);
        super.onDestroy();
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

    public void startSearching()//working here
    {
        devices = new HashMap<String,BluetoothDevice>();
        mReceiver = new SingBroadcastReceiver();

        IntentFilter ifilter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
        registerReceiver(mReceiver, ifilter);

        ifilter = new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_STARTED);
        registerReceiver(mReceiver, ifilter);

        ifilter = new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
        registerReceiver(mReceiver, ifilter);

        ba.startDiscovery();
    }

    public void addValueToList(String bName)
    {
        if(!values.contains(bName))
        {
            values.add(bName);
            adapter.notifyDataSetChanged();
        }
    }


    /*
    Used to scan
     */
    private class SingBroadcastReceiver extends BroadcastReceiver {

        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction(); //may need to chain this to a recognizing function
            if(BluetoothAdapter.ACTION_DISCOVERY_STARTED.equals(action))
            {

                progressDoalog = new ProgressDialog(Scan.this);
                progressDoalog.setTitle("Scanning");
                progressDoalog.setMessage("Currently looking for possible SkillCourt pads");
                progressDoalog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
                progressDoalog.show();


            }
            else if (BluetoothDevice.ACTION_FOUND.equals(action)){
                // Get the BluetoothDevice object from the Intent
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                devices.put(device.getName(),device);
                if(device.getName() != null) {

                    addValueToList(device.getName());
                }
                else {
                    addValueToList(device.getAddress());
                }

            }
            else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
                //discovery finishes, dismis progress dialog
                if(devices.isEmpty())
                {
                    TextView tv = (TextView)findViewById(R.id.scanning_message_textview);
                    tv.setText("No bluetooth device was found");
                }
                progressDoalog.dismiss();
                if(ba.isDiscovering())
                    ba.cancelDiscovery();//not sure
            }


        }
    }

    public void scanAgain(View view)
    {
        startSearching();
    }

    public void goBackHome(View view)
    {


        String[] result = new String[2];
        result[0] = "Nothing";
        result[1] = "Nothing";

        Intent intent = new Intent(this, Home.class);
        intent.putExtra("result", result);
        this.setResult(this.RESULT_CANCELED, intent);
        this.finish();
    }

}
