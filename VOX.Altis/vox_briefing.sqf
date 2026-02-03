waitUntil {!isNil "VOX_ATTACKER"};
waitUntil {!isNil "VOX_DEFENDER"};

private _posA = VOX_ATTACKER select 0;
private _posB = VOX_DEFENDER select 0;
private _posC = [(((_posA select 0) + (_posB select 0)) / 2),(((_posA select 1) + (_posB select 1)) / 2)];
mapAnimAdd [0, 0.2, _posC];
mapAnimCommit;

if (VOX_DEBUG) then {
	private _polyline = [_posA select 0, _posA select 1, _posB select 0, _posB select 1];
	private _marker = createMarker [format ["VOX_%1_%2", _posA, _posB], _posA];
	_marker setMarkerPolyline _polyline;
};

/// objective marker
if (isServer) then {
	private _posA = VOX_ATTACKER select 0;
	private _posD = VOX_DEFENDER select 0;
	
};

/// radio effect for briefing;
0 call VOX_FNC_RADIO;

VOX_FNC_ENDBRIEFING = {
	if (isServer) then {
		VOX_PHASE = "TACTICAL";
		publicVariable "VOX_PHASE";
		execVM "vox_tactical.sqf";
	};
};

/// Open briefing menu
[] spawn {
	private _open = false;
	while {VOX_PHASE == "BRIEFING"} do {
		if (visibleMap && !_open) then {
			_open = true;
			(findDisplay 46) createDisplay "VOX_BRIEFING";
			private _menu = findDisplay 1400;
			private _info = _menu displayCtrl 1401;
			private _start = _menu displayCtrl 1402;
			
			/// Info text backround
			private _color = [0, 0.3, 0.6, 0.5];
			if (playerSide == east) then {
				_color = [0.5, 0, 0, 0.5];
			};

			_info ctrlSetBackgroundColor _color;

			_info lbAdd "TACTICAL BRIEFING:";
			_info lbAdd "";
			_info lbAdd "Available supports can be accessed with radio (8 -> 0)";
			_info lbAdd "'Command Group' leader has High Command Module (Ctrl+Space)";
			
			/// Start button text
			if (isServer) then {
				_start ctrlSetText "COMMENCE BATTLE";
			} else {
				_start ctrlSetText "WAITING HOST...";
			};
		};
		
		/// make sure menu doesn't close if map is closed
		if (!visibleMap && _open) then {
			(findDisplay 1400) closedisplay 1;
			_open = false;
			openmap true;
		};
		
		sleep 1;
	};
};