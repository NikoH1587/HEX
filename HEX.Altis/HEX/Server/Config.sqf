///HEX_GRID pushBack [[_row, _col], _name, [_x,_y], "Border", "ColorBLACK", []]
HEX_TITLE = "HEX: Campaign Generator";
HEX_AUTHOR = "Made by Kosmokainen";
HEX_VERSION = "Version 1.0";
HEX_DESCRIPTION = ["Description 1", "Description 2", "Description n"];
HEX_GRID = [];
HEX_SCENARIO = "W"; // N, E, S, W
HEX_PHASE = "STRATEGIC";
HEX_WEATHER = ["CLEAR", "CLOUDS", "STORM", "FOG"];
HEX_TIME = ["DAWN", "DAY", "DUSK", "NIGHT"];
HEX_SIZE = 750;
HEX_GROUPS = 6;
HEX_VEHICLES = 2;
HEX_EVEN = [[0,-1],[1,-1],[1,0],[0,1],[-1,0],[-1,-1]];
HEX_ODD = [[0,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0]];
HEX_TURN = west;
HEX_WEST = "BLU_F";
HEX_EAST = "OPF_F";
HEX_INTENSITY = 0; /// Strategic ambient sounds 0, 1, 2

HEX_SOUNDS = [
"a3\dubbing_radio_f\sfx\in2a.ogg",
"a3\dubbing_radio_f\sfx\in2b.ogg",
"a3\dubbing_radio_f\sfx\in2c.ogg",
"a3\dubbing_radio_f\sfx\out2a.ogg",
"a3\dubbing_radio_f\sfx\out2b.ogg",
"a3\dubbing_radio_f\sfx\out2c.ogg"
];

HEX_RADIO = [
"a3\dubbing_radio_f\sfx\radionoise1.ogg",
"a3\dubbing_radio_f\sfx\radionoise2.ogg",
"a3\dubbing_radio_f\sfx\radionoise3.ogg"
];

HEX_AMBIENT = [
"a3\sounds_f\sfx\radio\ambient_radio1.wss",
"a3\sounds_f\sfx\radio\ambient_radio10.wss",
"a3\sounds_f\sfx\radio\ambient_radio11.wss",
"a3\sounds_f\sfx\radio\ambient_radio12.wss",
"a3\sounds_f\sfx\radio\ambient_radio13.wss",
"a3\sounds_f\sfx\radio\ambient_radio14.wss",
"a3\sounds_f\sfx\radio\ambient_radio15.wss",
"a3\sounds_f\sfx\radio\ambient_radio16.wss",
"a3\sounds_f\sfx\radio\ambient_radio17.wss",
"a3\sounds_f\sfx\radio\ambient_radio18.wss",
"a3\sounds_f\sfx\radio\ambient_radio19.wss",
"a3\sounds_f\sfx\radio\ambient_radio2.wss",
"a3\sounds_f\sfx\radio\ambient_radio20.wss",
"a3\sounds_f\sfx\radio\ambient_radio21.wss",
"a3\sounds_f\sfx\radio\ambient_radio22.wss",
"a3\sounds_f\sfx\radio\ambient_radio23.wss",
"a3\sounds_f\sfx\radio\ambient_radio24.wss",
"a3\sounds_f\sfx\radio\ambient_radio25.wss",
"a3\sounds_f\sfx\radio\ambient_radio26.wss",
"a3\sounds_f\sfx\radio\ambient_radio27.wss",
"a3\sounds_f\sfx\radio\ambient_radio28.wss",
"a3\sounds_f\sfx\radio\ambient_radio29.wss",
"a3\sounds_f\sfx\radio\ambient_radio3.wss",
"a3\sounds_f\sfx\radio\ambient_radio30.wss",
"a3\sounds_f\sfx\radio\ambient_radio4.wss",
"a3\sounds_f\sfx\radio\ambient_radio5.wss",
"a3\sounds_f\sfx\radio\ambient_radio6.wss",
"a3\sounds_f\sfx\radio\ambient_radio7.wss",
"a3\sounds_f\sfx\radio\ambient_radio8.wss",
"a3\sounds_f\sfx\radio\ambient_radio9.wss",
"a3\sounds_f\sfx\ui\uav\uav_01.wss",
"a3\sounds_f\sfx\ui\uav\uav_02.wss",
"a3\sounds_f\sfx\ui\uav\uav_03.wss",
"a3\sounds_f\sfx\ui\uav\uav_04.wss",
"a3\sounds_f\sfx\ui\uav\uav_05.wss",
"a3\sounds_f\sfx\ui\uav\uav_06.wss",
"a3\sounds_f\sfx\ui\uav\uav_07.wss",
"a3\sounds_f\sfx\ui\uav\uav_08.wss",
"a3\sounds_f\sfx\ui\uav\uav_09.wss",
"a3\sounds_f\sfx\ui\uav\uav_loop.wss"
];

HEX_COMBAT = [
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight1.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight2.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight3.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight4.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight1.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight2.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight3.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight4.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight1.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight2.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight3.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_firefight4.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions1.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions2.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions3.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions4.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions5.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions1.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions2.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions3.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions4.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_explosions5.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_heli1.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_heli2.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_heli3.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_jet1.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_jet2.wss",
"a3\sounds_f\environment\ambient\battlefield\battlefield_jet3.wss"
];

/// MAX 15+15 counters?
HEX_CFG_WEST = ["b_hq", "b_art", "b_support", "b_air", "b_plane", "b_antiair", "b_inf", "b_unknown", "b_recon", "b_motor_inf", "b_mech_inf", "b_armor"];
HEX_CFG_EAST = ["o_hq", "o_art", "o_support", "o_air", "o_plane", "o_antiair", "o_inf", "o_unknown", "o_recon", "o_motor_inf", "o_mech_inf", "o_armor"];
