return {
	GameActivity = {
		properties = {
			CPUTeam = { description = "Which team is CPU-managed, if any. LEGACY, now controlled by PlayerNIsHuman, where N is between 1 and 4 inclusive.", default = -1 },
			DeliveryDelay = { description = "Time it takes for a delivery to be made in milliseconds.", default = 4500 },
			DefaultFogOfWar = { description = "Default fog of war value.", default = -1 },
			DefaultRequireClearPathToOrbit = { description = "Default clear path to orbit value.", default = -1 },
			DefaultDeployUnits = { description = "Default deploy units value.", default = -1 },
			DefaultGoldCake = { description = "Default gold amount for Cake difficulty.", default = -1 },
			DefaultGoldEasy = { description = "Default gold amount for Easy difficulty.", default = -1 },
			DefaultGoldMedium = { description = "Default gold amount for Medium difficulty.", default = -1 },
			DefaultGoldHard = { description = "Default gold amount for Hard difficulty.", default = -1 },
			DefaultGoldNuts = { description = "Default gold amount for Nuts difficulty.", default = -1 },
			FogOfWarSwitchEnabled = { description = "Whether the fog of war switch is enabled in the scenario setup dialog.", default = true },
			DeployUnitsSwitchEnabled = { description = "Whether the deploy units switch is enabled in the scenario setup dialog.", default = true },
			GoldSwitchEnabled = { description = "Whether the gold switch is enabled in the scenario setup dialog.", default = true },
			RequireClearPathToOrbitSwitchEnabled = { description = "Whether the require clear path to orbit switch is enabled in the scenario setup dialog.", default = true },
			BuyMenuEnabled = { description = "Whether the buy menu is enabled.", default = true },
		}
		fallback_class = "Activity"
	}
}
