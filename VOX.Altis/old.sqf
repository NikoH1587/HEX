VOX_SIZE = 500;
VOX_GND = [];
VOX_NAV = [];
VOX_AIR = [];

private _locs = nearestLocations [[worldSize / 2, worldSize / 2], ["Hill", "NameCityCapital", "NameCity", "NameVillage", "NameLocal"], worldSize];

{
	private _pos = [round (position _x select 0), round (position _x select 1)];
	VOX_GROUND pushback [_pos, [random 1, random 1, random 1], [], []]; /// [_pos, _color, _cells, _nearSeeds]
}forEach _locs;

private _locs2 = nearestLocations [[worldSize / 2, worldSize / 2], ["NameMarine"], worldSize];
{
	private _pos = [round (position _x select 0), round (position _x select 1)];
	VOX_WATER pushback [_pos, [random 1, random 1, random 1], [], []]; /// [_pos, _color, _cells, _nearSeeds]
}forEach _locs2;

private _airMarkers = allMapMarkers select {_x select [0, 4] == "AIR_"};

{
	private _pos = [round (getmarkerpos _x select 0), round (getmarkerpos _x select 1)];
	VOX_AIR pushback [_pos, [random 1, random 1, random 1], [], []]; /// [_pos, _color, _cells, _nearSeeds]
} forEach _airMarkers;

_fnc_nearest = {
	private _pos = _this select 0;
	private _grid = _this select 1;
	
	private _nearest = _grid select 0;
	private _minDist = _pos distance2D (_nearest select 0);
	
	{
		private _d = _pos distance2D (_x select 0);
		if (_d < _minDist) then {
			_minDist = _d;
			_nearest = _x;
		};
	}forEach _grid;
	
	_nearest
};

for "_col" from 0 to round(worldSize / VOX_SIZE) do {
    for "_row" from 0 to round(worldSize / VOX_SIZE) do {
	
		private _pos = [_col * VOX_SIZE, _row * VOX_SIZE];
		if (surfaceIsWater _pos) then {continue};
		
		private _nearest = [_pos, VOX_GROUND] call _fnc_nearest;

		(_nearest select 2) pushback [_row, _col];
		
		private _marker = createMarker [format ["VOX1_%1_%2", _row, _col], _pos];
		_marker setMarkerShape "RECTANGLE";
		_marker setMarkerBrush "Grid";
		_marker setMarkerSize [VOX_SIZE / 2, VOX_SIZE / 2];
		private _color = _nearest select 1;
		_marker setMarkerColor (format ["#(%1,%2,%3,1)", _color select 0, _color select 1, _color select 2]);
    };
};

for "_col" from 0 to round(worldSize / VOX_SIZE) do {
    for "_row" from 0 to round(worldSize / VOX_SIZE) do {
	
		private _pos = [_col * VOX_SIZE, _row * VOX_SIZE];
		if !(surfaceIsWater _pos) then {continue};
		
		private _nearest = [_pos, VOX_WATER] call _fnc_nearest;

		(_nearest select 2) pushback [_row, _col];
		
		private _marker = createMarker [format ["VOX2_%1_%2", _row, _col], _pos];
		_marker setMarkerShape "RECTANGLE";
		_marker setMarkerBrush "Cross";
		_marker setMarkerSize [VOX_SIZE / 2, VOX_SIZE / 2];
		private _color = _nearest select 1;
		_marker setMarkerColor (format ["#(%1,%2,%3,1)", _color select 0, _color select 1, _color select 2]);
    };
};

_fnc_edgeCells = {
	private _seed = _this;
	private _seedPos = _seed select 0;
	private _cells = _seed select 2;
	
	private _edges = [];
	
	private _dirs = [[-1, 0],[1, 0],[0, -1],[0, 1]];
	
	{
		private _cell = _x;
		private _row = _x select 0;
		private _col = _x select 1;
		private _isEdge = false;
		
		{
			private _nRow = _row + (_x select 0);
			private _nCol = _col + (_x select 1);
			private _nPos = [_nCol * VOX_SIZE, _nRow * VOX_SIZE];
			
			if (_nCol < 0 or _nRow < 0 or surfaceIsWater _nPos) exitWith {
				_isEdge = true;
			};		
			
			if (_cells find [_nRow, _nCol] == -1) exitWith {
				_isEdge = true;
			};
		}forEach _dirs;
		
		if (_isEdge) then {
			_edges pushBack _cell;
		};
	}forEach _cells;
	
	_edges
};

/// mark edges
{
	private _edges = _x call _fnc_edgeCells;
	{
		private _row = _x select 0;
		private _col = _x select 1;
		private _marker = format ["VOX1_%1_%2", _row, _col];
		_marker setMarkerAlpha 1;
	}forEach _edges;
	
}forEach VOX_GROUND;

/////////////
/////////////


/// VOX: Operations Generator

VOX_SIZE = 1000;
VOX_DEBUG = true;
VOX_GRID = [];

private _civMarkers = allMapMarkers select {_x select [0, 4] == "CIV_" or _x select [0, 4] == "LOG_"};
private _navMarkers = allMapMarkers select {_x select [0, 4] == "NAV_"};
private _airMarkers = allMapMarkers select {_x select [0, 4] == "AIR_" or _x select [0, 4] == "HEL_"};

/// [_pos, _cells, _nav, _air, _civs]

