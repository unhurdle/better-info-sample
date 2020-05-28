package com.unhurdle.cep
{
	import com.adobe.cep.AppSkinInfo;
	import com.adobe.cep.CepColor;
	import com.adobe.cep.UIColor;
	import com.adobe.cep.CSInterface;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.Event;


	public class ThemeManager extends EventDispatcher
	{
        /**
         * FalconJX will inject html into the index.html file.  Surround with
         * "inject_html" tag as follows:
         *
         * <inject_html>
		 * <!-- Will contain Topcoat original CSS href -->
		 * <link id="topcoat" rel="stylesheet"/>
		 * <!-- Topcoat overrides (Font, etc) -->
		 * <link id="topcoat-host" rel="stylesheet" href="../css/topcoat-host.css"/>
		 * <!-- Actual Panel styling -->
		 * <link rel="stylesheet" href="../css/styles.css"/>
		 * <script type="text/javascript" src="../js/jquery-2.0.2.min.js"></script>
         * </inject_html>
         */
		public function ThemeManager(en:SingletonEnforcer)
		{
		}
		private static var _instance:ThemeManager;
		public static function get instance():ThemeManager{return getInstance()}
		public static function getInstance():ThemeManager {
			if (_instance == null){
				_instance = new ThemeManager(new SingletonEnforcer);
			}
			return _instance;
		}

		public static const THEME_CHANGED:String = "THEME_CHANGED";

		public var backgroundColor:String;
		public var darkTheme:Boolean;
		public function getBackgroundColor(delta:Number):String{
			return "#" + toHex(appSkinInfo.panelBackgroundColor.color as CepColor,delta);
		}
		
		// Convert the Color object to string in hexadecimal format; 
		private function toHex(color:CepColor, delta:Number=NaN):String {
			
			function computeValue(value:Number, delta:Number):String {
				var computedValue:Number = !isNaN(delta) ? value + delta : value;
				if (computedValue < 0) {
					computedValue = 0;
				} else if (computedValue > 255) {
					computedValue = 255;
				}
				
				computedValue = Math.floor(computedValue);
				
				var computedStr:String = computedValue.toString(16);
				return computedStr.length === 1 ? "0" + computedValue : computedStr;
			}
			
			var hex:String = "";
			if (color) {
				hex = computeValue(color.red, delta) + computeValue(color.green, delta) + computeValue(color.blue, delta);
			}
			return hex;
		}
		
		// Add a rule in a stylesheet
		public function addRule(stylesheetId:String, selector:String, rule:String):void {
			var stylesheet:* = document.getElementById(stylesheetId);
			if (stylesheet) {
				stylesheet = stylesheet.sheet;
				if (stylesheet.addRule) {
					stylesheet.addRule(selector, rule);
					console.log("addRule: " + selector + ' { ' + rule + ' }');
				} else if (stylesheet.insertRule) {
					stylesheet.insertRule(selector + ' { ' + rule + ' }', stylesheet.cssRules.length);
					console.log("insertRule: " + selector + ' { ' + rule + ' }');
				}
			}
		}
		private var appSkinInfo:AppSkinInfo;
		// Update the theme with the appropriate Topcoat CSS using appSkinInfo
		// to determine which one to load - then overrides some Topcoat properties
		public function updateThemeWithAppSkinInfo():void {
			appSkinInfo = new AppSkinInfo(CSInterface.hostEnvironment.appSkinInfo);
			// console.log(appSkinInfo);
			
			var themeShade:String = "";
			var redShade:Number = appSkinInfo.panelBackgroundColor.color.red;
			backgroundColor = "#" + toHex(appSkinInfo.panelBackgroundColor.color as CepColor)
			
			if (redShade > 200) { // exact: 214 (#D6D6D6)
				themeShade = "lightlight"; // might be useful in the future
				// this is where font color and other theme dependent stuff could go
				$("#topcoat").attr("href", "../css/topcoat-desktop-lightlight.min.css");
				
			} else if (redShade > 180) { // exact: 184 (#B8B8B8)
				themeShade = "light";
				$("#topcoat").attr("href", "../css/topcoat-desktop-light.min.css");
				
			} else if (redShade > 80) { // exact: 83 (#535353)
				themeShade = "dark";
				$("#topcoat").attr("href", "../css/topcoat-desktop-dark.min.css");
				
			} else if (redShade > 50) { // exact: 52 (#343434)
				themeShade = "darkdark";
				$("#topcoat").attr("href", "../css/topcoat-desktop-darkdark.min.css");
			}
			darkTheme = themeShade.indexOf("light") < 0;
			
			// Override Topcoat CSS with Font settings (family, size and color)
			// original idea by David Deraedt
			// Here I use an empty CSS file
			var styleId:String = "topcoat-host";
			var fontColor:String = darkTheme ? "#E6E6E6" : "#202020";
			
			addRule(styleId, "body", "font-family:" + appSkinInfo.baseFontFamily );
			addRule(styleId, "body", "font-size:" + appSkinInfo.baseFontSize + "px");
			addRule(styleId, "body", "color:" + fontColor);
			dispatchEvent(new Event(THEME_CHANGED));
		}
		public function addRuleOverride(selector:String, rule:String):void {
			addRule("topcoat-host",selector,rule);
		}
		
		// Callback for the CSInterface.THEME_COLOR_CHANGED_EVENT
		public function onAppThemeColorChanged(event:Event):void {
//			var skinInfo = JSON.parse(window.__adobe_cep__.getHostEnvironment()).appSkinInfo;
			updateThemeWithAppSkinInfo();
		}
		public function init():void {
			
			
			// Update the theme
			updateThemeWithAppSkinInfo();
			
			// Set the Event Listener for future theme changes
			CSInterface.addEventListener(CSInterface.THEME_COLOR_CHANGED_EVENT, onAppThemeColorChanged);
		}		
	}
}
class SingletonEnforcer{
}