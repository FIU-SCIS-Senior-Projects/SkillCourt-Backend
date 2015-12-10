package com.seniorproject.skillcourt;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.os.Bundle;

/**
 * Created by Andy on 2/15/2015.
 */

public class genericWarning extends DialogFragment {

    private String message;
    private String possitive;

    void setMessage(String message)
    {
        this.message = message;
    }

    void setPossitive(String possitive)
    {
        this.possitive = possitive;
    }



    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the Builder class for convenient dialog construction
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setMessage(message)
                .setPositiveButton(possitive, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {

                    }
                });
        // Create the AlertDialog object and return it
        return builder.create();
    }
}