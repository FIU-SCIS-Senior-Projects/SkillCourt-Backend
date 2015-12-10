package com.seniorproject.skillcourt;

import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.jjoe64.graphview.GraphView;
import com.jjoe64.graphview.helper.GraphViewXML;
import com.jjoe64.graphview.series.DataPoint;
import com.jjoe64.graphview.series.LineGraphSeries;
import com.jjoe64.graphview.series.PointsGraphSeries;

import java.util.ArrayList;
import java.util.LinkedList;


public class DisplayStats extends ActionBarActivity {
    ListView stats_list_view;
    ArrayList<String> values;
    ArrayAdapter<String> adapter;

    LinkedList<LinkedList<String>> l;

    int lpos = -1;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_stats);

        Intent intent = getIntent();
        String puname = intent.getStringExtra(Login.EXTRA_MESSAGE);

        dbInteraction dbi = new dbInteraction();
        String accu = dbi.getMaxAccuracy(puname);
        String force = dbi.getMaxForce(puname);
        String reactT = dbi.getMinReaction(puname);
        String longestSt = dbi.getMaxStreak(puname);
        String points = dbi.getMaxPoints(puname);

        if(accu == null || force == null || reactT == null || longestSt == null || points == null)
        {
            genericWarning w = new genericWarning();
            w.setPossitive("OK");
            w.setMessage("There is an error in the internet connection");
            w.show(getFragmentManager(), "internet_connection_problem");
        }
        else if(accu.length() == 0)
        {
            TextView tv = (TextView) findViewById(R.id.stats);
            tv.setText("No Performance Available for " + puname);
        }
        else//missing empty string if user has no stats
        {
            l = dbi.getAllStats(puname);

            stats_list_view = (ListView) findViewById(R.id.stats_list);
            values = new ArrayList<String>();


            values.add("Best Accuracy: " + accu);
            values.add("Maximun Force: " + force + " N");
            values.add("Best Reaction Time: " + reactT + " s");
            values.add("Longest Streak: " + longestSt);
            values.add("Max Number of Points: " + points);

            adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
            //adapter.notifyDataSetChanged();
            stats_list_view.setAdapter(adapter);

            stats_list_view.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                public void onItemClick(AdapterView<?> parentAdapter, View view, int position, long id) {

                    if(position == 0)//best accuracy
                    {
                        GraphView graph = (GraphView) findViewById(R.id.graph);
                        graph.removeAllSeries();
                        DataPoint[] fdp = new DataPoint[l.size()];
                        for(int i = 0; i < l.size(); i++)
                        {
                            fdp[i] = new DataPoint(i,Double.parseDouble(l.get(i).get(0))/Double.parseDouble(l.get(i).get(2)));
                        }

                        if(lpos != 0) {
                            LineGraphSeries<DataPoint> series = new LineGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = 0;
                        }
                        else
                        {
                            PointsGraphSeries<DataPoint> series = new PointsGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = -1;
                        }

                            graph.setTitle("Game Number VS Accuracy");



                    }
                    else if(position == 1)//max force
                    {
                        GraphView graph = (GraphView) findViewById(R.id.graph);
                        graph.removeAllSeries();
                        DataPoint[] fdp = new DataPoint[l.size()];
                        for(int i = 0; i < l.size(); i++)
                        {
                            fdp[i] = new DataPoint(i,Double.parseDouble(l.get(i).get(1)));
                        }

                        if(lpos != 1) {
                            LineGraphSeries<DataPoint> series = new LineGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = 1;
                        }
                        else
                        {
                            PointsGraphSeries<DataPoint> series = new PointsGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = -1;
                        }
                        graph.setTitle("Game Number VS Force (N)");
                    }
                    else if(position == 2)//reaction time
                    {
                        GraphView graph = (GraphView) findViewById(R.id.graph);
                        graph.removeAllSeries();
                        DataPoint[] fdp = new DataPoint[l.size()];
                        for(int i = 0; i < l.size(); i++)
                        {
                            fdp[i] = new DataPoint(i,Double.parseDouble(l.get(i).get(3)));
                        }

                        if(lpos != 2) {
                            LineGraphSeries<DataPoint> series = new LineGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = 2;
                        }
                        else
                        {
                            PointsGraphSeries<DataPoint> series = new PointsGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = -1;
                        }
                        graph.setTitle("Game Number VS Reaction Time (s)");
                    }
                    else if(position == 3)//longest Streak
                    {
                        GraphView graph = (GraphView) findViewById(R.id.graph);
                        graph.removeAllSeries();
                        DataPoint[] fdp = new DataPoint[l.size()];
                        for(int i = 0; i < l.size(); i++)
                        {
                            fdp[i] = new DataPoint(i,Double.parseDouble(l.get(i).get(4)));
                        }

                        if(lpos != 3) {
                            LineGraphSeries<DataPoint> series = new LineGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = 3;
                        }
                        else
                        {
                            PointsGraphSeries<DataPoint> series = new PointsGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = -1;
                        }

                        graph.setTitle("Game Number VS Longest Streak");

                    }
                    else if(position == 4)//max number of points
                    {
                        GraphView graph = (GraphView) findViewById(R.id.graph);
                        graph.removeAllSeries();
                        DataPoint[] fdp = new DataPoint[l.size()];
                        for(int i = 0; i < l.size(); i++)
                        {
                            fdp[i] = new DataPoint(i,Double.parseDouble(l.get(i).get(5)));
                        }

                        if(lpos != 4) {
                            LineGraphSeries<DataPoint> series = new LineGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = 4;
                        }
                        else
                        {
                            PointsGraphSeries<DataPoint> series = new PointsGraphSeries<DataPoint>(fdp);
                            graph.addSeries(series);
                            lpos = -1;
                        }

                        graph.setTitle("Game Number VS Number of Points");



                    }
                }
            });


        }
    }


    private class GraphTouchListener implements View.OnTouchListener{
        @Override
        public boolean onTouch(View v, MotionEvent event)
        {

            return false;
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_display_stats, menu);
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
        if(id == R.id.action_goHome)
        {
            Intent intent = new Intent(this, Home.class);
            String[] str = new String[1];
            str[0] = "Display";
            intent.putExtra("result", str);
            this.setResult(this.RESULT_OK, intent);
            finish();
        }
        return super.onOptionsItemSelected(item);
    }


}
