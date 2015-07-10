package com.seniorproject.skillcourt;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;

import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.util.UUID;

import android.content.Intent;
import android.os.Bundle ;
import android.support.v7.app.ActionBarActivity;
import android.widget.TextView;

public class Feedback extends ActionBarActivity
{
    // Bluetooth Related Vars
    private OutputStream outStream;
    private InputStream inStream;
    BluetoothSocket btSocket;
    BluetoothDevice dev;
    protected static final UUID MY_UUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");

    String puname ;
    TextView successes ;
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);

        Intent intent = getIntent();
        //puname = intent.getStringExtra(Login.EXTRA_MESSAGE);
        dev = intent.getExtras().getParcelable(Home.EXTRA_PAD);

        successes = (TextView) findViewById(R.id.successes) ;
        successes.setText("nothing yet");
        getFeedback() ;
    }

    private void getFeedback()
    {
        try {
            //Method m = dev.getClass().getMethod("createRfcommSocket", new Class[] {int.class});
            //btSocket = (BluetoothSocket) m.invoke(dev, 1);

            btSocket = dev.createRfcommSocketToServiceRecord(MY_UUID);
            btSocket.connect();
            outStream = btSocket.getOutputStream();
            inStream = btSocket.getInputStream();

            int available = inStream.available();
            while(available < 34) available = inStream.available() ;

            byte [] feedback = new byte [34] ;
            inStream.read(feedback) ;

            ByteBuffer byteBuff = ByteBuffer.wrap(feedback) ;
            char initial = byteBuff.getChar() ;
            if(initial != 'F')
            {
                successes.setText("NO F");
            }
            else
            {
                successes.setText("YES F");
            }
            btSocket.close();
        }
        catch (Exception e)
        {
            System.out.println(e);
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("It looks like there is an issue in the bluetooth connection in feedback. Make sure that your pad is on....");
            w.show(getFragmentManager(),"no_bluetooth");
        }
    }
}
