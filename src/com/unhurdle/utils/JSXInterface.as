package com.unhurdle.utils
{
	import com.adobe.cep.CSInterface;
	import com.adobe.cep.SystemPath;


	public class JSXInterface
	{
		/**
		*
		* <inject_html>
   		* <script src="../libs/CSInterface.js"></script>
    	* <script src="../libs/jquery-2.0.2.min.js"></script>
        * </inject_html>
		*/

		private static var _instance:JSXInterface;
		public static function get instance():JSXInterface{return getInstance()}
		public static function getInstance():JSXInterface {
			if (_instance == null){
				_instance = new JSXInterface();
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
			var promise:Promise = new Promise(function(resolve:*,reject:*):void{
				CSInterface.evalScript(script,function(result:*):void{
					result = getResultVal(result,script);
					if(isError(result)){
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
		/**
        * @flexjsignorecoercion Promise
		*/
		public function getSysInfo():Promise{
			return runScript("com_unhurdle_utils.getSysInfo()").then(function(result:*):*{
				console.log(result);
				_sysInfo = new SysInfo(result);
				return Promise.resolve(true);
			}) as Promise;
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
		


		private function JSXInterface()
		{
		}
		public function init():Promise{
			return loadJSX();
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
		public function getAltText():Promise{
			return runScript("com_unhurdle_info.getAltText()");
		}
		public function setAltText(text:String):Promise{
			return runScript("com_unhurdle_info.setAltText('" + text +"')");
		}
		public function getLabel():Promise{
			return runScript("com_unhurdle_info.getLabel()");
		}
		public function setLabel(label:String,content:String):void{
			runScript("com_unhurdle_info.setLabel('" + label + "','" + content + "')");
		}
		public function getParaStyle():Promise{
			return runScript("com_unhurdle_info.getParaStyle()");
		}
		public function getCharStyle():Promise{
			return runScript("com_unhurdle_info.getCharStyle()");
		}
		public function getImageScaleX():Promise{
			return runScript("com_unhurdle_info.getImageScaleX()");
		}
		public function getImageScaleY():Promise{
			return runScript("com_unhurdle_info.getImageScaleY()");
		}
		public function getAbsoluteImageScaleX():Promise{
			return runScript("com_unhurdle_info.getAbsoluteImageScaleX()");
		}
		public function getAbsoluteImageScaleY():Promise{
			return runScript("com_unhurdle_info.getAbsoluteImageScaleY()");
		}
		public function getEffectivePpi():Promise{
			return runScript("com_unhurdle_info.getEffectivePpi()");
		}
		public function getFileName():Promise{
			return runScript("com_unhurdle_info.getFileName()");
		}
		public function getNumItems():Promise{
			return runScript("com_unhurdle_info.getNumItems()");
		}
		public function getSelectionType():Promise{
			return runScript("com_unhurdle_info.getSelectionType()");
		}
		public function removeAllPageLabels(key:String):void{
			runScript("com_unhurdle_info.removeAllPageLabels('" + key + "')");
		}
		/**
        * @flexjsignorecoercion Promise
		*/
		public function haveOpenDocument():Promise{
			return runScript("com_unhurdle_utils.haveOpenDocument()").then(function(result:*):*{
				if(result){
					return Promise.resolve(result);
				} else {
					return Promise.reject(result);
				}
			}) as Promise;
		}
		public function documentOptionsSaved():Promise{
			return this.haveOpenDocument().
			then(function(result:*):*{
				return runScript('app.documents[0].extractLabel("com.unhurdle.docOptions.aiEnabled")');
			}).
			then(function(result:*):*{
				if(result == ""){
					return Promise.reject(result);
				} else {
					return Promise.resolve(result);
				}
			});
			// var doc:Document = app.activeDocument;
			// if(!doc){return false}
			// var val:String = doc.extractLabel("com.unhurdle.docOptions.aiEnabled");
			// return val != "";
		}
		
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



		public function setLogLevel(value:int):Promise{
			return runScript("com_unhurdle_log.LogLevel = " + value);
		}
		//com_unhurdle_log.LogLevel = 0;

		public function getLogLevel():Promise{
			return runScript("com_unhurdle_log.LogLevel");
		}



		public function showLoggingDialog():Promise{
			var scriptStr:String = "com_unhurdle_dialogs.SetLogging()";
			return runScript(scriptStr);
		}
	}
}
