function confirmChanges(pw, npw, npwc, coach, priv, form) {
    var ret = "";
    if (npw != "") {
	if (npw != npwc) {
	    // New Password must match new password confirmation
	    alert("New Password must match New Password Confirmation");
	    return false;
	}
    ret = ret + "p";
    }
    if (coach != "") {
	ret = ret + "c";
    }

    var p = document.createElement("input");
    form.appendChild(p);
    p.name = "changes";
    p.type = "hidden";
    p.value = ret;
    form.submit();
    return true;
}
