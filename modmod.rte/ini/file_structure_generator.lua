-- REQUIREMENTS ----------------------------------------------------------------





-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


--[[
Returned format:
{
	["Browncoats.rte"] = {
		Actors = {
			Infantry = {
				BrowncoatHeavy = {
					"BrowncoatHeavy.ini"
				}
			}
		}
	}
}
]]--
function M.get_file_structure()
	return {
		["Browncoats.rte"] = {
			Actors = {
				Infantry = {
					BrowncoatHeavy = {
						"BrowncoatHeavy.ini"
					},
					BrowncoatLight = {
						"BrowncoatLight.ini"
					}
				}
			}
		},
		["Coalition.rte"] = {
			Devices = {
				Weapons = {
					GatlingGun = {
						"GatlingGun.ini"
					}
				}
			}
		}
	}
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
