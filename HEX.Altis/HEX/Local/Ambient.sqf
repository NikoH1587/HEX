/// Intensity:
/// 0: Occasional radio chatter
/// 1: Occasional radio & Combat
/// 2: Constant radio & Constant combat

/// Play ambient radio sounds
0 spawn {
	while {HEX_PHASE == "STRATEGIC"} do {
		private _random = random 30;
		if (HEX_INTENSITY == 1) then {_random = random 20};
		if (HEX_INTENSITY == 2) then {_random = random 10};
	
		sleep 10; /// Delay because of radio message lenght
		
		private _ambient = HEX_AMBIENT select floor random count HEX_AMBIENT;
		playSoundUI [_ambient, 0.1];
		sleep _random;
	}
};

/// play ambient combat sounds
0 spawn {
	while {HEX_PHASE == "STRATEGIC"} do {
		private _random = random 20;
		if (HEX_INTENSITY == 2) then {_random = random 10};
		
		if (HEX_INTENSITY != 0) then {
			private _combat = HEX_COMBAT select floor random count HEX_COMBAT;
			playSoundUI [_combat, 0.1];
		};
		sleep _random;
	};
};
