package com.seniorproject.skillcourt;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;

/**
 * Created by Andy on 2/26/2015.
 */
    public class noBluetoothDialog extends DialogFragment {

        private String message = "Your device does not support bluetooth connection";
        private String possitive = "OK";

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            // Use the Builder class for convenient dialog construction
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setMessage(message)
                    .setPositiveButton(possitive, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            String[] result = null;
                            Intent intent = new Intent(getActivity(), Home.class);
                            intent.putExtra("result", result);
                            getActivity().setResult(getActivity().RESULT_CANCELED, intent);
                            getActivity().finish();
                        }
                    });
            // Create the AlertDialog object and return it
            return builder.create();
        }
    }
