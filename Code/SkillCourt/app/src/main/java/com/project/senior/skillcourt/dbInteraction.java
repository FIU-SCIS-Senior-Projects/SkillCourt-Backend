package com.project.senior.skillcourt;

/**
 * Created by andymartinez on 2/10/15.
 */
public class dbInteraction {
    private String host = "http://skillcourt-dev.cis.fiu.edu/php/checkIfUnameExist.php";

    public dbInteraction()
    {

    }

    /*
    *Returns 0 if puname does not exist
    *Returns -1 if there is an error in the connection
    *Returns 1 if puname exists
     */
    int checkIfPunameExist(String puname)
    {
        return 0;
    }
}