{VOX_GRID pushback [getMarkerPos _x, [], [], [], []];}forEach _civMarkers;

_fnc_nearest = {
	private _pos = _this;
	
	private _nearest = VOX_GRID select 0;
	private _minDist = _pos distance2D (_nearest select 0);
	
	{
		private _d = _pos distance2D (_x select 0);
		if (_d < _minDist) then {
			_minDist = _d;
			_nearest = _x;
		};
	}forEach VOX_GRID;
	
	_nearest
};

/// create grid
for "_col" from 0 to round(worldSize / VOX_SIZE) do {
    for "_row" from 0 to round(worldSize / VOX_SIZE) do {
	
		private _pos = [(_col * VOX_SIZE) + VOX_SIZE / 2, (_row * VOX_SIZE) + VOX_SIZE / 2];
		if (surfaceIsWater _pos) then {continue}; /// skip water
		
		private _nearest = _pos call _fnc_nearest;

		(_nearest select 1) pushback [_row, _col];
    };
};

/// connect NAVs to nearest CIV
{
	private _pos1 = getmarkerPos _x;

	private _nearest = _pos1 call _fnc_nearest;
	(_nearest select 2) pushback _pos1;
	private _pos2 = _nearest select 0;

	if (VOX_DEBUG) then {
		private _polyline = [_pos1 select 0, _pos1 select 1, _pos2 select 0, _pos2 select 1];
		private _marker = createMarker [format ["NAV_%1", _pos1], _pos1];
		_marker setMarkerPolyline _polyline;
	};
}forEach _navMarkers;

/// connect AIRs to nearest CIV
{
	private _pos1 = getmarkerPos _x;

	private _nearest = _pos1 call _fnc_nearest;
	(_nearest select 3) pushback _pos1;
	private _pos2 = _nearest select 0;
	private _polyline = [_pos1 select 0, _pos1 select 1, _pos2 select 0, _pos2 select 1];
	
	if (VOX_DEBUG) then {
		private _marker = createMarker [format ["AIR_%1", _pos1], _pos1];
		_marker setMarkerPolyline _polyline;
	};
}forEach _airMarkers;

_fnc_edgeCells = {
	private _cells = _this;
	
	private _edges = [];
	private _dirs = [[-1, 0],[1, 0],[0, -1],[0, 1]];
	
	{
		private _cell = _x;
		private _row = _x select 0;
		private _col = _x select 1;
		private _isEdge = false;
		
		{
			private _nRow = _row + (_x select 0);
			private _nCol = _col + (_x select 1);
			private _nPos = [_nCol * VOX_SIZE, _nRow * VOX_SIZE];
			
			if (_nCol < 0 or _nRow < 0 or surfaceIsWater _nPos) exitWith {
				_isEdge = true;
			};		
			
			if (_cells find [_nRow, _nCol] == -1) exitWith {
				_isEdge = true;
			};
		}forEach _dirs;
		
		if (_isEdge) then {
			_edges pushBack _cell;
		};
	}forEach _cells;
	
	_edges
};

/// create area markers
{
	private _color = [random 1, random 1, random 1];
	private _cells = _x select 1;
	{
		private _row = _x select 0;
		private _col = _x select 1;
		private _pos = [(_col * VOX_SIZE) + VOX_SIZE / 2, (_row * VOX_SIZE) + VOX_SIZE / 2];
		private _marker = createMarker [format ["VOX_%1_%2", _row, _col], _pos];
		_marker setMarkerShape "RECTANGLE";
		_marker setMarkerBrush "Solid";
		_marker setMarkerSize [VOX_SIZE / 2, VOX_SIZE / 2];
		_marker setMarkerColor (format ["#(%1,%2,%3,1)", _color select 0, _color select 1, _color select 2]);
	}forEach _cells;
}forEach VOX_GRID;

/// get nearby cells
/// get find cells in seeds
/// get seed

_fnc_findSeeds = {
	private _row = _x select 0;
	private _col = _x select 1;
	private _dirs = [[-1, 0],[1, 0],[0, -1],[0, 1]];
	private _seeds = [];
	{
		private _nRow = _row + (_x select 0);
		private _nCol = _col + (_x select 1);
		{
			private _seedPos = _x select 0;
			private _cells = _x select 1;
			private _find = _cells find [_nRow, _nCol];
			if (_find != -1) then {
				_seeds pushBackUnique _seedPos;
			};
		}forEach VOX_GRID;
	}forEach _dirs;
	
	_seeds
};

{	
	private _pos = _x select 0;
	private _cells = _x select 1;
	private _seeds = [];
	private _edges = (_x select 1) call _fnc_edgeCells;
	
	{
		private _cellSeeds = _x call _fnc_findSeeds;
		{
			private _seed = _x;
			if !(_seed isEqualTo _pos) then {
				_seeds pushBackUnique _seed;
			};
		}forEach _cellSeeds;
	}forEach _edges;
	
	{
		if (VOX_DEBUG) then {
			private _polyline = [_pos select 0, _pos select 1, _x select 0, _x select 1];
			private _marker = createMarker [format ["CIV_%1_%2", _pos, _x], _x];
			_marker setMarkerPolyline _polyline;	
			_marker setMarkerColor "ColorWHITE";
		};
	}forEach _seeds;
}forEach VOX_GRID;