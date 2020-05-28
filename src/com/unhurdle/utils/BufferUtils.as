package com.unhurdle.utils
{
	public class BufferUtils
	{
		public function BufferUtils()
		{
		}
		public static function ArrayFromBuffer(buff:Buffer):ArrayBuffer{
			return new Uint8Array(buff).buffer;
		}
		public static function bufferFromArray(arr:ArrayBuffer):Buffer{
			var arrView:Uint8Array = new Uint8Array(arr);
			var len:int = arrView.length;
			var buff:Buffer = new Buffer(len);
			for(var i:int=0;i<len;i++){
				buff[i] = arrView[i];
			}
			return buff;
		}
	}
}