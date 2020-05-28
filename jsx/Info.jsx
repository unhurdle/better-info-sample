com_unhurdle_info = {};

com_unhurdle_info.getAltText = function(){
	try{
		var text = "";
		var sel = app.selection;
		if(!sel){return text}
		for(var i=0;i<sel.length;i++){
			var obj = sel[i];
			if(com_unhurdle_info.isText(obj)){
				continue;
			}
			if(obj.graphics.length == 0){
				continue;
			}
			try{
				text = obj.objectExportOptions.altText();
				if(text){
					return text;
				}
			}catch(err){
				return JSON.stringify(err);
			}
		}
		return text;
	}catch(err){
		return "";
	}

}
com_unhurdle_info.setAltText = function(text){
	try{
		var label = "";
		var sel = app.selection;
		if(!sel){return}
		sel[0].objectExportOptions.properties = {
			altTextSourceType: SourceType.SOURCE_CUSTOM,
			customAltText: text
		};
	}catch(err){
		return JSON.stringify(err);
	}	
}
com_unhurdle_info.getLabel = function(){
	try{
		var label = "";
		var sel = app.selection;
		if(!sel){return label}
		for(var i=0;i<sel.length;i++){
			var obj = sel[i];
			if(com_unhurdle_info.isText(obj)){
				obj = obj.parentTextFrames[0];
				if(!obj){
					continue;
				}
			}
			var extract = obj.label;
			if(label && label != extract){
				return "";
			}
			label = extract;
		}
		return label;
	}catch(err){
		return JSON.stringify(err);
	}

}
com_unhurdle_info.hasShape = function(obj){
	if(obj instanceof Group){
		var objs = obj.allPageItems;
		for(var i = 0;i<objs.length;i++){
			if(com_unhurdle_info.hasShape(objs[i])){
				return true;
			}
		}
		return false;
	}
	try{
		return obj instanceof Rectangle ||
			obj instanceof Oval ||
			obj instanceof Polygon;
	}catch(err){}
	return false;
}
com_unhurdle_info.hasGraphic = function(obj){
	if(obj instanceof Group){
		var objs = obj.allPageItems;
		for(var i = 0;i<objs.length;i++){
			if(com_unhurdle_info.hasGraphic(objs[i])){
				return true;
			}
		}
		return false;
	}
	try{
		return obj.graphics.length > 0;
	}catch(err){}
	return false;
}
com_unhurdle_info.hasText = function(obj){
	switch (obj.constructor.name){
		case "Character":
		case "InsertionPoint":
		case "Word":
		case "Text":
		case "Paragraph":
		case "TextColumn":
		case "Story":
		case "TextStyleRange":
		case "TextFrame":
			return true;
		default:
			return false;
	}
}
com_unhurdle_info.isText = function(obj){
	switch (obj.constructor.name){
		case "Character":
		case "InsertionPoint":
		case "Word":
		case "Text":
		case "Paragraph":
		case "TextColumn":
		case "Story":
		case "TextStyleRange":
			return true;
		default:
			return false;
	}
}
com_unhurdle_info.textIsSelected = function(){
	var selection = app.selection;
	if(!selection){return false}
	if(selection.length==0){return false}
	for(var i=0;i<selection.length;i++){
		if(com_unhurdle_info.hasText(selection[i])){
			return true;
		}
	}
	return false;
}
com_unhurdle_info.imageIsSelected = function(){
	var selection = app.selection;
	if(!selection){return false}
	if(selection.length==0){return false}
	for(var i=0;i<selection.length;i++){
		if(com_unhurdle_info.hasGraphic(selection[i])){
			return true;
		}
	}
	return false;
}
com_unhurdle_info.shapeIsSelected = function(){
	var selection = app.selection;
	if(!selection){return false}
	if(selection.length==0){return false}
	for(var i=0;i<selection.length;i++){
		if(com_unhurdle_info.hasShape(selection[i])){
			return true;
		}
	}
	return false;
}
com_unhurdle_info.removeAllPageLabels = function(key){
	var doc = app.documents[0];
	if(!doc){return}
	if(doc.layoutWindows.length == 0){return}
	var spread = doc.layoutWindows.item(0).activeSpread;
	if(!spread){return}
	var objs = spread.allPageItems;
	for(var i=0;i<objs.length;i++){
		try{
			objs[i].insertLabel(key,"");
		}catch(err){}
	}
}
com_unhurdle_info.getSelectionType = function(){
	if(com_unhurdle_info.textIsSelected()){
		return "text";
	}
	if(com_unhurdle_info.imageIsSelected()){
		return "image";
	}
	if(com_unhurdle_info.shapeIsSelected()){
		return "shape";
	}
	return "none";
}
com_unhurdle_info.getCharStyle = function(){
	try{
		var selection = app.selection;
		if(!selection){return ""}
		if(selection.length==0){return ""}
		var style = selection[0].appliedCharacterStyle;
		return style.name;
	}catch(err){
		return "";
	}
}
com_unhurdle_info.getParaStyle = function(){
	try{
		var selection = app.selection;
		if(!selection){return ""}
		if(selection.length==0){return ""}
		var style = selection[0].appliedParagraphStyle;
		return style.name;
	}catch(err){
		return "";
	}
}
com_unhurdle_info.getImageScaleX = function(){
	try{
		var selection = app.selection;
		if(!selection){return ""}
		if(selection.length==0){return ""}
		if(com_unhurdle_info.imageIsSelected(selection[0])){
			return "" + selection[0].images[0].horizontalScale + "%";
		}
	}catch(err){
		return "";
	}
}
com_unhurdle_info.getImageScaleY = function(){
	try{
		var selection = app.selection;
		if(!selection){return ""}
		if(selection.length==0){return ""}
		if(com_unhurdle_info.imageIsSelected(selection[0])){
			return "" + selection[0].images[0].verticalScale + "%";
		}
	}catch(err){
		return "";
	}
}

