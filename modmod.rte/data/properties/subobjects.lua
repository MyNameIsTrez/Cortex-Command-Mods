return {
	ActorEditor = nil,
	AreaEditor = nil,
	AssemblyEditor = nil,
	BaseEditor = nil,
	EditorActivity = nil,
	GameActivity = nil,
	GAScripted = {
		"AddPieSlice",
	},
	GATutorial = nil,
	GibEditor = nil,
	MultiplayerGame = nil,
	MultiplayerServerLobby = nil,
	SceneEditor = nil,
	ACDropShip = {
		-- "RThruster",
		"RightThruster",
		-- "RightEngine",
		-- "LThruster",
		"LeftThruster",
		-- "LeftEngine",
		-- "URThruster",
		"UpRightThruster",
		-- "ULThruster",
		"UpLeftThruster",
		-- "RHatchDoor",
		"RightHatchDoor",
		-- "LHatchDoor",
		"LeftHatchDoor",
		"HatchDoorSwingRange",
	},
	ACrab = {
		"Turret",
		"Jetpack",
		-- "LFGLeg",
		"LeftFGLeg",
		-- "LBGLeg",
		"LeftBGLeg",
		-- "RFGLeg",
		"RightFGLeg",
		-- "RBGLeg",
		"RightBGLeg",
		-- "LFootGroup",
		"LeftFootGroup",
		-- "RFootGroup",
		"RightFootGroup",
		"StrideSound",
		-- "LStandLimbPath",
		"LeftStandLimbPath",
		-- "LWalkLimbPath",
		"LeftWalkLimbPath",
		-- "LDislodgeLimbPath",
		"LeftDislodgeLimbPath",
		-- "RStandLimbPath",
		"RightStandLimbPath",
		-- "RWalkLimbPath",
		"RightWalkLimbPath",
		-- "RDislodgeLimbPath",
		"RightDislodgeLimbPath",
	},
	ACraft = {
		Exit = {
			"Offset",
			"Velocity",
		},
		"HatchOpenSound",
		"HatchCloseSound",
		"CrashSound",
		"AddExit",
	},
	ACRocket = {
		-- "RLeg",
		"RightLeg",
		-- "LLeg",
		"LeftLeg",
		-- "RFootGroup",
		"RightFootGroup",
		-- "LFootGroup",
		"LeftFootGroup",
		-- "MThruster",
		"MainThruster",
		-- "RThruster",
		"RightThruster",
		-- "LThruster",
		"LeftThruster",
		-- "URThruster",
		"UpRightThruster",
		-- "ULThruster",
		"UpLeftThruster",
		"RaisedGearLimbPath",
		"LoweredGearLimbPath",
		"LoweringGearLimbPath",
		"RaisingGearLimbPath",
	},
	Activity = {
		"Team1Icon",
		"Team2Icon",
		"Team3Icon",
		"Team4Icon",
	},
	Actor = {
		"BodyHitSound",
		"AlarmSound",
		"PainSound",
		"DeathSound",
		"DeviceSwitchSound",
		"StableVelocityThreshold",
		"HolsterOffset",
		"AddInventoryDevice",
		-- "AddInventory",
		"PieMenu",
	},
	ADoor = {
		"Door",
		"OpenOffset",
		"ClosedOffset",
		"OpenClosedOffset",
		"OpenAngle",
		"ClosedAngle",
		"OpenClosedAngle",
		"AddSensor",
		"DoorMoveStartSound",
		"DoorMoveSound",
		"DoorDirectionChangeSound",
		"DoorMoveEndSound",
	},
	ADSensor = {
		"StartOffset",
		"SensorRay",
	},
	AEmitter = {
		"AddEmission",
		"EmissionSound",
		"BurstSound",
		"EndSound",
		"EmissionAngle",
		"EmissionOffset",
		"Flash",
	},
	AHuman = {
		"Head",
		"Jetpack",
		"FGArm",
		"BGArm",
		"FGLeg",
		"BGLeg",
		"HandGroup",
		"FGFootGroup",
		"BGFootGroup",
		"StrideSound",
		"StandLimbPath",
		"StandLimbPathBG",
		"WalkLimbPath",
		"CrouchLimbPath",
		"CrouchLimbPathBG",
		"CrawlLimbPath",
		"ArmCrawlLimbPath",
		"ClimbLimbPath",
		"JumpLimbPath",
		"DislodgeLimbPath",
	},
	Arm = {
		"HeldDevice",
		"Hand",
		"IdleOffset",
	},
	AtomGroup = {
		"Material",
		"AddAtom",
		"JointOffset",
	},
	Attachable = {
		"ParentOffset",
		"JointOffset",
		"BreakWound",
		"ParentBreakWound",
		"AddPieSlice",
	},
	BunkerAssembly = {
		"FGColorFile",
		"MaterialFile",
		"BGColorFile",
		"BitmapOffset",
		"Location",
		"AddChildObject",
		"SymmetricAssembly",
		"PlaceObject",
	},
	BunkerAssemblyScheme = {
		"BitmapFile",
		"AddChildObject",
		"SymmetricScheme",
		"AssemblyGroup",
	},
	Deployment = {
		"LoadoutName",
		"Icon",
	},
	Emission = {
		"EmittedParticle",
		"Offset",
	},
	Gib = {
		"GibParticle",
		"Offset",
	},
	GlobalScript = {
		"ScriptPath",
		"AddPieSlice",
	},
	HDFirearm = {
		"Magazine",
		"Flash",
		"PreFireSound",
		"FireSound",
		"FireEchoSound",
		"ActiveSound",
		"DeactivationSound",
		"EmptySound",
		"ReloadStartSound",
		"ReloadEndSound",
		"MuzzleOffset",
		"EjectionOffset",
	},
	HeldDevice = {
		"StanceOffset",
		"SharpStanceOffset",
		"SupportOffset",
		"PickupableBy",
	},
	Icon = {
		"BitmapFile",
	},
	Leg = {
		"Foot",
		"ContractedOffset",
		"ExtendedOffset",
		"IdleOffset",
	},
	LimbPath = {
		"StartOffset",
		"AddSegment",
	},
	Loadout = {
		"DeliveryCraft",
		"AddCargoItem",
	},
	Magazine = {
		"RegularRound",
		"TracerRound",
	},
	Material = {
		"Color",
		"FGTextureFile",
		"BGTextureFile",
	},
	MetaPlayer = nil,
	MetaSave = nil,
	MOPixel = {
		"Atom",
		"Color",
	},
	MOSParticle = {
		"Atom",
	},
	MOSprite = {
		"SpriteFile",
		"IconFile",
		"SpriteOffset",
		"Rotation",
		"EntryWound",
		"ExitWound",
	},
	MOSRotating = {
		"AtomGroup",
		"DeepGroup",
		"AddEmitter",
		"AddAttachable",
		"AddGib",
		"GibSound",
		"AddCustomValue",
	},
	MovableObject = {
		"Velocity",
		"ScreenEffect",
	},
	PEmitter = {
		"AddEmission",
		"EmissionSound",
		"BurstSound",
		"EndSound",
		"EmissionAngle",
		"EmissionOffset",
	},
	PieMenu = {
		"AddPieSlice",
	},
	PieSlice = {
		"Icon",
		"SubPieMenu",
	},
	Round = {
		"Particle",
		"Shell",
		"FireSound",
	},
	Scene = {
		Area = {
			"AddBox",
		},
		"LocationOnPlanet",
		"P1ResidentBrain",
		"P2ResidentBrain",
		"P3ResidentBrain",
		"P4ResidentBrain",
		"PreviewBitmapFile",
		"Terrain",
		"PlaceSceneObject",
		-- "PlaceMovableObject",
		"BlueprintObject",
		"PlaceAIPlanObject",
		"AddBackgroundLayer",
		"AllUnseenPixelSizeTeam1",
		"AllUnseenPixelSizeTeam2",
		"AllUnseenPixelSizeTeam3",
		"AllUnseenPixelSizeTeam4",
		"UnseenLayerTeam1",
		"UnseenLayerTeam2",
		"UnseenLayerTeam3",
		"UnseenLayerTeam4",
		"AddArea",
		"GlobalAcceleration",
	},
	SceneLayer = {
		"BitmapFile",
	},
	SceneObject = {
		SOPlacer = {
			"PlacedObject",
			"Offset",
			"Rotation",
		},
		"Position",
	},
	SLBackground = {
		"ScrollRatio",
		"ScaleFactor",
		"OriginPointOffset",
		"AutoScrollStep",
	},
	SLTerrain = {
		"BackgroundTexture",
		"FGColorLayer",
		"BGColorLayer",
		"AddTerrainFrosting",
		"AddTerrainDebris",
		"PlaceTerrainObject",
	},
	SoundContainer = {
		"AddSound",
		"AddSoundSet",
		"Position",
	},
	SoundSet = {
		"AddSound",
		"AddSoundSet",
	},
	TDExplosive = {
		"DetonationSound",
	},
	TerrainDebris = {
		"DebrisFile",
		"DebrisMaterial",
		"TargetMaterial",
	},
	TerrainFrosting = {
		"FrostingMaterial",
		"TargetMaterial",
	},
	TerrainObject = {
		"FGColorFile",
		"BGColorFile",
		"MaterialFile",
		"BitmapOffset",
	},
	ThrownDevice = {
		"ActivationSound",
		"StartThrowOffset",
		"EndThrowOffset",
		"StrikerLever",
	},
	Turret = {
		"MountedDevice",
		"AddMountedDevice",
	},
	MetaMan = {
		"AddPlayer",
		"Team1Icon",
		"Team2Icon",
		"Team3Icon",
		"Team4Icon",
		"AddScene",
		"AddOffensive",
		"Team1AISkill",
		"Team2AISkill",
		"Team3AISkill",
		"Team4AISkill",
		"MetaGUI",
	},
	MovableMan = {
		"AddEffect",
		"AddAmmo",
		"AddDevice",
		"AddActor",
	},
	SceneMan = {
		"AddMaterial",
	},
	SettingsMan = {
		"PaletteFile",
		"Player1Scheme",
		"Player2Scheme",
		"Player3Scheme",
		"Player4Scheme",
	},
	MetagameGUI = {
		"P1BoxPos",
		"P2BoxPos",
		"P3BoxPos",
		"P4BoxPos",
		"PhaseBoxPos",
	},
	Atom = {
		"Offset",
		"OriginalOffset",
		"Material",
		"TrailColor",
	},
	Box = {
		"Corner",
	},
	Color = nil,
	ContentFile = nil,
	DataModule = {
		"IconFile",
		"FactionBuyMenuTheme",
		"AddMaterial",
	},
	Entity = nil,
	GenericSavedData = nil,
	InputMapping = nil,
	InputScheme = {
		"LeftUp",
		"LeftDown",
		"LeftLeft",
		"LeftRight",
		"Fire",
		"Aim",
		"AimUp",
		"AimDown",
		"AimLeft",
		"AimRight",
		"PieMenu",
		"Jump",
		"Crouch",
		"Next",
		"Prev",
		"WeaponChangeNext",
		"WeaponChangePrev",
		"WeaponPickup",
		"WeaponDrop",
		"WeaponReload",
		"Start",
		"Back",
		"RightUp",
		"RightDown",
		"RightLeft",
		"RightRight",
	},
	Matrix = nil,
	Serializable = nil,
	Vector = nil,
}
