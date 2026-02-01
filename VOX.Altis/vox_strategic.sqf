VOX_LOC_SELECTABLE = [];
VOX_LOC_MODE = "SELECT";
VOX_LOC_SELECTED = [];
VOX_LOC_ORDERS = [];

VOX_FNC_SELECTABLE = {

	private _counters = VOX_CFG_WEST;
	if (side player == east) then {_counters = VOX_CFG_EAST};
	{
		private _seed = _x;
		private _pos = _x select 0;
		if (_x select 3 in _counters && _x select 5 == 0 && VOX_LOC_MODE == "SELECT") then {
			VOX_LOC_SELECTABLE pushback _seed;
			private _marker = createMarkerLocal [format ["LOC_%1", _pos], _pos];
			_marker setMarkerTypeLocal "selector_selectable";
			_marker setMarkerSizeLocal [1.5, 1.5];
		} else {
			private _marker = format ["LOC_%1", _pos];
			deletemarkerLocal _marker;
		};
	}forEach VOX_GRID;
};

VOX_FNC_SELECT = {
	private _pos = _this;
	{
		private _seed = _x;
		if (_pos distance (_x select 0) < VOX_SIZE) then {
			VOX_LOC_MODE = "ORDER";
			VOX_LOC_SELECTED = _seed;
			0 call VOX_FNC_SELECTABLE;
			0 call VOX_FNC_ORDERS;
			0 call VOX_FNC_SOUND;
		};
	}forEach VOX_LOC_SELECTABLE;
};

VOX_FNC_ORDERS = {
	private _selected = VOX_LOC_SELECTED;
	VOX_LOC_ORDERS = [];
	private _neighbors = _selected select 4;
	private _nav = false;
	private _air = false;
	
	if (_selected select 3 in ["b_naval", "o_naval"]) then {_nav = true};
	if (_selected select 3 in ["b_air", "o_air"]) then {_air = true};
	/// [_pos, _cells, _type, _unit, _border, _hasmoved]	
	
	{
		private _seed = _x;
		private _pos = _x select 0;
		private _type = _x select 2;
		if ((_pos in _neighbors or ((_nav && _type == "NAV") or (_air && _type == "AIR"))) && _seed select 3 == "hd_dot") then {
			VOX_LOC_ORDERS pushback _seed;
		} else {
			private _marker = format ["LOC_%1", _pos];
			deletemarkerLocal _marker;
		};
	}forEach VOX_GRID;
	
	{
		private _pos = _x select 0;
		private _marker = createMarkerLocal [format ["LOC_%1", _pos], _pos];
		_marker setMarkerTypeLocal "selector_selectedMission";
		_marker setMarkerSizeLocal [1.5, 1.5];
	}forEach VOX_LOC_ORDERS;
	
	private _posMarker = VOX_LOC_SELECTED select 0;
	private _marker = createMarkerLocal ["LOC_SELECT", _posMarker];
	_marker setMarkerTypeLocal "selector_selectedEnemy";
	_marker setMarkerSizeLocal [1.5, 1.5];
	
	VOX_LOC_MODE = "ORDER";
};

VOX_FNC_ORDER = {
	private _pos = _this;
	{
		private _seed = _x;
		private _pos2 = _seed select 0;
		if (_pos distance _pos2 < VOX_SIZE) then {
			[VOX_LOC_SELECTED, _seed] remoteExec ["VOX_FNC_MOVE", 2];
		};
		
		private _marker = format ["LOC_%1", _pos2];
		deleteMarkerLocal _marker;
		
	}forEach VOX_LOC_ORDERS;
	
	deleteMarkerLocal "LOC_SELECT";
	0 call VOX_FNC_SOUND;
	VOX_LOC_MODE = "SELECT";
};

openMap true;
0 call VOX_FNC_SELECTABLE;


while {VOX_PHASE == "STRATEGIC"} do {
	sleep 0.1;
	if (VOX_TURN == side player && VOX_LOC_COMMANDER) then {
		onMapSingleClick {
			if (VOX_LOC_MODE == "SELECT") then {
				_pos spawn VOX_FNC_SELECT;
			};
			if (VOX_LOC_MODE == "ORDER") then {
				_pos spawn VOX_FNC_ORDER;
			};
			true;
		};
	};
};
