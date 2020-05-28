package com.unhurdle.view.renderers
{
	import org.apache.flex.html.supportClasses.StringItemRenderer;
	import com.unhurdle.cep.ThemeManager;
	
	public class ListRenderer extends StringItemRenderer
	{
		public function ListRenderer()
		{
			super();
		}
		override public function updateRenderer():void
		{
			var elem:Element = element as Element;
		 
			elem.style.color = '';
			if(ThemeManager.instance.darkTheme){
				//elem.style.color = '#FFFFFF';
			} else {
				// elem.style.color = '#000000';
			}
			if (selected){
				elem.style.backgroundColor = '#9C9C9C';
				elem.style.color = '#FFFFFF';
			}
			else if (hovered){
				elem.style.backgroundColor = ThemeManager.instance.getBackgroundColor(20);
			} else {
				elem.style.backgroundColor = null;
			}
		}
	}
}