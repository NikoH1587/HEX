waitUntil {!isNil "VOX_COMBAT"};
private _attacker = VOX_COMBAT select 0;
private _defender = VOX_COMBAT select 1;

private _posA = _attacker select 0;
private _posB = _defender select 0;
private _posC = [(((_posA select 0) + (_posB select 0)) / 2),(((_posA select 1) + (_posB select 1)) / 2)];
mapAnimAdd [0, 0.1, _posC];
mapAnimCommit;

if (VOX_DEBUG) then {
	private _polyline = [_posA select 0, _posA select 1, _posB select 0, _posB select 1];
	private _marker = createMarker [format ["VOX_%1_%2", _posA, _posB], _posA];
	_marker setMarkerPolyline _polyline;
};

_fnc_drawmarkers = {
		private _pos = _this select 0;
		private _cells = _this select 1;
		private _unit = _this select 3;
		
		private _name = format ["VOX_%1", _pos];
		private _marker = createMarker [_name, _pos];
		_marker setMarkerType _unit;
		_marker setMarkerSize [1.5, 1.5];
		
		private _color = "ColorBLUFOR";
		if (_unit select [0,1] == "o") then {_color = "ColorOPFOR"};
		
		{
			private _row = _x select 0;
			private _col = _x select 1;
			private _pos2 = [(_col * VOX_SIZE) + VOX_SIZE / 2, (_row * VOX_SIZE) + VOX_SIZE / 2];
			private _marker2 = createMarker [format ["VOX_%1_%2", _row, _col], _pos2];
			_marker2 setMarkerShape "RECTANGLE";
			_marker2 setMarkerBrush "Solid";
			_marker2 setMarkerSize [VOX_SIZE / 2, VOX_SIZE / 2];
			_marker2 setMarkerColor _color;
			_marker2 setMarkerAlpha 0.5;
		}forEach _cells
};

/// draw objectives
if (isServer) then {
	(VOX_COMBAT select 0) call _fnc_drawmarkers;
	(VOX_COMBAT select 1) call _fnc_drawmarkers;
};

/// radio effect for briefing;
0 call VOX_FNC_RADIO;