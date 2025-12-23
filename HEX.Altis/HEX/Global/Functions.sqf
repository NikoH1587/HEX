/// Find hexes in grid next to hex, server/local

HEX_FNC_NEAR = {
	private _hex = _this;
	private _row = _hex select 0;
	private _col = _hex select 1;
	
	private _dirs = [[0,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0]];
	if (_col mod 2 == 0) then {_dirs = [[0,-1],[1,-1],[1,0],[0,1],[-1,0],[-1,-1]]};
	private _near = [];
	
	{
		private _rowNew = _row + (_x select 1);
		private _colNew = _col + (_x select 0);
		
		private _found = HEX_GRID select {(_x select 0) == _rowNew && (_x select 1) == _colNew};
		if (count _found > 0) then {_near pushBack (_found select 0)};
	}forEach _dirs;
	
	_near
};

/// Find hexes with a fill, server/local
HEX_FNC_FILL = {
	private _hex = _this select 0;
	private _max = _this select 1;
	
	private _open = [_hex];
	private _seen = [_hex];
	
	while {count _open > 0 && count _seen < _max} do {
		private _hex2 = _open deleteAt 0;
		{
			private _hex3 = _x;
			if ((_hex3 in HEX_GRID) && !(_hex3 in _seen)) then {
				_seen pushBack _hex3;
				_open pushBack _hex3;
			};
		}forEach (_hex2 call HEX_FNC_NEAR);
	};
	
	_seen
};

/// Moves one hex into another on server
HEX_FNC_MOVE = {
	private _org = _this select 0;
	private _end = _this select 1;
	
	/// Find origin index
	private _indexORG = HEX_GRID find _org;
	/// Find destination index
	private _indexEND = HEX_GRID find _end;	
	
	/// Replace origin with "hd_dot", civilian, 0
	_newORG = [_org select 0, _org select 1, _org select 2, "hd_dot", civilian, 0, 1];
	HEX_GRID set [_indexORG, _newORG];
	
	/// Replace destination with origin
	_newEND = [_end select 0, _end select 1, _end select 2, _org select 3, _org select 4, (_org select 5) - 1, _org select 6];
	HEX_GRID set [_indexEND, _newEND];
	
	/// Update grid information globally
	publicVariable "HEX_GRID";
	
	/// Update zone of control globally
	private _zoco = 0 spawn HEX_FNC_ZOCO; 
	waitUntil {scriptDone _zoco};

	/// Update counters globally
	remoteExec ["HEX_FNC_COTE", 0, false];
};

/// Clears markers and orders locally
HEX_FNC_CLIC = {
	/// Remove order markers
	{
		private _hex = _x;
		private _row = _x select 0;
		private _col = _x select 1;
		private _pos = _x select 2;
		private _name = format ["ACT_%1_%2", _row, _col];		
		deleteMarkerLocal _name;
	}forEach LOC_ORDERS;
	
	deleteMarkerLocal "HEX_SELECT";
	
	/// Reset local variables
	if (isNil "LOC_ORDERS" == false) then {
		LOC_ORDERS = [];
	};
	
	if (isNil "LOC_SELECT" == false) then {
		LOC_SELECT = [];
	};
	
	if (isNil "LOC_MODE" == false) then {
		LOC_MODE = "SELECT";
	};	
	
	/// Stop radio noise;
	if (isNil "LOC_SOUND" == false) then {
		stopSound LOC_SOUND;
	};
};

/// Updates counter markers on client
HEX_FNC_COTE = {
	{
		private _hex = _x;
		private _row = _x select 0;
		private _col = _x select 1;
		private _pos = _x select 2;
		private _cfg = _x select 3;
		private _sid = _x select 4;
		private _act = _x select 5;
		private _org = _x select 6;

		private _name = format ["LOC_%1_%2", _row, _col];
		deleteMarkerLocal _name;

		private _draw = false;
		if (_sid == side player) then {_draw = true};
	
		private _near = _hex call HEX_FNC_NEAR;
		{
			private _sid2 = _x select 4;
			if (_sid2 == side player) then {
				_draw = true;
			};
		}forEach _near;
	
		if (_draw == true && _cfg != "hd_dot") then {
			private _marker = createMarkerLocal [_name, _pos];
			_marker setMarkerTypeLocal _cfg;
			if (_org == 2) then {_marker setMarkerAlphaLocal 0.5};
			private _sup = false;
			if (_cfg in ["b_air", "b_plane"]) then {_sup = true};
			if (_cfg in ["o_air", "o_plane"]) then {_sup = true};
			if (_sid == side player && _act > 0 && _sup == false) then {
				if (_act == 1) then {_marker setMarkerTextLocal ("I")};
				if (_act == 2) then {_marker setMarkerTextLocal ("II")};	
				if (_act == 3) then {_marker setMarkerTextLocal ("III")};	
			};
		};
	}forEach HEX_GRID;
};