com_unhurdle_info.getAbsoluteImageScaleX = function(){
	try{
		var selection = app.selection;
		if(!selection){return ""}
		if(selection.length==0){return ""}
		if(com_unhurdle_info.imageIsSelected(selection[0])){
			return "" + selection[0].images[0].absoluteHorizontalScale + "%";
		}
	}catch(err){
		return "";
	}
}
com_unhurdle_info.getAbsoluteImageScaleY = function(){
	try{
		var selection = app.selection;
		if(!selection){return ""}
		if(selection.length==0){return ""}
		if(com_unhurdle_info.imageIsSelected(selection[0])){
			return "" + selection[0].images[0].absoluteVerticalScale + "%";
		}
	}catch(err){
		return "";
	}
}
com_unhurdle_info.getEffectivePpi = function(){
	try{
		var selection = app.selection;
		if(!selection){return ""}
		if(selection.length==0){return ""}
		if(com_unhurdle_info.imageIsSelected(selection[0])){
			return "" + selection[0].images[0].actualPpi;
		}
	}catch(err){
		return "";
	}
}
com_unhurdle_info.getFileName = function(){
	try{
		var text = "";
		var sel = app.selection;
		if(!sel){return text}
		for(var i=0;i<sel.length;i++){
			var obj = sel[i];
			if(com_unhurdle_info.isText(obj)){
				continue;
			}
			if(!obj.hasOwnProperty("graphics")){
				continue;
			}
			if(obj.graphics.length == 0){
				continue;
			}
			try{
				text = obj.graphics[0].itemLink.name;
				if(text){
					return text;
				}
			}catch(err){
				"";
			}
		}
		return text;
	}catch(err){
		return JSON.stringify(err);
	}
}
com_unhurdle_info.getNumItems = function(){
		var text = "";
		var sel = app.selection;
		if(!sel){
			return "0";
		}
		return "" + sel.length;
}