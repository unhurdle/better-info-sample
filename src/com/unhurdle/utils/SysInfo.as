package com.unhurdle.utils
{
	public class SysInfo
	{
		public function SysInfo(info:Object)
		{
			this.appData = info["appData"];
			this.appPackage = info["appPackage"];
			this.commonFiles = info["commonFiles"];
			this.current = info["current"];
			this.desktop = info["desktop"];
			this.fs = info["fs"];
			this.myDocuments = info["myDocuments"];
			this.startup = info["startup"];
			this.system = info["system"];
			this.temp = info["temp"];
			this.trash = info["trash"];
			this.userData = info["userData"];
			this.os = info["os"];
			this.engineVersion = info["engineVersion"];
			this.engineName = info["engineName"];
			this.locale = info["locale"];
			this.userFolder = info["userFolder"];
			this.pluginsFolder = info["pluginsFolder"];
			this.scriptsFolder = info["scriptsFolder"];
		}
		public var appData:String;
		public var appPackage:String;
		public var commonFiles:String;
		public var current:String;
		public var desktop:String;
		public var fs:String;
		public var myDocuments:String;
		public var startup:String;
		public var system:String;
		public var temp:String;
		public var trash:String;
		public var userData:String;
		public var os:String;
		public var engineVersion:String;
		public var engineName:String;
		public var locale:String;
		public var userFolder:String;
		public var pluginsFolder:String;
		public var scriptsFolder:String;
	}
}