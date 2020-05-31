gIsMac = File.fs == "Macintosh";
kAppVersion = parseFloat(app.version);

if(typeof(com_unhurdle_utils)=='undefined'){
	com_unhurdle_utils = {};
}

com_unhurdle_utils.GetFileSystem = function(){
	return File.fs;
}
com_unhurdle_utils.GetNativePath = function(uri){
	
	try{
		var file = com_unhurdle_utils.NewFile(uri);
		if(gIsMac){return file.absoluteURI}
		return file.fsName;
	}catch(err){
		return "";
	}
}
com_unhurdle_utils.GetFile = function(title,filter) {
	var fileName = "";
	if(filter){
		// Not sure if we need to do something
	} else {
		filter = null;
	}
	var file = File.openDialog(title,filter);
	if(file){
		return com_unhurdle_utils.NewFile(file).fsName;
		// if(gIsMac){
		// 	fileName = file.absoluteURI;
		// } else {
		// 	fileName = file.fsName;
		// }
	}
	return fileName;
}
com_unhurdle_utils.GetFolder = function(title,sourceFolder){
	if(sourceFolder){
		try{
			var folder = Folder(sourceFolder).selectDlg(title);
		}catch(err){sourceFolder = ""}
	}
	if(!sourceFolder){
		var folderName = "";
		var folder = Folder.selectDialog(title);
	}
	if(folder){
		return com_unhurdle_utils.NewFolder(folder).fsName;
		// if(gIsMac){
		// 	folderName = folder.absoluteURI;
		// } else {
		// 	folderName = folder.fsName;
		// }
	}
	return folderName;
}
com_unhurdle_utils.GetSaveFile = function(title){
	var fileName = "";
	var file = File.saveDialog(title);
	if(file){
		if(gIsMac){
			fileName = file.absoluteURI;
		} else {
			fileName = file.fsName;
		}
	}
	return fileName;

}
com_unhurdle_utils.GetPluginDataFolder = function(endPath){
	var userData = Folder.userData;
	userData = com_unhurdle_utils.NewFolder(userData);
	return userData + "/" + endPath;
}


com_unhurdle_utils.GetTempFolder = function(){
	var temp = Folder.temp;
	temp = com_unhurdle_utils.NewFolder(temp);
	if(gIsMac){
		return temp.absoluteURI;
	} else {
		return temp.fsName;
	}
}



///////////////////////////////////////////////////




