com_unhurdle_log = {};
com_unhurdle_log.LOG_PATH = Folder.myDocuments.absoluteURI + "/UnHurdle/Logging/Logs";
com_unhurdle_log.ERROR_LOG_PATH = Folder.myDocuments.absoluteURI + "/UnHurdle/Logging/Error Logs";
com_unhurdle_log.LogLevel = 0;
/*
0 no logging
1 error logging
2 message logging
*/
com_unhurdle_log.GetTime = function(){
	var d = new Date();
	return d.toDateString() + " " + d.toTimeString();
}
com_unhurdle_log.GetDateString = function(){
	var d = new Date();
	var m = d.getMonth()+1;
	if(m<10){
		m = "0" + m;
	}
	var date = d.getDate();
	if(date<10){
		date = "0" + date;
	}
	return "" + d.getFullYear() + "-" + m + "-" + date;
}

com_unhurdle_log.GetLogFile = function(){
		var folder = Folder(com_unhurdle_log.LOG_PATH);
		if(!folder.exists){
			folder.create();
		}
		var LogFile = File(folder.absoluteURI +"/" + com_unhurdle_log.GetDateString() + " log.txt");
		if(!LogFile.exists){
			LogFile.open('w');
			LogFile.writeln('Job Log Created: ' + com_unhurdle_log.GetTime());
			LogFile.close();
		}
	return LogFile;
}

com_unhurdle_log.GetErrorLogFile = function(){
		var folder = Folder(com_unhurdle_log.ERROR_LOG_PATH);
		if(!folder.exists){
			folder.create();
		}
		var ErrorLogFile = File(folder.absoluteURI +"/" + com_unhurdle_log.GetDateString() + " log.txt");
		if(!ErrorLogFile.exists){
			ErrorLogFile.encoding = "UTF-8";
			ErrorLogFile.open('w');
			ErrorLogFile.write('<errors created="' + com_unhurdle_log.GetTime()+'"/>');
			ErrorLogFile.close();
		}
	return ErrorLogFile;
}
com_unhurdle_log.LogError = function(error,reason){
	if(com_unhurdle_log.LogLevel < 1){
		return;
	}
	try{
		var f = com_unhurdle_log.GetErrorLogFile();
		var xml = <error/>;
		xml.timeStamp = com_unhurdle_log.GetTime();
		//xml.jobID = gCurrentTicketName;
		xml.errorMsg = error;
		xml.reason = reason;
		//xml.instance = SERVER_CONFIG;
		var s = "" + error + " : " + com_unhurdle_log.GetTime();
		f.open('r');
		var errorXML = f.read();
		f.close();
		try{
			errorXML = XML(errorXML);
		}catch(err){
			f.rename(xml.timeStamp + f.name);
			ErrorLogFile = null;
			f = GetErrorLogFile();
			f.open('r');
			var errorXML = f.read();
			f.close();
			try{
				errorXML = XML(errorXML);
			}catch(err){
				return;
			}
		}
		errorXML.appendChild(xml);
		f.open('w');
	//	f.seek(f.length-9);
		f.write(errorXML);
		f.close();
	}catch(err){}
}
com_unhurdle_log.LogJob = function(entry){
	try{
		var f = com_unhurdle_log.GetLogFile();
		var s = "" + entry + ", processed: " + com_unhurdle_log.GetTime();
		f.open('e');
		f.seek(f.length);
		f.writeln(s);
		f.close();
	}catch(err){}
}

com_unhurdle_log.LogEntry = function(entry){
	if(com_unhurdle_log.LogLevel < 2){
		return;
	}
	try{
		var f = com_unhurdle_log.GetLogFile();
		var s = "" + entry + " " + com_unhurdle_log.GetTime();
		f.open('e');
		f.seek(f.length);
		f.writeln(s);
		f.close();
	}catch(err){}
}
