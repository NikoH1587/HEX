VOX_FNC_DRAWMARKERS = {
	{
		private _pos = _x select 0;
		private _unit = _x select 3;
		private _move = _x select 5;
		
		private _name = format ["VOX_%1", _pos];
		deleteMarker _name;
		
		if (_unit != "hd_dot") then {
			private _marker = createMarker [_name, _pos];
			_marker setMarkerType _unit;
			if (_move == 1) then {_marker setMarkerAlpha 0.75};
		};
	}forEach VOX_GRID;
};

VOX_FNC_MOVE = {
	private _old = _this select 0;
	private _new = _this select 1;
	
	private _indexOld = VOX_GRID find _old;
	private _indexNew = VOX_GRID find _new;
	
	/// [_pos, _cells, _type, _unit, _border, _hasmoved]
	VOX_GRID set [_indexOld, [_old select 0, _old select 1, _old select 2, "hd_dot", _old select 4, 0]];
	VOX_GRID set [_indexNew, [_new select 0, _new select 1, _new select 2, _old select 3, _new select 4, 1]];	
	
	/// re-draw markers
	0 call VOX_FNC_DRAWMARKERS;
};

VOX_FNC_SOUND = {
	private _sounds = [
		"a3\dubbing_radio_f\sfx\in2a.ogg",
		"a3\dubbing_radio_f\sfx\in2b.ogg",
		"a3\dubbing_radio_f\sfx\in2c.ogg",
		"a3\dubbing_radio_f\sfx\out2a.ogg",
		"a3\dubbing_radio_f\sfx\out2b.ogg",
		"a3\dubbing_radio_f\sfx\out2c.ogg"
	];
	
	private _sound = _sounds select floor random count _sounds;
	playSoundUI [_sound, 1, random 1];	
};