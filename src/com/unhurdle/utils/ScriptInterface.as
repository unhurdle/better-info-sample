package com.unhurdle.utils
{
	import com.adobe.cep.CSInterface;
	import com.adobe.cep.SystemPath;
  public class ScriptInterface
	{

		private static var _instance:ScriptInterface;
		public static function get instance():ScriptInterface{return getInstance()}
		public static function getInstance():ScriptInterface {
			if (_instance == null){
				_instance = new ScriptInterface();
			}
			return _instance;
		}
		private function loadJSX():Promise {
			var extensionRoot:String = CSInterface.getSystemPath(SystemPath.EXTENSION) + "/jsx/";
			console.log(extensionRoot);
			return runScript('$._ext.evalFiles("' + extensionRoot + '")');
//			csInterface.evalScript('$._ext.evalFiles("' + extensionRoot + '")',getOS);
		}
		private function getOS():void{
			CSInterface.evalScript("com_unhurdle_utils.GetFileSystem()",
				function(result:*):void{
					_isMac  = result == "Macintosh";
				}
			);
		}
		public function runScript(script:String):Promise{
			Logger.logMessage("running script: " + script);
			var promise:Promise = new Promise(function(resolve:*,reject:*):void{
				CSInterface.evalScript(script,function(result:*):void{
					result = getResultVal(result,script);
					if(isError(result)){
						Logger.logError(JSON.stringify(result));
						reject(result);
					} else {
						resolve(result);
					}
				})
				
			});
			return promise;
		}
		private function getResultVal(str:String,scriptStr:String):*{
			if(str == "false"){
				return false;
			}
			if(str == "true"){
				return true;
			}
			if(str === ""){
				return "";
			}
			var num:Number = Number(str);
			if(!isNaN(num)){
				return num;
			}
			if(str.indexOf("[") == 0 || str.indexOf("{") == 0){
				var res:*;
				try{
					res = JSON.parse(str);
					return res;
				}catch(err){
				}
			}
			if(str =="EvalScript error."){
				var err:Error = new Error(str);
				err.name = "JSX Error";
				err.message = "Error parsing ExtendScript."
				err.description = scriptStr;
				console.log(scriptStr);
				return err;
			}
			return str;
		}
		private function isError(value:*):Boolean{
			if(!value){
				return false;
			}
			if(value.hasOwnProperty("message") && value.hasOwnProperty("name")){
				if(value.name.indexOf("Error") > -1){
					return true;
				}
			}
			return false;
		}
		private var _sysInfo:*;
		public function get sysInfo():SysInfo{
			return _sysInfo;
		}

		public function getSysInfo():Promise{
			return getSysInternal(0,null).then(function(result:*):*{
				console.log(result);
				_sysInfo = new SysInfo(result);
				return Promise.resolve(true);
			}) as Promise;
		}
		private function getSysInternal(wait:Number,resolveFunc:Function):Promise{
			var promise:Promise = new Promise(function(resolve:*,reject:*):void{
				var script:String = "com_unhurdle_utils.GetSysInfo()";
				setTimeout(function():*{
					CSInterface.evalScript(script,function(result:*):void{
						result = getResultVal(result,script);
						if(isError(result)){
							getSysInternal(500,resolve);
							Logger.logError(JSON.stringify(result));
							// reject(result);
						} else {
							resolve(result);
							if(resolveFunc){
								resolveFunc(result);
							}
						}
					})},
					wait
				);
				
			});
			return promise;

		}
		public function temp():Promise{
			return runScript("Folder.temp");
		}
		public function appData():Promise{
			return runScript("Folder.appData");
		}
		public function appPackage():Promise{
			return runScript("Folder.appPackage");
		}
		public function commonFiles():Promise{
			return runScript("Folder.commonFiles");
		}
		public function desktop():Promise{
			return runScript("Folder.desktop");
		}
		private function ScriptInterface()
		{
		}
		public function init():Promise{
			var promises:Array = [loadJSX(),getSysInfo()];
			return Promise.all(promises);
		}
		private var macChecked:Boolean = false;
		private var _isMac:Boolean;
		public function get isMac():Boolean{
			if(!macChecked){
				var platform:String = os.platform().toLowerCase();
				_isMac = platform.indexOf("darwin") >=0;
				macChecked = true;
			}
			return _isMac;
		}

		public function showLoggingDialog():Promise{
			var scriptStr:String = "com_unhurdle_utils.SetLogging()";
			return runScript(scriptStr);
		}
		
		// public function haveOpenDocument():Promise{
		// 	return runScript("com_unhurdle_utils.HaveOpenDocument()").then(function(result:*):*{
		// 		if(result){
		// 			return Promise.resolve(result);
		// 		} else {
		// 			return Promise.reject(result);
		// 		}
		// 	}) as Promise;
		// }
		
		public function alert(str:String):void{
			runScript("alert('" + str + "')");
		}
		public function beep():void{
			runScript("beep()");
		}
		public function confirm(message:String,noAsDefault:Boolean=false,title:*=undefined):Promise{
			var scrStr:String = "confirmJSX('" + message + "'," + noAsDefault + "," + title + ")";
			return runScript(scrStr);
			// csInterface.evalScript("confirm(" + message + "," + noAsDefault + "," + title + ")",function(result):void{
				//figure out how to get the results of a confirm
			// });
		}

		public function getFile(title:String,filter:String=""):Promise{
			return runScript("com_unhurdle_utils.GetFile('" + title + "','" + filter + "')");
		}
		//com_unhurdle_utils.GetFile(PanelStrings.SELECT_PRESET_FILE)

		public function getFolder(title:String,sourceFolder:String=""):Promise{
			return runScript("com_unhurdle_utils.GetFolder('" + title + "','" + sourceFolder + "')");
		}
		//com_unhurdle_utils.GetFolder(PanelStrings.SELECT_LOCATION)

		public function registerEvent(eventType:String):void{
			runScript("com_unhurdle_utils.RegisterEvent('" + eventType + "')");
		}
		// public function writeFile(path:String,contents:String):void{
		// 	runScript("com_unhurdle_utils.WriteFile('" + path + "','" + contents + "')");
		// }
		// public function writeln(str:String):void{
		// 	var script:String = "$.writeln('" + str + "')";
		// 	console.log(script);
		// 	runScript(script);
		// }

	}
}
