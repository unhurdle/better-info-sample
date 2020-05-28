package com.unhurdle.utils
{
	import org.apache.royale.net.URLRequest;
	import org.apache.royale.utils.BinaryData;
	import com.adobe.cep.CSInterface;
	import com.adobe.cep.SystemPath;	
	import fs.Stats;

	public class File
	{
		public function File(path:String = null)
		{
			if(path)
			{
				// we should probably validate the path using fs.
				_path = path;
			}
		}
		private var _path:String;
		private var _descriptor:int;
		public function get creationDate():Date{
			return fs.statSync(nativePath).ctime;
		}
		private var _data:BinaryData;

		public function get data():BinaryData
		{
			return _data;
		}
		public static function get desktopDirectory():File{
			return null;
		}
		public static function get documentsDirectory():File{
			return new File(CSInterface.getSystemPath(SystemPath.MY_DOCUMENTS));
		}
/**
					console.log(csInterface.getSystemPath(SystemPath.USER_DATA)); /Users/harbs/Library/Application Support
					console.log(csInterface.getSystemPath(SystemPath.COMMON_FILES)); /Library/Application Support
					console.log(csInterface.getSystemPath(SystemPath.MY_DOCUMENTS)); /Users/harbs/Documents

					console.log(csInterface.getSystemPath(SystemPath.APPLICATION)); /Library/Application Support/Adobe/CEP/extensions/com.undavide.flyout (deprecated)
					console.log(csInterface.getSystemPath(SystemPath.EXTENSION)); /Library/Application Support/Adobe/CEP/extensions/com.undavide.flyout
					console.log(csInterface.getSystemPath(SystemPath.HOST_APPLICATION)); /Applications/Adobe InDesign CC 2015/Adobe InDesign CC 2015.app/Contents/MacOS/Adobe InDesign CC 2015



 */		
		public var downloaded:Boolean;
		public function get exists():Boolean{
			if(!_path){
				return false;
			}
			return fs.existsSync(nativePath);

		}
		public function get extension():String{
			return _path ? path.extname(nativePath) : "";
		}
		public function get isDirectory():Boolean{
			if(!exists)
				return false;
			return fs.statSync(nativePath).isDirectory();
		}
		public function get isHidden():Boolean{
			return false;
		}
		public function get isPackage():Boolean{
			return false;
		}
		public function get isSymbolicLink():Boolean{
			return false;
		}
		public static function get lineEnding():String
		{
			return os.EOL;
		}
		public function get modificationDate():Date{
			return _path ? fs.statSync(nativePath).mtime : null;
		}

		public function get name():String
		{
			return _path ? path.basename(nativePath) : "";
		}

		public function get nativePath():String
		{
			return _path ? path.normalize(_path) : "";
		}
		public function set nativePath(value:String):void{
			_path = value;
		}

		public function get parent():File{
			return new File(path.dirname(nativePath));
		}
		public static function get separator():String{
			return path.sep;
		}
		public function get size():Number{
			if(!_path){
				return 0;
			}
			var stats:Stats = fs.statSync(nativePath);
			return stats["size"] ? stats["size"] : 0;
		}
		public function get spaceAvailable():Number{
			return 0;
		}
		public function get systemCharset():String{
			return "";
		}
		public function get type():String{
			//windows
			return this.extension;
		}
		public static function get userDirectory():File{
			return documentsDirectory.parent;
		}
		public static function get userData():File{
			return new File(CSInterface.getSystemPath(SystemPath.USER_DATA));
		}
		
		public function browse(typeFilter:Array = null):Boolean{
			return false;
		}
		public function browseForDirectory(title:String):void{

		}
		public function browseForOpen(title:String, typeFilter:Array = null):void{

		}
		public function browseForOpenMultiple(title:String, typeFilter:Array = null):void{

		}
		public function browseForSave(title:String):void{

		}
		public function cancel():void{

		}
		public function canonicalize():void{

		}
		public function clone():File{
			return new File(_path);
		}
		public function copyTo(newLocation:File, overwrite:Boolean = false):void{
			Logger.logMessage('copy to ' + JSON.stringify(newLocation));
			//include the fs, path modules
			var fss:* = require('fs');
			var path:* = require('path');

			if(!newLocation.exists){
				newLocation.createDirectory();
			}
			//gets file name and adds it to dir2
			var f:* = path.basename(nativePath);
			var source:* = fss.createReadStream(nativePath);
			var dest:* = fss.createWriteStream(path.resolve(newLocation.nativePath, f));

			source.pipe(dest);
			source.on('end', function ():void{
				console.log('Succesfully copied'); 
				Logger.logMessage('Succesfully copied');
			});
			source.on('error', function (err:*):void{
				Logger.logError("copy failed: " + JSON.stringify(err));
				console.log(err); 
			});
		}
		public function copyToAsync(newLocation:File, overwrite:Boolean = false):void{

		}
		public function createDirectory():void{
			createDirectoryStructure(nativePath);
		}
		private function createDirectoryStructure(dirPath:String):void{
			var parentPath:String = path.dirname(dirPath);
			if(!fs.existsSync(parentPath)){
				createDirectoryStructure(parentPath);
			}
			if(!fs.existsSync(dirPath)){
				fs.mkdirSync(dirPath);
			}

		}
		// public static function createTempDirectory():File{
		// 	cep.fs.
		// 	fs.mkdtempSync
		// 	var tmp:* = require('tmp');
		// 	var a = fs.openSync("","")
		// 	var fd
		// }
		// public static function createTempFile():File{
		// 	return null
		// }
		public function deleteDirectory(deleteDirectoryContents:Boolean = false):void{
			Logger.logMessage("deleting directory");
			try{
				deleteFolderRecursive(nativePath);
			}catch(err){
				Logger.logError("delete directory failed: " + JSON.stringify(err));
				console.log(err);
			}
		}
		private function deleteFolderRecursive(folderPath:String):void {
			if( fs.existsSync(folderPath) ) {
				var files:Array = fs.readdirSync(folderPath);
				for(var i:int=0;i<files.length;i++){
					var curPath:String = path.join(folderPath,files[i]);
					if(fs.lstatSync(curPath).isDirectory()) { // recurse
						deleteFolderRecursive(curPath);
					} else { // delete file
						fs.unlinkSync(curPath);
					}
				}
				fs.rmdirSync(folderPath);
			}
		}
		public function deleteDirectoryAsync(deleteDirectoryContents:Boolean = false):void{

		}
		public function deleteFile():void{
			fs.unlinkSync(nativePath);
		}
		public function deleteFileAsync():void{
			fs.unlink(nativePath);
		}
		public function download(request:URLRequest, defaultFileName:String = null):void{

		}
		public function getDirectoryListing():Array{
			var files:Array = fs.readdirSync(_path);
			var retVal:Array = [];
			for(var i:int=0;i<files.length;i++){
				retVal.push(resolvePath(files[i]));
			}
			return retVal;
		}
		public function getDirectoryListingAsync():void{

		}
		public function getRelativePath(ref:File, useDotDot:Boolean = false):String{
			return path.relative(_path,ref.nativePath);
		}
		public static function getRootDirectories():Array{
			return [];
		}
		public function load():void{

		}
		public function moveTo(newLocation:File, overwrite:Boolean = false):void{
			//include the fs, path modules
			Logger.logMessage("moving to " + JSON.stringify(newLocation));
			var fss:* = require('fs');
			var path:* = require('path');

			if(!newLocation.parent.exists){
				newLocation.parent.createDirectory();
			}
			//gets file name and adds it to dir2
			var dest:* = path.resolve(newLocation.nativePath);

			fss.rename(nativePath, dest, function (err:*):void
			{
				if(err){
					Logger.logError("move failed: " + JSON.stringify(err));
					throw err;
				} 
				else{
					Logger.logMessage('Successfully moved');
					console.log('Successfully moved');
				} 
			});
		}
		public function moveToAsync(newLocation:File, overwrite:Boolean = false):void{

		}
		public function moveToTrash():void{

		}
		public function moveToTrashAsync():void{

		}
		public function openWithDefaultApplication():void{

		}
		public function resolvePath(pathVal:String):File{
			return new File(path.resolve(_path,pathVal));
		}
		public function save(data:*, defaultFileName:String = null):void{

		}
		public function upload(request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Boolean = false):void{

		}
		public function uploadUnencoded(request:URLRequest):void{

		}
		
	}
}