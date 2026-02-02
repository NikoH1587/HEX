/// VOX: Operations Generator

/// local
VOX_LOC_COMMANDER = true;

/// global functions
private _functions = execVM "vox_functions.sqf";
waitUntil {scriptDone _functions};

if (isServer) then {
	private _default = execVM "vox_default.sqf";
	waitUntil {scriptDone _default};
	private _generate = execVM "vox_generate.sqf";
	waitUntil {scriptDone _generate};
	["vox_strategic.sqf"] remoteExec ["execVM"]
};