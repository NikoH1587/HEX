waitUntil {!isNil "HEX_TACTICAL"};

/// Close strategic menu
(findDisplay 1300) closedisplay 1;

/// Open briefing menu
[] spawn {
	private _open = false;
	while {HEX_PHASE == "BRIEFING"} do {
		sleep 0.1;
		if (visibleMap && !_open) then {
			(findDisplay 46) createDisplay "HEX_BRIEFING";
			_open = true;
			private _menu = findDisplay 1400;
			private _text = _menu displayCtrl 1401;
			private _info = _menu displayCtrl 1402;
			private _west = _menu displayCtrl 1403;
			private _east = _menu displayCtrl 1404;
			private _start = _menu displayCtrl 1405;
			private _color = [0, 0.3, 0.6, 0.5];
			if (playerSide == east) then {
				_color = [0.5, 0, 0, 0.5];
			};
			
			/// Title text
			private _time = HEX_TIME select 0;
			if (_time in ["DAY1", "DAY2", "DAY3"]) then {_time = "DAY"};
			_text ctrlSetText ("TACTICAL BRIEFING: D+" + str HEX_DAY + " - " + _time + " - " + (HEX_WEATHER select 0));
			_text ctrlSetBackgroundColor _color;
			
			/// Info text
			_info lbAdd "Description 1";
			_info lbAdd "Description 2";
			_info lbAdd "Description 3";
			_info lbAdd "";
			_info lbAdd "Description 4";
			_info lbAdd "Description 5";
			_info lbAdd "Description 6";
			
			/// Add active units to list with name + icon
			/// [_row, _col, [_x,_y], "hd_dot", civilian, 0, 1];
			{
				private _type = _x select 3;
				private _side = _x select 4;
				private _state = _x select 6;
				private _icon = "\A3\ui_f\data\map\markers\nato\" + _type + ".paa";
				private _text = "Infantry 9x";
				switch (_type select [2]) do {
					case "hq": {_text = "Headquarters 1x"};
					case "art": {_text = "Artillery 1x"};
					case "support": {_text = "Support 3x"};
					case "air": {_text = "Helicopter 1x"};
					case "plane": {_text = "Plane 1x"};
					case "antiair": {_text = "Anti-Air 1x"};
					case "recon": {_text = "Recon 6x"};
					case "motor_inf": {_text = "Motorized 6x"};
					case "mech_inf": {_text = "Mechanized 3x"};
					case "armor": {_text = "Armor 3x"};
				};
				
				private _alpha = 1;
				if (_state == 0) then {_text = _text + "(ERROR)"};		
				if (_state == 2) then {_text = _text + "(DISORGANIZED)"; _alpha = 0.5};
				
				if (_side == west) then {
					private _added = _west lbAdd _text;
					_west lbSetPicture [_added, _icon];
					_west lbSetPictureColor [_added, [0, 0.3, 0.6, _alpha]];
				};
				if (_side == east) then {
					private _added = _east lbAdd _text;
					_east lbSetPicture [_added, _icon];
					_east lbSetPictureColor [_added, [0.5, 0, 0, _alpha]];				
				};
			}forEach HEX_TACTICAL;
			/// Add supporting units?		
			
			/// Start button text
			if (isServer) then {
				_start ctrlSetText "COMMENCE BATTLE";
			} else {
				_start ctrlSetText "WAITING FOR HOST...";
			};
		};
		
		if (!visiblemap && _open) then {
			(findDisplay 1400) closedisplay 1;
			_open = false;
		};
	};
};

/// Start tactical combat
LOC_FNC_START = {
	if (isServer) then {
	
	};
};