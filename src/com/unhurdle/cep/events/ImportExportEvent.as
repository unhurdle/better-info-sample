package com.unhurdle.cep.events
{
	public class ImportExportEvent
	{
		public function ImportExportEvent()
		{
		}
		public static const AFTER_EXPORT:String = "afterExport";
		public static const AFTER_IMPORT:String = "afterImport";
		public static const BEFORE_EXPORT:String = "beforeExport";
		public static const BEFORE_IMPORT:String = "beforeImport";
		public static const FAILED_EXPORT:String = "failedExport";
	}
}