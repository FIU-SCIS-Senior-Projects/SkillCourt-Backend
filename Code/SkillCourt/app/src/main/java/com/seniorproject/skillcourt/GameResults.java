package com.seniorproject.skillcourt;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

/**
 * Created by msant080 on 4/18/2015.
 */
public class GameResults extends ActionBarActivity {

    BluetoothSocket btSocket;
    BluetoothDevice dev;
    Statistic stats;
    String puname;

    protected static final UUID MY_UUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");

    protected void onCreate(Bundle savedInstanceState) {
        Intent intent = getIntent();
        puname = intent.getStringExtra(Login.EXTRA_MESSAGE);
        stats = intent.getParcelableExtra("stats");

        dev = intent.getExtras().getParcelable(Home.EXTRA_PAD);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game_results);

        ((TextView) findViewById(R.id.textView20)).setText(stats.getPoints());
        ((TextView) findViewById(R.id.textView26)).setText(stats.getPoints() + "s");
        ((TextView) findViewById(R.id.textView27)).setText(stats.getPoints());
        ((TextView) findViewById(R.id.textView28)).setText("" + ((((Double.valueOf(
                stats.getOnTarget())))/Double.valueOf(stats.getShots()))*100) + "%");
        ((TextView) findViewById(R.id.textView29)).setText(stats.getAvgTimeBtwShots() + "s");
        ((TextView) findViewById(R.id.textView30)).setText(stats.getAvgForce() + "N");

    }

    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_welcome, menu);
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

        return super.onOptionsItemSelected(item);
    }

    public void goBack(View view) {
        try {
            btSocket = dev.createRfcommSocketToServiceRecord(MY_UUID);
            btSocket.connect();
            OutputStream outStream = btSocket.getOutputStream();
            InputStream inStream = btSocket.getInputStream();
            outStream.write("disc\n".getBytes());
            //btSocket.close();//delete this
            //
            long startTime = System.currentTimeMillis();
            while((System.currentTimeMillis() - startTime)/1000 < 1){}

            btSocket.close();
            Intent intent = new Intent(this, Home.class);
            intent.getStringExtra(Login.EXTRA_MESSAGE);
            startActivity(intent);

        }catch (Exception e)
        {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("It looks like there is an issue in the bluetooth connection. Make sure that your pad is on....");
            w.show(getFragmentManager(),"no_bluetooth");
        }
    }

    public void playAgain(View view) {
        Intent intent = new Intent(this, Play.class);
        intent.putExtra(Login.EXTRA_MESSAGE, puname);
        intent.putExtra(Home.EXTRA_PAD, dev);
        startActivity(intent);
    }
}
