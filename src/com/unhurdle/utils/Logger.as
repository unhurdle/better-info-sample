package com.unhurdle.utils
{
	public class Logger
	{
		public static const LOG_LEVEL_0:int = 0;
		public static const LOG_LEVEL_ERROR:int = 1;
		public static const LOG_LEVEL_MESSAGE:int = 2;
		private static var logLevel:int = 0;
		public static function setLevel(level:int):void{
			logLevel = level;
		}
		public function Logger()
		{
		}
		public static function logError(error:String):void{
			if(logLevel > 0){
				var message:String = "error: " + error;
				log(message);
			}
		}
		public static function logMessage(message:String):void{
			if(logLevel > LOG_LEVEL_ERROR){
				message = "message: " + message;
				log(message);
			}
		}
		private static function log(message:String):void{
			try{
				message += "\n";
				// 	var filePath:String = FileUtils.getPluginDataFolder().nativePath + "/log.txt";
				// 	FileUtils.writeUTFFile(filePath,message,true);
				var logDir:File = File.documentsDirectory.resolvePath("BetterInfo").resolvePath("Logs");
				logDir.createDirectory();
				var fileName:String = getDateString() + " log.txt";
				var file:File = logDir.resolvePath(fileName);
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.APPEND);
				fs.writeUTFBytes(message);
				fs.close();
			}catch (err:Error){
				console.log(err);
			}
		}
		private static function getDateString():String{
			var d:Date = new Date();
			var m:Number = d.getMonth()+1;
			var ms:String = "" + m;
			if(m<10){
				ms = "0" + m;
			}
			var date:Number = d.getDate();
			var ds:String = "" + date;
			if(date<10){
				ds = "0" + date;
			}
			return "" + d.getFullYear() + "-" + ms + "-" + ds;
		}
	}
}