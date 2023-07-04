return {
	ActorEditor = nil,
	AreaEditor = nil,
	AssemblyEditor = nil,
	BaseEditor = nil,
	EditorActivity = nil,
	GameActivity = {
		CPUTeam = nil,
		DeliveryDelay = "milliseconds",
		DefaultFogOfWar = ,
		DefaultRequireClearPathToOrbit = ,
		DefaultDeployUnits = ,
		DefaultGoldCake = ,
		DefaultGoldEasy = ,
		DefaultGoldMedium = ,
		DefaultGoldHard = ,
		DefaultGoldNuts = ,
		FogOfWarSwitchEnabled = ,
		DeployUnitsSwitchEnabled = ,
		GoldSwitchEnabled = ,
		RequireClearPathToOrbitSwitchEnabled = ,
		BuyMenuEnabled = ,
	},
	GAScripted = {
		ScriptPath = ,
		LuaClassName = ,
	},
	GATutorial = nil,
	GibEditor = nil,
	MultiplayerGame = nil,
	MultiplayerServerLobby = nil,
	SceneEditor = nil,
	ACDropShip = {
		AutoStabilize = ,
		MaxEngineAngle = ,
		LateralControlSpeed = ,
		HoverHeightModifier = ,
	},
	ACrab = {
		-- JumpTime = ,
		JetTime = ,
		-- JumpReplenishRate = ,
		JetReplenishRate = ,
		-- JumpAngleRange = ,
		JetAngleRange = ,
		AimRangeUpperLimit = ,
		AimRangeLowerLimit = ,
	},
	ACraft = {
		Exit = {
			VelocitySpread = ,
			Radius = ,
			Range = ,
		},
		HatchDelay = ,
		DeliveryDelayMultiplier = ,
		ExitInterval = ,
		CanLand = ,
		MaxPassengers = ,
		ScuttleIfFlippedTime = ,
		ScuttleOnDeath = ,
	},
	ACRocket = {
		MaxGimbalAngle = ,
	},
	Activity = {
		Description = ,
		SceneName = ,
		MaxPlayerSupport = ,
		MinTeamsRequired = ,
		Difficulty = ,
		CraftOrbitAtTheEdge = ,
		InCampaignStage = ,
		TeamOfPlayer1 = ,
		TeamOfPlayer2 = ,
		TeamOfPlayer3 = ,
		TeamOfPlayer4 = ,
		Player1IsHuman = ,
		Player2IsHuman = ,
		Player3IsHuman = ,
		Player4IsHuman = ,
		Team1Name = ,
		Team2Name = ,
		Team3Name = ,
		Team4Name = ,
		Team1Funds = ,
		Team2Funds = ,
		Team3Funds = ,
		Team4Funds = ,
		TeamFundsShareOfPlayer1 = ,
		TeamFundsShareOfPlayer2 = ,
		TeamFundsShareOfPlayer3 = ,
		TeamFundsShareOfPlayer4 = ,
		FundsContributionOfPlayer1 = ,
		FundsContributionOfPlayer2 = ,
		FundsContributionOfPlayer3 = ,
		FundsContributionOfPlayer4 = ,
	},
	Actor = {
		Status = ,
		DeploymentID = ,
		PassengerSlots = ,
		Health = ,
		MaxHealth = ,
		ImpulseDamageThreshold = ,
		StableRecoveryDelay = ,
		AimAngle = ,
		AimRange = ,
		AimDistance = ,
		SharpAimDelay = ,
		SightDistance = ,
		Perceptiveness = ,
		CanRevealUnseen = ,
		CharHeight = ,
		MaxInventoryMass = ,
		AIMode = ,
		Organic = ,
		Mechanical = ,
	},
	ADoor = {
		DoorMoveTime = ,
		ClosedByDefault = ,
		ResetDefaultDelay = ,
		SensorInterval = ,
		DrawMaterialLayerWhenOpen = ,
		DrawMaterialLayerWhenClosed = ,
	},
	ADSensor = {
		SkipPixels = ,
	},
	AEmitter = {
		EmissionEnabled = ,
		EmissionCount = ,
		EmissionCountLimit = ,
		ParticlesPerMinute = ,
		NegativeThrottleMultiplier = ,
		PositiveThrottleMultiplier = ,
		Throttle = ,
		EmissionsIgnoreThis = ,
		BurstSize = ,
		BurstScale = ,
		BurstDamage = ,
		EmitterDamageMultiplier = ,
		BurstSpacing = ,
		BurstTriggered = ,
		EmissionDamage = ,
		FlashScale = ,
		FlashOnlyOnBurst = ,
		LoudnessOnEmit = ,
	},
	AHuman = {
		ThrowPrepTime = ,
		LookToAimRatio = ,
		-- JumpTime = ,
		JetTime = ,
		-- JumpReplenishRate = ,
		JetReplenishRate = ,
		-- JumpAngleRange = ,
		JetAngleRange = ,
		FGArmFlailScalar = ,
		BGArmFlailScalar = ,
		ArmSwingRate = ,
		StandRotAngleTarget = ,
		WalkRotAngleTarget = ,
		CrouchRotAngleTarget = ,
		JumpRotAngleTarget = ,
	},
	Arm = {
		GripStrength = ,
		ThrowStrength = ,
		MaxLength = ,
		WillIdle = ,
		MoveSpeed = ,
	},
	AtomGroup = {
		AutoGenerate = ,
		Resolution = ,
		Depth = ,
	},
	Attachable = {
		DrawAfterParent = ,
		DeleteWhenRemovedFromParent = ,
		ApplyTransferredForcesAtOffset = ,
		GibWithParentChance = ,
		ParentGibBlastStrengthMultiplier = ,
		JointStrength = ,
		-- Strength = ,
		JointStiffness = ,
		-- Stiffness = ,
		InheritsHFlipped = ,
		InheritsRotAngle = ,
		-- InheritedRotAngleRadOffset = ,
		InheritedRotAngleOffset = ,
		InheritedRotAngleDegOffset = ,
		InheritsFrame = ,
		CollidesWithTerrainWhileAttached = ,
	},
	BunkerAssembly = {
		ParentScheme = ,
	},
	BunkerAssemblyScheme = {
		Limit = ,
		OneTypePerScene = ,
		MaxDeployments = ,
	},
	Deployment = {
		SpawnRadius = ,
		WalkRadius = ,
		ID = ,
		HFlipped = ,
	},
	Emission = {
		ParticlesPerMinute = ,
		BurstSize = ,
		Spread = ,
		MinVelocity = ,
		MaxVelocity = ,
		LifeVariation = ,
		PushesEmitter = ,
		InheritsVel = ,
		StartTimeMS = ,
		StopTimeMS = ,
	},
	Gib = {
		Count = ,
		Spread = ,
		MinVelocity = ,
		MaxVelocity = ,
		LifeVariation = ,
		InheritsVel = ,
		IgnoresTeamHits = ,
		SpreadMode = ,
	},
	GlobalScript = {
		LuaClassName = ,
		LateUpdate = ,
	},
	HDFirearm = {
		RateOfFire = ,
		ActivationDelay = ,
		DeactivationDelay = ,
		ReloadTime = ,
		FullAuto = ,
		FireIgnoresThis = ,
		Reloadable = ,
		RecoilTransmission = ,
		IsAnimatedManually = ,
		ShakeRange = ,
		SharpShakeRange = ,
		NoSupportFactor = ,
		ParticleSpreadRange = ,
		ShellEjectAngle = ,
		ShellSpreadRange = ,
		ShellAngVelRange = ,
		ShellVelVariation = ,
		LegacyCompatibilityRoundsAlwaysFireUnflipped = ,
	},
	HeldDevice = {
		HeldDeviceType = ,
		OneHanded = ,
		DualWieldable = ,
		GripStrengthMultiplier = ,
		SharpLength = ,
		Loudness = ,
	},
	Icon = {
		FrameCount = ,
	},
	Leg = {
		WillIdle = ,
		MoveSpeed = ,
	},
	LimbPath = {
		StartSegCount = ,
		EndSegCount = ,
		SlowTravelSpeed = ,
		NormalTravelSpeed = ,
		FastTravelSpeed = ,
		PushForce = ,
	},
	Loadout = nil,
	Magazine = {
		RoundCount = ,
		RTTRatio = ,
		Discardable = ,
		AIBlastRadius = ,
	},
	Material = {
		Index = ,
		Priority = ,
		Piling = ,
		-- Integrity = ,
		StructuralIntegrity = ,
		-- Restitution = ,
		Bounce = ,
		Friction = ,
		Stickiness = ,
		DensityKGPerVolumeL = ,
		DensityKGPerPixel = ,
		GibImpulseLimitPerVolumeL = ,
		GibWoundLimitPerVolumeL = ,
		SettleMaterial = ,
		-- SpawnMaterial = ,
		TransformsInto = ,
		IsScrap = ,
		UseOwnColor = ,
	},
	MetaPlayer = {
		Name = ,
		Team = ,
		Human = ,
		InGamePlayer = ,
		Aggressiveness = ,
		GameOverRound = ,
		NativeTechModule = ,
		NativeCostMultiplier = ,
		ForeignCostMultiplier = ,
		BrainPool = ,
		Funds = ,
		OffensiveBudget = ,
		OffensiveTarget = ,
	},
	MetaSave = {
		SavePath = ,
		PlayerCount = ,
		Difficulty = ,
		RoundCount = ,
		SiteCount = ,
	},
	MOPixel = {
		MinLethalRange = ,
		MaxLethalRange = ,
	},
	MOSParticle = nil,
	MOSprite = {
		FrameCount = ,
		SpriteAnimMode = ,
		SpriteAnimDuration = ,
		HFlipped = ,
		AngularVel = ,
		SettleMaterialDisabled = ,
	},
	MOSRotating = {
		DeepCheck = ,
		OrientToVel = ,
		GibImpulseLimit = ,
		GibWoundLimit = ,
		-- WoundLimit = ,
		GibBlastStrength = ,
		WoundCountAffectsImpulseLimitRatio = ,
		GibAtEndOfLifetime = ,
		EffectOnGib = ,
		LoudnessOnGib = ,
		DamageMultiplier = ,
	},
	MovableObject = {
		Mass = ,
		Scale = ,
		GlobalAccScalar = ,
		AirResistance = ,
		AirThreshold = ,
		PinStrength = ,
		RestThreshold = ,
		LifeTime = ,
		Sharpness = ,
		HitsMOs = ,
		GetsHitByMOs = ,
		IgnoresTeamHits = ,
		IgnoresAtomGroupHits = ,
		IgnoresAGHitsWhenSlowerThan = ,
		RemoveOrphanTerrainRadius = ,
		RemoveOrphanTerrainMaxArea = ,
		RemoveOrphanTerrainRate = ,
		MissionCritical = ,
		CanBeSquished = ,
		HUDVisible = ,
		ScriptPath = ,
		EffectStartTime = ,
		EffectRotAngle = ,
		InheritEffectRotAngle = ,
		RandomizeEffectRotAngle = ,
		RandomizeEffectRotAngleEveryFrame = ,
		EffectStopTime = ,
		EffectStartStrength = ,
		EffectStopStrength = ,
		EffectAlwaysShows = ,
		DamageOnCollision = ,
		DamageOnPenetration = ,
		WoundDamageMultiplier = ,
		ApplyWoundDamageOnCollision = ,
		ApplyWoundBurstDamageOnCollision = ,
		IgnoreTerrain = ,
		SimUpdatesBetweenScriptedUpdates = ,
	},
	PEmitter = {
		EmissionEnabled = ,
		EmissionCount = ,
		EmissionCountLimit = ,
		ParticlesPerMinute = ,
		NegativeThrottleMultiplier = ,
		PositiveThrottleMultiplier = ,
		Throttle = ,
		EmissionsIgnoreThis = ,
		BurstSize = ,
		BurstScale = ,
		BurstSpacing = ,
		BurstTriggered = ,
		FlashScale = ,
		FlashOnlyOnBurst = ,
		LoudnessOnEmit = ,
	},
	PieMenu = {
		IconSeparatorMode = ,
		FullInnerRadius = ,
		BackgroundThickness = ,
		BackgroundSeparatorSize = ,
		DrawBackgroundTransparent = ,
		BackgroundColor = ,
		BackgroundBorderColor = ,
		SelectedItemBackgroundColor = ,
	},
	PieSlice = {
		Type = ,
		Direction = ,
		CanBeMiddleSlice = ,
		Enabled = ,
		ScriptPath = ,
		FunctionName = ,
		DrawFlippedToMatchAbsoluteAngle = ,
	},
	Round = {
		ParticleCount = ,
		FireVelocity = ,
		InheritsFirerVelocity = ,
		Separation = ,
		LifeVariation = ,
		ShellVelocity = ,
		AILifeTime = ,
		AIFireVel = ,
		AIPenetration = ,
	},
	Scene = {
		Area = {
			Name = ,
		},
		MetagamePlayable = ,
		Revealed = ,
		MetasceneParent = ,
		MetagameInternal = ,
		ScriptSave = ,
		OwnedByTeam = ,
		RoundIncome = ,
		P1BuildBudget = ,
		P2BuildBudget = ,
		P3BuildBudget = ,
		P4BuildBudget = ,
		P1BuildBudgetRatio = ,
		P2BuildBudgetRatio = ,
		P3BuildBudgetRatio = ,
		P4BuildBudgetRatio = ,
		AutoDesigned = ,
		TotalInvestment = ,
		ScanScheduledTeam1 = ,
		ScanScheduledTeam2 = ,
		ScanScheduledTeam3 = ,
		ScanScheduledTeam4 = ,
	},
	SceneLayer = {
		WrapX = ,
		WrapY = ,
	},
	SceneObject = {
		SOPlacer = {
			HFlipped = ,
			Team = ,
		},
		GoldValue = ,
		-- GoldCost = ,
		Buyable = ,
		BuyableMode = ,
		Team = ,
		PlacedByPlayer = ,
	},
	SLBackground = {
		FrameCount = ,
		SpriteAnimMode = ,
		SpriteAnimDuration = ,
		IsAnimatedManually = ,
		DrawTransparent = ,
		IgnoreAutoScaling = ,
		CanAutoScrollX = ,
		CanAutoScrollY = ,
		AutoScrollStepInterval = ,
	},
	SLTerrain = nil,
	SoundContainer = {
		SoundSelectionCycleMode = ,
		-- CycleMode = ,
		SoundOverlapMode = ,
		Immobile = ,
		AttenuationStartDistance = ,
		LoopSetting = ,
		Priority = ,
		AffectedByGlobalPitch = ,
		Volume = ,
		Pitch = ,
		PitchVariation = ,
	},
	SoundSet = {
		SoundSelectionCycleMode = ,
	},
	TDExplosive = {
		IsAnimatedManually = ,
	},
	TerrainDebris = {
		DebrisPieceCount = ,
		DebrisPlacementMode = ,
		OnlyBuried = ,
		MinDepth = ,
		MaxDepth = ,
		MinRotation = ,
		MaxRotation = ,
		CanHFlip = ,
		CanVFlip = ,
		FlipChance = ,
		DensityPerMeter = ,
	},
	TerrainFrosting = {
		MinThickness = ,
		MaxThickness = ,
		InAirOnly = ,
	},
	TerrainObject = nil,
	ThrownDevice = {
		MinThrowVel = ,
		MaxThrowVel = ,
		TriggerDelay = ,
		ActivatesWhenReleased = ,
	},
	Turret = {
		MountedDeviceRotationOffset = ,
	},
	MetaMan = {
		GameState = ,
		GameName = ,
		TeamCount = ,
		CurrentRound = ,
		RevealedScenes = ,
		RevealRate = ,
		RevealExtra = ,
		CurrentOffensive = ,
		Difficulty = ,
	},
	MovableMan = {
		SplashRatio = ,
	},
	SceneMan = nil,
	SettingsMan = {
		ResolutionX = ,
		ResolutionY = ,
		ResolutionMultiplier = ,
		TwoPlayerSplitscreenVertSplit = ,
		MasterVolume = ,
		MuteMaster = ,
		MusicVolume = ,
		MuteMusic = ,
		SoundVolume = ,
		MuteSounds = ,
		SoundPanningEffectStrength = ,
		ListenerZOffset = ,
		MinimumDistanceForPanning = ,
		ShowForeignItems = ,
		FlashOnBrainDamage = ,
		BlipOnRevealUnseen = ,
		MaxUnheldItems = ,
		UnheldItemsHUDDisplayRange = ,
		AlwaysDisplayUnheldItemsInStrategicMode = ,
		SubPieMenuHoverOpenDelay = ,
		EndlessMode = ,
		EnableCrabBombs = ,
		CrabBombThreshold = ,
		ShowEnemyHUD = ,
		SmartBuyMenuNavigation = ,
		ScrapCompactingHeight = ,
		AutomaticGoldDeposit = ,
		ScreenShakeStrength = ,
		ScreenShakeDecay = ,
		MaxScreenShakeTime = ,
		DefaultShakePerUnitOfGibEnergy = ,
		DefaultShakePerUnitOfRecoilEnergy = ,
		DefaultShakeFromRecoilMaximum = ,
		LaunchIntoActivity = ,
		DefaultActivityType = ,
		DefaultActivityName = ,
		DefaultSceneName = ,
		DisableLuaJIT = ,
		RecommendedMOIDCount = ,
		SimplifiedCollisionDetection = ,
		SceneBackgroundAutoScaleMode = ,
		DisableFactionBuyMenuThemes = ,
		EnableParticleSettling = ,
		EnableMOSubtraction = ,
		DeltaTime = ,
		RealToSimCap = ,
		AllowSavingToBase = ,
		ShowMetaScenes = ,
		SkipIntro = ,
		ShowToolTips = ,
		CaseSensitiveFilePaths = ,
		DisableLoadingScreenProgressReport = ,
		LoadingScreenProgressReportPrecision = ,
		ConsoleScreenRatio = ,
		ConsoleUseMonospaceFont = ,
		AdvancedPerformanceStats = ,
		MenuTransitionDurationMultiplier = ,
		DrawAtomGroupVisualizations = ,
		DrawHandAndFootGroupVisualizations = ,
		DrawLimbPathVisualizations = ,
		DrawRaycastVisualizations = ,
		DrawPixelCheckVisualizations = ,
		PrintDebugInfo = ,
		MeasureModuleLoadTime = ,
		PlayerNetworkName = ,
		NetworkServerName = ,
		UseNATService = ,
		NATServiceAddress = ,
		NATServerName = ,
		NATServerPassword = ,
		UseExperimentalMultiplayerSpeedBoosts = ,
		ClientInputFps = ,
		ServerTransmitAsBoxes = ,
		ServerBoxWidth = ,
		ServerBoxHeight = ,
		ServerUseHighCompression = ,
		ServerUseFastCompression = ,
		ServerHighCompressionLevel = ,
		ServerFastAccelerationFactor = ,
		ServerUseInterlacing = ,
		ServerEncodingFps = ,
		ServerSleepWhenIdle = ,
		ServerSimSleepWhenIdle = ,
		VisibleAssemblyGroup = ,
		DisableMod = ,
		EnableGlobalScript = ,
		MouseSensitivity = ,
	},
	MetagameGUI = nil,
	Atom = {
		TrailLength = ,
		TrailLengthVariation = ,
	},
	Box = {
		Width = ,
		Height = ,
	},
	Color = {
		Index = ,
		R = ,
		G = ,
		B = ,
	},
	ContentFile = {
		FilePath = ,
		-- Path = ,
	},
	DataModule = {
		ModuleName = ,
		Author = ,
		Description = ,
		IsFaction = ,
		IsMerchant = ,
		SupportedGameVersion = ,
		Version = ,
		ScanFolderContents = ,
		IgnoreMissingItems = ,
		CrabToHumanSpawnRatio = ,
		ScriptPath = ,
		Require = ,
	},
	Entity = {
		CopyOf = ,
		PresetName = ,
		-- InstanceName = ,
		Description = ,
		RandomWeight = ,
		AddToGroup = ,
	},
	InputMapping = {
		KeyMap = ,
		MouseButtonMap = ,
		JoyButtonMap = ,
		StickMap = ,
		AxisMap = ,
		DirectionMap = ,
	},
	InputScheme = {
		Device = ,
		Preset = ,
		JoystickDeadzoneType = ,
		JoystickDeadzone = ,
		DigitalAimSpeed = ,
	},
	Matrix = {
		AngleDegrees = ,
		AngleRadians = ,
	},
	Serializable = nil,
	Vector = {
		X = ,
		Y = ,
	},
}
