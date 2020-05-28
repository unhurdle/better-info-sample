//HarbsUI Script UI Library version 1.0010;

// portions of the code credit to Bob Stucky

var curHarbsUIVersion = 1.0045;
if(typeof HarbsUIVersion == "undefined" || HarbsUIVersion<curHarbsUIVersion){
	kAppVersion = parseFloat(app.version);
	if(kAppVersion<5){
		kOK="OK";
		kCancel="Cancel";
		kClose="CLose";
		kDelete="Delete";
		kNew="New";
		kNew_="New...";
		kEdit="Edit";
		kEdit_="Edit...";
	}
	else{
		kOK = app.translateKeyString("$ID/OK");//kOK || 
		kCancel = app.translateKeyString("$ID/Cancel");//kCancel || 
		kClose = app.translateKeyString("$ID/kClose");//kClose || 
		kDelete = app.translateKeyString("$ID/Delete");//kDelete || 
		kNew_ = app.translateKeyString("$ID/New...");//kNew || 
		kEdit_ = app.translateKeyString("$ID/Edit...");//kEdit || 
		kNew = app.translateKeyString("$ID/&New");
		kEdit = app.translateKeyString("$ID/&Edit");
	}



	HarbsUI = {};
		/*
		This widget adds a integer edit box with validation and keyboard nudging.
		It is used like this:
		var intBox = new HarbsUI.IntegerEditBox(myScriptUIContainer,{editValue:0});
		Valid properties are:
		width
		editValue
		minimumValue
		maximumValue
		smallNudge
		largeNudge
		*/
		HarbsUI.IntegerEditBox = function(container,props){//width,editValue,minimumValue,maximumValue,largeNudge,smallNudge
			var width = props.width || 50;
			this.value = props.editValue || 0;
			this.minVal = props.minimumValue || 0;
			this.maximumValue = props.maximumValue || 100;
			this.text = this.value;
			var editBox = container.add("edittext", undefined, this.value );
			this.largeNudge = props.largeNudge || 10;
			//alert(this.largeNudge);
			this.smallNudge = props.smallNudge || 1;
			var that =this;
			if(kAppVersion >=6){
				
				editBox.addEventListener( "keydown", handleNudge  );
			}
			editBox.preferredSize.width = width;
			editBox.widget = this;
			editBox.onChanging = function() {
				if ( this.text.length == 0 ) {
					//alert(2);
					this.text = this.widget.value;
					this.widget.text = this.text;
				}
				else if ( isNaN( parseInt( this.text ) ) ) {
					this.text = this.widget.text
				}
				else if ( parseInt( this.text ) > this.widget.maximumValue ) {
					this.text = this.widget.maximumValue;
					this.widget.text = this.text;
				}
				else if ( parseInt( this.text ) < this.widget.minVal ) {
					this.text = this.widget.minVal;
					this.widget.text = this.text;
				}
				else{
					//alert(4);
					this.text=parseInt(this.text);
					this.widget.text = this.text;
				}
			}
			function handleNudge ( ev ) {
			//alert("nudge");
				if ( ev.shiftKey ) {var ndg = that.largeNudge;}
				else {var ndg = that.smallNudge;}
				// handle the case of a blank entry in the field at the start
				if ( ev.target.text == "" ) {var num = 0;}
				else {var num = parseFloat( ev.target.text );}
				if(isNaN(num) ){num=0}
				switch( ev.keyName ) {
					case "Down" : { // just fall through with ndg set to it's negative value
						ndg = ndg * -1;
					}
					case "Up" : {
						ev.target.text = higherMultiple( num, ndg, that.maximumValue, that.minVal );
						ev.target.nudged=true;
						break;
					}
				}
			}
		
		// this next function is to make sure the nudge feature increments in multiples of the nudge value, and handles the max/min value settings
			var higherMultiple = function( num, ndg, max, min ) {
			// The behavior of the InDesign's nudges is to go to the next multiple of the nudge value
			// for example, if the control's value is 7, the largeNudge is 5, a large nudge will make the value 10 (next multiple of the largeNudge).
				if ( ndg < 0 ) { // if the nudge is negative, we're incrementing down, but in the loop below, we're always counting up
					ndg = ndg * -1;
					var icrmnt = -1;
				}
				else { 
					var icrmnt = 1;
				}
				// here we have to catch the case of the values being at max or min, we can't increment if that's the case
				if ( max != undefined && ( num + icrmnt ) >= max ) { // if there's a max value, and incrementing goes past it, return
					return max;
				}
				else if ( min != undefined && ( num + icrmnt ) <= min ) { // if there's a min value, and decrementing goes past it, return
					return min;
				}
				for ( var i = 0; i < ndg; i++ ) {
					num += icrmnt;
					if ( num % ndg == 0 ) { // if we're at a multiple of the nudge value, return the number
						return num;
					}
					else if ( max && num >= max ) { // if there's a max value, and we're at it, return
						return max;
					}
					else if ( min && num <= min ) { // if there's a min value, and we're at it, return
						return min;
					}
				}
				return num;
			}
			return editBox;
		}
		//
	
		/*
		This widget gives the ability to add an IntegerEditBox and a label in a single step.
		It is used like this:
		var intBox = new HarbsUI.IntegerEditGroup(myScriptUIContainer,"Add your value here",undefined,{editValue:0});
		
		fieldLabel must be provided all the other parameters are optional
		* if you are lining up a column of IntegerEditGroups, make sure you provide a labelWidth as wide as the widest label
		*	Valid properties are:
			width
			editValue
			minimumValue
			maximumValue
			smallNudge
			largeNudge
		* height constrains the height of the group.
		
		*/
		
		HarbsUI.IntegerEditGroup = function(container,fieldLabel,labelWidth,props,height){
			var err;
			if(container == undefined){throw (new Error("No container provided."));}
			if(fieldLabel == undefined){throw (new Error("No label provided!"));}
			try{var g = container.add('group');}
			catch(err){throw (new Error("Invalid container provided."))}
			g.orientation = 'row';
			g.alignChildren = 'top';
			if(height){g.maximumSize.height = height}
			gg = g.add('group');
			gg.orientation = 'column';
			gg.alignChildren = 'right';
			gg.margins = 0;
			if(labelWidth){gg.preferredSize.width = labelWidth}
			g.label = gg.add('statictext',undefined,fieldLabel);
			gg2 = g.add('group');
			gg.orientation = 'column';
			gg.alignChildren = 'left';
			var ib = new HarbsUI.IntegerEditBox (gg2,props);
			ib.name = g.label;
			return ib;
		}


		/*
		This widget adds a number edit box with validation and keyboard nudging.
		It is used like this:
		var intBox = new HarbsUI.NumberEditBox(myScriptUIContainer,{editValue:0});
		Valid properties are:
		width
		editValue
		minimumValue
		maximumValue
		smallNudge
		largeNudge
		decimals
		*/
		HarbsUI.NumberEditBox = function(container,props){//width,editValue,minimumValue,maximumValue,largeNudge,smallNudge
			var width = props.width || 50;
			this.value = props.editValue || 0;
			this.minVal = props.minimumValue || 0;
			this.maximumValue = props.maximumValue || 100;
			this.text = this.value;
			var editBox = container.add("edittext", undefined, this.value );
			this.largeNudge = props.largeNudge || 10;
			//alert(this.largeNudge);
			this.smallNudge = props.smallNudge || 1;
			this.decimals = isNaN(Number(props.decimals)) ? 1 : parseInt(props.decimals,10);
			var that = this;
			var clickStamp = new Date().getTime();
			if(kAppVersion >=6){
				
				editBox.addEventListener( "keydown", handleNudge  );
			}
			editBox.preferredSize.width = width;
			editBox.widget = this;
			editBox.onChanging = function() {
				if ( this.text.length == 0 ) {
					//alert(2);
					this.text = this.widget.value;
					this.widget.text = this.text;
				}
				else if ( isNaN( parseFloat( this.text ) ) ) {
					this.text = this.widget.text
				}
				else if ( parseFloat( this.text ) > this.widget.maximumValue ) {
					this.text = this.widget.maximumValue;
					this.widget.text = this.text;
				}
				else if ( parseFloat( this.text ) < this.widget.minVal ) {
					this.text = this.widget.minVal;
					this.widget.text = this.text;
				}
				else{
					//alert(4);
					//this.text= +parseFloat(this.text).toFixed(this.decimals);
					if((this.text.lastIndexOf(".") == this.text.length-1) || this.text.lastIndexOf("0") == this.text.length-1){
						this.widget.text = this.text;
						// do nothing because the user is typing decimals.
					} else {
						//this.text = parseFloat(this.text);
						this.text= parseFloat(parseFloat(this.text).toFixed(this.widget.decimals));
						this.widget.text = this.text;
					}
				}
			}
			function handleNudge ( ev ) {
				var newTime = new Date().getTime();
				if(newTime - clickStamp < 100){
					return;
				}
				clickStamp = new Date().getTime();
				if ( ev.shiftKey ) {var ndg = that.largeNudge;}
				else {var ndg = that.smallNudge;}
				// handle the case of a blank entry in the field at the start
				if ( ev.target.text == "" ) {var num = 0;}
				else {var num = parseFloat( ev.target.text );}
				if(isNaN(num) ){num=0}
				switch( ev.keyName ) {
					case "Down" : { // just fall through with ndg set to it's negative value
						ndg = ndg * -1;
					}
					case "Up" : {
						ev.target.text = higherMultiple( num, ndg, that.maximumValue, that.minVal );
						ev.target.nudged=true;
						break;
					}
				}
			}
		
		// this next function is to make sure the nudge feature increments in multiples of the nudge value, and handles the max/min value settings
			var higherMultiple = function( num, ndg, max, min ) {
			// The behavior of the InDesign's nudges is to go to the next multiple of the nudge value
			// for example, if the control's value is 7, the largeNudge is 5, a large nudge will make the value 10 (next multiple of the largeNudge).
//				if ( ndg < 0 ) { // if the nudge is negative, we're incrementing down, but in the loop below, we're always counting up
//					ndg = ndg * -1;
//					var icrmnt = -1;
//				}
//				else { 
//					var icrmnt = 1;
//				}

				num += ndg;
				// here we have to catch the case of the values being at max or min, we can't increment if that's the case
				if ( max != undefined && num >= max ) { // if there's a max value, and incrementing goes past it, return
					return max;
				}
				else if ( min != undefined && num <= min ) { // if there's a min value, and decrementing goes past it, return
					return min;
				}
				return num;
			}
			return editBox;
		}
		//
	
		/*
		This widget gives the ability to add an NumberEditGroup and a label in a single step.
		It is used like this:
		var intBox = new HarbsUI.NumberEditGroup(myScriptUIContainer,"Add your value here",undefined,{editValue:0});
		
		fieldLabel must be provided all the other parameters are optional
		* if you are lining up a column of IntegerEditGroups, make sure you provide a labelWidth as wide as the widest label
		*	Valid properties are:
			width
			editValue
			minimumValue
			maximumValue
			smallNudge
			largeNudge
			decimals
		* height constrains the height of the group.
		
		*/
		
		HarbsUI.NumberEditGroup = function(container,fieldLabel,labelWidth,props,height){
			var err;
			if(container == undefined){throw (new Error("No container provided."));}
			if(fieldLabel == undefined){throw (new Error("No label provided!"));}
			try{var g = container.add('group');}
			catch(err){throw (new Error("Invalid container provided."))}
			g.orientation = 'row';
			g.alignChildren = 'top';
			if(height){g.maximumSize.height = height}
			gg = g.add('group');
			gg.orientation = 'column';
			gg.alignChildren = 'right';
			gg.margins = 0;
			if(labelWidth){gg.preferredSize.width = labelWidth}
			g.label = gg.add('statictext',undefined,fieldLabel);
			gg2 = g.add('group');
			gg.orientation = 'column';
			gg.alignChildren = 'left';
			var ib = new HarbsUI.NumberEditBox (gg2,props);
			ib.name = g.label;
			return ib;
		}

	
		/*
		This widget provides a sliderbox with numerical feedback.
		It is used like this:
		var sliderBox = new HarbsUI.SliderBox(myScriptUIContainer);
		
		The only required parameter is a ScriptUI container
		*	Valid properties are:
			width
			value
			minimumValue
			maximumValue
			
		*/
		
		HarbsUI.SliderBox = function( container, props) {
			var err;
			if(container == undefined){throw (new Error("No container provided."));}
			this.width = props.width || 50;
			this.initVal = props.value || 0;
			this.minVal = props.minimumValue || 0;
			this.maxVal = props.maximumValue || 100;
			this.text = this.initVal;
			try{var g = container.add( "group" );}
			catch(err){throw (new Error("Invalid container provided."))}
			g.orientation = "column";
			g.spacing = 2;
			var eb = g.add( "edittext", undefined, this.initVal );
			eb.preferredSize.width = width;
			eb.sldr = g.add( "slider", undefined, this.initVal, this.minVal, this.maxVal );
			eb.sldr.preferredSize.width = width;
			eb.sldr.eb = eb;
			eb.widget = this;
			eb.onChanging = function() {
				if ( this.text.length > 1 ) {
					if ( isNaN( parseFloat( this.text ) ) ) {
						this.text = this.widget.text
						this.sldr.value = this.widget.text;
					}
				}
				else if ( this.length == 0 ) {
					this.text = this.widget.minVal;
					this.sldr.value = this.text;
					this.widget.text = this.text;
				}
			}
			eb.onChange = function() {
				if ( isNaN( parseFloat( this.text ) ) ) {
					this.text = this.widget.text
					this.sldr.value = this.widget.text;
				}
				else {
					if ( parseFloat( this.text ) > this.widget.maxVal ) {
						this.text = this.widget.maxVal;
					}
					if ( parseFloat( this.text ) < this.widget.minVal ) {
						this.text = this.widget.minVal;
					}
					this.text = this.text;
					this.sldr.value = this.text;
					this.widget.text = this.text;
				}	
			}
			eb.sldr.onChanging = function() {
				this.eb.text = this.value;
				this.eb.widget.text = this.value;
			}
		}
		
		//~ makeWindow = function() {
		//~ 	var w = new Window( "palette", "Testing" );
		//~ 	w.preferredSize.width=200;
		//~ 	w.sliderBox = new HarbsUI.SliderBox( w, 100, 20, -1, 100 );
		//~ 	w.DD = w.add("dropdownlist",undefined,"test",{items:["qwert yuiopl kjhggfds aazx cvbb t yuiopl kjhggfds aazx cvbb t yuiopl kjhggfds aazx cvbbnm","test2"]});
		//~ //	var DD = w.add("dropdownlist",undefined,"test",{items:["qwert yuiopl kjhggfds aazx cvbb t yuiopl kjhggfds aazx cvbb t yuiopl kjhggfds aazx cvbbnm","test2"]});
		//~ 	w.DD.preferredSize.width=250;
		//~ 	w.DD.selection=0;
		//~ 	w.show();
		//~ 	
		//~ 	w.onClose = function() {
		//~ 		alert( "and the final value was: " + w.sliderBox.text );
		//~ 	}
		//~ }
		
		//makeWindow();
	
		/*
		This widget provides a Text ComboBox. The text can be either selected or typed into the edit box.
		It is used like this:
		var sliderBox = new HarbsUI.SliderBox(myScriptUIContainer);
		
		The only required parameter is a ScriptUI container if there are no list items, the second argument can be undefined.
		*	Valid properties are:
			width
			value
			minimumValue
			maximumValue
			
		*/
		
		HarbsUI.TextComboBox = function(container, listItems/*Array*/ , props/*Object*/ ){
			var err;
			if(container == undefined){throw (new Error("No container provided."));}		
			var fld;
			try{container = container.add('group');}
			catch(err){ throw (new Error("Invalid container provided.")); }
			this.width = props.width || 100;
			this.selection = props.selection || 0;
			this.listItems = props.listItems || [];
			this.text = this.listItems[this.selection] || '';
			this.indent = indent || 0;
			container.indent = this.indent;
			container.orientation = 'stack';
			container.alignChildren = 'left';
			fld = container.add("edittext");
			var dd = container.add("dropdownlist",undefined,undefined,{items:this.listItems});
			dd.selection=this.selection;
			dd.preferredSize.width = this.width;
			var fld2 = container.add("edittext");
			fld.text =this.text;
			fld.preferredSize.width = this.width-20;
			fld2.text =this.text;
			fld2.preferredSize.width = this.width-20;
			fld.onChanging = function(){fld2.text = fld.text;}
			fld2.onChanging = function(){fld.text = fld2.text;}
			dd.onChange = function(){
				fld.text = dd.selection.text;
				fld2.text = dd.selection.text;
			}
			return fld;
		}
		//test = new Window ("dialog", "test");
		//cmbx = new HarbsUI.TextComboEditBox(test,[1,3,5,7],0,70,0,);
		//test.show()
	
		/*
		This widget allows you to set a listbox and associated widgets to automatically respond to clicking.
		It also creates doubleClick functionality. It will trigger an editButton if one is assigned to the listbox, or you can create your own "doubleClick" function.
		
		It is used like this:
		(optional) listBox.editButton = myEditButton;
		(optional) listBox.deleteButton = myDeleteButton;
		(optional creation of custom doubleClick) listBox.doubleClick = function(){alert("Don't double click me!!!")};
		
		listbox.onClick = HarbsUI.listboxClick;
		
		The StandardListBox uses this widget.
		
		listboxClick is NOT instantiated.
		
		*/	
		HarbsUI.listboxClick = function (item){
			var onDoubleClick = function (item){
				if(item.detail ==2){
					if(that.hasOwnProperty("doubleClick")){that.doubleClick();}
					else if (that.hasOwnProperty("editButton")){that.editButton.notify("onClick");}
				}
			}
			if (this.hasOwnProperty("editButton")){
				if(this.selection){this.editButton.enabled = true;}
				else{this.editButton.enabled = false;}
			}
			if (this.hasOwnProperty("deleteButton")){
				if(this.selection){this.deleteButton.enabled = true;}
				else{this.deleteButton.enabled = false;}
			}
			var that = this;
			this.addEventListener('click', onDoubleClick);
		}
		//EXAMPLE OF USE:
		/*
		test = new Window ("dialog", "List Box Click");
		listbox = test.add('listbox',undefined,undefined,{items:[1,2,3]})
		var editButton = test.add('button');
		editButton.text = "Edit";
		editButton.enabled=false;
		listbox.editButton = editButton;
		editButton.onClick = function (){
			alert("super!");
			}
		listbox.onClick = HarbsUI.listboxClick;
		
		//to use a unique double click function instead -- define one as below:
		listbox.doubleClick = function(){
			alert("great!");
			}
		test.show();
		*/
	
		/*
		This widget adds a group of standard buttons common for dialogs. If your window type is dialog, Okay and Cancel are always created.
		
		No properties are required.
		
		Valid properties are:
		okLabel:String,
		cancelLabel:String,
		newLabel:bool,
		editLabel:bool,
		deleteLabel:bool,
		size:Number,
		spacer:Number (specifies the space between the okay and Cancel buttons and the rest),
		orientation:String ("row" or "column"),
		alignChildren:String (any valid alignment property. Default is "fill".)
		
		It is used like this:
		
		// adds okay and cancel buttons to a dialog:
		HarbsUI.StandardButtonGroup(d);
		
		//add an editButton as well with 10 pixels of space:
		d.sbg = new HarbsUI.StandardButtonGroup(w,{editButton:1,spacer:10});
		
		d.sbg.editButton.onClick = function(){
			alert("let's edit our thingy!");
		}
		
		*/	
	
		HarbsUI.StandardButtonGroup = function (container,props){
			props = props || {};
			var err,okBut,canclBut,spacer,newButton,editButton,deleteButton,size,orientation,alignChildren;
			
			okBut = props.okLabel;
			canclBut = props.cancelLabel;
			spacer = props.spacer;
			newButton = props.newLabel;
			editButton = props.editLabel;
			deleteButton = props.deleteLabel;
			size = props.size
			orientation = props.orientation;
			alignChildren = props.alignChildren;
			
			if(!container){throw (new Error("You Must Provide a Container for the Button Group!"));}
			//if(!alignChildren){alignChildren='fill';}
			//if(!orientation){orientation='column'}
			try{var group = container.add('group');}
			catch(err){throw (new Error("Invalid container provided."));}
			group.orientation = orientation || 'column';
			group.alignChildren = alignChildren || 'fill';
			group.spacing = 0;
			if(size){
				if(group.orientation=='column'){
					group.preferredSize.width = size;
				}
				else if(group.orientation=='row'){
					group.preferredSize.height = size;
				}
			}
			if(okBut || (!okBut  && group.window.type == 'dialog')){
				okBut=okBut || kOK;
				group.okBut = group.add('button', undefined, okBut, {name:'ok'});
				group.okBut.onClick = function(){group.window.close(1);}
			}
			if(canclBut|| (!canclBut && group.window.type == 'dialog')){
				canclBut = canclBut || kCancel;
				// if(canclBut != kClose){canclBut = kCancel;}
				group.cancelButton =group.add('button', undefined, canclBut, {name:'cancel'});
				group.cancelButton.onClick = function(){group.window.close(0);}
			}
			if(spacer){
				group.spacer = group.add('group');
				if(group.orientation=='row'){group.spacer.preferredSize.width=spacer;}
				else{group.spacer.preferredSize.height=spacer;}
			}
			if(newButton){group.newButton =group.add('button', undefined, newButton);}
			if(editButton){group.editButton =group.add('button', undefined, editButton);}
			if(deleteButton){group.deleteButton =group.add('button', undefined, deleteButton);}
			return group;
		}
		//
		HarbsUI.DropDownDialog = function (title,dropdownLabel,dropdownList,selectedIndex){
			var w = new Window ('dialog', title);
			w.orientation = 'row';w.alignChildren = 'top';
			w.dropdown = new HarbsUI.DropdownGroup(w,dropdownLabel,dropdownList,selectedIndex);
			w.buttons = new HarbsUI.StandardButtonGroup(w);
			w.buttons.cancelButton.active = true;
			return w;
		}
		//EXAMPLE USAGE:
		//~ w=new HarbsUI.DropDownDialog("My Drop Down",'my fabulous items',[1023496738,'test',3,4,5]);
		//~ if(w.show()){
		//~ 	alert("fabulous");
		//~ 	}
		HarbsUI.DropdownGroup = function(container,dropdownLabel,dropdownList,selectedIndex,labelWidth,ddWidth,height,spacing){
			var group = container.add('group');
			container.spacing=0;
			group.spacing = spacing || 0;
			group.orientation = 'row';
			group.alignChildren = 'center';
			if(height){group.maximumSize.height = height}
			group.margins=0;
			group.group = group.add('group');
			group.group.orientation = 'column';
			group.group.alignChildren = 'right';
			group.group.margins = 0;
			group.group.spacing=0;
			if(labelWidth){group.group.preferredSize.width = labelWidth}
			group.label = group.group.add('statictext',undefined,dropdownLabel);
			group.label.margins = 0;
			group.dropdown = group.add('dropdownlist',undefined,undefined,{items:dropdownList});
			group.dropdown.margins = 0;
			if(selectedIndex != undefined){
				group.dropdown.selection = selectedIndex;
			}
			if(ddWidth){group.dropdown.preferredSize.width = ddWidth;}
			group.dropdown.name = group.label;
			return group.dropdown;
		}
		HarbsUI.TextEditGroup = function(container,fieldLabel,contents,labelWidth,fieldWidth,height,alternateLabel){
			var group = container.add('group');
			group.orientation = 'row';
			group.alignChildren = 'top';
			if(height){group.maximumSize.height = height}
			group.group = group.add('group');
			group.group.orientation = 'stack';
			group.group.alignChildren = 'right';
			group.group.margins = 0;
			if(labelWidth){group.group.preferredSize.width = labelWidth}
			group.label = group.group.add('statictext',undefined,fieldLabel);
			if(alternateLabel){group.alternateLabel=group.group.add('statictext',undefined,alternateLabel)}
			group.textEditBox = group.add('edittext',undefined,contents);
			if(fieldWidth){group.textEditBox.preferredSize.width = fieldWidth;}
			group.textEditBox.name = group.label;
			if(alternateLabel){group.textEditBox.alternateName = group.alternateLabel}
			return group.textEditBox;
		}
		//
		HarbsUI.StandardListBox = function(title,listBoxHeader,list,preferredSize,listInfo,language){
			//language = language || 'English';
			var okName, newName, cancelName, editName, deleteName;
			
			okName =kOK; cancelName=kCancel; newName=kNew; editName = kEdit, deleteName=kDelete;
			
			var d = new Window ('dialog', title);
			d.orientation='row';
			d.alignChildren='top';
			preferredSize = preferredSize || [220,150];
			var font = d.graphics.font.family;
			var fontSize = d.graphics.font.size;
			d.column1 = d.add('group');
			d.column1.orientation='column';
			d.column1.alignChildren='left';
			//d.column2 = d.add('group');
			//d.column2.orientation='column';
			var text = d.column1.add("statictext",undefined,listBoxHeader);
			text.graphics.font = ScriptUI.newFont (font,'BOLD',fontSize);
			//text.alignment='left';
			var listBox = d.column1.add('listbox', undefined, undefined,{items:list});
			listBox.preferredSize = preferredSize;
			listBox.alignment = 'left';
			listBox.listInfo = listInfo;
			if(listBox.items.length>0){
				listBox.selection = listBox.items[0];
			}
			if(listInfo){
				listBox.infoTitle = d.column1.add('statictext',undefined,'Info:');
				//listBox.infoTitle = infoTitle.text;
				listBox.infoText = d.column1.add('statictext',undefined,listInfo[0],{multiline:true,scrolling:true});
				listBox.infoText.preferredSize.height = 90;
				listBox.infoText.preferredSize.width = 220;
			}
			listBox.onClick = HarbsUI.listboxClick;
			listBox.onChange = function(){
				var listBox = this;
				if(listBox.hasOwnProperty("infoText")){
					listBox.customClick();
				}
				if(listBox.selection){
					listBox.editButton.enabled=true;
					listBox.deleteButton.enabled=true;
				}
				else{
					listBox.editButton.enabled=false;
					listBox.deleteButton.enabled=false;
				}
			}
			listBox.customClick = function(){
				if(! listInfo){return}
				if(listBox.selection){
					var theIndex = listBox.selection.index;
					listBox.infoText.text = listBox.listInfo[theIndex];
				}
				else{listBox.infoText.text = "";}
			}
		//d.listBox = d.column1.add('listbox');
		//okName, newName, cancelName, editName, deleteName
		//alert(this.reflect.properties)

			var props = {
				okLabel:okName,
				cancelLabel:cancelName,
				newLabel:newName,
				editLabel:editName,
				deleteLabel:deleteName,
				spacer:10
			}
			var buttonGroup = new HarbsUI.StandardButtonGroup(d,props);
			listBox.okayButton = buttonGroup.okayButton;
			listBox.cancelButton = buttonGroup.cancelButton;
			listBox.newButton = buttonGroup.newButton;
			listBox.editButton = buttonGroup.editButton;
			listBox.deleteButton = buttonGroup.deleteButton;
			listBox.dialog = d;
			listBox.active=true;
			return listBox;
		}
		//
		HarbsUI.StandardDialog = function(title,orientation,alignment,okName,cancelName){
			orientation = orientation || 'row';
			alignment = alignment || 'top';
			okName = okName || kOK;
			cancelName = cancelName || kCancel;

			var d = new Window ('dialog', title);
			d.orientation= orientation;
			d.alignChildren= alignment;
			d.mainGroup = d.add('group');
			d.mainGroup.orientation='column';
			d.mainGroup.alignChildren='left';
			var props = {
				okLabel:okName,
				cancelLabel:cancelName
//				spacer:10
			}
			d.buttonGroup = new HarbsUI.StandardButtonGroup(d,props);
			return d;
		}
		HarbsUI.DoubleDialog = function(title,orientation,alignment,okName,cancelName){
			orientation = orientation || 'row';
			alignment = alignment || 'top';
			okName = okName || kOK;
			cancelName = cancelName || kCancel;

			var d = new Window ('dialog', title);
			d.orientation= orientation;
			d.alignChildren= alignment;
			d.holderGroup = d.add('group');
			d.holderGroup.orientation = 'row';
			d.holderGroup.alignChildren = 'left';

			d.labelGroup = d.holderGroup.add('group');
			d.labelGroup.orientation='column';
			d.labelGroup.alignChildren='right';
			d.mainGroup = d.holderGroup.add('group');
			d.mainGroup.orientation='column';
			d.mainGroup.alignChildren='left';
			var props = {
				okLabel:okName,
				cancelLabel:cancelName,
				orientation:'row'
//				spacer:10
			}
			d.buttonGroup = new HarbsUI.StandardButtonGroup(d,props);
			return d;
		}
		HarbsUI.TreeView = function(parent,structure,name,nodeIcon,bounds){
			if(bounds instanceof Array){
				var width = bounds[0] || undefined;
				var height = bounds[1] || undefined;
			}
			// Create the panel for the TreeView
			var panel = parent.add("panel", undefined, name);
			panel.alignment = ["fill", "fill"];
			panel.alignChildren = ["fill", "fill"]
		
			// Create the TreeView list
			var treeview = panel.add("treeview");
			if(width){treeview.preferredSize.width = width;}
			if(height){treeview.preferredSize.height = height;}
			AddItemsToTreeView(treeview,structure,nodeIcon);
			return treeview;
			function AddItemsToTreeView(parent,structure,icon){
				for(var i=0;i<structure.length;i++){
					if(structure[i].type=="node"){
						var node = parent.add("node",structure[i].name);
						if(icon){node.image = icon;}
						node.reference = structure[i].reference;
						AddItemsToTreeView(node,structure[i].children,icon);
					}
					else{
						var item = parent.add("item",structure[i].name);
						item.reference = structure[i].reference;
					}
				}
				//return parent;
			}
		}
	HarbsUIVersion = curHarbsUIVersion;
}
// var d = new HarbsUI.StandardListBox ("My Title","About My List",["1","2","3","4"],undefined,"Some info about my stuff...");
	//
//this.Harbs=Harbs;
//this.HarbsUI = HarbsUI;
//this.scriptFuntions = {}
//this.scriptFuntions.one = Harbs;
//this.scriptFuntions.two = HarbsUI;
