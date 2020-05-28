package com.unhurdle.utils
{

	// COMPILE::SWF
	// {
	// 	import flash.filesystem.FileStream;
	// }
	// COMPILE::JS
	// {
		import com.unhurdle.utils.BufferUtils;
		import com.unhurdle.utils.FileMode;
		import org.apache.royale.events.EventDispatcher;
		import org.apache.royale.utils.BinaryData;
		import org.apache.royale.utils.IBinaryDataInput;
		import org.apache.royale.utils.IBinaryDataOutput;

	// }

	// COMPILE::SWF
	// public class FileStream extends flash.filesystem.FileStream
	// {
	// 	public function FileStream()
	// 	{
	// 		super();
	// 	}
	// }
	// COMPILE::JS
	public class FileStream extends EventDispatcher
	{
		public function FileStream()
		{
			_binary = new BinaryData();
		}

		private var _file:File;
		private var _fileMode:String;
		private var _binary:BinaryData;
		
		
		public function get bytesAvailable():uint{
			return _binary.bytesAvailable;
		}
		public function get endian():String{
			return _binary.endian;
		}
		public function set endian(value:String):void{
			_binary.endian = value;
		}
		public var objectEncoding:uint;
		public var position:int = 0;
		public var readAhead:Number;
		/**
        * @flexjsignorecoercion ArrayBuffer
		*/
		public function close():void{
			if(_fileMode == FileMode.READ || _fileMode == FileMode.APPEND){
				return;
			}
			var buff:Buffer = BufferUtils.bufferFromArray(_binary.data as ArrayBuffer);
			// console.log(buff);
			// console.log(_file);
			fs.writeFileSync(_file.nativePath,buff);
		}
		/**
        * @flexjsignorecoercion Buffer
		*/
		public function open(file:File, fileMode:String):void{
			_file = file;
			_fileMode = fileMode;
			if(fileMode == FileMode.READ){
				var buff:Buffer = fs.readFileSync(file.nativePath) as Buffer;
				_binary = new BinaryData(BufferUtils.ArrayFromBuffer(buff));
			} else {
				_binary = new BinaryData();
			}
		}
		private function appendFile(binary:BinaryData):void
		{
			var buff:Buffer = BufferUtils.bufferFromArray(binary.data as ArrayBuffer);
			fs.appendFileSync(_file.nativePath,buff);
		}
		public function openAsync(file:File, fileMode:String):void{
			
		}
		public function readBoolean():Boolean{
			return _binary.readBoolean();
		}
		public function readByte():int{
			return _binary.readByte();
		}
		public function readBytes(bytes:BinaryData, offset:uint = 0, length:uint = 0):void{
			_binary.readBinaryData(bytes,offset,length);
		}
		
		public function readDouble():Number{
			return _binary.readDouble();
		}
		public function readFloat():Number{
			return _binary.readFloat();
		}
		public function readInt():int{
			return _binary.readInt();
		}
//		public function readMultiByte(length:uint, charSet:String):String{
//			return _binary.readMultiByte(length,charSet);
//		}
//		public function readObject():*{
//			return _binary.readObject();
//		}
		public function readShort():int{
			return _binary.readShort();
		}
		public function readUnsignedByte():uint{
			return _binary.readUnsignedByte();
		}
		public function readUnsignedInt():uint{
			return _binary.readUnsignedInt();
		}
		public function readUnsignedShort():uint{
			return _binary.readUnsignedShort();
		}
		public function readUTF():String{
			return _binary.readUTF();
		}
		public function readUTFBytes(length:uint):String{
			return _binary.readUTFBytes(length);
		}
		
		
//		public function truncate():void{
//			_binary.truncate();
//		}
		public function writeBoolean(value:Boolean):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeBoolean(value);
				appendFile(bd);
			} else {
				_binary.writeBoolean(value);
			}
		}
		public function writeByte(value:int):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeByte(value);
				appendFile(bd);
			} else {
				_binary.writeByte(value);
			}
		}
		public function writeBytes(bytes:BinaryData, offset:uint = 0, length:uint = 0):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeBinaryData(bytes, offset, length);
				appendFile(bd);
			} else {
				_binary.writeBinaryData(bytes,offset,length);
			}
		}
		public function writeDouble(value:Number):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeDouble(value);
				appendFile(bd);
			} else {
				_binary.writeDouble(value);
			}
		}
		public function writeFloat(value:Number):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeFloat(value);
				appendFile(bd);
			} else {
				_binary.writeFloat(value);
			}
		}
		public function writeInt(value:int):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeInt(value);
				appendFile(bd);
			} else {
				_binary.writeInt(value);
			}
		}
//		public function writeMultiByte(value:String, charSet:String):void{
//			_binary.writeMultiByte(value,charSet);
//		}
//		public function writeObject(object:*):void{
//			_binary.writeObject(object);
//		}
		public function writeShort(value:int):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeShort(value);
				appendFile(bd);
			} else {
				_binary.writeShort(value);
			}
		}
		public function writeUnsignedInt(value:uint):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeUnsignedInt(value);
				appendFile(bd);
			} else {
				_binary.writeUnsignedInt(value);
			}
		}
		public function writeUTF(value:String):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeUTF(value);
				appendFile(bd);
			} else {
				_binary.writeUTF(value);
			}
		}
		public function writeUTFBytes(value:String):void{
			if(_fileMode == FileMode.APPEND){
				var bd:BinaryData = new BinaryData();
				bd.writeUTFBytes(value);
				appendFile(bd);
			} else {
				_binary.writeUTFBytes(value);
			}
		}
	}
}