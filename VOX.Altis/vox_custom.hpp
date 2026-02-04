class VOX_CUSTOM
{
	idd = 1200;

	class ControlsBackground
	{
		class Background : RscText
		{
			idc = -1;
			x = safeZoneX;
			y = safeZoneY;
			w = safeZoneW;
			h = safeZoneH;
			colorBackground[] = {0.1,0.1,0.1,1};
		};
	};

	class Controls
	{		
		class formation: RscCombo
		{
			idc = 1201;
			x = GUI_GRID_CENTER_X + 0 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 0 * GUI_GRID_CENTER_H;
			w = 20 * GUI_GRID_CENTER_W;
			h = 2 * GUI_GRID_CENTER_H;
			onLBSelChanged = "(_this select 1) call VOX_FNC_FORMATION";
			rowHeight = 1.5 * GUI_GRID_CENTER_H;
			tooltip = "Configure formations. (Click on list to remove group)";
		};			
		
		class for_list: RscListbox
		{
			idc = 1202;
			x = GUI_GRID_CENTER_X + 0 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 2 * GUI_GRID_CENTER_H;
			w = 20 * GUI_GRID_CENTER_W;
			h = 12 * GUI_GRID_CENTER_H;
			onLBSelChanged = "(_this select 1) call VOX_FNC_DELCFG";
			rowHeight = 1.5 * GUI_GRID_CENTER_H;
		};
		
		class faction: RscCombo
		{
			idc = 1203;
			x = GUI_GRID_CENTER_X + 20 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 0 * GUI_GRID_CENTER_H;
			w = 20 * GUI_GRID_CENTER_W;
			h = 2 * GUI_GRID_CENTER_H;
			onLBSelChanged = "(_this select 1) call VOX_FNC_FACTION";
			rowHeight = 1.5 * GUI_GRID_CENTER_H;
			tooltip = "Click on list to add groups, recommended 10-15.";
		};	
		
		class cfg_list: RscListbox
		{
			idc = 1204;
			x = GUI_GRID_CENTER_X + 20 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 2 * GUI_GRID_CENTER_H;
			w = 20 * GUI_GRID_CENTER_W;
			h = 12 * GUI_GRID_CENTER_H;
			onLBSelChanged = "(_this select 1) call VOX_FNC_ADDCFG";
			rowHeight = 1.5 * GUI_GRID_CENTER_H;
		};
		
		class blufor: RscCombo
		{
			idc = 1205;
			x = GUI_GRID_CENTER_X + 0 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 14 * GUI_GRID_CENTER_H;
			w = 10 * GUI_GRID_CENTER_W;
			h = 2 * GUI_GRID_CENTER_H;
			onLBSelChanged = "(_this select 1) call VOX_FNC_ADDWEST";
			rowHeight = 1.5 * GUI_GRID_CENTER_H;
			tooltip = "Add formation to BLUFOR side.";
		};

		class blu_list: RscListbox
		{
			idc = 1206;
			x = GUI_GRID_CENTER_X + 0 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 16 * GUI_GRID_CENTER_H;
			w = 10 * GUI_GRID_CENTER_W;
			h = 9 * GUI_GRID_CENTER_H;
			onLBSelChanged = "(_this select 1) call VOX_FNC_DELWEST";
			rowHeight = 1.5 * GUI_GRID_CENTER_H;
			colorBackground[] = {0, 0.3, 0.6, 0.5};
		};		
		
		class opfor: RscCombo
		{
			idc = 1207;
			x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 14 * GUI_GRID_CENTER_H;
			w = 10 * GUI_GRID_CENTER_W;
			h = 2 * GUI_GRID_CENTER_H;
			onLBSelChanged = "(_this select 1) call VOX_FNC_ADDEAST";
			rowHeight = 1.5 * GUI_GRID_CENTER_H;
			tooltip = "Add formation to OPFOR side.";
		};

		class opf_list: RscListbox
		{
			idc = 1208;
			x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 16 * GUI_GRID_CENTER_H;
			w = 10 * GUI_GRID_CENTER_W;
			h = 9 * GUI_GRID_CENTER_H;
			onLBSelChanged = "(_this select 1) call VOX_FNC_DELEAST";
			rowHeight = 1.5 * GUI_GRID_CENTER_H;
			colorBackground[] = {0.5, 0, 0, 0.5};
		};

		class minimap : RscMapControl
		{
			idc = 1209;
			x = GUI_GRID_CENTER_X + 20 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 14 * GUI_GRID_CENTER_H;
			w = 20 * GUI_GRID_CENTER_W;
			h = 9 * GUI_GRID_CENTER_H;
			tooltip = "Click to reposition objectives.";
		};
		
		class side: RscText
		{
			idc = 1210;
			x = GUI_GRID_CENTER_X + 20 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 23 * GUI_GRID_CENTER_H;
			w = 10 * GUI_GRID_CENTER_W;
			h = 2 * GUI_GRID_CENTER_H;
		};		
		
		class start: RscButton
		{
			idc = 1211;
			text = "> START <";			
			x = GUI_GRID_CENTER_X + 30 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 23 * GUI_GRID_CENTER_H;
			w = 10 * GUI_GRID_CENTER_W;
			h = 2 * GUI_GRID_CENTER_H;
			onButtonClick = "[] call VOX_FNC_START;";
		};		
	};
};