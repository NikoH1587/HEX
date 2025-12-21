openmap true;
LOC_MODE = "SELECT"; /// "SELECT", "ORDER";
LOC_ORDERS = [];
LOC_SELECT = [];

LOC_FNC_SELECT = {
	private _selectable = [];
	private _posCLICK = _this;
	/// Find counters with moves
	{
		private _hex = _x;
		private _sid = _x select 4;
			private _act = _x select 5;
		if (_sid == side player && _act > 0) then {
			_selectable pushback _hex;
		};
	}forEach HEX_GRID;

	/// Select counter
	{
		private _hex = _x;
		private _pos = _x select 2;
		if (_pos distance _posCLICK < (HEX_SIZE/2)) then {
			LOC_SELECT = _x;
			LOC_MODE = "ORDER";
			
			private _marker = createMarkerLocal ["HEX_SELECT", _pos];
			_marker setMarkerTypeLocal "Select";
			_marker setMarkerSize [1.5, 1.5];
			
			/// Play sound 
			0 spawn LOC_FNC_EFFECT;
			
			/// Add all possible near moves
			private _near = _hex call HEX_FNC_NEAR;
			{
				private _nearHEX = _x;
				private _side = _x select 4;
				if (_side == civilian) then {
					LOC_ORDERS pushback _nearHEX;
				};
			}forEach _near;
			
			/// Add move markers
			{
				private _row = _x select 0;
				private _col = _x select 1;
				private _pos2 = _x select 2;
				private _name2 = format ["ACT_%1_%2", _row, _col];
				private _marker2 = createMarkerLocal [_name2, _pos2];
				_marker2 setMarkerTypeLocal "Select";
			}ForEach LOC_ORDERS;
		};
	}forEach _selectable;
};

LOC_FNC_ORDER = {
	private _posCLICK = _this;

	/// Select move
	{
		private _hex = _x;
		private _pos = _x select 2;
		
		if (_pos distance _posCLICK < (HEX_SIZE/2)) then {
		
			private _hex2 = LOC_SELECT;
			private _row2 = _hex2 select 0;
			private _col2 = _hex2 select 1;
			
			private _name2 = format ["LOC_%1_%2", _row2, _col2];
			_name2 setMarkerPosLocal _pos;
			
			/// Send move to server
			[LOC_SELECT, _hex] remoteExec ["HEX_FNC_MOVE", 2, false];
		};
	}forEach LOC_ORDERS;
	
	/// Clear local orders, markers and sound
	remoteExec ["HEX_FNC_CLIC", 0, false];
};

/// Sound effect
LOC_FNC_EFFECT = {
	
	private _sound = HEX_SOUNDS select floor random count HEX_SOUNDS;
	private _radio = HEX_RADIO select floor random count HEX_RADIO;
	private _pitch = random 1;
	playSoundUI [_sound, 1, random 1];
	LOC_SOUND = playSoundUI [_radio, 2 - _pitch, _pitch];
};

LOC_FNC_ENDTURN = {
	hint str "TURN ENDED";
	/// update info boxes?
};

/// Open menu
[] spawn {
	private _open = false;
	while {HEX_PHASE == "STRATEGIC"} do {
		sleep 0.1;
		if (visibleMap && !_open) then {
			(findDisplay 46) createDisplay "HEX_STRATEGIC";
			private _menu = findDisplay 1300;
			_open = true;
			private _time = _menu displayCtrl 1302;
			private _weather = _menu displayCtrl 1303;
			private _turn = _menu displayCtrl 1303;

			private _color = [0, 0.3, 0.6, 0.5];
			
			if (playerSide == east) then {
				_color = [0.5, 0, 0, 0.5];
			};

			_time ctrlSetBackgroundColor _color;
			_weather ctrlSetBackgroundColor _color;
			_turn ctrlSetBackgroundColor _color;
			
			/// Command
			onMapSingleClick {
				if (LOC_MODE == "SELECT") then {
					_pos spawn LOC_FNC_SELECT;
				};
	
				if (LOC_MODE == "ORDER") then {
					_pos spawn LOC_FNC_ORDER;
				};
				true;
			};
		};
		
		/// Update information
		if (visibleMap && _open) then {
			private _menu = findDisplay 1300;
			private _info = _menu displayCtrl 1301;
			private _time = _menu displayCtrl 1302;
			private _weather = _menu displayCtrl 1303;
			private _turn = _menu displayCtrl 1304;
			
			if (HEX_TURN == west) then {
				_info ctrlSetBackgroundColor [0, 0.3, 0.6, 0.5];
				_info ctrlSetText "BLUFOR TURN";
			} else {
				_info ctrlSetBackgroundColor [0.5, 0, 0, 0.5];	
				_info ctrlSetText "OPFOR TURN";
			};
			
			_time ctrlSetText ((HEX_TIME select 0) + " (" + (HEX_TIME select 1) + ">" + (HEX_TIME select 2) + ">"  + (HEX_TIME select 3) + ")");
			_weather ctrlSetText ((HEX_WEATHER select 0) + " (" + (HEX_WEATHER select 1) + ">" + (HEX_WEATHER select 2) + ">"  + (HEX_WEATHER select 3) + ")");
			
			if (side player == HEX_TURN) then {
				_turn ctrlSetText "END TURN";
			} else {
				_turn ctrlSetText "WAITING...";	
			};
		};
		
		if (!visiblemap && _open) then {
			(findDisplay 1300) closedisplay 1;
			_open = false;
			
		};
	};
};

/// Third Menu:
/// Turn info
/// End Turn Button
/// Time /// DAWN / DAY / DUSK / NIGHT
/// Weather forecast: CLEAR / CLOUDY / STORM / FOGGY

/// TBD: Road +1 move skip:
/// Origin (1st hex) has to have road hex
/// Middle (2nd hex w/HEX_FNC_NEAR) is civilian & Road
/// destination (3rd) is civilian & Road

/// Could also be done like this (would use flood as origin point, with enemy ZoC + max radius limiting it):
/// road tile + logi(support) = move another unit into road hex
/// friendly helo + airport = move another unit into hex
/// ship + harbor = move another unit into shore hex
/// HQ = Teleport in reserve/imaginary units?
			
/// Aircraft carrier / etc ship = airport + harbor
/// this could make airdrops/shore landings possible