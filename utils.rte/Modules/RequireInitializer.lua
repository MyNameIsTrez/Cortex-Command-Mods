function RequireInit(modName)
	package.path = package.path .. string.format(";%s.rte/?.lua", modName);
end


RequireInit("Utils");