com_unhurdle_utils.NewFile = function(inPath){
  var file;
  try{
    do{
      if (inPath instanceof File){
        var path = inPath.absoluteURI;
      } else if (inPath instanceof Folder){
        var path = inPath.absoluteURI;
      } else {
        var path = inPath;
      }
      file = new File(path);
      if (File.fs != "Macintosh"){
        break;
      }
      var filePath = file.fsName;
      if (filePath == path){ // File path wasn't changed by Extendscript
        break;
      }
      if (filePath.match(/^\/Volumes\//i) == null){ // File path isn't a Volumes path
        break;
      }
      var rootVolumeName = File("/").parent.displayName;
      var rootName = com_unhurdle_utils.GetRootName(file);
      if(rootName && rootName != rootVolumeName){
      	break;
      }
      filePath = filePath.replace(/^\/Volumes\//,"/" + rootVolumeName + "/");
      file = new File(filePath);
    }
    while (false);
  } catch (err){
    file = null;
  }
  return file;
}
 
com_unhurdle_utils.NewFolder = function(inPath){
  var folder;
  try{
    do{
      if (inPath instanceof File){
        var path = inPath.absoluteURI;
      } else if (inPath instanceof Folder){
        var path = inPath.absoluteURI;
      } else {
        var path = inPath;
      }
      folder = new Folder(path);
      if (File.fs != "Macintosh"){
        break;
      }
      var folderPath = folder.fsName;
      if (folderPath == path){ // Folder path wasn't changed by Extendscript
        break;
      }
      if (path.charAt(0) == "~"){
        path = File("~").fsName + path.substr(1);
      }
      if (path.charAt(0) != "/"){ // Not an absolute path
        break;
      }     
      var rootVolumeName = File("/").parent.displayName;
      var rootName = com_unhurdle_utils.GetRootName(folder);
      if(rootName && rootName != rootVolumeName){
      	break;
      }
      folder = new Folder("/Volumes/" + rootVolumeName + path);
    }
    while (false);
  }
  catch (err){
    folder = null;
  }
  return folder;
}
com_unhurdle_utils.GetRootName = function(folder){
	var rootName = folder.name;
	while(folder){
		if(folder.name != "Volumes" && folder.name){
			rootName = folder.name;
		}
		folder = folder.parent;
	}
	if(rootName == "Users"){
		rootName = "";
	}
	return rootName;
}
com_unhurdle_utils.NormalizeFilePath = function(file){
	if(File.fs != "Macintosh"){return file}
	return File(file.fsName.replace(/^\/Volumes/,"/" + File("///").parent.displayName));
}
com_unhurdle_utils.RemoveVolumePath = function(path){
	if(File.fs != "Macintosh"){
		return path;
	}
	path = unescape(path);
	var root = File("/").parent.displayName;
	root = "^/" + root;
	path=path.replace(new RegExp(root),"");
	return path
}

com_unhurdle_utils.ToHex = function(d) {
    var r = d % 16;
    var result;
    if (d-r == 0) 
        result = com_unhurdle_utils.toChar(r);
    else 
        result = com_unhurdle_utils.ToHex( (d-r)/16 ) + com_unhurdle_utils.toChar(r);
    return result;
}
com_unhurdle_utils.toChar = function(n) {
    const alpha = "0123456789abcdef";
    return alpha.charAt(n);
};
com_unhurdle_utils.getSysInfo = function(){
	var info = {
		appData : com_unhurdle_utils.NewFolder(Folder.appData).fsName,
		appPackage : com_unhurdle_utils.NewFolder(Folder.appPackage).fsName,
		commonFiles : com_unhurdle_utils.NewFolder(Folder.commonFiles).fsName,
		current : com_unhurdle_utils.NewFolder(Folder.current).fsName,
		desktop : com_unhurdle_utils.NewFolder(Folder.desktop).fsName,
		fs : Folder.fs,
		myDocuments : com_unhurdle_utils.NewFolder(Folder.myDocuments).fsName,
		startup : com_unhurdle_utils.NewFolder(Folder.startup).fsName,
		system : com_unhurdle_utils.NewFolder(Folder.system).fsName,
		temp : com_unhurdle_utils.NewFolder(Folder.temp).fsName,
		trash : com_unhurdle_utils.NewFolder(Folder.trash).fsName,
		userData : com_unhurdle_utils.NewFolder(Folder.userData).fsName,
		os : $.os,
		engineVersion : $.version,
		engineName : $.engineName,
		locale : $.locale,
		userFolder : com_unhurdle_utils.NewFolder(File("~")).fsName,
		pluginsFolder : com_unhurdle_utils.getPlugInsFolder(),
		scriptsFolder : com_unhurdle_utils.getScriptFolder()
	};
	return JSON.stringify(info);
}
com_unhurdle_utils.haveOpenDocument = function(){
	return app.documents.length > 0 ? "true" : "false";
}
com_unhurdle_utils.getPlugInsFolder = function(){
	var pluginsFolder = null;
	do{
	//
	// On Mac this is a folder inside the app package
	//
		var appFolder = Folder.startup;
		if (! appFolder.exists){break;}
        if(appFolder.name == "MacOS"){appFolder = appFolder.parent;}
		pluginsFolder = Folder(appFolder + "/Plug-Ins");
		while (appFolder.exists && ! pluginsFolder.exists){
			appFolder = appFolder.parent;
			pluginsFolder = Folder(appFolder + "/Plug-Ins");
		}
		if (! pluginsFolder.exists){
			pluginsFolder = null;
			break;
		}
	}
	while (false);
	if(pluginsFolder){
		return pluginsFolder.fsName;
	}
	return "";
}
com_unhurdle_utils.getScriptFolder = function(){
	var scriptsFolder = null;
	do{
	//
	// On Mac this is a folder inside the app package
	//
		var appFolder = Folder.startup;
		if (! appFolder.exists){break;}
        if(appFolder.name == "MacOS"){appFolder = appFolder.parent;}
		scriptsFolder = Folder(appFolder + "/Scripts");
		while (appFolder.exists && ! scriptsFolder.exists){
			appFolder = appFolder.parent;
			scriptsFolder = Folder(appFolder + "/Scripts");
		}
		if (! scriptsFolder.exists){
			scriptsFolder = null;
			break;
		}
	}
	while (false);
	if(scriptsFolder){
		return scriptsFolder.fsName;
	}
	return "";
}
com_unhurdle_utils.RegisterEvent = function(event){
	
	var eventType = event.substr(event.lastIndexOf(".")+1);
	var checkEvent = '#targetengine "com.unhurdle";\n' +
		'this["com.unhurdle.event.' + eventType + '"]';
	var eventLoaded = app.doScript(checkEvent);
	if(eventLoaded){
		return "";
	}

	var scriptStr = '#targetengine "com.unhurdle";\n' +
		'app.addEventListener("' + eventType + '",dispatchChange);\n' +
		'function dispatchChange(){\n' +
		'new ExternalObject( "lib:PlugPlugExternalObject");\n' +
		'var eventObj = new CSXSEvent();\n' +
		'eventObj.type = "' + event + '";\n' +
		'eventObj.dispatch();\n' +
		'}\n' +
		'this["com.unhurdle.event.' + eventType +'"] = true;';
	app.doScript(scriptStr);

	return "";


}