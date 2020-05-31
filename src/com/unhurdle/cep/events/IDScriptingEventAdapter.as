package com.unhurdle.cep.events
{
	import com.unhurdle.utils.ScriptInterface;

	public class IDScriptingEventAdapter
	{
		public function IDScriptingEventAdapter()
		{
		}
		public static function registerEvent(event:String):void{
			ScriptInterface.instance.registerEvent(event);

		}

	}
}