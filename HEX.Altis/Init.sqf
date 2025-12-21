call compile preprocessFile "HEX\Global\Functions.sqf";

if (isServer) then {
	call compile preprocessFile "HEX\Server\Config.sqf";
	call compile preprocessFile "HEX\Server\Grid.sqf";
};

sleep 1;
removeSwitchableUnit OFFICER_EAST;
removeSwitchableUnit LEADER_EAST;
removeSwitchableUnit SOLDIER_EAST;
///teamSwitch;
call compile preprocessFile "HEX\Local\Strategic.sqf";
call compile preprocessFile "HEX\Local\Ambient.sqf";

///[] call BIS_fnc_jukebox; /// maybe add this at start of tactical phase?

/// Zero Menu:
/// Title, Author, Version
/// Cool picture?
/// Description List
/// "WAITING FOR HOST" text?

/// First Menu:
/// Title, Author, Version
/// Cool picture?
/// Continue Campaign / Default Campaign
/// New Campaign

/// Second Menu:
/// West / East faction
/// Current West / Selectable West
/// Current East / Selectable East
/// Scenario Direction
/// First Turn West/East
/// Experimental toggle
/// "START CAMPAIGN"

/// Third Menu:
/// Turn info
/// End Turn
/// Time
/// Weather forecast

/// Fourth menu:
/// Tactical Briefing

/// Fifth menu:
/// Tactical Debriefing

/// Player respawn:
/// Create respawn west/ respawn east markers
/// Store loadout locally 
/// Set loadout from local storage (in mp)

/// Sources used: 
/// https://www.youtube.com/watch?v=kDFAHoxdL4Y&list=PLrFF_4LjPgISFZ6TzRi82O153ZQp5H-TJ