/// Updates grid zone of control of counters on server and intensity globally
HEX_FNC_ZOCO = {
	private _intensity = 0;
	
	{
		private _hex = _x;
		private _row = _x select 0;
		private _col = _x select 1;
		private _sid = _x select 4;
	
		private _near = _hex call HEX_FNC_NEAR;
		private _sides = [_sid];
		{
			_sides pushback (_x select 4);
		}forEach _near;
	
		private _color = "colorBLACK";
		if (west in _sides) then {_color = "colorBLUFOR"};
		if (east in _sides) then {_color = "colorOPFOR"};
		if (west in _sides && east in _sides) then {_color = "ColorCIV"; _Intensity = _Intensity + 1};
	
		private _marker = format ["HEX_%1_%2", _row, _col];
		_marker setMarkerColor _color;
		if (_color != "ColorBLACK") then {
			_marker setMarkerAlpha 0.5;
			_marker setMarkerBrush "SolidBorder";
		} else {
			_marker setMarkerBrush "Border";
			_marker setMarkerAlpha 1;
		};
	}forEach HEX_GRID;
	
	private _ambience = 0;
	if (_intensity > 3) then {_ambience = 1};
	if (_intensity > 6) then {_ambience = 2};
	HEX_INTENSITY = _ambience;
	publicVariable "HEX_INTENSITY";
};

/// End turn globally
HEX_FNC_TURN = {

	/// Switch turn globally
	private _turn = civilian;
	if (HEX_TURN == west) then {_turn = east};
	if (HEX_TURN == east) then {_turn = west};
	HEX_TURN = _turn;
	
	/// Create new time array
	private _time = HEX_TIME;
	private _oldTime = _time select 0;
	_time deleteat 0;
	_time append [_oldTime];
	HEX_TIME = _time;
	
	/// Create new weather array
	private _weather = HEX_WEATHER;
	private _newWeather = HEX_ALLWEATHER select floor random count HEX_ALLWEATHER;
	_weather deleteAt 0;
	_weather append [_newWeather];
	HEX_WEATHER = _weather;

	publicVariable "HEX_TURN";
	publicVariable "HEX_TIME";
	publicVariable "HEX_WEATHER";
	
	/// Set new weather
	private _overcast = 0;
	private _fog = 0;
	if (_weather select 0 == "CLOUDS") then {_overcast = 0.5};
	if (_weather select 0 == "STORM") then {_overcast = 1};
	if (_weather select 0 == "FOG") then {_fog = 0.33};
	0 setOverCast _overcast;
	0 setFog _fog;
	forceWeatherChange;
	
	/// Set date
	private _now = date;
	private _year = _now select 0;
	private _month = _now select 1;

	if (_oldTime == "DUSK") then {HEX_DAY = HEX_DAY + 1};
	private _day = HEX_DAY;	
	
	private _hour = 0;
	if (HEX_TIME select 0 == "NIGHT") then {_hour = -3 + (floor (random 9))};
	if (HEX_TIME select 0 == "DAWN") then {_hour = 6 + (floor (random 3))}; 
	if (HEX_TIME select 0 == "DAY1") then {_hour = 9 + (floor (random 3))};
	if (HEX_TIME select 0 == "DAY2") then {_hour = 12 + (floor (random 3))};
	if (HEX_TIME select 0 == "DAY3") then {_hour = 15 + (floor (random 3))};
	if (HEX_TIME select 0 == "DUSK") then {_hour = 18 + (floor (random 3))};
	
	private _date = [_year, _month, _day, _hour, 0] call BIS_fnc_fixDate;
	setDate _date;
	
	/// Update grid counter moves;
	{
		private _index = _forEachIndex;
		private _hex = _x;
		private _cfg = _x select 3;
		private _sid = _x select 4;
	
		private _act = 1;
		if (HEX_TURN == _sid) then {
			if (_cfg in ["b_mech_inf", "b_armor", "o_mech_inf", "o_armor", "b_antiair", "o_antiair"]) then {_act = 2};
			if (_cfg in ["b_motor_inf", "b_recon", "o_motor_inf", "o_recon", "b_support", "o_support"]) then {_act = 3};
			_hex set [5, _act];
			HEX_GRID set [_index, _hex];
		};
	}forEach HEX_GRID;
	
	publicVariable "HEX_GRID";
	
	/// Clear local orders, markers and sound
	remoteExec ["HEX_FNC_CLIC", 0, false];
	
	/// Update counters globally
	remoteExec ["HEX_FNC_COTE", 0, false];
	
	/// Initiate tactical phase?
	/// publicVariable "HEX_PHASE";
};