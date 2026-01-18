/// Spawn groups on server (variable in group)

HEX_OBJECTIVES_WEST = [];
HEX_OBJECTIVES_NEUT = [];
HEX_OBJECTIVES_EAST = [];

/// add neutral objectives

{
	private _hex = _x;
	private _sid = _x select 4;
	if (_sid == resistance) then {HEX_OBJECTIVES_NEUT pushback _hex};
}forEach HEX_GRID;

/// TODO: remove all other (grid?) markers

{
	private _hex = _x;
	private _row = _x select 0;
	private _col = _x select 1;
	private _pos = _x select 2;
	private _type = _x select 3;
	private _side = _x select 4;
	private _state = _x select 6;
	
	private _factions = [HEX_WEST];
	if (_side == east) then {_factions = [HEX_EAST]};
	
	/// add to objectives
	if (_side == west) then {HEX_OBJECTIVES_WEST pushback _hex};
	if (_side == east) then {HEX_OBJECTIVES_EAST pushback _hex};
	
	/// get platoon size
	private _size = 3;
	if (_side == west) then {_size = HEX_PLTW};
	if (_side == east) then {_size = HEX_PLTE};
	
	if (_type in ["b_inf", "o_inf"]) then {_size = 5};
	
	private _armor = false;
	private _icons = ["\A3\ui_f\data\map\markers\nato\b_inf.paa", "\A3\ui_f\data\map\markers\nato\n_inf.paa", "\A3\ui_f\data\map\markers\nato\o_inf.paa"];	
	if (_type in ["b_recon", "o_recon"]) then {_icons = ["\A3\ui_f\data\map\markers\nato\b_recon.paa", "\A3\ui_f\data\map\markers\nato\n_recon.paa", "\A3\ui_f\data\map\markers\nato\o_recon.paa"]};	
	if (_type in ["b_motor_inf", "o_motor_inf"]) then {_icons = ["\A3\ui_f\data\map\markers\nato\b_motor_inf.paa", "\A3\ui_f\data\map\markers\nato\n_motor_inf.paa", "\A3\ui_f\data\map\markers\nato\o_motor_inf.paa"]};
	if (_type in ["b_mech_inf", "o_mech_inf"]) then {_icons = ["\A3\ui_f\data\map\markers\nato\b_mech_inf.paa", "\A3\ui_f\data\map\markers\nato\n_mech_inf.paa", "\A3\ui_f\data\map\markers\nato\o_mech_inf.paa"]};
	if (_type in ["b_armor", "o_armor"]) then {_armor = true; _icons = ["\A3\ui_f\data\map\markers\nato\b_armor.paa", "\A3\ui_f\data\map\markers\nato\n_armor.paa", "\A3\ui_f\data\map\markers\nato\o_armor.paa"]};
	
	private _groupsAndWeights = [_factions, _icons] call HEX_SRV_FNC_GROUPS;
	private _weights = [];
	private _groups = [];
	
	{
		_weights pushback (_x select 0);
		_groups pushback (_x select 1);
	}ForEach _groupsAndWeights;
	
	for "_i" from 1 to _size do {
		private _select = _groups selectRandomWeighted _weights;
		private _config = "true" configClasses _select;
		if (_armor) then {_config = [_config select 0]};
	
		private _group = [_pos, _side, _config, _type] call HEX_FNC_SRV_SPAWNGROUP;
		_group setVariable ["HEX_ICON", _type, true];
		_group setVariable ["HEX_ID", [_row, _col, _i], true];
	};

	/// remove groups from pool

}forEach HEX_TACTICAL;

{
	private _row = _x select 0;
	private _col = _x select 1;
	private _pos = _x select 2;
	private _type = _x select 3;
	private _side = _x select 4;
	private _count = 1;
	
	private _factions = [HEX_WEST];
	if (_side == east) then {_factions = [HEX_EAST]};
	private _configs = [_factions, _type] call HEX_SRV_FNC_VEHICLES;
	
	private _select = _configs select floor random count _configs;
	private _group = [_pos, _side, _select] call HEX_FNC_SRV_SPAWNVEHICLE;
	_group setVariable ["HEX_ICON", _type, true];
	_group setVariable ["HEX_ID", [_row, _col, 1], true];
	
	/// remove unit from pool
}forEach HEX_STRATEGIC;

/// performacne testing

private _testWest = west call HEX_LOC_FNC_GROUPS;
{
	private _rand = ceil random 2;

	private _obj = HEX_OBJECTIVES_WEST select floor random count HEX_OBJECTIVES_WEST;

	if (_rand == 2) then {
		_obj = HEX_OBJECTIVES_EAST select floor random count HEX_OBJECTIVES_EAST;
	};
	
	private _pos = _obj select 2;
	private _wp = _x addWaypoint [_pos, HEX_SIZE / 3];
}forEach _testWest;

private _testEast = east call HEX_LOC_FNC_GROUPS;
{
	private _rand = ceil random 2;

	private _obj = HEX_OBJECTIVES_EAST select floor random count HEX_OBJECTIVES_EAST;

	if (_rand == 2) then {
		_obj = HEX_OBJECTIVES_WEST select floor random count HEX_OBJECTIVES_WEST;
	};
	
	private _pos = _obj select 2;
	private _wp = _x addWaypoint [_pos, HEX_SIZE / 3];
}forEach _testEast;

{
	private _unit = _x;
	if (side _unit == west && HEX_SINGLEPLAYER) then {addSwitchableUnit _unit};
}forEach AllUnits;

{
	private _row = _x select 0;
	private _col = _x select 1;
	private _pos = _x select 2;
	private _name = format ["HEX_OBJ_%1_%2", _row, _col];
	private _marker = createMarker [_name, _pos];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerColor "ColorBLUFOR";
	_marker setMarkerSize [HEX_SIZE / 3, HEX_SIZE / 3];
} forEach HEX_OBJECTIVES_WEST;

{
	private _row = _x select 0;
	private _col = _x select 1;
	private _pos = _x select 2;
	private _name = format ["HEX_OBJ_%1_%2", _row, _col];
	private _marker = createMarker [_name, _pos];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerColor "ColorOPFOR";
	_marker setMarkerSize [HEX_SIZE / 3, HEX_SIZE / 3];
} forEach HEX_OBJECTIVES_EAST;

/// Spawn Capture points on server (name after counter)
/// TODO: CAPTURE points
/// PRIMARY CAPTURE POINT / SPAWN = 1/2 radius of HEX_SIZE - at centre
/// SECONDARY CAPTURE POINT(S) = 1/4 radius of HEX_SIZE - on location(s) in HEX_SIZE radius from centre

/// Start 1h counter, call debriefing after
/// if all groups killed / all points captured:
/// stop counter short of time

HEX_PHASE = "TACTICAL";
publicVariable "HEX_PHASE";

/// Close tactical briefing locally
remoteExec ["HEX_LOC_FNC_CLOSEBRIEFING", 2, false];

/// Open Slotting menu locally with JIP
remoteExec ["HEX_LOC_FNC_SLOTTING", 0, true];