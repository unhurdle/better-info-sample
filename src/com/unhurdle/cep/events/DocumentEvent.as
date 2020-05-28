package com.unhurdle.cep.events
{
	public class DocumentEvent
	{
		public function DocumentEvent()
		{
		}
		public static const AFTER_CLOSE:String = "afterClose";
		public static const AFTER_NEW:String = "afterNew";
		public static const AFTER_OPEN:String = "afterOpen";
		public static const AFTER_REVERT:String = "afterRevert";
		public static const AFTER_SAVE:String = "afterSave";
		public static const AFTER_SAVE_AS:String = "afterSaveAs";
		public static const AFTER_SAVE_A_COPY:String = "afterSaveACopy";
		public static const BEFORE_CLOSE:String = "beforeClose";
		public static const BEFORE_NEW:String = "beforeNew";
		public static const BEFORE_OPEN:String = "beforeOpen";
		public static const BEFORE_REVERT:String = "beforeRevert";
		public static const BEFORE_SAVE:String = "beforeSave";
		public static const BEFORE_SAVE_AS:String = "beforeSaveAs";
		public static const BEFORE_SAVE_A_COPY:String = "beforeSaveACopy";
	}
}