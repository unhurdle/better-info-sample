package com.unhurdle.utils
{	
	import stream.Stream;
	
	public class FolderZipper
	{
		public function FolderZipper(){}
		
		public static function zipFolder(folderToZip:File,destinationFolder:File):Promise{
			var JSZip:* = require("jszip");

			var zip:* = new JSZip();
			var name:String = folderToZip.name;
			recursiveAdd(folderToZip,zip,"");
			var promise:Promise = new Promise(function(resolve:*,reject:*):void{
				var zipFile:File = destinationFolder.resolvePath(folderToZip.name + ".zip");
				var zipStream:Stream  = zip["generateNodeStream"](
				{"type":'nodebuffer',"streamFiles":true})["pipe"](
				fs.createWriteStream(zipFile.nativePath));

				zipStream.on('finish', function ():* {
    				// JSZip generates a readable stream with a "end" event,
    				// but is piped here in a writable stream which emits a "finish" event.
   		 			console.log(zipFile.name + " written.");
						resolve(zipFile);
				});
				zipStream.on('error',function():void{
					console.log("zip error");
					reject("error");
				})
			});
			return promise;
		}
		private static function recursiveAdd(folder:File,zip:*,baseName:String,skipHidden:Boolean = true,exclude:RegExp=null):void{
			var i:int;
			var file:File;
			var childName:String;
			var files:Array = folder.getDirectoryListing();
			for(i=0;i<files.length;i++){
				file = files[i] as File;
				childName = baseName + file.name;
				if(exclude && childName.match(exclude)){
					continue;
				}
				if(skipHidden && file.isHidden){
					continue;
				}
				if(file.isDirectory){
					recursiveAdd(file,zip,childName + "/");
				} else {
					if(file.size < 1){
						continue;
					}
					zip.file(childName,fs.readFileSync(file.nativePath));
				}
			}
		}
	}
}