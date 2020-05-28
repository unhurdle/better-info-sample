package com.unhurdle.utils
{
	
	import org.apache.royale.utils.BinaryData;
	import com.unhurdle.utils.Logger;
	import com.unhurdle.utils.ScriptInterface;

	public class FileUtils
	{
		private function FileUtils()
		{
		}
		private static function get scriptInterface():ScriptInterface{
			return ScriptInterface.getInstance();
		}
		public static var pluginDomain:String = "com.unhurdle";
		/**
		 * This needs to be set in the app!
		 */
		public static var pluginName:String = "Example";
		public static function getPluginDataFolder():File{
			var folder:File = File.userData.resolvePath(pluginDomain).resolvePath(pluginName);
			createFolder(folder.nativePath);
			return folder;
		}
		public static function addVolumeToFile(file:File):void{
			if(!file.exists && scriptInterface.isMac){
				file.nativePath = "/Volumes" + file.nativePath;
			}
		}
		
		public static function getDocumentsFolderPath():String{
			return File.documentsDirectory.nativePath;
		}
		public static function createFolder(filePath:String):Boolean{
			Logger.logMessage("creating folder");
			try{
				var f:File = new File(filePath);
			}catch(err:Error){
				Logger.logError("create folder failed: " + JSON.stringify(err));
				return false;
			}
			if(!f.exists){
				f.createDirectory();
			}
			return true;
		}
		
		private static function normalizeFilePath(filePath:String):String{
			//not sure if we need ot do anything...
			Logger.logMessage("before normalize: " + filePath);
			if(filePath.charAt(0) == "~"){
				filePath = scriptInterface.sysInfo.userFolder + filePath.substr(1);
			}
			if(filePath.indexOf("file:") == 0){
				filePath = filePath.substr(5);
			}
			if(filePath.indexOf("////") == 0){
				filePath = filePath.substr(3);
			}
			// Photoshop 2019 returns the volume name without "/Volume"
			// Illustrator returns it with "/Volume"
			if(filePath.indexOf("///") == 0){
				if(scriptInterface.isMac){
					filePath = filePath.substr(2);
					if(filePath.indexOf("/Volumes") != 0){
						filePath = "/Volumes" + filePath;
					}
				} else {
					filePath = filePath.substr(3);
					filePath = path.normalize(filePath);
				}
			}
			filePath = decodeURIComponent(filePath);
			Logger.logMessage("after normalize: " + filePath);
			return filePath;
		}
		
		/**
        * @royaleignorecoercion Promise
		*/
		public static function getFile(title:String,filter:Array = null):Promise{
			var filterStr:String = filter ? filter.join(";") : "";
			return scriptInterface.getFile(title,filterStr);
			// var res:Object = cep.fs["showOpenDialog"](false,false,title,null,filter);
			// if(!res){
			// 	return null;
			// }
			// if(!res.data){
			// 	return null;
			// }
			// if(!res.data[0]){
			// 	return null;
			// }
			// return new File(String(res.data[0]));

			// return scriptInterface.getFile(title).then(function(result:*):*{
			// 	if(result){
			// 		var fileName:String = normalizeFilePath(result);
			// 		var file:File = new File(fileName);
			// 		addVolumeToFile(file);
			// 		return file; 
			// 	}
			// 	return Promise.reject();
			// }) as Promise;

			// var file:File;
			// var fileName:String = scriptInterface.getFile(title);
			// if(fileName){
			// 	fileName = normalizeFilePath(fileName);
			// 	file = new File(fileName);
			// 	addVolumeToFile(file);
			// }
			// return file;
		}
		public static function getFileName(filePath:String):String{
			return path.basename(filePath);
		}
		public static function getFileFromPath(filePath:String):File{
			filePath = normalizeFilePath(filePath);
			return new File(filePath);
		}
		
		public static function getFolder(title:String):Promise{
			return scriptInterface.getFolder(title);
			// var res:Object = cep.fs["showOpenDialog"](false,true,title);
			// if(!res){
			// 	return null;
			// }
			// if(!res.data){
			// 	return null;
			// }
			// if(!res.data[0]){
			// 	return null;
			// }
			// return new File(String(res.data[0]));
		}
		public static function writeUTFFile(filePath:String,contents:String,append:Boolean=false):Boolean{
			Logger.logMessage("writing file: " + filePath);
			filePath = normalizeFilePath(filePath);
			var file:File = new File(filePath);
			if(file.exists){
//				trace("file exists");
			}
			try{
				if(!file.parent.exists){
					file.parent.createDirectory();
				}
				var mode:String = FileMode.WRITE;
				if(append){
					mode = FileMode.APPEND;
				}
				var fs:FileStream = new FileStream();
				fs.open(file,mode);
				fs.writeUTFBytes(contents);
				fs.close();
			}catch (err:Error){
				Logger.logError("write file failed: " + JSON.stringify(err));
				return false;
			}
			return true;
		}
		public static function writeBinFile(filePath:String,bytes:BinaryData):Boolean{
			filePath = normalizeFilePath(filePath);
			var file:File = new File(filePath);
			if(!file.parent.exists){
				file.parent.createDirectory();
			}
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(bytes);
			stream.close();
			return true;
		}
		public static function readUTFFile(filePath:String):String{
			filePath = normalizeFilePath(filePath);
			var file:File = new File(filePath);
			if(!file.exists){
				return "";
			}
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			var contents:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			return contents;
		}
		public static function readBinFile(filePath:String):BinaryData{
			var bytes:BinaryData;
			filePath = normalizeFilePath(filePath);
			var file:File = new File(filePath);
			if (!file.exists) {return bytes}
			bytes = new BinaryData();
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			stream.readBytes(bytes);
			stream.close();
			return bytes;
		}
		public static function readBase64(filePath:String):String{
				var buff:Buffer = fs.readFileSync(filePath) as Buffer;
				return buff.toString('base64');
		}
				
		public static function zipFolder(source:File,destFolder:File):Promise{
			Logger.logMessage("FileUtils.zipFolder()");
// console.log("FileUtils.zipFolder() 1");
// console.log(source);
// console.log(destFolder);
			if(!source){
				scriptInterface.alert("No Source");
				return Promise.reject("No Source Path");// {success:false,reason:"No Source Path"};
			}
			if(!destFolder){
				scriptInterface.alert("No Destination Folder");
				return Promise.reject("No Destination Folder");//{success:false,reason:"No Destination Folder"};
			}
			//var source:File = new File(normalizeFilePath(sourcePath));
			if( !source.exists){
				scriptInterface.alert("Source does not exist.");
				return Promise.reject("Source: " + source.nativePath + " does not exist.");// {success:false,reason:"Source: " + source.url + " does not exist."};
			}
			if( !source.isDirectory ){
				scriptInterface.alert("Source is not a directory.");
				return Promise.reject("Source: " + source.nativePath + " is not a directory.");// {success:false,reason:"Source: " + source.url + " is not a directory."};
			}
			//var dest:File = new File(normalizeFilePath(destFolder));
			if(!destFolder.exists){
				destFolder.createDirectory();
			}
			if( !destFolder.isDirectory ){
				scriptInterface.alert("Destination directory could not be found.");
				return Promise.reject("Destination directory: " + destFolder.nativePath + " could not be found.");// {success:false,reason:"Destination directory: " + destFolder.url + " could not be found."};
			}
// console.log("FileUtils.zipFolder() 2");
			Logger.logMessage("source: " + source.nativePath + ", destination: " + destFolder.nativePath);
			return FolderZipper.zipFolder(source,destFolder);
//			dest.openWithDefaultApplication();
			// trace(zipFile.url);
			// return {success:true,url:zipFile.url};
		}

	}
}