package com.unhurdle.cep.events
{
	import com.unhurdle.utils.File;
	import com.unhurdle.utils.FileUtils;
	import com.unhurdle.utils.ScriptInterface;

	public class IDScriptingEventAdapter
	{
		public function IDScriptingEventAdapter()
		{
		}
		public static function registerEvent(event:String):void{
			var eventType:String = event.substr(event.lastIndexOf(".")+1);
			var scriptFolder:File = new File(ScriptInterface.instance.sysInfo.scriptsFolder).resolvePath("UnHurdle").resolvePath("startup scripts");
			scriptFolder.createDirectory();
			var scriptFile:File = scriptFolder.resolvePath(eventType +".jsx");
			if(!scriptFile.exists){
				var scriptStr:String = '#targetengine "com.unhurdle";\n' +
				'app.addEventListener("' + eventType + '",dispatchChange);\n' +
				'function dispatchChange(){\n' +
				'new ExternalObject( "lib:PlugPlugExternalObject");\n' +
				'var eventObj = new CSXSEvent();\n' +
				'eventObj.type = "' + event + '";\n' +
				'eventObj.dispatch();\n' +
				'}';
				ScriptInterface.instance.runScript(scriptStr);
				FileUtils.writeUTFFile(scriptFile.nativePath,scriptStr);
			}
		}

	}
}