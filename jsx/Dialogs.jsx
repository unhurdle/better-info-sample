com_unhurdle_dialogs = {};
com_unhurdle_dialogs.SetLogging = function(){
    try{
    var logLevel = com_unhurdle_log.LogLevel;
    var title = "Logging (Use as directed)";
    var dropdownLabel = "Select Logging Level";
    var dropdownList = ["None","Errors","Full"];
    var d = new HarbsUI.DropDownDialog(title,dropdownLabel,dropdownList,logLevel);
    if(d.show()){
        com_unhurdle_log.LogLevel = d.dropdown.selection.index;
        return "" + com_unhurdle_log.LogLevel;
    }
    }catch(err){
        return JSON.stringify(err);
    }
}
com_unhurdle_dialogs.showLogin = function(props){
	try{
		props = JSON.parse(props);
        var emailLabel = props.emailLabel || "Email";
        var passwordLabel = props.passwordLabel || "Password";
        var emailText = props.emailText || "";
        var passwordText = props.passwordText || "";
        var buttonLabel = props.buttonLabel || "Login";
        var d = new HarbsUI.DoubleDialog (props.title,'column','top',buttonLabel);
        d.labelGroup.add('statictext',undefined,emailLabel);
        d.labelGroup.add('statictext',undefined,passwordLabel);
        var email = d.mainGroup.add('edittext',undefined,emailText);
        email.characters = 15;
        var password = d.mainGroup.add("edittext",undefined,passwordText,{noecho:true});
        password.characters = 15;
        if(d.show()){
            return JSON.stringify({email:email.text,password:password.text});
            //alert(email.text + " " + password.text);
        } else {
            return "";
        }
    }catch(err){
        return JSON.stringify(err);
    }
}
