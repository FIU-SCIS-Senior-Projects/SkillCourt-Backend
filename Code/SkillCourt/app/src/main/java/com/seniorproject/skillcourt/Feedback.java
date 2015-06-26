package com.seniorproject.skillcourt;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

import android.content.Intent;
import android.os.Bundle ;
import android.support.v7.app.ActionBarActivity;

public class Feedback extends ActionBarActivity
{
    // Bluetooth Related Vars
    private OutputStream outStream;
    private InputStream inStream;
    BluetoothSocket btSocket;
    BluetoothDevice dev;
    protected static final UUID MY_UUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");

    String puname ;

    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);

        Intent intent = getIntent();
        puname = intent.getStringExtra(Login.EXTRA_MESSAGE);
        dev = intent.getExtras().getParcelable(Home.EXTRA_PAD);
    }


}
