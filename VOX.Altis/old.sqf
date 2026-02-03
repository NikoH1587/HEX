/// create area markers
{
	private _pos = _x select 0;
	private _cells = _x select 1;
	private _type = _x select 2;
	
	private _color = [0, 0, 0];
	private _edges = _cells call _fnc_edgeCells;
	switch (_type) do {
		case "NAV": {_color = [0.5, 0.5, 0.5]};
		case "AIR": {_color = [1, 1, 1]};
	};
	
	private _cellsDXY = [];
	private _prevX = 0;
	private _prevY = 0;
	
	{
		private _row = _x select 0;
		private _col = _x select 1;
		if (_x in _edges) then {
			private _posX = (_col * VOX_SIZE) + VOX_SIZE / 2;
			private _posY = (_row * VOX_SIZE) + VOX_SIZE / 2;
			private _dir = _pos getDir [_posX, _posY];
			_cellsDXY pushback [_dir, _posX, _posY];
		};
	}forEach _cells;
	
	_cellsDXY sort true;
	private _polyline = [];
	{
		_polyline pushback (_x select 1);
		_polyline pushback (_x select 2);		
	}forEach _cellsDXY;
	
	private _marker = createMarker [format ["POL_%1", _pos], _pos];
	_marker setMarkerShape "Polyline";
	_marker setMarkerPolyline _polyline;	
	
}forEach VOX_GRID;