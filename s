DEADEYE UNUSUAL RUNTIME SOURCE SEARCH
=====================================
Client-visible scripts scanned: 35629
Relevant scripts found: 1065
Decompile failures: 0


========================================
MATCH #1
PATH: CorePackages.Workspace.Packages._Index.GameCollections.GameCollections.useRenderGameCollectionItem
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 11439
========================================

--- SOURCE LINES 1-97 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local GameCollections = script:FindFirstAncestor("GameCollections")
    4 | local Parent = GameCollections.Parent
    5 | local React = require(Parent.React)
    6 | local Responsive = require(Parent.Responsive)
    7 | local usePreferredInput = Responsive.usePreferredInput
    8 | local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
    9 | local GameTile = require(Parent.GameTile)
   10 | local GameTileConstants = GameTile.GameTileConstants
   11 | local GameTileLayoutType = GameTile.GameTileTypes.GameTileLayoutType
   12 | local AppGameTile = GameTile.AppGameTile
   13 | local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
   14 | local useTriggerGameTileFeedbackCallbacks = require(GameCollections.useTriggerGameTileFeedbackCallbacks)
   15 | local SeeAllTile = require(GameCollections.SeeAllTile)
   16 | local useNavigateToGameDetails = require(Parent.GameTile).useNavigateToGameDetails
   17 | local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
   18 | require(Parent.HoldToPlay)
   19 | require(Parent.VideoUtils)
   20 | local FFlagLuaAppContinueSortInstantPlay = require(Parent.SharedFlags).FFlagLuaAppContinueSortInstantPlay
   21 | local FFlagLuaAppEnableReportExperience = require(Parent.SharedFlags).FFlagLuaAppEnableReportExperience
   22 | local FFlagLuaAppNarrowTileHideRating = require(Parent.SharedFlags).FFlagLuaAppNarrowTileHideRating
   23 | local FFlagLuaAppNarrowTileHidePlayerCount = require(Parent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount
   24 | local FFlagLuaAppEnableHomepageOneByTwoTile = require(Parent.SharedFlags).FFlagLuaAppEnableHomepageOneByTwoTile
   25 | local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(Parent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
   26 | local FFlagLuaAppEmphasisGameTileVideo = require(Parent.SharedFlags).FFlagLuaAppEmphasisGameTileVideo
   27 | local GameCollectionItemType = GameCollectionItemTypes.GameCollectionItemType
   28 | local function useRenderGameCollectionItem(p_u_1, p_u_2: boolean?, p_u_3, p_u_4: boolean?, p_u_5: boolean?, p_u_6: string, p_u_7: boolean?, p_u_8: (...any) -> ...any, p_u_9: (...any) -> ...any, p_u_10: string?, p_u_11: string?, p_u_12: string?, p_u_13: (...any) -> ...any?, p_u_14: string?, p_u_15: number?, p_u_16: boolean?, p_u_17: string?, p_u_18: boolean?, p_u_19: boolean?, p_u_20: boolean?, p_u_21, p_u_22, p_u_23, p_u_24: number?, p_u_25: number?, p_u_26: boolean?, p_u_27: boolean?, p_u_28, p_u_29: (...any) -> ...any?, p_u_30: number?, p_u_31: boolean?, p_u_32: {[any]: any}?, p_u_33: (...any) -> ...any?, p_u_34: string?, p_u_35: string?, p_u_36: boolean?, p_u_37: boolean?, p_u_38: boolean?, p_u_39: number?, p_u_40: boolean?, _, _2, _3, p_u_41: boolean?, p_u_42: boolean?, p_u_43: boolean?, p_u_44, p_u_45: boolean?, p_u_46: boolean?, p_u_47: string?)
   29 | 	--[[ line: 36 | upvalues: (copy) usePreferredInput, (copy) useNavigateToGameDetails, (copy) useTriggerGameTileFeedbackCallbacks, (copy) Responsive, (copy) FFlagLuaAppContinueSortInstantPlay, (copy) useBreakpointXOrSmaller, (copy) FFlagLuaAppNarrowTileHideRating, (copy) FFlagLuaAppNarrowTileHidePlayerCount, (copy) GameTileConstants, (copy) GameTileLayoutType, (copy) React, (copy) SeeAllTile, (copy) GameCollectionItemType, (copy) FFlagLuaAppEnableReportExperience, (copy) FFlagLuaAppEmphasisGameTileVideo, (copy) FFlagLuaAppEnableHomepageOneByTwoTile, (copy) getTileBadgeByPositionConfigFromEntry, (copy) AppGameTile, (copy) FFlagLuaAppUsePrevalidatedVideoGamePlayability]]
   30 | 	local v48 = usePreferredInput()
   31 | 	local v_u_49 = useNavigateToGameDetails()
   32 | 	local v50, v51 = useTriggerGameTileFeedbackCallbacks()
   33 | 	local v_u_52 = v50
   34 | 	local v_u_53 = v51
   35 | 	if p_u_7 then
   36 | 		p_u_7 = v48 == Responsive.Input.Pointer
   37 | 	end
   38 | 	local v_u_54
   39 | 	if FFlagLuaAppContinueSortInstantPlay then
   40 | 		v_u_54 = v48 == Responsive.Input.Touch
   41 | 	else
   42 | 		v_u_54 = nil
   43 | 	end
   44 | 	local v_u_55
   45 | 	if p_u_3 == "Wide" then
   46 | 		v_u_55 = true
   47 | 	else
   48 | 		v_u_55 = p_u_3 == "Event"
   49 | 	end
   50 | 	local Small = useBreakpointXOrSmaller(Responsive.Keys.Small)
   51 | 	local XSmall = useBreakpointXOrSmaller(Responsive.Keys.XSmall)
   52 | 	local v56 = FFlagLuaAppNarrowTileHideRating and p_u_42 and p_u_42 or FFlagLuaAppNarrowTileHidePlayerCount and p_u_43
   53 | 	if Small then
   54 | 		if p_u_24 > 0 then
   55 | 			Small = not v56
   56 | 		else
   57 | 			Small = false
   58 | 		end
   59 | 	end
   60 | 	local v_u_57
   61 | 	if Small then
   62 | 		v_u_57 = GameTileConstants.TileTextLines[p_u_3 or GameTileLayoutType.Narrow].largeMetadataTextLines
   63 | 	else
   64 | 		v_u_57 = GameTileConstants.TileTextLines[p_u_3 or GameTileLayoutType.Narrow].metadataTextLines
   65 | 	end
   66 | 	local useCallback = React.useCallback
   67 | 	local function v76(p58, p59: number, p60, p61: number?)
   68 | 		--[[ line: 167 | upvalues: (copy) p_u_15, (copy) p_u_13, (ref) React, (ref) SeeAllTile, (ref) GameCollectionItemType, (copy) p_u_23, (copy) p_u_32, (copy) p_u_30, (copy) p_u_39, (copy) p_u_21, (copy) p_u_22, (copy) p_u_14, (copy) p_u_12, (copy) p_u_11, (copy) p_u_1, (copy) p_u_16, (copy) p_u_3, (copy) p_u_7, (copy) p_u_18, (copy) p_u_8, (copy) p_u_9, (copy) p_u_10, (copy) p_u_29, (copy) v_u_49, (copy) p_u_6, (copy) p_u_24, (copy) p_u_34, (copy) p_u_33, (copy) p_u_35, (copy) p_u_36, (copy) p_u_37, (ref) FFlagLuaAppEnableReportExperience, (copy) p_u_38, (copy) p_u_31, (copy) p_u_44, (ref) FFlagLuaAppEmphasisGameTileVideo, (ref) FFlagLuaAppEnableHomepageOneByTwoTile, (copy) p_u_28, (ref) getTileBadgeByPositionConfigFromEntry, (ref) AppGameTile, (copy) p_u_4, (copy) p_u_5, (copy) v_u_55, (copy) p_u_2, (copy) p_u_17, (copy) p_u_19, (copy) p_u_20, (ref) v_u_52, (ref) v_u_53, (copy) p_u_25, (ref) v_u_57, (copy) p_u_26, (copy) p_u_27, (copy) XSmall, (copy) p_u_40, (copy) p_u_41, (ref) FFlagLuaAppNarrowTileHideRating, (copy) p_u_42, (ref) FFlagLuaAppNarrowTileHidePlayerCount, (copy) p_u_43, (ref) FFlagLuaAppUsePrevalidatedVideoGamePlayability, (copy) p_u_45, (ref) FFlagLuaAppContinueSortInstantPlay, (copy) p_u_46, (copy) p_u_47, (copy) v_u_54]]
   69 | 		if p_u_15 and (p59 == p_u_15 and p_u_13) then
   70 | 			local t = { onActivated = p_u_13, size = p60, layoutOrder = p59 }
   71 | 			return React.createElement(SeeAllTile, t), GameCollectionItemType.SeeAllTile
   72 | 		end
   73 | 		local v62
   74 | 		if p_u_23 then
   75 | 			v62 = p_u_23(p59)
   76 | 		else
   77 | 			v62 = nil
   78 | 		end
   79 | 		local v63 = p_u_32
   80 | 		if v63 then
   81 | 			v63 = p_u_32[p58.universeId]
   82 | 		end
   83 | 		local v64
   84 | 		if p_u_30 then
   85 | 			v64 = p_u_30 + p59
   86 | 		else
   87 | 			v64 = nil
   88 | 		end
   89 | 		if p58.customRenderFunction then
   90 | 			local customRenderFunction = p58.customRenderFunction
   91 | 			local t2 = {
   92 | 				item = p58,
   93 | 				index = p59,
   94 | 				itemSize = p60,
   95 | 				rowNum = p61,
   96 | 				zIndex = -p59,
   97 | 				maxItemIndex = p_u_39,


========================================
MATCH #2
PATH: CorePackages.Workspace.Packages._Index.GameCollections.GameCollections.useTriggerGameTileFeedbackCallbacks
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 1098
========================================

--- SOURCE LINES 1-31 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local Parent = script:FindFirstAncestor("GameCollections").Parent
    4 | local React = require(Parent.React)
    5 | local useTriggerFeedback = require(Parent.InteractionFeedback).useTriggerFeedback
    6 | local function useTriggerGameTileFeedbackCallbacks()
    7 | 	--[[ line: 8 | upvalues: (copy) useTriggerFeedback, (copy) React]]
    8 | 	local v_u_1 = useTriggerFeedback()
    9 | 	local v_u_2 = React.useRef(nil)
   10 | 	return React.useCallback(function(p3)
   11 | 		--[[ line: 11 | upvalues: (copy) v_u_2, (copy) v_u_1]]
   12 | 		local GuiState = p3.GuiState
   13 | 		if v_u_2.current == Enum.GuiState.Press then
   14 | 			v_u_1("Default", "Release")
   15 | 		end
   16 | 		if GuiState == Enum.GuiState.Hover then
   17 | 			v_u_1("Default", "Hover")
   18 | 		end
   19 | 		if GuiState == Enum.GuiState.Press then
   20 | 			v_u_1("Default", "Press")
   21 | 		end
   22 | 		v_u_2.current = GuiState
   23 | 	end, { v_u_1, v_u_2 }), React.useCallback(function()
   24 | 		--[[ line: 25 | upvalues: (copy) v_u_2, (copy) v_u_1]]
   25 | 		if v_u_2.current == Enum.GuiState.Press then
   26 | 			v_u_1("Default", "Release")
   27 | 		end
   28 | 		v_u_2.current = Enum.GuiState.Idle
   29 | 	end, { v_u_1, v_u_2 })
   30 | end
   31 | return useTriggerGameTileFeedbackCallbacks


========================================
MATCH #3
PATH: CorePackages.Workspace.Packages._Index.GameTile.GameTile.AppGameTile
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 77272
========================================

--- SOURCE LINES 26-136 ---
   26 | local GameTileVideoThumbnail = require(GameTile.GameTileVideoThumbnail)
   27 | local VideoEndReason = require(GameTile.Video.Analytics.VideoEndReason)
   28 | local GameVideoPlaybackDetector = require(GameTile.Video.GameVideoPlaybackDetector)
   29 | local useHasVideoThumbnailSelector = require(GameTile.Video.useHasVideoThumbnailSelector)
   30 | local getLayoutDataVideo = require(GameTile.getLayoutDataVideo)
   31 | local formatExperienceIcon = require(GameTile.formatExperienceIcon)
   32 | local formatExperienceRating = require(GameTile.formatExperienceRating)
   33 | local formatExperienceThumbnail = require(GameTile.formatExperienceThumbnail)
   34 | local HiddenTileContent = require(GameTile.HiddenGameTile.HiddenTileContent)
   35 | local ItemLayoutDataParsingUtils = require(GameTile.ItemLayoutDataParsingUtils)
   36 | local Parent = GameTile.Parent
   37 | local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
   38 | local AppBlox = require(Parent.AppBlox)
   39 | local React = require(Parent.React)
   40 | local None = React.None
   41 | local Roact = require(Parent.Roact)
   42 | local RoactRodux = require(Parent.RoactRodux)
   43 | local Cryo = require(Parent.Cryo)
   44 | local Foundation = require(Parent.Foundation)
   45 | local RoactServices = require(Parent.RoactServices).RoactServices
   46 | local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
   47 | local VideoUtils = require(Parent.VideoUtils)
   48 | local t = require(Parent.t)
   49 | local UIBlox = require(Parent.UIBlox)
   50 | local SharedFlags = require(Parent.SharedFlags)
   51 | local FFlagLuaAppGameTileNotInterestedDirectAction = SharedFlags.FFlagLuaAppGameTileNotInterestedDirectAction
   52 | local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
   53 | local withStyle = UIBlox.Style.withStyle
   54 | local Images = UIBlox.App.ImageSet.Images
   55 | local AspectRatioModeEnum = UIBlox.App.Tile.AspectRatioModeEnum
   56 | local ImpressionsTagUtility = require(Parent.Impressions).ImpressionsTagUtility
   57 | local useUiModeInfo = require(Parent.RobloxAppHooks).useUiModeInfo
   58 | local useRoactService = require(Parent.RobloxAppHooks).useRoactService
   59 | local UiMode = require(Parent.RobloxAppEnums).UiMode
   60 | local memoize = require(Parent.AppCommonLib).memoize
   61 | local IntervalPerformanceTracker = require(Parent.IntervalPerformanceTracker).IntervalPerformanceTracker
   62 | local GameIconReducer = require(Parent.GameIconRodux).GameIcons.GameIconReducer
   63 | local GameInfosReducer = require(Parent.GameInfosRodux).GameInfosReducer
   64 | local toLegacyGameInfoModel = require(Parent.GameInfosRodux).toLegacyGameInfoModel
   65 | local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
   66 | require(Parent.DataHydration)
   67 | local GameHydrationReact = require(Parent.GameHydrationReact)
   68 | local useTokens = require(Parent.Foundation).Hooks.useTokens
   69 | local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
   70 | local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
   71 | local useTriggerFeedback = require(Parent.InteractionFeedback).useTriggerFeedback
   72 | local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
   73 | local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
   74 | local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
   75 | local Responsive = require(Parent.Responsive)
   76 | local usePreferredInput = Responsive.usePreferredInput
   77 | local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate
   78 | local DiscoveryAppLaunchTracker = require(Parent.AppLaunchTracker).DiscoveryAppLaunchTracker
   79 | local GetFFlagEnableNavigationPerformanceIntervals = require(Parent.SharedFlags).GetFFlagEnableNavigationPerformanceIntervals
   80 | local FFlagLuaAppMigrateGameTileHoverFixes = require(Parent.SharedFlags).FFlagLuaAppMigrateGameTileHoverFixes
   81 | local FFlagLuaAppMigrateGameTileFixConsoleMetadataText = require(Parent.SharedFlags).FFlagLuaAppMigrateGameTileFixConsoleMetadataText
   82 | local FFlagLuaAppUnifyPlayButtonTile = require(Parent.SharedFlags).FFlagLuaAppUnifyPlayButtonTile
   83 | local FFlagLuaAppEdpMediaGalleryVideoPreview = require(Parent.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
   84 | local FFlagLuaAppEdpMediaGalleryFullScreen = require(Parent.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
   85 | local FFlagLuaAppGameDetailsAttributionFix = require(Parent.SharedFlags).FFlagLuaAppGameDetailsAttributionFix
   86 | local v_u_1 = game:DefineFastFlag("LuaAppUseRatingFormatHelper2", false)
   87 | local FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix = require(Parent.SharedFlags).FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix
   88 | local FFlagGameTileMigrateOffLegacyPresence = require(Parent.SharedFlags).FFlagGameTileMigrateOffLegacyPresence
   89 | local v_u_2
   90 | if FFlagGameTileMigrateOffLegacyPresence then
   91 | 	v_u_2 = require(Parent.FriendsHydrationReact).useGetOnlineFriendsByUniverseId
   92 | else
   93 | 	v_u_2 = nil
   94 | end
   95 | local FFlagLuaAppHapticTriggeredTelemetry = require(Parent.SharedFlags).FFlagLuaAppHapticTriggeredTelemetry
   96 | local FFlagLuaAppNotInterestedReportPlaceId = require(Parent.SharedFlags).FFlagLuaAppNotInterestedReportPlaceId
   97 | local FFlagLuaAppEnableReportExperience = require(Parent.SharedFlags).FFlagLuaAppEnableReportExperience
   98 | local FFlagLuaAppNarrowTileHideRating = require(Parent.SharedFlags).FFlagLuaAppNarrowTileHideRating
   99 | local FFlagLuaAppNarrowTileHidePlayerCount = require(Parent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount
  100 | local FIntLuaAppGameTileVideoDwellTimeInSec = require(Parent.SharedFlags).FIntLuaAppGameTileVideoDwellTimeInSec
  101 | local FIntLuaAppGameTileVideoVisiblePercent = require(Parent.SharedFlags).FIntLuaAppGameTileVideoVisiblePercent
  102 | local FFlagLuaAppTileVideoCandidateOnly = require(Parent.SharedFlags).FFlagLuaAppTileVideoCandidateOnly
  103 | local FFlagLuaAppOneByTwoHoverIdleAutoplay = require(Parent.SharedFlags).FFlagLuaAppOneByTwoHoverIdleAutoplay
  104 | local v_u_3 = game:DefineFastFlag("LuaAppKeepTileBadgesDuringVideo", false)
  105 | local FFlagLuaAppVideoTileDisableActivation = require(Parent.SharedFlags).FFlagLuaAppVideoTileDisableActivation
  106 | local FFlagLuaAppFixHiddenTileVideoCleanup = require(Parent.SharedFlags).FFlagLuaAppFixHiddenTileVideoCleanup
  107 | local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(Parent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
  108 | local FFlagLuaAppHomeReduceRenders = require(Parent.SharedFlags).FFlagLuaAppHomeReduceRenders
  109 | local FFlagLuaAppContinueSortInstantPlay = require(Parent.SharedFlags).FFlagLuaAppContinueSortInstantPlay
  110 | local FFlagLuaAppGameTileExtractGameDetailsCallback = require(Parent.SharedFlags).FFlagLuaAppGameTileExtractGameDetailsCallback
  111 | local FFlagLuaAppDemoModePlayButtonTelemetry = require(Parent.SharedFlags).FFlagLuaAppDemoModePlayButtonTelemetry
  112 | local InstantPlayLauncher = require(GameTile.InstantPlayLauncher)
  113 | local InstantPlayButton = require(GameTile.InstantPlayButton)
  114 | local FFlagLuaAppGenreRatingFooter = require(Parent.SharedFlags).FFlagLuaAppGenreRatingFooter
  115 | local FFlagLuaAppGameTileSelectionVideoPlayback = require(Parent.SharedFlags).FFlagLuaAppGameTileSelectionVideoPlayback
  116 | local FFlagLuaAppGateVideoPlaybackOnNavigationFocus = require(Parent.SharedFlags).FFlagLuaAppGateVideoPlaybackOnNavigationFocus
  117 | local FFlagLuaAppSearchResultsPageGameTileVideo = require(Parent.SharedFlags).FFlagLuaAppSearchResultsPageGameTileVideo
  118 | local FFlagLuaAppHomeThumbnailPrefetch = require(Parent.SharedFlags).FFlagLuaAppHomeThumbnailPrefetch
  119 | local FFlagLuaAppHomeMomentVideoFallback = require(Parent.SharedFlags).FFlagLuaAppHomeMomentVideoFallback
  120 | local FFlagMigrateGameIconsToStore = require(Parent.SharedFlags).FFlagMigrateGameIconsToStore
  121 | local FFlagMigrateGameInfoToStore = require(Parent.SharedFlags).FFlagMigrateGameInfoToStore
  122 | local v_u_4
  123 | if FFlagLuaAppHomeThumbnailPrefetch then
  124 | 	v_u_4 = require(GameTile.resolveGameTileThumbnailUri)
  125 | else
  126 | 	v_u_4 = nil
  127 | end
  128 | local VideoPlaybackCoordinator = require(Parent.VideoUtils).VideoPlaybackCoordinator
  129 | local GameTileContextualActions = require(GameTile.GameTileContextualActions)
  130 | local GameTileOverflowMenu = require(GameTile.GameTileOverflowMenu)
  131 | local getAvailableGameTileOverflowMenuItems = require(GameTile.getAvailableGameTileOverflowMenuItems)
  132 | local t2 = {}
  133 | game:DefineFastInt("LuaAppGameTileHoverDelayMs", 130)
  134 | local v_u_5 = FFlagLuaAppContinueSortInstantPlay and { Treatment1 = "SDUI.InstantPlay.Treatment1", Treatment2 = "SDUI.InstantPlay.Treatment2", Treatment3 = "SDUI.InstantPlay.Treatment3" } or nil
  135 | local v_u_6 = FFlagLuaAppContinueSortInstantPlay and { [v_u_5.Treatment1] = true, [v_u_5.Treatment2] = true, [v_u_5.Treatment3] = true } or nil
  136 | local v_u_7

--- SOURCE LINES 1527-1637 ---
 1527 | 			end
 1528 | 		else
 1529 | 			v133 = v133 and v133.title
 1530 | 			if not v133 then
 1531 | 				v133 = v124 and v124.name or ""
 1532 | 			end
 1533 | 		end
 1534 | 		local t20 = { game = v124, universeId = universeId }
 1535 | 		if FFlagLuaAppGameDetailsAttributionFix then
 1536 | 			v123 = nil
 1537 | 		end
 1538 | 		t20.navigationUniverseId = v123
 1539 | 		t20.name = v133
 1540 | 		t20.totalUpVotes = v126
 1541 | 		t20.totalDownVotes = v125
 1542 | 		t20.imageThumbnail = v135
 1543 | 		t20.wideThumbnail = v136
 1544 | 		t20.videoThumbnail = v141
 1545 | 		if not FFlagLuaAppHomeMomentVideoFallback then
 1546 | 			v139 = nil
 1547 | 		end
 1548 | 		t20.videoAccessContext = v139
 1549 | 		t20.friendActivityTitle = v127
 1550 | 		t20.rating = v142
 1551 | 		t20.showAgeRating = v128
 1552 | 		t20.ageRatingText = v131
 1553 | 		t20.friendVisits = v145
 1554 | 		t20.friendVisitedString = v146
 1555 | 		t20.hidePlayButton = v132
 1556 | 		t20.footerLayoutData = v147
 1557 | 		return t20
 1558 | 	end, function(p_u_148)
 1559 | 		--[[ line: 1467 | upvalues: (copy) OpenCentralOverlayForPlacesList, (copy) OpenSponsoredTooltip]]
 1560 | 		return { openContextualMenu = function(p149, p150, p151)
 1561 | 				--[[ line: 1469 | upvalues: (copy) p_u_148, (ref) OpenCentralOverlayForPlacesList]]
 1562 | 				p_u_148(OpenCentralOverlayForPlacesList(p149, p150, p151))
 1563 | 			end, openSponsoredTooltip = function(p152)
 1564 | 				--[[ line: 1472 | upvalues: (copy) p_u_148, (ref) OpenSponsoredTooltip]]
 1565 | 				return p_u_148(OpenSponsoredTooltip(p152))
 1566 | 			end }
 1567 | 	end)(AppGameTile)
 1568 | 	if not FFlagLuaAppGameDetailsAttributionFix then
 1569 | 		v_u_153 = RoactServices.connect({ networking = RoactNetworking })(v_u_153)
 1570 | 	end
 1571 | 	v219 = function(p_u_154)
 1572 | 		--[[ line: 1484 | upvalues: (copy) React, (copy) useTokens, (copy) FFlagMigrateGameIconsToStore, (copy) GameHydrationReact, (copy) useIsHoveredTile, (copy) useUiModeInfo, (copy) UiMode, (copy) useValidTileBadges, (copy) useSelector, (copy) FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix, (copy) useHasInGameFriends, (copy) FFlagGameTileMigrateOffLegacyPresence, (copy) v_u_2, (copy) Cryo, (copy) useInGameUserIds, (copy) FFlagLuaAppGameTileSelectionVideoPlayback, (copy) FFlagLuaAppSearchResultsPageGameTileVideo, (copy) FFlagLuaAppGateVideoPlaybackOnNavigationFocus, (copy) FFlagLuaAppFixHiddenTileVideoCleanup, (copy) FFlagLuaAppGameDetailsAttributionFix, (copy) useRoactService, (copy) RoactNetworking, (copy) sponsoredGamesRecordClick, (copy) HoverTileCoordinator, (copy) VideoEndReason, (copy) VideoPlaybackCoordinator, (copy) GameCollectionItemTypes, (copy) GetFFlagEnableNavigationPerformanceIntervals, (copy) IntervalPerformanceTracker, (copy) useOverflowMenuOpen, (copy) useTriggerFeedback, (copy) FFlagLuaAppContinueSortInstantPlay, (copy) v_u_11, (copy) getAvailableGameTileOverflowMenuItems, (copy) FFlagLuaAppEnableReportExperience, (copy) useHasVideoThumbnailSelector, (copy) useTagAsViewportAutoplayCandidate, (copy) FFlagLuaAppTileVideoCandidateOnly, (copy) FFlagLuaAppOneByTwoHoverIdleAutoplay, (copy) FFlagLuaAppEdpMediaGalleryVideoPreview, (copy) usePreferredInput, (copy) GameVideoPlaybackDetector, (copy) Responsive, (copy) FIntLuaAppGameTileVideoDwellTimeInSec, (copy) FIntLuaAppGameTileVideoVisiblePercent, (copy) FFlagLuaAppUsePrevalidatedVideoGamePlayability, (ref) v_u_153]]
 1573 | 		local v155 = React.useRef(nil)
 1574 | 		local v156 = useTokens()
 1575 | 		local useHoverTile = p_u_154.useHoverTile
 1576 | 		local v157
 1577 | 		if FFlagMigrateGameIconsToStore then
 1578 | 			v157 = GameHydrationReact.useGameIcon(p_u_154.entry.universeId)
 1579 | 		else
 1580 | 			v157 = nil
 1581 | 		end
 1582 | 		local v158 = ("%*_%*_%*"):format(p_u_154.impressionsTag or "", p_u_154.index or "0", p_u_154.gameTileLayoutType or "Narrow")
 1583 | 		if p_u_154.impressionsTag == nil or p_u_154.index == nil then
 1584 | 			useHoverTile = false
 1585 | 		end
 1586 | 		local v159 = useIsHoveredTile(v155, v158, useHoverTile)
 1587 | 		local v160 = useUiModeInfo().uiMode == UiMode.TenFoot
 1588 | 		local v161 = v160 and true or p_u_154.useHoverTile
 1589 | 		if p_u_154.useExperienceTileMetadata ~= nil then
 1590 | 			v160 = p_u_154.useExperienceTileMetadata
 1591 | 		end
 1592 | 		local v162 = useValidTileBadges(p_u_154.entry.universeId, p_u_154.topicId, p_u_154.badgeOverride)
 1593 | 		local v164 = useSelector(function(p163)
 1594 | 			--[[ line: 1512 | upvalues: none]]
 1595 | 			return p163.LocalUserId
 1596 | 		end)
 1597 | 		local v165
 1598 | 		if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
 1599 | 			v165 = nil
 1600 | 		else
 1601 | 			v165 = useSelector(function(p166)
 1602 | 				--[[ line: 1518 | upvalues: none]]
 1603 | 				return p166.Users
 1604 | 			end)
 1605 | 		end
 1606 | 		local v168 = useSelector(function(p167)
 1607 | 			--[[ line: 1523 | upvalues: (copy) p_u_154]]
 1608 | 			return p167.InGameUsersByGame[p_u_154.entry.universeId]
 1609 | 		end)
 1610 | 		local v169 = useHasInGameFriends(v164, v165, v168)
 1611 | 		local v_u_170
 1612 | 		if FFlagGameTileMigrateOffLegacyPresence then
 1613 | 			v_u_170 = v_u_2(p_u_154.entry.universeId)
 1614 | 		else
 1615 | 			v_u_170 = nil
 1616 | 		end
 1617 | 		local v171
 1618 | 		if FFlagGameTileMigrateOffLegacyPresence then
 1619 | 			v171 = React.useMemo(function()
 1620 | 				--[[ line: 1534 | upvalues: (ref) Cryo, (copy) v_u_170]]
 1621 | 				return Cryo.List.map(v_u_170 or {}, function(p172)
 1622 | 					--[[ line: 1535 | upvalues: none]]
 1623 | 					return p172.id
 1624 | 				end)
 1625 | 			end, { v_u_170 })
 1626 | 		else
 1627 | 			v171 = nil
 1628 | 		end
 1629 | 		if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
 1630 | 			if not FFlagGameTileMigrateOffLegacyPresence then
 1631 | 				v171 = useInGameUserIds(v164, v168)
 1632 | 			end
 1633 | 		else
 1634 | 			v171 = nil
 1635 | 		end
 1636 | 		local v173, v_u_174 = React.useState(false)
 1637 | 		local v175, v176, v177

--- SOURCE LINES 1729-1839 ---
 1729 | 					else
 1730 | 						v192 = nil
 1731 | 					end
 1732 | 					t23.launchData = v192
 1733 | 					t23.tileType = p_u_154.entry.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile
 1734 | 					t23.nativeAdData = p_u_154.entry.adId
 1735 | 					t22.experienceJoinData = t23
 1736 | 					if GetFFlagEnableNavigationPerformanceIntervals() then
 1737 | 						IntervalPerformanceTracker:startTracking("AppGameTile_to_GameDetail", 2)
 1738 | 					end
 1739 | 					p_u_154.navigateToGameDetails(v_u_187, t22)
 1740 | 					p_u_154.reportGameDetailOpened(p_u_154.index, v_u_187)
 1741 | 					v_u_190()
 1742 | 				end
 1743 | 			end
 1744 | 			local t24 = {}
 1745 | 			local isHovered = p_u_154.isHovered
 1746 | 			local index3 = p_u_154.index
 1747 | 			local videoAnalytics = p_u_154.videoAnalytics
 1748 | 			local onActivated = p_u_154.onActivated
 1749 | 			local source = p_u_154.source
 1750 | 			local referralSource2 = p_u_154.referralSource
 1751 | 			local onPeekViewClosed = p_u_154.onPeekViewClosed
 1752 | 			local navigateToGameDetails = p_u_154.navigateToGameDetails
 1753 | 			local reportGameDetailOpened = p_u_154.reportGameDetailOpened
 1754 | 			local v194 = v_u_187
 1755 | 			local v195 = v_u_190
 1756 | 			local placeIdOverride = p_u_154.entry.placeIdOverride
 1757 | 			local launchDataOverride = p_u_154.entry.launchDataOverride
 1758 | 			local v196
 1759 | 			if p_u_154.videoPlaybackContext then
 1760 | 				v196 = p_u_154.videoPlaybackContext.videoPlaybackCoordinator
 1761 | 			else
 1762 | 				v196 = nil
 1763 | 			end
 1764 | 			t24[1], t24[2], t24[3], t24[4], t24[5], t24[6], t24[7], t24[8], t24[9], t24[10], t24[11], t24[12], t24[13], t24[14] = isHovered, index3, videoAnalytics, onActivated, source, referralSource2, onPeekViewClosed, navigateToGameDetails, reportGameDetailOpened, v194, v195, placeIdOverride, launchDataOverride, v196
 1765 | 			v188 = useCallback(v193, t24)
 1766 | 			v189 = v_u_190
 1767 | 		else
 1768 | 			v188 = nil
 1769 | 			v_u_187 = nil
 1770 | 			v_u_186 = nil
 1771 | 			v189 = nil
 1772 | 		end
 1773 | 		local v197 = useOverflowMenuOpen(v158)
 1774 | 		local v198 = useTriggerFeedback()
 1775 | 		local v_u_199
 1776 | 		if FFlagLuaAppContinueSortInstantPlay then
 1777 | 			v_u_199 = v_u_11(p_u_154.enableInstantPlay, p_u_154.instantPlayTreatment)
 1778 | 		else
 1779 | 			v_u_199 = nil
 1780 | 		end
 1781 | 		local useMemo = React.useMemo
 1782 | 		local function v203()
 1783 | 			--[[ line: 1695 | upvalues: (ref) getAvailableGameTileOverflowMenuItems, (copy) p_u_154, (ref) FFlagLuaAppContinueSortInstantPlay, (copy) v_u_199, (ref) FFlagLuaAppEnableReportExperience]]
 1784 | 			local v200 = getAvailableGameTileOverflowMenuItems
 1785 | 			local t25 = {
 1786 | 				isSponsored = p_u_154.entry.isSponsored,
 1787 | 				enableExplicitFeedback = p_u_154.enableExplicitFeedback,
 1788 | 				enableSponsoredFeedback = p_u_154.enableSponsoredFeedback,
 1789 | 				enableReportAd = p_u_154.enableReportAd
 1790 | 			}
 1791 | 			local v201
 1792 | 			if FFlagLuaAppContinueSortInstantPlay then
 1793 | 				v201 = v_u_199.isTreatment1
 1794 | 			else
 1795 | 				v201 = nil
 1796 | 			end
 1797 | 			t25.enableGameDetails = v201
 1798 | 			local v202
 1799 | 			if FFlagLuaAppEnableReportExperience then
 1800 | 				v202 = p_u_154.enableReportExperience
 1801 | 			else
 1802 | 				v202 = nil
 1803 | 			end
 1804 | 			t25.enableReportExperience = v202
 1805 | 			return v200(t25)
 1806 | 		end
 1807 | 		local t26 = {}
 1808 | 		local isSponsored = p_u_154.entry.isSponsored
 1809 | 		local enableExplicitFeedback = p_u_154.enableExplicitFeedback
 1810 | 		local enableSponsoredFeedback = p_u_154.enableSponsoredFeedback
 1811 | 		local enableReportAd = p_u_154.enableReportAd
 1812 | 		local v204
 1813 | 		if FFlagLuaAppContinueSortInstantPlay then
 1814 | 			v204 = v_u_199.isTreatment1
 1815 | 		else
 1816 | 			v204 = nil
 1817 | 		end
 1818 | 		local v205
 1819 | 		if FFlagLuaAppEnableReportExperience then
 1820 | 			v205 = p_u_154.enableReportExperience
 1821 | 		else
 1822 | 			v205 = nil
 1823 | 		end
 1824 | 		t26[1], t26[2], t26[3], t26[4], t26[5], t26[6] = isSponsored, enableExplicitFeedback, enableSponsoredFeedback, enableReportAd, v204, v205
 1825 | 		local v206 = useMemo(v203, t26)
 1826 | 		local v207 = useHasVideoThumbnailSelector(p_u_154.entry.universeId, p_u_154.topicId)
 1827 | 		local v208 = p_u_154.entry.primaryWideVideoAssetId ~= nil and true or v207
 1828 | 		local v209 = useTagAsViewportAutoplayCandidate
 1829 | 		local videoPlaybackContext = p_u_154.videoPlaybackContext
 1830 | 		local v210
 1831 | 		if FFlagLuaAppTileVideoCandidateOnly then
 1832 | 			v210 = v208
 1833 | 		else
 1834 | 			v210 = nil
 1835 | 		end
 1836 | 		local v211
 1837 | 		if FFlagLuaAppFixHiddenTileVideoCleanup then
 1838 | 			v211 = p_u_154.isHidden
 1839 | 		else


========================================
MATCH #4
PATH: CorePackages.Workspace.Packages._Index.Moments.Moments.Components.Feed.Items.Moment.Scrubber.PreviewPopover
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 5327
========================================

--- SOURCE LINES 61-136 ---
   61 | 		local current = v_u_11.current
   62 | 		if current ~= nil then
   63 | 			local function update()
   64 | 				--[[ line: 86 | upvalues: (ref) v_u_14, (copy) current]]
   65 | 				v_u_14({ position = current.AbsolutePosition.X, width = current.AbsoluteSize.X })
   66 | 			end
   67 | 			v_u_14({ position = current.AbsolutePosition.X, width = current.AbsoluteSize.X })
   68 | 			local v_u_17 = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(update)
   69 | 			local v_u_18 = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
   70 | 			return function()
   71 | 				--[[ line: 96 | upvalues: (copy) v_u_17, (copy) v_u_18]]
   72 | 				v_u_17:Disconnect()
   73 | 				v_u_18:Disconnect()
   74 | 			end
   75 | 		end
   76 | 	end, {})
   77 | 	React.useEffect(function()
   78 | 		--[[ line: 104 | upvalues: (copy) v_u_12, (copy) v_u_16]]
   79 | 		local current2 = v_u_12.current
   80 | 		if current2 ~= nil then
   81 | 			local function update2()
   82 | 				--[[ line: 110 | upvalues: (ref) v_u_16, (copy) current2]]
   83 | 				v_u_16(current2.AbsoluteSize.X)
   84 | 			end
   85 | 			v_u_16(current2.AbsoluteSize.X)
   86 | 			local v_u_19 = current2:GetPropertyChangedSignal("AbsoluteSize"):Connect(update2)
   87 | 			return function()
   88 | 				--[[ line: 116 | upvalues: (copy) v_u_19]]
   89 | 				v_u_19:Disconnect()
   90 | 			end
   91 | 		end
   92 | 	end, { v8 })
   93 | 	local Size_100 = v_u_2.Size.Size_100
   94 | 	local v25 = React.joinBindings({ p1.progressRatio, v13, v15 }):map(function(p20: {[any]: any})
   95 | 		--[[ line: 124 | upvalues: (ref) previewPopoverMath, (copy) v_u_4, (copy) v_u_5, (copy) Size_100, (copy) v_u_2]]
   96 | 		local v21 = p20[1]
   97 | 		local v22 = p20[2]
   98 | 		local v23 = p20[3]
   99 | 		local v24 = previewPopoverMath.getCenterOffsetX({
  100 | 			ratio = v21,
  101 | 			containerPosition = v22.position,
  102 | 			containerWidth = v22.width,
  103 | 			popoverWidth = v23,
  104 | 			screenWidth = v_u_4.X,
  105 | 			insetLeft = v_u_5.left,
  106 | 			insetRight = v_u_5.right,
  107 | 			margin = Size_100
  108 | 		})
  109 | 		return UDim2.new(0, v24, 0, -v_u_2.Size.Size_600)
  110 | 	end)
  111 | 	local createElement = React.createElement
  112 | 	local v26 = View
  113 | 	local t = { tag = "size-full", ref = v_u_11 }
  114 | 	local t2 = {}
  115 | 	local v27
  116 | 	if v8 then
  117 | 		local createElement2 = React.createElement
  118 | 		local v28 = View
  119 | 		local t3 = { tag = "col align-x-center gap-medium anchor-bottom-center auto-xy", ref = v_u_12, Position = v25 }
  120 | 		local t4 = {}
  121 | 		local v29
  122 | 		if controller == nil or not controller.getHasVideoPreview() then
  123 | 			v29 = nil
  124 | 		else
  125 | 			v29 = React.createElement(VideoPreview, { preview = v7, animationRatio = v3.animationRatio, LayoutOrder = v6() })
  126 | 		end
  127 | 		t4.VideoPreview = v29
  128 | 		t4.TimeLabel = React.createElement(TimeLabel, { progress = p1.progress, animationRatio = v3.animationRatio, LayoutOrder = v6() })
  129 | 		v27 = createElement2(v28, t3, t4)
  130 | 	else
  131 | 		v27 = nil
  132 | 	end
  133 | 	t2.MovingContainer = v27
  134 | 	return createElement(v26, t, t2)
  135 | end
  136 | return React.memo(PreviewPopover)


========================================
MATCH #5
PATH: CorePackages.Workspace.Packages._Index.Moments.Moments.Components.Feed.Items.Moment.Scrubber.previewPopoverMath
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 594
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return { getCenterOffsetX = function(p1: {[any]: any})
    4 | 		--[[ line: 42 | upvalues: none]]
    5 | 		local v2 = p1.containerPosition + p1.ratio * p1.containerWidth
    6 | 		local v3 = p1.insetLeft + p1.margin
    7 | 		local v4 = p1.screenWidth - p1.insetRight - p1.margin
    8 | 		local v5 = v4 - v3
    9 | 		if v5 <= 0 or p1.popoverWidth <= 0 then
   10 | 			return v2 - p1.containerPosition
   11 | 		end
   12 | 		local v6 = v3 + p1.popoverWidth / 2
   13 | 		local v7 = v4 - p1.popoverWidth / 2
   14 | 		local v8
   15 | 		if v7 < v6 then
   16 | 			v8 = v3 + v5 / 2
   17 | 		else
   18 | 			v8 = math.clamp(v2, v6, v7)
   19 | 		end
   20 | 		return v8 - p1.containerPosition
   21 | 	end }


========================================
MATCH #6
PATH: CorePackages.Workspace.Packages._Index.SponsoredTiles.SponsoredTiles.OneByTwoTile
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 43966
========================================

--- SOURCE LINES 12-234 ---
   12 | local normalizeFontFace = Foundation.Utility.normalizeFontFace
   13 | local PlayButton = require(Parent.GamePlayButton).PlayButton
   14 | local useLocalization = require(Parent.Localization).Hooks.useLocalization
   15 | local DiscoveryTypes = require(Parent.DiscoveryTypes)
   16 | local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType
   17 | local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
   18 | local GameHydrationReact = require(Parent.GameHydrationReact)
   19 | local useGameInfosSelector = require(Parent.GameInfosRodux).useGameInfosSelector
   20 | local useNavigation = require(Parent.Navigation).useNavigation
   21 | local AppPage = require(Parent.RobloxAppEnums).AppPage
   22 | local useRoactService = require(Parent.RobloxAppHooks).useRoactService
   23 | local RoactServiceTags = require(Parent.RoactServiceTags)
   24 | local RoactNetworking = RoactServiceTags.RoactNetworking
   25 | local AppSessionService = RoactServiceTags.AppSessionService
   26 | local RobloxAppSessionization = require(Parent.RobloxAppSessionization)
   27 | local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
   28 | local SessionType = RobloxAppSessionization.SessionType
   29 | local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
   30 | local sponsoredGamesRecordClick = DiscoveryAnalytics.Requests.sponsoredGamesRecordClick
   31 | local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
   32 | local OneByTwoTileTelemetry = require(Parent.SponsoredTilesTelemetry).OneByTwoTileTelemetry
   33 | require(SponsoredTiles.types)
   34 | local VideoPlayer = require(Parent.VideoPlayer)
   35 | local VideoDisplay = VideoPlayer.VideoDisplay
   36 | local VideoLoadingState = VideoPlayer.VideoLoadingState
   37 | local VideoUtils = require(Parent.VideoUtils)
   38 | local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
   39 | local VideoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
   40 | local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
   41 | local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate
   42 | local getPlaybackDetectionMethod = VideoUtils.getPlaybackDetectionMethod
   43 | local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
   44 | local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason
   45 | local useTagAsSponsoredAdViewabilityCandidate = require(Parent.SponsoredAdViewability).useTagAsSponsoredAdViewabilityCandidate
   46 | local ImpressionsTagUtility = require(Parent.Impressions).ImpressionsTagUtility
   47 | local useIsHoveredTile = GameTile.useIsHoveredTile
   48 | local useValidTileBadges = GameTile.useValidTileBadges
   49 | local GameTileThumbnailBadges = GameTile.GameTileThumbnailBadges
   50 | local HoverTileCoordinator = GameTile.HoverTileCoordinator
   51 | local TileVideoBlockingConfig = GameTile.TileVideoBlockingConfig
   52 | local getAvailableGameTileOverflowMenuItems = GameTile.getAvailableGameTileOverflowMenuItems
   53 | local SpanTileOverflowMenu = require(SponsoredTiles.SpanTileOverflowMenu.SpanTileOverflowMenu)
   54 | local AppBlox = require(Parent.AppBlox)
   55 | local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
   56 | local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
   57 | local useTriggerFeedback = require(Parent.InteractionFeedback).useTriggerFeedback
   58 | local SharedFlags = require(Parent.SharedFlags)
   59 | local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
   60 | local FFlagLuaAppHapticTriggeredTelemetry = SharedFlags.FFlagLuaAppHapticTriggeredTelemetry
   61 | local FFlagLuaAppSponsoredAdVideoViewabilityEnabled = SharedFlags.FFlagLuaAppSponsoredAdVideoViewabilityEnabled
   62 | local FIntLuaAppGameTileVideoDwellTimeInSec = SharedFlags.FIntLuaAppGameTileVideoDwellTimeInSec
   63 | local FIntLuaAppGameTileVideoVisiblePercent = SharedFlags.FIntLuaAppGameTileVideoVisiblePercent
   64 | local FFlagLuaAppGameTileSelectionVideoPlayback = SharedFlags.FFlagLuaAppGameTileSelectionVideoPlayback
   65 | local FFlagLuaAppNotInterestedReportPlaceId = SharedFlags.FFlagLuaAppNotInterestedReportPlaceId
   66 | local FFlagLuaAppSduiSponsoredOneByTwoTile = SharedFlags.FFlagLuaAppSduiSponsoredOneByTwoTile
   67 | local FFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
   68 | local v_u_1 = game:DefineFastFlag("LuaAppDefaultGameAdTileText", false)
   69 | local FFlagLuaAppOneByTwoTileGatePlayerOnVideoLoad = SharedFlags.FFlagLuaAppOneByTwoTileGatePlayerOnVideoLoad
   70 | local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay
   71 | local FFlagLuaAppVideoAutoplayOneByTwoTileCandidatePercentageUpdate = SharedFlags.FFlagLuaAppVideoAutoplayOneByTwoTileCandidatePercentageUpdate
   72 | local FFlagLuaAppVideoAutoplayOneByTwoTileDoubleAnchor = SharedFlags.FFlagLuaAppVideoAutoplayOneByTwoTileDoubleAnchor
   73 | local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
   74 | local FFlagLuaAppEnableOneByTwoTileFunnelTelemetry = SharedFlags.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry
   75 | local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
   76 | local v2 = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentLandscape", 40)
   77 | local v3 = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentSquare", 25)
   78 | local v4 = game:DefineFastInt("LuaAppOneByTwoTileGradientBottomTransparencyPercent", 25)
   79 | local v5 = game:DefineFastInt("LuaAppOneByTwoTileGradientTopTransparencyPercent", 100)
   80 | local v6 = game:DefineFastInt("LuaAppOneByTwoTileGradientBottomHeightPercent", 50)
   81 | local v_u_7 = v2 / 100
   82 | local v_u_8 = v3 / 100
   83 | local v_u_9 = v4 / 100
   84 | local v_u_10 = v5 / 100
   85 | local v_u_11 = v6 / 100
   86 | local function OneByTwoTile(p_u_12: {[any]: any})
   87 | 	--[[ line: 181 | upvalues: (copy) useTokens, (copy) Responsive, (copy) React, (copy) useIsHoveredTile, (copy) OmniRecommendationsContentType, (copy) v_u_1, (copy) FFlagMigrateGameInfoToStore, (copy) GameHydrationReact, (copy) useGameInfosSelector, (copy) useOverflowMenuOpen, (copy) useTriggerFeedback, (copy) FFlagLuaAppVideoAutoplayOneByTwoTileDoubleAnchor, (copy) DiscoveryEventErrorLogger, (copy) GameCollectionItemTypes, (copy) FFlagLuaAppEnableOneByTwoTileFunnelTelemetry, (copy) OneByTwoTileTelemetry, (copy) FFlagLuaAppOneByTwoHoverIdleAutoplay, (copy) FFlagLuaAppSponsoredAdVideoViewabilityEnabled, (copy) useTagAsViewportAutoplayCandidate, (copy) FFlagLuaAppVideoAutoplayOneByTwoTileCandidatePercentageUpdate, (copy) useTagAsSponsoredAdViewabilityCandidate, (copy) VideoPlaybackCoordinator, (copy) getAvailableGameTileOverflowMenuItems, (copy) FFlagLuaAppEnableReportExperience, (copy) FFlagLuaAppSduiSponsoredOneByTwoTile, (copy) FFlagLuaAppHapticTriggeredTelemetry, (copy) getOverflowMenuSignalStore, (copy) FFlagLuaAppOneByTwoTileGatePlayerOnVideoLoad, (copy) VideoLoadingState, (copy) useCanDevicePlayVideoPreview, (copy) TileVideoBlockingConfig, (copy) useRoactService, (copy) RoactNetworking, (copy) AppSessionService, (copy) useNavigation, (copy) useLocalization, (copy) DiscoveryAnalytics, (copy) sponsoredGamesRecordClick, (copy) SetGamePlaySession, (copy) SessionType, (copy) HoverTileCoordinator, (copy) FFlagLuaAppDemoModePlayButtonTelemetry, (copy) VideoEndReason, (copy) AppPage, (copy) ImpressionsTagUtility, (copy) useValidTileBadges, (copy) v_u_7, (copy) v_u_8, (copy) ButtonSize, (copy) VideoDisplay, (copy) v_u_10, (copy) v_u_11, (copy) v_u_9, (copy) GameTileThumbnailBadges, (copy) Image, (copy) SpanTileOverflowMenu, (copy) FFlagLuaAppNotInterestedReportPlaceId, (copy) FoundationFontFaceMigration, (copy) normalizeFontFace, (copy) PlayButton, (copy) FFlagLuaAppGameTileSelectionVideoPlayback, (copy) getPlaybackDetectionMethod, (copy) VideoPlaybackDetector, (copy) VideoPlaybackDetectionMethod, (copy) FIntLuaAppGameTileVideoDwellTimeInSec, (copy) FIntLuaAppGameTileVideoVisiblePercent]]
   88 | 	local v13 = useTokens()
   89 | 	local v14 = Responsive.useResponsive({ Responsive.BreakpointConfig.sizes.Small }) == Responsive.Keys.Small
   90 | 	local v_u_15 = React.useRef(nil)
   91 | 	local v_u_16 = React.useRef(nil)
   92 | 	local hoverKey = p_u_12.hoverKey
   93 | 	local v17 = Responsive.useLastInput() ~= Responsive.Input.Touch
   94 | 	local v_u_18 = useIsHoveredTile(v_u_15, hoverKey, v17)
   95 | 	local v19 = Responsive.usePreferredInput()
   96 | 	local v_u_20
   97 | 	if p_u_12.adId == nil then
   98 | 		v_u_20 = false
   99 | 	else
  100 | 		v_u_20 = p_u_12.adId ~= ""
  101 | 	end
  102 | 	local v_u_21 = p_u_12.contentType == OmniRecommendationsContentType.AdLink
  103 | 	if v_u_21 then
  104 | 		local v22
  105 | 		if p_u_12.clickoutUrl == nil then
  106 | 			v22 = false
  107 | 		else
  108 | 			v22 = p_u_12.clickoutUrl ~= ""
  109 | 		end
  110 | 		assert(v22, "OneByTwoTile AdLink requires clickoutUrl")
  111 | 	else
  112 | 		local v23
  113 | 		if p_u_12.universeId == nil then
  114 | 			v23 = false
  115 | 		else
  116 | 			v23 = p_u_12.universeId ~= ""
  117 | 		end
  118 | 		assert(v23, "OneByTwoTile Game requires universeId")
  119 | 	end
  120 | 	local createElement11, Fragment, v164, t26
  121 | 	do
  122 | 		local v_u_24, v_u_25, v30, v_u_31, v_u_34, v37, v43, v_u_44, v_u_45, v46, v_u_52, v53, v54, v55, v65
  123 | 		do
  124 | 			local headline = p_u_12.headline
  125 | 			local subtitle = p_u_12.subtitle
  126 | 			v_u_24 = nil
  127 | 			v_u_25 = nil
  128 | 			if v_u_1 then
  129 | 				if FFlagMigrateGameInfoToStore then
  130 | 					local v26 = GameHydrationReact.useGameInfo(p_u_12.universeId or "")
  131 | 					if v26 then
  132 | 						v_u_24 = v26.name
  133 | 						v_u_25 = v26.gameAgeDisplayName
  134 | 					end
  135 | 				else
  136 | 					local v27 = useGameInfosSelector(p_u_12.universeId or "")
  137 | 					if v27 then
  138 | 						v_u_24 = v27.name
  139 | 						v_u_25 = v27.ageRecommendationDisplayName
  140 | 					end
  141 | 				end
  142 | 				if p_u_12.contentType == OmniRecommendationsContentType.Game then
  143 | 					local v28 = headline
  144 | 					if v28 == nil or v28 == "" then
  145 | 						if v_u_24 == nil or v_u_24 == "" then
  146 | 							v_u_24 = nil
  147 | 						end
  148 | 					else
  149 | 						v_u_24 = v28
  150 | 					end
  151 | 					local v29 = subtitle
  152 | 					if v29 == nil or v29 == "" then
  153 | 						if v_u_25 == nil or v_u_25 == "" then
  154 | 							v_u_25 = nil
  155 | 						end
  156 | 					else
  157 | 						v_u_25 = v29
  158 | 					end
  159 | 				else
  160 | 					v_u_24 = headline
  161 | 					v_u_25 = subtitle
  162 | 				end
  163 | 			else
  164 | 				v_u_24 = headline
  165 | 				v_u_25 = subtitle
  166 | 			end
  167 | 			v30, v_u_31 = React.useState(false)
  168 | 			local v_u_32 = useOverflowMenuOpen(hoverKey)
  169 | 			local v_u_33 = useTriggerFeedback()
  170 | 			v_u_34 = React.useRef(false)
  171 | 			local v35
  172 | 			if FFlagLuaAppVideoAutoplayOneByTwoTileDoubleAnchor then
  173 | 				local v_u_36 = false
  174 | 				if p_u_12.cellVerticalPadding == nil then
  175 | 					if p_u_12.size == nil or p_u_12.size.Height.Scale <= 1 then
  176 | 						v35 = v13.Gap.Large
  177 | 						v_u_36 = true
  178 | 					else
  179 | 						v35 = p_u_12.size.Height.Offset / (p_u_12.size.Height.Scale - 1)
  180 | 					end
  181 | 				else
  182 | 					v35 = p_u_12.cellVerticalPadding
  183 | 				end
  184 | 				local t = { v_u_36 }
  185 | 				React.useEffect(function()
  186 | 					--[[ line: 246 | upvalues: (ref) v_u_36, (ref) DiscoveryEventErrorLogger]]
  187 | 					if v_u_36 then
  188 | 						DiscoveryEventErrorLogger.reportError("SponsoredTiles", "OneByTwoTile: could not resolve cellVerticalPadding for a 1x2 tile")
  189 | 					end
  190 | 				end, t)
  191 | 				React.useEffect(function()
  192 | 					--[[ line: 255 | upvalues: (copy) p_u_12, (ref) GameCollectionItemTypes, (ref) DiscoveryEventErrorLogger]]
  193 | 					if p_u_12.alignmentType ~= GameCollectionItemTypes.AlignmentType.LeftPin and p_u_12.alignmentType ~= GameCollectionItemTypes.AlignmentType.RightPin then
  194 | 						local reportError = DiscoveryEventErrorLogger.reportError
  195 | 						local t2 = {}
  196 | 						local alignmentType = p_u_12.alignmentType
  197 | 						t2.alignmentType = tostring(alignmentType)
  198 | 						reportError("SponsoredTiles", "OneByTwoTile: 1x2 tile is neither left- nor right-pinned", t2)
  199 | 					end
  200 | 				end, { p_u_12.alignmentType })
  201 | 			else
  202 | 				v35 = nil
  203 | 			end
  204 | 			if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
  205 | 				React.useEffect(function()
  206 | 					--[[ line: 271 | upvalues: (copy) p_u_12, (ref) OneByTwoTileTelemetry, (ref) GameCollectionItemTypes]]
  207 | 					if p_u_12.oneByTwoTileFlowId then
  208 | 						OneByTwoTileTelemetry.logOneByTwoTileRendered({
  209 | 							oneByTwoTileFlowId = p_u_12.oneByTwoTileFlowId,
  210 | 							recommendationsRequestId = p_u_12.recommendationsRequestId,
  211 | 							topicId = p_u_12.topicId,
  212 | 							contentType = p_u_12.contentType,
  213 | 							adId = p_u_12.adId,
  214 | 							componentType = GameCollectionItemTypes.GameCollectionItemType.OneByTwoTile,
  215 | 							alignmentType = p_u_12.alignmentType,
  216 | 							isSdui = p_u_12.isSdui == true
  217 | 						})
  218 | 					end
  219 | 				end, {
  220 | 					p_u_12.oneByTwoTileFlowId,
  221 | 					p_u_12.recommendationsRequestId,
  222 | 					p_u_12.topicId,
  223 | 					p_u_12.contentType,
  224 | 					p_u_12.adId,
  225 | 					p_u_12.alignmentType,
  226 | 					p_u_12.isSdui
  227 | 				})
  228 | 			end
  229 | 			if FFlagLuaAppOneByTwoHoverIdleAutoplay and (FFlagLuaAppSponsoredAdVideoViewabilityEnabled and v_u_20) then
  230 | 				v37 = ("%*|%*"):format(hoverKey, p_u_12.adId)
  231 | 			else
  232 | 				v37 = hoverKey
  233 | 			end
  234 | 			local v38 = useTagAsViewportAutoplayCandidate


========================================
MATCH #7
PATH: CorePackages.Workspace.Packages._Index.SponsoredTiles.SponsoredTiles.TwoByOneGameTile
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 32481
========================================

--- SOURCE LINES 1-226 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local SponsoredTiles = script:FindFirstAncestor("SponsoredTiles")
    4 | local Parent = SponsoredTiles.Parent
    5 | local GameTile = require(Parent.GameTile)
    6 | local getGameTileLayoutData = GameTile.getGameTileLayoutData
    7 | local formatExperienceThumbnail = GameTile.formatExperienceThumbnail
    8 | local useIsHoveredTile = GameTile.useIsHoveredTile
    9 | local useNavigateToGameDetails = GameTile.useNavigateToGameDetails
   10 | local GameTileThumbnailBadges = GameTile.GameTileThumbnailBadges
   11 | local getAvailableGameTileOverflowMenuItems = GameTile.getAvailableGameTileOverflowMenuItems
   12 | local SpanTileOverflowMenu = require(SponsoredTiles.SpanTileOverflowMenu.SpanTileOverflowMenu)
   13 | local TwoByOneGameTileTelemetry = require(Parent.SponsoredTilesTelemetry).TwoByOneGameTileTelemetry
   14 | require(SponsoredTiles.types)
   15 | local HiddenTileContent = GameTile.HiddenTileContent
   16 | local ItemLayoutDataParsingUtils = GameTile.ItemLayoutDataParsingUtils
   17 | local HoverTileCoordinator = GameTile.HoverTileCoordinator
   18 | local React = require(Parent.React)
   19 | local Foundation = require(Parent.Foundation)
   20 | local ButtonSize = Foundation.Enums.ButtonSize
   21 | local useTokens = Foundation.Hooks.useTokens
   22 | local Image = Foundation.Image
   23 | local normalizeFontFace = Foundation.Utility.normalizeFontFace
   24 | local Responsive = require(Parent.Responsive)
   25 | local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
   26 | local GameInfosReducer = require(Parent.GameInfosRodux).GameInfosReducer
   27 | local AppBlox = require(Parent.AppBlox)
   28 | local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
   29 | local useOverflowMenuOpen = AppBlox.useOverflowMenuOpen
   30 | local useTriggerFeedback = require(Parent.InteractionFeedback).useTriggerFeedback
   31 | local ImpressionsTagUtility = require(Parent.Impressions).ImpressionsTagUtility
   32 | local GetTextSize = require(Parent.Style).GetTextSize
   33 | local PlayButton = require(Parent.GamePlayButton).PlayButton
   34 | local useOnPlayButtonCallback = require(Parent.GamePlayButton).useOnPlayButtonCallback
   35 | local usePlayButtonState = require(Parent.GamePlayButton).usePlayButtonState
   36 | local useLocalization = require(Parent.Localization).Hooks.useLocalization
   37 | local useRoactService = require(Parent.RobloxAppHooks).useRoactService
   38 | local RoactServiceTags = require(Parent.RoactServiceTags)
   39 | local RoactNetworking = RoactServiceTags.RoactNetworking
   40 | local AppSessionService = RoactServiceTags.AppSessionService
   41 | local RobloxAppSessionization = require(Parent.RobloxAppSessionization)
   42 | local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
   43 | local SessionType = RobloxAppSessionization.SessionType
   44 | local SharedFlags = require(Parent.SharedFlags)
   45 | local sponsoredGamesRecordClick = require(Parent.DiscoveryAnalytics).Requests.sponsoredGamesRecordClick
   46 | local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
   47 | local useValidTileBadges = GameTile.useValidTileBadges
   48 | local useTagAsViewportAutoplayCandidate = require(Parent.VideoUtils).useTagAsViewportAutoplayCandidate
   49 | local useTagAsSponsoredAdViewabilityCandidate = require(Parent.SponsoredAdViewability).useTagAsSponsoredAdViewabilityCandidate
   50 | local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
   51 | local v_u_1 = game:DefineFastInt("LuaAppTwoByOneTileSmallScreenBreakpoint", 600)
   52 | local v2 = game:DefineFastInt("LuaAppTwoByOneTileLogoHeightPercentLandscape", 20)
   53 | local v3 = game:DefineFastInt("LuaAppTwoByOneTileLogoHeightPercentSquare", 36)
   54 | local v4 = game:DefineFastInt("LuaAppTwoByOneTileGradientStartOpacityPercent", 30)
   55 | local v5 = game:DefineFastInt("LuaAppTwoByOneTileGradientEndOpacityPercent", 100)
   56 | local v6 = game:DefineFastInt("LuaAppTwoByOneTileGradientWidthPercent", 50)
   57 | local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver
   58 | local FFlagLuaAppHapticTriggeredTelemetry = SharedFlags.FFlagLuaAppHapticTriggeredTelemetry
   59 | local FFlagLuaAppTileVideoCandidateOnly = SharedFlags.FFlagLuaAppTileVideoCandidateOnly
   60 | local FFlagLuaAppSponsoredAdViewabilityEnabled = SharedFlags.FFlagLuaAppSponsoredAdViewabilityEnabled
   61 | local FFlagLuaAppSponsoredAdVideoViewabilityEnabled = SharedFlags.FFlagLuaAppSponsoredAdVideoViewabilityEnabled
   62 | local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags.FFlagLuaAppDemoModePlayButtonTelemetry
   63 | local FFlagLuaAppHomeThumbnailPrefetch = SharedFlags.FFlagLuaAppHomeThumbnailPrefetch
   64 | local FFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
   65 | local FFlagLuaAppNotInterestedReportPlaceId = SharedFlags.FFlagLuaAppNotInterestedReportPlaceId
   66 | local FFlagLuaAppSduiSponsoredTwoByOneTile = SharedFlags.FFlagLuaAppSduiSponsoredTwoByOneTile
   67 | local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
   68 | local v_u_7
   69 | if FFlagLuaAppHomeThumbnailPrefetch then
   70 | 	v_u_7 = GameTile.resolveGameTileThumbnailUri
   71 | else
   72 | 	v_u_7 = nil
   73 | end
   74 | local v_u_8 = Color3.new(1, 1, 1)
   75 | local v_u_9 = Color3.new(0, 0, 0)
   76 | local v_u_10 = v2 / 100
   77 | local v_u_11 = v3 / 100
   78 | local v_u_12 = v4 / 100
   79 | local v_u_13 = v5 / 100
   80 | local v_u_14 = v6 / 100
   81 | local t = {
   82 | 	Default = { ctaStyle = nil, onCtaActivation = "JoinGame", onTileActivation = "OpenEdp" },
   83 | 	Variant1 = { ctaStyle = nil, onCtaActivation = nil, onTileActivation = "JoinGame" },
   84 | 	Variant2 = { ctaStyle = "StandardLight", onCtaActivation = "OpenEdp", onTileActivation = "JoinGame" },
   85 | 	Variant3 = { ctaStyle = "OverMedia", onCtaActivation = "OpenEdp", onTileActivation = "JoinGame" }
   86 | }
   87 | return function(p_u_15: {[any]: any})
   88 | 	--[[ line: 189 | upvalues: (copy) useNavigateToGameDetails, (copy) useRoactService, (copy) RoactNetworking, (copy) AppSessionService, (copy) useLocalization, (copy) t, (copy) useTokens, (copy) Responsive, (copy) v_u_1, (copy) ButtonSize, (copy) React, (copy) GetTextSize, (copy) v_u_10, (copy) v_u_11, (copy) useValidTileBadges, (copy) useTriggerFeedback, (copy) useOverflowMenuOpen, (copy) useIsHoveredTile, (copy) FFlagLuaAppSduiSponsoredTwoByOneTile, (copy) sponsoredGamesRecordClick, (copy) GameCollectionItemTypes, (copy) TwoByOneGameTileTelemetry, (copy) getAvailableGameTileOverflowMenuItems, (copy) FFlagLuaAppEnableReportExperience, (copy) FFlagLuaAppHapticTriggeredTelemetry, (copy) getOverflowMenuSignalStore, (copy) SetGamePlaySession, (copy) SessionType, (copy) HoverTileCoordinator, (copy) FFlagLuaAppDemoModePlayButtonTelemetry, (copy) usePlayButtonState, (copy) useOnPlayButtonCallback, (copy) FFlagMigrateGameInfoToStore, (copy) useSelector, (copy) GameInfosReducer, (copy) FFlagLuaAppHomeThumbnailPrefetch, (copy) v_u_7, (copy) formatExperienceThumbnail, (copy) getGameTileLayoutData, (copy) ItemLayoutDataParsingUtils, (copy) ImpressionsTagUtility, (copy) useTagAsViewportAutoplayCandidate, (copy) FFlagLuaAppTileVideoCandidateOnly, (copy) FFlagLuaAppSponsoredAdViewabilityEnabled, (copy) FFlagLuaAppSponsoredAdVideoViewabilityEnabled, (copy) useTagAsSponsoredAdViewabilityCandidate, (copy) HiddenTileContent, (copy) FFlagLuaAppHomePageFirstImageLoadObserver, (copy) v_u_14, (copy) v_u_8, (copy) v_u_12, (copy) v_u_13, (copy) v_u_9, (copy) GameTileThumbnailBadges, (copy) Image, (copy) FoundationFontFaceMigration, (copy) normalizeFontFace, (copy) PlayButton, (copy) SpanTileOverflowMenu, (copy) FFlagLuaAppNotInterestedReportPlaceId]]
   89 | 	local v_u_16 = useNavigateToGameDetails()
   90 | 	local v_u_17 = useRoactService(RoactNetworking)
   91 | 	local v_u_18 = useRoactService(AppSessionService)
   92 | 	local v19 = useLocalization({ sponsoredText = "Feature.GamePage.Label.Sponsored", joinButtonText = "Common.VisitGame.Label.Play" })
   93 | 	local v_u_20
   94 | 	if p_u_15.ctaText then
   95 | 		v_u_20 = p_u_15.ctaText
   96 | 	else
   97 | 		v_u_20 = v19.joinButtonText
   98 | 	end
   99 | 	local v_u_21 = t[p_u_15.tileVariant] or t.Default
  100 | 	local v22 = useTokens()
  101 | 	local v23 = UDim.new(0, v22.Radius.Medium)
  102 | 	local t2 = {{ Key = "Smaller", maxWidth = v_u_1 }}
  103 | 	local createElement3, v102, t18, t19
  104 | 	do
  105 | 		local v24, v25, v26, v27, v28, v29, v30, v31, v_u_32
  106 | 		if Responsive.useResponsive(t2) == "Smaller" then
  107 | 			v24 = v22.Padding.Medium
  108 | 			v25 = v22.Padding.Medium
  109 | 			v26 = v22.Typography.TitleLarge
  110 | 			v27 = v22.Typography.BodySmall
  111 | 			v28 = v22.Typography.CaptionSmall
  112 | 			v29 = v22.Gap.XXSmall
  113 | 			v30 = ButtonSize.Small
  114 | 			v31 = v22.Size.Size_800
  115 | 			v_u_32 = v22.Typography.TitleSmall
  116 | 		else
  117 | 			v24 = v22.Padding.Large
  118 | 			v25 = v22.Padding.Large
  119 | 			v26 = v22.Typography.HeadingMedium
  120 | 			v27 = v22.Typography.BodyMedium
  121 | 			v28 = v22.Typography.CaptionMedium
  122 | 			v29 = v22.Gap.XSmall
  123 | 			v30 = ButtonSize.Medium
  124 | 			v31 = v22.Size.Size_1000
  125 | 			v_u_32 = v22.Typography.TitleMedium
  126 | 		end
  127 | 		local v_u_33 = v22.Padding.Large * 4
  128 | 		local t3 = { v_u_20, v_u_32, v_u_33 }
  129 | 		local v35 = React.useMemo(function()
  130 | 			--[[ line: 236 | upvalues: (ref) GetTextSize, (copy) v_u_20, (ref) v_u_32, (copy) v_u_33]]
  131 | 			local v34 = GetTextSize(v_u_20, v_u_32.FontSize, v_u_32.Font, Vector2.new(1 / 0, 1 / 0))
  132 | 			return UDim.new(0, v34.X + v_u_33)
  133 | 		end, t3)
  134 | 		local v36
  135 | 		if v_u_21.ctaStyle == "StandardLight" then
  136 | 			v36 = v22.Color.Extended.White.White_20.Color3
  137 | 		else
  138 | 			v36 = v22.LightMode.ActionOverMedia.Background.Color3
  139 | 		end
  140 | 		local v37
  141 | 		if v_u_21.ctaStyle == "StandardLight" then
  142 | 			v37 = v22.Color.Extended.White.White_20.Transparency
  143 | 		else
  144 | 			v37 = v22.LightMode.ActionOverMedia.Background.Transparency
  145 | 		end
  146 | 		local logoAspectRatio = p_u_15.logoAspectRatio
  147 | 		local v38 = tonumber(logoAspectRatio)
  148 | 		local v39 = v38 and v38 > 0 and v38 or 1
  149 | 		local v40
  150 | 		if v39 == 3 then
  151 | 			v40 = v_u_10
  152 | 		else
  153 | 			v40 = v_u_11
  154 | 		end
  155 | 		local universeId = p_u_15.universeId
  156 | 		local placeId = p_u_15.placeId
  157 | 		local v41 = useValidTileBadges(universeId, p_u_15.topicId, p_u_15.badgeOverride)
  158 | 		local hoverKey = p_u_15.hoverKey
  159 | 		local v42, v_u_43 = React.useState(false)
  160 | 		local v44 = React.useRef(nil)
  161 | 		local v_u_45 = useTriggerFeedback()
  162 | 		local v_u_46 = useOverflowMenuOpen(hoverKey)
  163 | 		local v_u_47 = useIsHoveredTile(v44, hoverKey, true)
  164 | 		local v_u_48 = React.useRef(false)
  165 | 		local useCallback = React.useCallback
  166 | 		local function v49()
  167 | 			--[[ line: 282 | upvalues: (copy) p_u_15, (ref) FFlagLuaAppSduiSponsoredTwoByOneTile, (ref) sponsoredGamesRecordClick, (copy) v_u_17]]
  168 | 			if p_u_15.isSponsored and p_u_15.adId and not (FFlagLuaAppSduiSponsoredTwoByOneTile and p_u_15.disableSponsoredClickRecording) then
  169 | 				sponsoredGamesRecordClick(v_u_17, p_u_15.adId)
  170 | 			end
  171 | 		end
  172 | 		local t4 = {}
  173 | 		local isSponsored = p_u_15.isSponsored
  174 | 		local adId = p_u_15.adId
  175 | 		local v50
  176 | 		if FFlagLuaAppSduiSponsoredTwoByOneTile then
  177 | 			v50 = p_u_15.disableSponsoredClickRecording
  178 | 		else
  179 | 			v50 = nil
  180 | 		end
  181 | 		t4[1], t4[2], t4[3], t4[4] = v_u_17, isSponsored, adId, v50
  182 | 		local v_u_51 = useCallback(v49, t4)
  183 | 		local v52 = React.useCallback(function()
  184 | 			--[[ line: 299 | upvalues: (copy) v_u_48]]
  185 | 			v_u_48.current = false
  186 | 		end, {})
  187 | 		local useCallback2 = React.useCallback
  188 | 		local function v54()
  189 | 			--[[ line: 304 | upvalues: (ref) FFlagLuaAppSduiSponsoredTwoByOneTile, (copy) p_u_15, (ref) GameCollectionItemTypes, (copy) v_u_16, (copy) universeId, (ref) TwoByOneGameTileTelemetry]]
  190 | 			if FFlagLuaAppSduiSponsoredTwoByOneTile and p_u_15.onOpenGameDetails then
  191 | 				p_u_15.onOpenGameDetails()
  192 | 			else
  193 | 				local t5 = { index = p_u_15.index, placeIdOverride = p_u_15.placeIdOverride }
  194 | 				local t6 = {}
  195 | 				local v53
  196 | 				if p_u_15.launchDataOverride then
  197 | 					v53 = p_u_15.launchDataOverride
  198 | 				else
  199 | 					v53 = nil
  200 | 				end
  201 | 				t6.launchData = v53
  202 | 				t6.tileType = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
  203 | 				t6.nativeAdData = p_u_15.adId
  204 | 				t5.experienceJoinData = t6
  205 | 				v_u_16(universeId, t5)
  206 | 				if not FFlagLuaAppSduiSponsoredTwoByOneTile then
  207 | 					TwoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()
  208 | 				end
  209 | 				if p_u_15.reportGameDetailOpened then
  210 | 					p_u_15.reportGameDetailOpened(p_u_15.index, universeId)
  211 | 				end
  212 | 			end
  213 | 			if FFlagLuaAppSduiSponsoredTwoByOneTile then
  214 | 				TwoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()
  215 | 			end
  216 | 		end
  217 | 		local t7 = {}
  218 | 		local index = p_u_15.index
  219 | 		local placeIdOverride = p_u_15.placeIdOverride
  220 | 		local launchDataOverride = p_u_15.launchDataOverride
  221 | 		local reportGameDetailOpened = p_u_15.reportGameDetailOpened
  222 | 		local adId2 = p_u_15.adId
  223 | 		local v55
  224 | 		if FFlagLuaAppSduiSponsoredTwoByOneTile then
  225 | 			v55 = p_u_15.onOpenGameDetails
  226 | 		else


========================================
MATCH #8
PATH: CorePackages.Workspace.Packages._Workspace.AppChat.AppChat.Components.ChatConversation.ChatMessageContainer
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 36929
========================================

--- SOURCE LINES 2-265 ---
    2 | 
    3 | local IXPService = game:GetService("IXPService")
    4 | local UserInputService = game:GetService("UserInputService")
    5 | local TextService = game:GetService("TextService")
    6 | local AppChat = script:FindFirstAncestor("AppChat")
    7 | local Parent = AppChat.Parent
    8 | local setTimeout = require(Parent.LuauPolyfill).setTimeout
    9 | local React = require(Parent.React)
   10 | local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
   11 | local useStyle = require(Parent.UIBlox).Core.Style.useStyle
   12 | local useNavigation = require(Parent.Navigation).useNavigation
   13 | local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
   14 | local Options = require(AppChat.Components.ChatConversation.MessageInteraction.Options)
   15 | local OptionsEnum = require(AppChat.Components.ChatConversation.MessageInteraction.OptionsEnum)
   16 | local ChatMessageContainerConstants = require(script.Parent.ChatMessageContainerConstants)
   17 | local EnumScreens = require(AppChat.EnumScreens)
   18 | local Cryo = require(Parent.Cryo)
   19 | local Foundation = require(Parent.Foundation)
   20 | local Skeleton = Foundation.Skeleton
   21 | local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
   22 | local normalizeFontFace = Foundation.Utility.normalizeFontFace
   23 | local GetTextSize = require(Parent.Style).GetTextSize
   24 | local useLocalUserId = require(Parent.RobloxAppHooks).useLocalUserId
   25 | local Conversation = require(AppChat.Models.Conversation)
   26 | local getReplyLabelDescriptor = require(AppChat.Utils.getReplyLabelDescriptor)
   27 | require(AppChat.Analytics.EventNames)
   28 | local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
   29 | local Logger = require(script.Parent.Logger)
   30 | local NoticeText = require(script.Parent.NoticeText)
   31 | local SystemMessage = require(script.Parent.SystemMessage)
   32 | local UserProfiles = require(Parent.UserProfiles)
   33 | local ChatConversationTelemetryEvents = require(AppChat.Components.ChatConversation.ChatConversationTelemetryEvents)
   34 | local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
   35 | local GlobalLongPressSignal = require(AppChat.Components.ChatConversation.Utils.GlobalLongPressSignal)
   36 | local MessageFtuxTooltip = require(script.Parent.MessageFtuxTooltip)
   37 | local MessageFtuxTooltip2 = MessageFtuxTooltip.MessageFtuxTooltip
   38 | local MessageFtuxTooltipVariant = MessageFtuxTooltip.MessageFtuxTooltipVariant
   39 | local MessageFtuxTooltipDismissSignal = MessageFtuxTooltip.MessageFtuxTooltipDismissSignal
   40 | local SwipeDirection = require(AppChat.Enums.SwipeDirection)
   41 | local getFFlagDebugAppChat = require(AppChat.Flags.getFFlagDebugAppChat)
   42 | local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)
   43 | local useReplyingToMessageDispatch = require(AppChat.Components.ChatConversation.MessageInteraction.ReplyingContext.useReplyingToMessageDispatch)
   44 | local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
   45 | local useLocalization = require(Parent.Localization).Hooks.useLocalization
   46 | local useTelemetry = require(AppChat.Telemetry.useTelemetry)
   47 | local useTriggerFeedback = require(Parent.InteractionFeedback).useTriggerFeedback
   48 | local HapticFeedbackContext = require(AppChat.Utils.HapticFeedback).HapticFeedbackContext
   49 | local HapticFeedbackType = require(AppChat.Utils.HapticFeedback).HapticFeedbackType
   50 | local useSwipeGesture = require(AppChat.Hooks.useSwipeGesture)
   51 | local UserTile = require(Parent.UserTile).UserTile
   52 | local LayoutMode = require(Parent.UserTile).LayoutMode
   53 | local UserPresence = require(Parent.Foundation).Enums.UserPresence
   54 | local FFlagAppChatEnableMessageContextMenu = require(AppChat.Flags.FFlagAppChatEnableMessageContextMenu)
   55 | local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
   56 | local FFlagAppChatAlignAvatarToMessageGroupBottom = require(AppChat.Flags.FFlagAppChatAlignAvatarToMessageGroupBottom)
   57 | local useDescendantSelected = require(script.Parent.Hooks.useDescendantSelected).useDescendantSelected
   58 | local v_u_1 = game:DefineFastFlag("AppChatEnableRepliesUIIxpEnabled2", false)
   59 | local v_u_2 = game:DefineFastString("AppChatEnableRepliesUIIxpLayer1", "Party.ConversationPage")
   60 | local v_u_3 = game:DefineFastInt("AppChatMessageLongPressDistanceThreshold", 25)
   61 | local MessageModel = require(AppChat.Models.MessageModel)
   62 | local v_u_4 = game:DefineFastFlag("AppChatUseSymmetricSwipe", false)
   63 | local v_u_5 = game:DefineFastInt("AppChatReplyIconSwipeOffset", 25)
   64 | local v_u_6 = require(AppChat.Flags.SignalsMigrationConfig).shouldReadMessageListFromSignalsStore or FFlagAppChatSignalsReplyStore
   65 | local v_u_7
   66 | if v_u_6 then
   67 | 	v_u_7 = require(AppChat.Stores.GetConversationMessageViewModelStore)
   68 | else
   69 | 	v_u_7 = nil
   70 | end
   71 | local v_u_8 = UDim2.new(0, 0, 0.5, 0)
   72 | local v_u_9 = UDim2.new(1, 0, 0.5, 0)
   73 | local v_u_10 = Vector2.new(0, 0.5)
   74 | local v_u_11 = Vector2.new(1, 0.5)
   75 | local t = {
   76 | 	failed = false,
   77 | 	filteredForReceivers = false,
   78 | 	isIncoming = false,
   79 | 	isNewSender = false,
   80 | 	parentWidth = 0,
   81 | 	messageId = "",
   82 | 	conversationId = "",
   83 | 	messageType = nil,
   84 | 	messageTypePaddingOffset = 0,
   85 | 	moderated = false,
   86 | 	messageMaxWidth = 0,
   87 | 	inputBoxRef = nil,
   88 | 	viewProfileOnAvatarPressed = true,
   89 | 	messageDefaultNoticeText = "PLACEHOLDER Not everyone in this chat can see your message.",
   90 | 	messageModeratedNoticeText = "PLACEHOLDER Your message was moderated and not sent.",
   91 | 	messageHiddenNoticeText = "PLACEHOLDER This message is not available",
   92 | 	unknownUserKey = "Feature.Chat.Label.UnknownUser",
   93 | 	isPending = false,
   94 | 	visibility = nil,
   95 | 	unitTestTouchEnabled = false,
   96 | 	Font = Enum.Font.Gotham,
   97 | 	openViewProfile = function()
   98 | 		--[[ line: 101 | upvalues: (copy) Logger]]
   99 | 		Logger:warning("openViewProfile was not passed to ChatMessage")
  100 | 	end,
  101 | 	renderMessage = function()
  102 | 		--[[ line: 104 | upvalues: (copy) Logger]]
  103 | 		Logger:warning("renderMessage was not passed to ChatMessage")
  104 | 	end,
  105 | 	closeKeyboard = function()
  106 | 		--[[ line: 107 | upvalues: none]]
  107 | 	end
  108 | }
  109 | local v_u_12 = getFFlagDebugAppChat() and "TextButton" or "Frame"
  110 | function ChatMessageContainer(p13)
  111 | 	--[[ line: 122 | upvalues: (copy) Cryo, (copy) t, (copy) MessageModel, (copy) React, (copy) FFlagAppChatConsoleFocusFixes, (copy) useStyle, (copy) useChatPagePadding, (copy) Foundation, (copy) v_u_4, (copy) SwipeDirection, (copy) v_u_8, (copy) v_u_9, (copy) v_u_5, (copy) v_u_10, (copy) v_u_11, (copy) useTelemetry, (copy) ChatConversationTelemetryLayer, (copy) useTriggerFeedback, (copy) useDescendantSelected, (copy) ReactFocusNavigation, (copy) GlobalLongPressSignal, (copy) MessageFtuxTooltipDismissSignal, (copy) MessageFtuxTooltipVariant, (copy) ChatConversationTelemetryEvents, (copy) useNavigation, (copy) useGetConversationFromId, (copy) FFlagAppChatSignalsReplyStore, (copy) GetReplyingToStore, (copy) v_u_6, (copy) v_u_7, (copy) useReplyingToMessageDispatch, (copy) useLocalUserId, (copy) HapticFeedbackContext, (copy) HapticFeedbackType, (copy) useSwipeGesture, (copy) EnumScreens, (copy) setTimeout, (copy) v_u_3, (copy) UserInputService, (copy) FFlagAppChatEnableMessageContextMenu, (copy) ChatMessageContainerConstants, (copy) OptionsEnum, (copy) Conversation, (copy) getReplyLabelDescriptor, (copy) UserProfiles, (copy) useLocalization, (copy) FoundationFontFaceMigration, (copy) GetTextSize, (copy) TextService, (copy) getFFlagDebugAppChat, (copy) Options, (copy) FFlagAppChatAlignAvatarToMessageGroupBottom, (copy) UserTile, (copy) LayoutMode, (copy) UserPresence, (copy) normalizeFontFace, (copy) Skeleton, (copy) MessageFtuxTooltip2, (copy) v_u_1, (copy) IXPService, (copy) v_u_2, (copy) v_u_12, (copy) SystemMessage, (copy) NoticeText]]
  112 | 	local v_u_14 = Cryo.Dictionary.join(t, p13)
  113 | 	local v_u_15
  114 | 	if v_u_14.visibility then
  115 | 		v_u_15 = v_u_14.visibility == MessageModel.VisibilityTypes.Hidden
  116 | 	else
  117 | 		v_u_15 = false
  118 | 	end
  119 | 	local useCallback = React.useCallback
  120 | 	local function v16()
  121 | 		--[[ line: 127 | upvalues: (copy) v_u_14]]
  122 | 		if v_u_14.viewProfileOnAvatarPressed then
  123 | 			v_u_14.openViewProfile(v_u_14.senderUserId)
  124 | 		end
  125 | 	end
  126 | 	local t2 = {}
  127 | 	local senderUserId = v_u_14.senderUserId
  128 | 	local v17
  129 | 	if FFlagAppChatConsoleFocusFixes then
  130 | 		v17 = v_u_14.openViewProfile
  131 | 	else
  132 | 		v17 = nil
  133 | 	end
  134 | 	local v18
  135 | 	if FFlagAppChatConsoleFocusFixes then
  136 | 		v18 = v_u_14.viewProfileOnAvatarPressed
  137 | 	else
  138 | 		v18 = nil
  139 | 	end
  140 | 	t2[1], t2[2], t2[3] = senderUserId, v17, v18
  141 | 	local v_u_19 = useCallback(v16, t2)
  142 | 	local v_u_20 = useStyle()
  143 | 	local shouldShowName = v_u_14.shouldShowName
  144 | 	local v_u_21 = useChatPagePadding()
  145 | 	local v_u_22 = Foundation.Hooks.useTokens()
  146 | 	local v_u_28 = React.useMemo(function()
  147 | 		--[[ line: 152 | upvalues: (ref) v_u_4, (copy) v_u_14, (ref) SwipeDirection, (ref) Foundation, (ref) v_u_8, (ref) v_u_9, (ref) v_u_5, (ref) v_u_10, (ref) v_u_11]]
  148 | 		if not v_u_4 then
  149 | 			return {
  150 | 				direction = SwipeDirection.Right,
  151 | 				iconName = Foundation.Enums.IconName.ArrowThickToRight,
  152 | 				messagePosition = v_u_8,
  153 | 				iconOffset = v_u_5,
  154 | 				iconAnchorPoint = v_u_10
  155 | 			}
  156 | 		end
  157 | 		local t3 = {}
  158 | 		local v23
  159 | 		if v_u_14.isIncoming then
  160 | 			v23 = SwipeDirection.Right
  161 | 		else
  162 | 			v23 = SwipeDirection.Left
  163 | 		end
  164 | 		t3.direction = v23
  165 | 		local v24
  166 | 		if v_u_14.isIncoming then
  167 | 			v24 = Foundation.Enums.IconName.ArrowThickToRight
  168 | 		else
  169 | 			v24 = Foundation.Enums.IconName.ArrowThickToLeft
  170 | 		end
  171 | 		t3.iconName = v24
  172 | 		local v25
  173 | 		if v_u_14.isIncoming then
  174 | 			v25 = v_u_8
  175 | 		else
  176 | 			v25 = v_u_9
  177 | 		end
  178 | 		t3.messagePosition = v25
  179 | 		local v26
  180 | 		if v_u_14.isIncoming then
  181 | 			v26 = v_u_5
  182 | 		else
  183 | 			v26 = -v_u_5
  184 | 		end
  185 | 		t3.iconOffset = v26
  186 | 		local v27
  187 | 		if v_u_14.isIncoming then
  188 | 			v27 = v_u_10
  189 | 		else
  190 | 			v27 = v_u_11
  191 | 		end
  192 | 		t3.iconAnchorPoint = v27
  193 | 		return t3
  194 | 	end, { v_u_14.isIncoming })
  195 | 	local v_u_29 = nil
  196 | 	local v_u_30 = React.useRef(nil)
  197 | 	local v_u_31 = React.useRef(nil)
  198 | 	local zero = React.useRef(Vector2.zero)
  199 | 	local Context = useTelemetry(ChatConversationTelemetryLayer.Context)
  200 | 	local v_u_32 = useTriggerFeedback()
  201 | 	local v33, v34 = React.useState(false)
  202 | 	local v_u_35 = v33
  203 | 	local v_u_36, v_u_37 = React.useState(false)
  204 | 	local v_u_38, v_u_39 = React.useState(false)
  205 | 	local v_u_40, v_u_41
  206 | 	if FFlagAppChatConsoleFocusFixes then
  207 | 		v_u_40, v_u_41 = useDescendantSelected()
  208 | 	else
  209 | 		v_u_40 = nil
  210 | 		v_u_41 = nil
  211 | 	end
  212 | 	local v_u_42
  213 | 	if FFlagAppChatConsoleFocusFixes then
  214 | 		local v_u_43 = ReactFocusNavigation.useFocusGuiObject()
  215 | 		v_u_42 = React.useCallback(function()
  216 | 			--[[ line: 205 | upvalues: (copy) v_u_31, (copy) v_u_43]]
  217 | 			local current = v_u_31.current
  218 | 			if current then
  219 | 				v_u_43(current)
  220 | 			end
  221 | 		end, { v_u_31, v_u_43 })
  222 | 	else
  223 | 		v_u_42 = nil
  224 | 	end
  225 | 	React.useEffect(function()
  226 | 		--[[ line: 212 | upvalues: (ref) GlobalLongPressSignal, (copy) v_u_39]]
  227 | 		local v_u_44 = GlobalLongPressSignal.dismissed:connect(function()
  228 | 			--[[ line: 213 | upvalues: (ref) v_u_39]]
  229 | 			v_u_39(false)
  230 | 		end)
  231 | 		return function()
  232 | 			--[[ line: 216 | upvalues: (copy) v_u_44]]
  233 | 			v_u_44:disconnect()
  234 | 		end
  235 | 	end)
  236 | 	local v_u_46 = React.useMemo(function()
  237 | 		--[[ line: 222 | upvalues: (copy) v_u_14]]
  238 | 		local t4 = { conversationId = v_u_14.conversationId, targetMessageSenderId = v_u_14.senderUserId, targetMessageId = v_u_14.messageId }
  239 | 		local v45
  240 | 		if v_u_14.sent then
  241 | 			v45 = v_u_14.sent.dateTime
  242 | 		else
  243 | 			v45 = nil
  244 | 		end
  245 | 		t4.targetMessageSentAt = v45
  246 | 		t4.targetMessageLength = v_u_14.content and #v_u_14.content or nil
  247 | 		t4.targetMessageVisibility = v_u_14.visibility
  248 | 		return t4
  249 | 	end, {
  250 | 		v_u_14.conversationId,
  251 | 		v_u_14.senderUserId,
  252 | 		v_u_14.messageId,
  253 | 		v_u_14.sent,
  254 | 		v_u_14.content,
  255 | 		v_u_14.visibility
  256 | 	})
  257 | 	local v_u_47
  258 | 	if FFlagAppChatConsoleFocusFixes then
  259 | 		v_u_47 = React.useMemo(function()
  260 | 			--[[ line: 243 | upvalues: (copy) v_u_15, (copy) v_u_36, (ref) v_u_40]]
  261 | 			local v48 = not v_u_15
  262 | 			if v48 then
  263 | 				v48 = v_u_36 or v_u_40
  264 | 			end
  265 | 			return v48


========================================
MATCH #9
PATH: CorePackages.Workspace.Packages._Workspace.BuildExperience.BuildExperience.Components.Chat.ChatUserMessage
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 7396
========================================

--- SOURCE LINES 1-95 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local BuildExperience = script:FindFirstAncestor("BuildExperience")
    4 | local Parent = BuildExperience.Parent
    5 | local Foundation = require(Parent.Foundation)
    6 | local React = require(Parent.React)
    7 | local useLocalization = require(Parent.Localization).Hooks.useLocalization
    8 | local default = require(Parent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
    9 | require(BuildExperience.Chat.chatTypes)
   10 | local FFlagBuildExperienceCopyChatMessages = require(BuildExperience.Flags.FFlagBuildExperienceCopyChatMessages)
   11 | local FFlagBuildExperienceRichTextUserMessages = require(BuildExperience.Flags.FFlagBuildExperienceRichTextUserMessages)
   12 | local FFlagBuildExperienceUserMessageHapticFeedback = require(BuildExperience.Flags.FFlagBuildExperienceUserMessageHapticFeedback)
   13 | local FFlagBuildExperienceChatImageAttachments = require(BuildExperience.Flags.FFlagBuildExperienceChatImageAttachments)
   14 | local FFlagBuildExperienceChatResourceAttachments = require(Parent.SharedFlags).FFlagBuildExperienceChatResourceAttachments
   15 | local LocalizationStrings = require(BuildExperience.LocalizationStrings)
   16 | local v_u_1
   17 | if FFlagBuildExperienceChatImageAttachments then
   18 | 	v_u_1 = require(script.Parent.ChatImagePreviewList)
   19 | else
   20 | 	v_u_1 = nil
   21 | end
   22 | local v_u_2
   23 | if FFlagBuildExperienceChatResourceAttachments then
   24 | 	v_u_2 = require(script.Parent.ChatResourceAttachmentList)
   25 | else
   26 | 	v_u_2 = nil
   27 | end
   28 | local v_u_3
   29 | if FFlagBuildExperienceUserMessageHapticFeedback then
   30 | 	v_u_3 = require(Parent.InteractionFeedback).useTriggerFeedback
   31 | else
   32 | 	v_u_3 = nil
   33 | end
   34 | local Menu = Foundation.Menu
   35 | local Text = Foundation.Text
   36 | local View = Foundation.View
   37 | local IconName = Foundation.Enums.IconName
   38 | local InputSize = Foundation.Enums.InputSize
   39 | local PopoverAlign = Foundation.Enums.PopoverAlign
   40 | local PopoverSide = Foundation.Enums.PopoverSide
   41 | local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
   42 | local useTokens = Foundation.Hooks.useTokens
   43 | local t = { affordance = StateLayerAffordance.None }
   44 | local t2 = {
   45 | 	["&"] = "&amp;",
   46 | 	["<"] = "&lt;",
   47 | 	[">"] = "&gt;",
   48 | 	["\""] = "&quot;",
   49 | 	["\'"] = "&apos;"
   50 | }
   51 | local function UserMessageBubble(p4: {[any]: any})
   52 | 	--[[ line: 71 | upvalues: (copy) useTokens, (copy) FFlagBuildExperienceRichTextUserMessages, (copy) React, (copy) t2, (copy) Text, (copy) t, (copy) View]]
   53 | 	local v5 = useTokens()
   54 | 	if not FFlagBuildExperienceRichTextUserMessages then
   55 | 		local createElement = React.createElement
   56 | 		local v6 = View
   57 | 		local t3 = {
   58 | 			tag = "auto-xy padding-medium bg-shift-200",
   59 | 			LayoutOrder = p4.LayoutOrder,
   60 | 			cornerRadius = UDim.new(0, v5.Size.Size_500),
   61 | 			onSecondaryActivated = p4.onSecondaryActivated
   62 | 		}
   63 | 		local v7
   64 | 		if p4.onSecondaryActivated == nil then
   65 | 			v7 = nil
   66 | 		else
   67 | 			v7 = t
   68 | 		end
   69 | 		t3.stateLayer = v7
   70 | 		t3.testId = p4.testId
   71 | 		return createElement(v6, t3, { Text = React.createElement(Text, { tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis", Text = p4.messageText }) })
   72 | 	end
   73 | 	local messageText = p4.messageText
   74 | 	local v8 = React.useMemo(function()
   75 | 		--[[ line: 66 | upvalues: (copy) messageText, (ref) t2]]
   76 | 		return string.gsub(messageText, "[&<>\"\']", t2)
   77 | 	end, { messageText })
   78 | 	local createElement2 = React.createElement
   79 | 	local v9 = Text
   80 | 	local t4 = {
   81 | 		RichText = true,
   82 | 		tag = "auto-xy padding-medium text-body-medium text-wrap text-align-x-left bg-shift-200 content-emphasis",
   83 | 		LayoutOrder = p4.LayoutOrder,
   84 | 		cornerRadius = UDim.new(0, v5.Size.Size_500),
   85 | 		onSecondaryActivated = p4.onSecondaryActivated
   86 | 	}
   87 | 	local v10
   88 | 	if p4.onSecondaryActivated == nil then
   89 | 		v10 = nil
   90 | 	else
   91 | 		v10 = t
   92 | 	end
   93 | 	t4.stateLayer = v10
   94 | 	t4.Text = v8
   95 | 	t4.testId = p4.testId


========================================
MATCH #10
PATH: CorePackages.Workspace.Packages._Workspace.InteractionFeedback.InteractionFeedback
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 569
========================================

--- SOURCE LINES 1-12 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local InteractionFeedbackContext = require(script.InteractionFeedbackContext)
    4 | local useTriggerFeedback = require(script.useTriggerFeedback)
    5 | local FeedbackManagerInjectionContextProvider = require(script.FeedbackManagerInjectionContextProvider)
    6 | return {
    7 | 	InteractionFeedbackContext = InteractionFeedbackContext,
    8 | 	useTriggerFeedback = useTriggerFeedback,
    9 | 	withTriggerFeedback = require(script.withTriggerFeedback),
   10 | 	FeedbackManagerInjectionContextProvider = FeedbackManagerInjectionContextProvider,
   11 | 	["jest.config"] = script["jest.config"]
   12 | }


========================================
MATCH #11
PATH: CorePackages.Workspace.Packages._Workspace.InteractionFeedback.InteractionFeedback.FeedbackManagerInjectionContextProvider
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 660
========================================

--- SOURCE LINES 1-12 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local Parent = script:FindFirstAncestor("InteractionFeedback").Parent
    4 | local FeedbackManagerInjectionContext = require(Parent.UIBlox).Core.Control.FeedbackManagerInjectionContext
    5 | local React = require(Parent.React)
    6 | local useTriggerFeedback = require(script.Parent.useTriggerFeedback)
    7 | local function FeedbackManagerInjectionContextProvider(p1)
    8 | 	--[[ line: 7 | upvalues: (copy) useTriggerFeedback, (copy) React, (copy) FeedbackManagerInjectionContext]]
    9 | 	local t = { value = useTriggerFeedback() }
   10 | 	return React.createElement(FeedbackManagerInjectionContext.Provider, t, p1.children)
   11 | end
   12 | return FeedbackManagerInjectionContextProvider


========================================
MATCH #12
PATH: CorePackages.Workspace.Packages._Workspace.InteractionFeedback.InteractionFeedback.useTriggerFeedback
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 2138
========================================

--- SOURCE LINES 1-46 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local Parent = script:FindFirstAncestor("InteractionFeedback").Parent
    4 | local SharedFlags = require(Parent.SharedFlags)
    5 | local triggerFeedback = require(script.Parent.triggerFeedback)
    6 | local InteractionFeedbackContext = require(script.Parent.InteractionFeedbackContext)
    7 | local RoactUtils = require(Parent.RoactUtils)
    8 | local useInputType = RoactUtils.Hooks.useInputType
    9 | local useLaserPointerHand = RoactUtils.Hooks.useLaserPointerHand
   10 | local React = require(Parent.React)
   11 | local isSpatial = require(Parent.AppCommonLib).isSpatial
   12 | local FFlagLuaAppHapticTriggeredTelemetry = SharedFlags.FFlagLuaAppHapticTriggeredTelemetry
   13 | local function useHapticPositionAndRadius()
   14 | 	--[[ line: 18 | upvalues: (copy) useInputType, (copy) useLaserPointerHand, (copy) React, (copy) isSpatial]]
   15 | 	local v1 = useInputType()
   16 | 	local v_u_2 = useLaserPointerHand()
   17 | 	return React.useMemo(function()
   18 | 		--[[ line: 21 | upvalues: (ref) isSpatial, (copy) v_u_2]]
   19 | 		return isSpatial() and (v_u_2 == "Right" and { Vector3.new(1, 0, 0), 0.1 } or { Vector3.new(-1, 0, 0), 0.1 }) or { Vector3.new(0, 0, 0), 100 }
   20 | 	end, { v1, v_u_2 })
   21 | end
   22 | local function useTriggerFeedback()
   23 | 	--[[ line: 38 | upvalues: (copy) React, (copy) InteractionFeedbackContext, (copy) useHapticPositionAndRadius, (copy) triggerFeedback, (copy) FFlagLuaAppHapticTriggeredTelemetry]]
   24 | 	local v_u_3 = React.useContext(InteractionFeedbackContext)
   25 | 	local v4 = useHapticPositionAndRadius()
   26 | 	local v_u_5 = v4[1]
   27 | 	local v_u_6 = v4[2]
   28 | 	if not v_u_3 then
   29 | 		error("useTriggerFeedback must be used within an InteractionFeedbackProvider")
   30 | 	end
   31 | 	return React.useCallback(function(p7: string, p8, p9: string?, p10: {[any]: any}?)
   32 | 		--[[ line: 52 | upvalues: (ref) triggerFeedback, (copy) v_u_3, (ref) v_u_5, (ref) v_u_6, (ref) FFlagLuaAppHapticTriggeredTelemetry]]
   33 | 		local v11 = triggerFeedback
   34 | 		local v12 = v_u_3
   35 | 		local v13 = v_u_5
   36 | 		local v14 = v_u_6
   37 | 		if not FFlagLuaAppHapticTriggeredTelemetry then
   38 | 			p9 = nil
   39 | 		end
   40 | 		if not FFlagLuaAppHapticTriggeredTelemetry then
   41 | 			p10 = nil
   42 | 		end
   43 | 		return v11(p7, p8, v12, v13, v14, p9, p10)
   44 | 	end, { v_u_3, v_u_5, v_u_6 })
   45 | end
   46 | return useTriggerFeedback


========================================
MATCH #13
PATH: CorePackages.Workspace.Packages._Workspace.InteractionFeedback.InteractionFeedback.withTriggerFeedback
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 647
========================================

--- SOURCE LINES 1-16 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local Parent = script:FindFirstAncestor("InteractionFeedback").Parent
    4 | local Cryo = require(Parent.Cryo)
    5 | local React = require(Parent.React)
    6 | local useTriggerFeedback = require(script.Parent.useTriggerFeedback)
    7 | local function withTriggerFeedback(p_u_1)
    8 | 	--[[ line: 8 | upvalues: (copy) useTriggerFeedback, (copy) Cryo, (copy) React]]
    9 | 	return function(p2)
   10 | 		--[[ line: 9 | upvalues: (ref) useTriggerFeedback, (ref) Cryo, (ref) React, (copy) p_u_1]]
   11 | 		local t = { triggerFeedback = useTriggerFeedback() }
   12 | 		local v3 = Cryo.Dictionary.join(p2, t)
   13 | 		return React.createElement(p_u_1, v3)
   14 | 	end
   15 | end
   16 | return withTriggerFeedback


========================================
MATCH #14
PATH: CorePackages.Packages._Index.Foundation.Foundation.Components.Divider.useDividerVariants
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 1757
========================================

--- SOURCE LINES 1-47 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local Foundation = script:FindFirstAncestor("Foundation")
    4 | require(Foundation.Components.Types)
    5 | local DividerVariant = require(Foundation.Enums.DividerVariant)
    6 | local Orientation = require(Foundation.Enums.Orientation)
    7 | local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)
    8 | require(Foundation.Providers.Style.Tokens)
    9 | local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
   10 | local function variantsFactory(p1)
   11 | 	--[[ line: 26 | upvalues: (copy) Orientation, (copy) DividerVariant]]
   12 | 	local t = {
   13 | 		container = { tag = "col" },
   14 | 		stroke = { backgroundStyle = p1.Color.Stroke.Default },
   15 | 		line = { tag = "size-full-200", position = UDim2.fromOffset(0, p1.Size.Size_50), backgroundStyle = p1.Color.Common.HeavyDivider }
   16 | 	}
   17 | 	local t2 = {
   18 | 		[Orientation.Horizontal] = {
   19 | 			container = { tag = "size-full-0 auto-y" },
   20 | 			stroke = { Size = UDim2.new(1, 0, 0, p1.Stroke.Standard) }
   21 | 		},
   22 | 		[Orientation.Vertical] = {
   23 | 			container = { tag = "size-0-full auto-x" },
   24 | 			stroke = { Size = UDim2.new(0, p1.Stroke.Standard, 1, 0) }
   25 | 		}
   26 | 	}
   27 | 	return {
   28 | 		common = t,
   29 | 		padding = {
   30 | 			[DividerVariant.Inset] = {
   31 | 				container = { tag = "padding-x-xlarge" }
   32 | 			},
   33 | 			[DividerVariant.InsetLeft] = {
   34 | 				container = { tag = "padding-left-xlarge" }
   35 | 			},
   36 | 			[DividerVariant.InsetRight] = {
   37 | 				container = { tag = "padding-right-xlarge" }
   38 | 			}
   39 | 		},
   40 | 		orientation = t2
   41 | 	}
   42 | end
   43 | return function(p2, p3, p4)
   44 | 	--[[ line: 81 | upvalues: (copy) VariantsContext, (copy) variantsFactory, (copy) composeStyleVariant, (copy) Orientation]]
   45 | 	local v5 = VariantsContext.useVariants("Divider", variantsFactory, p2)
   46 | 	return composeStyleVariant(v5.common, p4 ~= Orientation.Horizontal and {} or v5.padding[p3], v5.orientation[p4])
   47 | end


========================================
MATCH #15
PATH: CorePackages.Packages._Index.Foundation.Foundation.Enums.DividerVariant
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 151
========================================

--- SOURCE LINES 1-9 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Default = "Default",
    5 | 	Heavy = "Heavy",
    6 | 	Inset = "Inset",
    7 | 	InsetLeft = "InsetLeft",
    8 | 	InsetRight = "InsetRight"
    9 | }


========================================
MATCH #16
PATH: CorePackages.Packages._Index.UGCValidation.UGCValidation.util.AssetCalculator
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 9887
========================================

--- SOURCE LINES 54-187 ---
   54 | 	local v11 = ConstantsInterface.getRigAttachmentToParent(nil, p4.Name)
   55 | 	local v12 = v10:FindFirstChild(v11, R15plusUtils.checkFlagEnabledForAllowHrd())
   56 | 	assert(v12)
   57 | 	local v13 = p4:FindFirstChild(v11, R15plusUtils.checkFlagEnabledForAllowHrd())
   58 | 	assert(v13)
   59 | 	return p6 * getAttachmentCFrameInPartSpace(v12) * v9 * getAttachmentCFrameInPartSpace(v13):Inverse()
   60 | end
   61 | local function calculateHierarchyTransforms(p14, p_u_15: (...any) -> ...any, p_u_16: {[any]: any}?)
   62 | 	--[[ line: 112 | upvalues: (copy) calculatePartTransformInHierarchy]]
   63 | 	local t4 = {}
   64 | 	local v_u_17
   65 | 	v_u_17 = function(p18: string, p19: string?, p20, p21: CFrame)
   66 | 		--[[ line: 119 | upvalues: (copy) p_u_15, (ref) calculatePartTransformInHierarchy, (copy) p_u_16, (copy) t4, (copy) v_u_17]]
   67 | 		local v22 = p_u_15(p18)
   68 | 		assert(v22)
   69 | 		local v23 = calculatePartTransformInHierarchy(v22, p19, p21, p_u_15, p_u_16)
   70 | 		t4[v22.Name] = v23
   71 | 		if p20.children then
   72 | 			for v24, v25 in p20.children do
   73 | 				v_u_17(v24, p18, v25, v23)
   74 | 			end
   75 | 		end
   76 | 	end
   77 | 	v_u_17(p14.root, nil, p14, CFrame.new())
   78 | 	return t4
   79 | end
   80 | local function calculateAssetCFrameFromPartsCFrames(p26, p27: {[any]: any})
   81 | 	--[[ line: 147 | upvalues: (copy) getPartNamesInHierarchyOrder, (copy) calculateCFrame]]
   82 | 	local v28 = getPartNamesInHierarchyOrder(p26)
   83 | 	return calculateCFrame(p27[v28[1]].Position, p27[v28[3]].Position)
   84 | end
   85 | function t3.calculatePartCFrameFromRigAttachments(p29, p30: userdata, p31: CFrame)
   86 | 	--[[ line: 174 | upvalues: (copy) ConstantsInterface, (copy) R15plusUtils, (copy) getAttachmentCFrameInPartSpace, (copy) AssetTraversalUtils, (copy) calculateCFrame]]
   87 | 	local v32
   88 | 	if p29 == Enum.AssetType.LeftArm or (p29 == Enum.AssetType.RightArm or p29 == Enum.AssetType.LeftLeg) then
   89 | 		v32 = true
   90 | 	else
   91 | 		v32 = p29 == Enum.AssetType.RightLeg
   92 | 	end
   93 | 	assert(v32)
   94 | 	local v33 = ConstantsInterface.getRigAttachmentToParent(p29, p30.Name)
   95 | 	if v33 ~= "" then
   96 | 		local v34 = p30:FindFirstChild(v33, R15plusUtils.checkFlagEnabledForAllowHrd())
   97 | 		assert(v34)
   98 | 		local v35 = p31 * getAttachmentCFrameInPartSpace(v34)
   99 | 		local v36 = AssetTraversalUtils.getAssetRigChild(p29, p30.Name)
  100 | 		if v36 then
  101 | 			local v37 = p30:FindFirstChild(ConstantsInterface.getRigAttachmentToParent(p29, v36), R15plusUtils.checkFlagEnabledForAllowHrd())
  102 | 			assert(v37)
  103 | 			local v38 = p31 * getAttachmentCFrameInPartSpace(v37)
  104 | 			return calculateCFrame(v35.Position, v38.Position)
  105 | 		end
  106 | 	end
  107 | end
  108 | function t3.calculateStraightenedLimb(p39, p40: {[any]: any}, p41: (...any) -> ...any)
  109 | 	--[[ line: 198 | upvalues: (copy) Cryo, (copy) getPartNamesInHierarchyOrder, (copy) AssetTraversalUtils, (copy) t3, (copy) ConstantsInterface, (copy) R15plusUtils, (copy) getAttachmentCFrameInPartSpace]]
  110 | 	local v42
  111 | 	if p39 == Enum.AssetType.LeftArm or (p39 == Enum.AssetType.RightArm or p39 == Enum.AssetType.LeftLeg) then
  112 | 		v42 = true
  113 | 	else
  114 | 		v42 = p39 == Enum.AssetType.RightLeg
  115 | 	end
  116 | 	assert(v42)
  117 | 	local v43 = Cryo.Dictionary.join(p40)
  118 | 	local v44 = CFrame.new()
  119 | 	local v45 = nil
  120 | 	for _, v46 in getPartNamesInHierarchyOrder(p39) do
  121 | 		local v47 = p41(v46)
  122 | 		local v48 = AssetTraversalUtils.getAssetRigChild(p39, v46)
  123 | 		local v49 = v48 == nil
  124 | 		local v50
  125 | 		if v49 then
  126 | 			v50 = v44
  127 | 		else
  128 | 			v50 = t3.calculatePartCFrameFromRigAttachments(p39, v47, p40[v46]) or v44
  129 | 		end
  130 | 		local v51 = p40[v46]
  131 | 		local v52 = v50.Rotation:Inverse() * v51.Rotation
  132 | 		local v53 = v50.Rotation:Inverse() * (v51.Position - v50.Position)
  133 | 		v43[v46] = CFrame.new(v53) * v52
  134 | 		if v45 then
  135 | 			local v54 = ConstantsInterface.getRigAttachmentToParent(p39, v46)
  136 | 			local v55 = v43[v46]
  137 | 			local v56 = v47:FindFirstChild(v54, R15plusUtils.checkFlagEnabledForAllowHrd())
  138 | 			assert(v56)
  139 | 			local v57 = v45 - (v55 * getAttachmentCFrameInPartSpace(v56)).Position
  140 | 			v43[v46] = CFrame.new(v43[v46].Position + v57) * v43[v46].Rotation
  141 | 		end
  142 | 		if not v49 then
  143 | 			local v58 = ConstantsInterface.getRigAttachmentToParent(p39, v48)
  144 | 			local v59 = v43[v46]
  145 | 			local v60 = v47:FindFirstChild(v58, R15plusUtils.checkFlagEnabledForAllowHrd())
  146 | 			assert(v60)
  147 | 			v45 = (v59 * getAttachmentCFrameInPartSpace(v60)).Position
  148 | 			v44 = v50
  149 | 		end
  150 | 	end
  151 | 	return v43
  152 | end
  153 | function t3.calculateAssetCFrame(p61, p62: userdata)
  154 | 	--[[ line: 251 | upvalues: (copy) t3, (copy) calculateAssetCFrameFromPartsCFrames]]
  155 | 	local v63 = t3.calculateAllTransformsForAsset(p61, p62)
  156 | 	if Enum.AssetType.DynamicHead == p61 then
  157 | 		return v63.Head
  158 | 	end
  159 | 	if Enum.AssetType.Torso == p61 then
  160 | 		return v63.LowerTorso
  161 | 	end
  162 | 	return calculateAssetCFrameFromPartsCFrames(p61, v63)
  163 | end
  164 | function t3.calculateAllTransformsForAsset(p64, p_u_65: userdata)
  165 | 	--[[ line: 262 | upvalues: (copy) calculateHierarchyTransforms, (copy) AssetTraversalUtils]]
  166 | 	if Enum.AssetType.DynamicHead == p64 then
  167 | 		return { Head = CFrame.new() }
  168 | 	end
  169 | 	local function findMeshHandle(p66: string)
  170 | 		--[[ line: 267 | upvalues: (copy) p_u_65]]
  171 | 		return p_u_65:FindFirstChild(p66)
  172 | 	end
  173 | 	return calculateHierarchyTransforms(AssetTraversalUtils.assetHierarchy[p64], findMeshHandle)
  174 | end
  175 | function t3.calculateAllTransformsForFullBody(p_u_67, p68: {[any]: any}?)
  176 | 	--[[ line: 274 | upvalues: (copy) t2, (copy) t, (copy) calculateHierarchyTransforms]]
  177 | 	local function findMeshHandle2(p69: string)
  178 | 		--[[ line: 278 | upvalues: (copy) p_u_67]]
  179 | 		return p_u_67[p69]
  180 | 	end
  181 | 	local v70
  182 | 	if p68 then
  183 | 		v70 = t2
  184 | 	else
  185 | 		v70 = t
  186 | 	end
  187 | 	return calculateHierarchyTransforms(v70, findMeshHandle2, p68)


========================================
MATCH #17
PATH: CorePackages.Packages._Index.UGCValidation.UGCValidation.util.AssetTraversalUtils
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 4870
========================================

--- SOURCE LINES 57-157 ---
   57 | 	assert(v34)
   58 | 	local v35
   59 | 	if p27 then
   60 | 		local v36
   61 | 		if p24 then
   62 | 			v36 = p24[p27]
   63 | 		else
   64 | 			v36 = p25:FindFirstChild(p27)
   65 | 		end
   66 | 		assert(v36)
   67 | 		local v37 = ConstantsInterface.getRigAttachmentToParent(p26, p29)
   68 | 		local v38 = v36:FindFirstChild(v37, R15plusUtils.checkFlagEnabledForAllowHrd())
   69 | 		assert(v38)
   70 | 		local v39 = v34:FindFirstChild(v37, R15plusUtils.checkFlagEnabledForAllowHrd())
   71 | 		assert(v39)
   72 | 		v35 = p28 * getAttachmentCFrameInPartSpace(v38) * getAttachmentCFrameInPartSpace(v39):Inverse()
   73 | 	else
   74 | 		v35 = CFrame.new()
   75 | 	end
   76 | 	t.calculateBounds(p26, v34, v35, p31, p32)
   77 | 	if p30.children then
   78 | 		for v40, v41 in p30.children do
   79 | 			t.traverseHierarchy(p24, p25, p26, p29, v35, v40, v41, p31, p32)
   80 | 		end
   81 | 	end
   82 | end
   83 | local v_u_42 = nil
   84 | local function initRigParentToChild()
   85 | 	--[[ line: 163 | upvalues: (ref) v_u_42, (copy) getPartNamesInHierarchyOrder]]
   86 | 	if not v_u_42 then
   87 | 		v_u_42 = {}
   88 | 		for _2, v43 in {
   89 | 			Enum.AssetType.LeftArm,
   90 | 			Enum.AssetType.RightArm,
   91 | 			Enum.AssetType.LeftLeg,
   92 | 			Enum.AssetType.RightLeg
   93 | 		} do
   94 | 			local v44 = getPartNamesInHierarchyOrder(v43)
   95 | 			v_u_42[v43] = {}
   96 | 			for v45 = 1, #v44 - 1 do
   97 | 				v_u_42[v43][v44[v45]] = v44[v45 + 1]
   98 | 			end
   99 | 		end
  100 | 	end
  101 | end
  102 | function t.getAssetRigChild(p46, p47: string)
  103 | 	--[[ line: 179 | upvalues: (copy) initRigParentToChild, (ref) v_u_42]]
  104 | 	initRigParentToChild()
  105 | 	local v48 = v_u_42[p46]
  106 | 	return assert(v48, "Invalid asset type")[p47]
  107 | end
  108 | t.assetHierarchy = {
  109 | 	[Enum.AssetType.DynamicHead] = { root = "Head" },
  110 | 	[Enum.AssetType.Torso] = {
  111 | 		root = "LowerTorso",
  112 | 		children = {
  113 | 			UpperTorso = {}
  114 | 		}
  115 | 	},
  116 | 	[Enum.AssetType.LeftArm] = {
  117 | 		root = "LeftUpperArm",
  118 | 		children = {
  119 | 			LeftLowerArm = {
  120 | 				children = {
  121 | 					LeftHand = {}
  122 | 				}
  123 | 			}
  124 | 		}
  125 | 	},
  126 | 	[Enum.AssetType.RightArm] = {
  127 | 		root = "RightUpperArm",
  128 | 		children = {
  129 | 			RightLowerArm = {
  130 | 				children = {
  131 | 					RightHand = {}
  132 | 				}
  133 | 			}
  134 | 		}
  135 | 	},
  136 | 	[Enum.AssetType.LeftLeg] = {
  137 | 		root = "LeftUpperLeg",
  138 | 		children = {
  139 | 			LeftLowerLeg = {
  140 | 				children = {
  141 | 					LeftFoot = {}
  142 | 				}
  143 | 			}
  144 | 		}
  145 | 	},
  146 | 	[Enum.AssetType.RightLeg] = {
  147 | 		root = "RightUpperLeg",
  148 | 		children = {
  149 | 			RightLowerLeg = {
  150 | 				children = {
  151 | 					RightFoot = {}
  152 | 				}
  153 | 			}
  154 | 		}
  155 | 	}
  156 | }
  157 | return t


========================================
MATCH #18
PATH: CoreGui.RobloxGui.Modules.InGameMenu
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 9202
========================================

--- SOURCE LINES 81-174 ---
   81 | 		local createElement = Roact.createElement
   82 | 		local v6 = LocalizationProvider
   83 | 		local t2 = { localization = RobloxLocaleId }
   84 | 		local t3 = {}
   85 | 		local createElement2 = Roact.createElement
   86 | 		local v7 = SelectionCursorProvider
   87 | 		local t4 = {}
   88 | 		local t5 = {}
   89 | 		local v8
   90 | 		if GetFFlagIGMGamepadSelectionHistory() then
   91 | 			v8 = Roact.createElement(FocusHandlerContextProvider, {}, { InGameMenu = Roact.createElement(App) }) or nil
   92 | 		else
   93 | 			v8 = nil
   94 | 		end
   95 | 		t5.FocusHandlerContextProvider = v8
   96 | 		t5.InGameMenu = not GetFFlagIGMGamepadSelectionHistory() and Roact.createElement(App) or nil
   97 | 		t3.CursorProvider = createElement2(v7, t4, t5)
   98 | 		t.LocalizationProvider = createElement(v6, t2, t3)
   99 | 		local v9 = v5(t)
  100 | 		local v10 = Roact.createElement(AppInteractionFeedbackProvider, {}, { tree = Roact.createElement(FeedbackManagerInjectionContextProvider, nil, { tree = v9 }) })
  101 | 		local v12 = Roact.createElement("ScreenGui", {
  102 | 			ResetOnSpawn = false,
  103 | 			IgnoreGuiInset = true,
  104 | 			DisplayOrder = Constants.DisplayOrder.RootMenu,
  105 | 			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
  106 | 			AutoLocalize = false,
  107 | 			[Roact.Change.AbsoluteSize] = function(p11)
  108 | 				--[[ line: 128 | upvalues: (ref) v_u_1, (ref) SetScreenSize]]
  109 | 				v_u_1:dispatch(SetScreenSize(p11.AbsoluteSize))
  110 | 			end
  111 | 		}, { StoreProvider = Roact.createElement(RoactRodux.StoreProvider, { store = v_u_1 }, { PolicyProvider = Roact.createElement(InGameMenuPolicy.Provider, {
  112 | 					policy = { InGameMenuPolicy.Mapper }
  113 | 				}, { ThemeProvider = v10 }) }) })
  114 | 		Roact.mount(v12, CoreGui, "InGameMenu")
  115 | 	end,
  116 | 	openInGameMenu = function(p13)
  117 | 		--[[ line: 145 | upvalues: (copy) v_u_1, (copy) OpenMenu, (copy) Constants]]
  118 | 		v_u_1:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.TopbarButton, p13))
  119 | 	end,
  120 | 	closeInGameMenu = function()
  121 | 		--[[ line: 149 | upvalues: (copy) CloseMenu, (copy) v_u_1]]
  122 | 		CloseMenu(v_u_1)
  123 | 	end,
  124 | 	openReportDialog = function(p14, p15)
  125 | 		--[[ line: 153 | upvalues: (copy) v_u_1, (copy) OpenMenu, (copy) Constants, (copy) TrustAndSafety]]
  126 | 		v_u_1:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.ReportAbuseTriggered, Constants.ReportDialogKey))
  127 | 		if p15 == nil then
  128 | 			p15 = Constants.AnalyticsInGameMenuName
  129 | 		end
  130 | 		TrustAndSafety.openReportDialogForPlayer(p14, p15)
  131 | 	end,
  132 | 	openGameSettingsPage = function()
  133 | 		--[[ line: 159 | upvalues: (copy) v_u_1, (copy) OpenMenu, (copy) Constants, (copy) SetCurrentPage]]
  134 | 		v_u_1:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.SettingsTriggered))
  135 | 		v_u_1:dispatch(SetCurrentPage("GameSettings"))
  136 | 	end,
  137 | 	openGameLeavePage = function()
  138 | 		--[[ line: 164 | upvalues: (copy) v_u_1, (copy) OpenMenu, (copy) Constants, (copy) SetCurrentPage]]
  139 | 		v_u_1:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.GamepadLeaveGame))
  140 | 		v_u_1:dispatch(SetCurrentPage(Constants.LeaveGamePromptPageKey))
  141 | 	end,
  142 | 	openCharacterResetPage = function()
  143 | 		--[[ line: 169 | upvalues: (copy) v_u_1, (copy) OpenMenu, (copy) Constants, (copy) SetCurrentPage, (copy) SetRespawning]]
  144 | 		v_u_1:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.GamepadResetCharacter))
  145 | 		v_u_1:dispatch(SetCurrentPage(Constants.MainPagePageKey))
  146 | 		v_u_1:dispatch(SetRespawning(true))
  147 | 	end,
  148 | 	openPlayersPage = function()
  149 | 		--[[ line: 175 | upvalues: (copy) v_u_1, (copy) OpenMenu, (copy) Constants, (copy) SetCurrentPage]]
  150 | 		v_u_1:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.PlayersTriggered))
  151 | 		v_u_1:dispatch(SetCurrentPage("Players"))
  152 | 	end,
  153 | 	getOpenChangedEvent = function()
  154 | 		--[[ line: 180 | upvalues: (copy) BindableEvent]]
  155 | 		return BindableEvent
  156 | 	end,
  157 | 	getOpen = function()
  158 | 		--[[ line: 184 | upvalues: (copy) v_u_1]]
  159 | 		return v_u_1:getState().isMenuOpen
  160 | 	end,
  161 | 	getRespawnBehaviour = function()
  162 | 		--[[ line: 188 | upvalues: (copy) v_u_1]]
  163 | 		local v16 = v_u_1:getState()
  164 | 		return v16.respawn.enabled, v16.respawn.customCallback
  165 | 	end,
  166 | 	getRespawnBehaviourChangedEvent = function()
  167 | 		--[[ line: 193 | upvalues: (copy) BindableEvent2]]
  168 | 		return BindableEvent2
  169 | 	end,
  170 | 	setMenuIconTooltipOpen = function(p17)
  171 | 		--[[ line: 197 | upvalues: (copy) v_u_1, (copy) SetMenuIconTooltipOpen]]
  172 | 		v_u_1:dispatch(SetMenuIconTooltipOpen(p17))
  173 | 	end
  174 | }


========================================
MATCH #19
PATH: CoreGui.RobloxGui.Modules.InGameMenu.Resources.Constants
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 6434
========================================

--- SOURCE LINES 1-107 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local CorePackages = game:GetService("CorePackages")
    4 | local t = require(CorePackages.Packages.t)
    5 | local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
    6 | local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
    7 | local FFlagEnableGameLeftMessage = SharedFlags.FFlagEnableGameLeftMessage
    8 | local FFlagRenameRespawnConfirmationPage = SharedFlags.FFlagRenameRespawnConfirmationPage
    9 | local t2 = { MouseAndKeyboard = "MouseAndKeyboard", Touch = "Touch", Gamepad = "Gamepad" }
   10 | return {
   11 | 	InviteStatus = {
   12 | 		Success = "Success",
   13 | 		Moderated = "Moderated",
   14 | 		Failed = "Failed",
   15 | 		Pending = "Pending"
   16 | 	},
   17 | 	InputType = t2,
   18 | 	FallbackLocaleId = "UNKNOWN_FALLBACK",
   19 | 	defaultPageKey = "InitalPage",
   20 | 	advancedSettingsPageKey = "AdvancedGameSettings",
   21 | 	vrComfortSettingsPageKey = "VRGameSettings",
   22 | 	LeaveToAppPromptPageKey = "LeaveToAppPrompt",
   23 | 	LeaveGamePromptPageKey = "LeaveGamePrompt",
   24 | 	MainPagePageKey = "MainPage",
   25 | 	InitalPageKey = "InitalPage",
   26 | 	ReportDialogKey = "ReportDialog",
   27 | 	PeoplePageKey = "peoplepage",
   28 | 	PeoplePageScrollBuffer = 5,
   29 | 	AnalyticsTargetName = "client",
   30 | 	AnalyticsInGameMenuName = "ingame_menu",
   31 | 	AnalyticsRespawnCharacterName = "respawn_character",
   32 | 	AnalyticsSettingsChangeName = "change_ingame_settings",
   33 | 	AnalyticsExplicitSettingsChangeName = "change_explicit_ingame_settings",
   34 | 	AnalyticsSettingsSafetyBubbleModeChangeName = "change_ingame_settings_safety_bubble_mode",
   35 | 	AnalyticsSettingsVRComfortSettingChangeName = "change_ingame_settings_vr_comfort_setting",
   36 | 	AnalyticsFullscreenModeName = "FullscreenMode",
   37 | 	AnalyticsMenuActionName = "ingame_menu_action",
   38 | 	AnalyticsMenuOpenName = "menu_open",
   39 | 	AnalyticsMenuOpenTypes = {
   40 | 		Keyboard = "KeyboardShortcut",
   41 | 		TopbarButton = "TopbarButton",
   42 | 		ReportAbuseTriggered = "ReportAbuse",
   43 | 		PlayersTriggered = "Players",
   44 | 		SettingsTriggered = "Settings",
   45 | 		EducationalMenuTriggered = "EducationalMenu",
   46 | 		GamepadLeaveGame = "GamepadLeaveGame",
   47 | 		GamepadResetCharacter = "GamepadResetCharacter",
   48 | 		ScreenshotUnhide = "ScreenshotUnhide"
   49 | 	},
   50 | 	AnalyticsMenuCloseName = "menu_close",
   51 | 	AnalyticsMenuLeaveName = "menu_leave",
   52 | 	AnalyticsLeaveGameName = "leave_game",
   53 | 	AnalyticsLeaveToHomeName = "leave_to_home",
   54 | 	AnalyticsLeaveToHomeSource = "home",
   55 | 	AnalyticsLeaveGameSource = "leave",
   56 | 	AnalyticsMenuButtonSource = "menu_button",
   57 | 	AnalyticsMenuHotkeySource = "gamepad_or_hotkey",
   58 | 	AnalyticsMenuResetCharacterName = "menu_reset_character",
   59 | 	AnalyticsResumeGameName = "resume",
   60 | 	AnalyticsResumeShieldSource = "shield",
   61 | 	AnalyticsResumeButtonSource = "button",
   62 | 	AnalyticsResumeGamepadSource = "gamepad",
   63 | 	AnalyticsResumeXButtonSource = "x_button",
   64 | 	AnalyticsConfirmedName = "confirmed",
   65 | 	AnalyticsCancelledName = "cancelled",
   66 | 	AnalyticsReportLeft = "ingame_menu_report_left",
   67 | 	AnalyticsReportSubmittedName = "ingame_menu_report_submitted",
   68 | 	AnalyticsRequestFriendName = "RequestFriendship",
   69 | 	AnalyticsRequestFriendContext = "PlayersMenu",
   70 | 	AnalyticsExamineAvatarName = "examine_avatar",
   71 | 	PlayerScriptStatusStrings = {
   72 | 		Default = "PlayerScript Status: Default",
   73 | 		Custom = "PlayerScript Status: Custom",
   74 | 		PossiblyCustom = "PlayerScript Status: Possibly Custom",
   75 | 		CustomOld = "PlayerScript Status: Custom Old"
   76 | 	},
   77 | 	ControllerBarHeight = 72,
   78 | 	DisplayOrder = {
   79 | 		RootMenu = 1,
   80 | 		BlurredModalPortal = 2,
   81 | 		FullscreenTitleBar = 7,
   82 | 		ConfirmationDialog = 8,
   83 | 		EducationalPopup = 9,
   84 | 		HeadsetDisconnectedDialog = 100,
   85 | 		ControllerBar = 9
   86 | 	},
   87 | 	ShieldOpenAnimationTweenTime = 0.5,
   88 | 	ShieldCloseAnimationTweenTime = 0.4,
   89 | 	ShieldOpenFadeTime2 = 0.25,
   90 | 	ShieldCloseFadeTime2 = 0.15,
   91 | 	ShieldExtraFadeTime = 0.05,
   92 | 	Zone = { PortalSize = 1, ContentOffset = 2 },
   93 | 	InputTypeMap = {
   94 | 		[Enum.UserInputType.MouseButton1] = t2.MouseAndKeyboard,
   95 | 		[Enum.UserInputType.MouseButton2] = t2.MouseAndKeyboard,
   96 | 		[Enum.UserInputType.MouseButton3] = t2.MouseAndKeyboard,
   97 | 		[Enum.UserInputType.MouseWheel] = t2.MouseAndKeyboard,
   98 | 		[Enum.UserInputType.MouseMovement] = t2.MouseAndKeyboard,
   99 | 		[Enum.UserInputType.Keyboard] = t2.MouseAndKeyboard,
  100 | 		[Enum.UserInputType.Gamepad1] = t2.Gamepad,
  101 | 		[Enum.UserInputType.Gamepad2] = t2.Gamepad,
  102 | 		[Enum.UserInputType.Gamepad3] = t2.Gamepad,
  103 | 		[Enum.UserInputType.Gamepad4] = t2.Gamepad,
  104 | 		[Enum.UserInputType.Gamepad5] = t2.Gamepad,
  105 | 		[Enum.UserInputType.Gamepad6] = t2.Gamepad,
  106 | 		[Enum.UserInputType.Gamepad7] = t2.Gamepad,
  107 | 		[Enum.UserInputType.Gamepad8] = t2.Gamepad,


========================================
MATCH #20
PATH: ReplicatedStorage.Services.Asset.RigService
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 14854
========================================

--- SOURCE LINES 1-112 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local t = {}
    4 | local t2 = {}
    5 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
    6 | local Players = game:GetService("Players")
    7 | if game:GetService("RunService"):IsServer() then
    8 | 	return {}
    9 | end
   10 | local _ = ReplicatedStorage.Shared
   11 | local _2 = ReplicatedStorage.Objects
   12 | local Services = ReplicatedStorage:WaitForChild("Services")
   13 | require((Services:WaitForChild("Data"):WaitForChild("ServerStateRegistryService")))
   14 | local Registry = require(ReplicatedStorage.Items.Registry)
   15 | local v_u_1 = require((script:WaitForChild("WeldHat")))
   16 | local v_u_2 = require((script:WaitForChild("AddCosmetics")))
   17 | local CollectionService = game:GetService("CollectionService")
   18 | local RelicsXYZ = require(ReplicatedStorage.Shared.Partnerships.Relics.Content.RelicsXYZ)
   19 | local Rigs = workspace:WaitForChild("Rigs")
   20 | local Folder = Instance.new("Folder")
   21 | Folder.Parent = ReplicatedStorage
   22 | Folder.Name = "RigCache"
   23 | function AreTablesEqual(p3, p4)
   24 | 	--[[ line: 40 | upvalues: none]]
   25 | 	for v5, v6 in next, p3 do
   26 | 		if p4[v5] ~= v6 then
   27 | 			return false
   28 | 		end
   29 | 	end
   30 | 	for v7, v8 in next, p4 do
   31 | 		if p3[v7] ~= v8 then
   32 | 			return false
   33 | 		end
   34 | 	end
   35 | 	return true
   36 | end
   37 | function GetAppearance(p9, p10)
   38 | 	--[[ line: 46 | upvalues: none]]
   39 | 	local v11 = workspace.PlayerCache:WaitForChild(p9)
   40 | 	if v11 then
   41 | 		if p10 == Enum.HumanoidRigType.R6 then
   42 | 			return v11:WaitForChild("R6")
   43 | 		end
   44 | 		return v11:WaitForChild("Player")
   45 | 	end
   46 | end
   47 | function AddCosmetics(p12, p13, p14)
   48 | 	--[[ line: 59 | upvalues: (copy) v_u_2]]
   49 | 	v_u_2(p12, p13, nil, p14)
   50 | end
   51 | function SetupBoombox(p15, p16)
   52 | 	--[[ line: 63 | upvalues: (copy) RelicsXYZ, (copy) CollectionService, (copy) v_u_1]]
   53 | 	local v17 = RelicsXYZ.Boombox.PromiseBoombox(RelicsXYZ.Boombox.GetBoomboxConfigs()[1])
   54 | 	v17:await()
   55 | 	local v18 = v17:expect()
   56 | 	if v18 == nil then
   57 | 		return
   58 | 	end
   59 | 	local v19 = v18:Clone()
   60 | 	local v20 = nil
   61 | 	if p16 and p16 ~= 239 then
   62 | 		local v21 = nil
   63 | 		for _3, v22 in ipairs((CollectionService:GetTagged("RelicsUGCSkin"))) do
   64 | 			if v22:GetAttribute("ID") == p16 then
   65 | 				v21 = v22
   66 | 				break
   67 | 			end
   68 | 		end
   69 | 		if v21 then
   70 | 			RelicsXYZ.Boombox.UpdateSkin(v19, v21.Name)
   71 | 		elseif p16 == 1730 then
   72 | 			v20 = true
   73 | 		end
   74 | 	end
   75 | 	v_u_1(p15, v19)
   76 | 	if v20 then
   77 | 		local MeshPart = v19:FindFirstChildOfClass("MeshPart")
   78 | 		MeshPart.Transparency = 1
   79 | 		local v23 = script.DefaultBoombox.Part:Clone()
   80 | 		v23.Parent = MeshPart
   81 | 		local Weld = Instance.new("Weld")
   82 | 		Weld.Parent = v23
   83 | 		Weld.Part0 = MeshPart
   84 | 		Weld.Part1 = v23
   85 | 		Weld.C1 = CFrame.Angles(0, 1.5707963267948966, 0)
   86 | 	end
   87 | 	return v19
   88 | end
   89 | function CreateCachedRig(p24, p25, p26, p27, p28, p29, p30, p31)
   90 | 	--[[ line: 101 | upvalues: (copy) ReplicatedStorage, (copy) Players, (copy) Folder, (copy) Registry, (copy) t2, (copy) Rigs]]
   91 | 	if not p24:FindFirstChild("Joints") then
   92 | 		local Folder2 = Instance.new("Folder")
   93 | 		Folder2.Name = "Joints"
   94 | 		Folder2.Parent = p24
   95 | 		for _4, v32 in p24:GetChildren() do
   96 | 			for _5, v33 in v32:GetChildren() do
   97 | 				if v33:IsA("Motor6D") then
   98 | 					if v33.Part0 and v33.Part1 then
   99 | 						v33.Parent = Folder2
  100 | 					else
  101 | 						v33:Destroy()
  102 | 					end
  103 | 				end
  104 | 			end
  105 | 		end
  106 | 		for _6, v34 in p24:GetDescendants() do
  107 | 			if v34:IsA("BasePart") then
  108 | 				v34.CanTouch = false
  109 | 				v34.CanQuery = false
  110 | 				v34.Massless = true
  111 | 				v34.CollisionGroup = "PlayerVis"
  112 | 			end

--- SOURCE LINES 127-237 ---
  127 | 			end
  128 | 		end
  129 | 	end
  130 | 	local v38 = p24:Clone()
  131 | 	local Humanoid = v38:FindFirstChildOfClass("Humanoid")
  132 | 	Humanoid.EvaluateStateMachine = false
  133 | 	Humanoid.RequiresNeck = false
  134 | 	Humanoid.BreakJointsOnDeath = false
  135 | 	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
  136 | 	v38.Name = p28
  137 | 	if p30 and p28 ~= Players.LocalPlayer.Name then
  138 | 		Humanoid.AnimationPlayed:Connect(function(p39)
  139 | 			--[[ line: 151 | upvalues: none]]
  140 | 			if p39.Animation and p39.Animation.Parent then
  141 | 				task.wait()
  142 | 				if not (p39.Animation and p39.Animation.Parent) then
  143 | 					p39:Stop(0)
  144 | 				end
  145 | 			else
  146 | 				p39:Stop(0)
  147 | 			end
  148 | 		end)
  149 | 	end
  150 | 	for _9, v40 in v38:GetChildren() do
  151 | 		if v40:IsA("BasePart") then
  152 | 			v40.Anchored = false
  153 | 		end
  154 | 	end
  155 | 	local HumanoidRootPart = v38:FindFirstChild("HumanoidRootPart")
  156 | 	local t3 = {}
  157 | 	for _10, v41 in v38.Joints:GetChildren() do
  158 | 		if v41.Part0 == HumanoidRootPart then
  159 | 			v41.Part0 = nil
  160 | 			table.insert(t3, v41)
  161 | 		end
  162 | 	end
  163 | 	local Folder3 = Instance.new("Folder")
  164 | 	Folder3.Name = ("%*_HRPAssetsFolder"):format(p24.Name)
  165 | 	Folder3.Parent = Folder
  166 | 	local t4 = {}
  167 | 	if p26 then
  168 | 		local t5 = {}
  169 | 		for _11, v42 in p26 do
  170 | 			table.insert(t5, v42)
  171 | 		end
  172 | 		AddCosmetics(v38, t5)
  173 | 	end
  174 | 	if p27 then
  175 | 		for _12, v43 in p27 do
  176 | 			local v44 = Registry.GetById(v43)
  177 | 			if v44 then
  178 | 				local Module = v44.Module
  179 | 				if Module:FindFirstChild("Headgear") then
  180 | 					if not Module.Headgear:GetAttribute("Optimized") then
  181 | 						Module.Headgear:SetAttribute("Optimized", true)
  182 | 						for _13, v45 in Module.Headgear:GetDescendants() do
  183 | 							if v45:IsA("BasePart") then
  184 | 								v45.CanCollide = false
  185 | 								v45.CanTouch = false
  186 | 								v45.CanQuery = false
  187 | 								v45.Massless = true
  188 | 								v45.CollisionGroup = "PlayerVis"
  189 | 							end
  190 | 						end
  191 | 					end
  192 | 					local v46 = Module.Headgear:Clone()
  193 | 					v46.Parent = v38.Head
  194 | 					local Weld2 = Instance.new("Weld")
  195 | 					Weld2.Part0 = v38.Head
  196 | 					Weld2.Part1 = v46.HumanoidRootPart
  197 | 					Weld2.Parent = v38.Head
  198 | 				end
  199 | 			end
  200 | 		end
  201 | 	end
  202 | 	local t6 = {}
  203 | 	if v38:FindFirstChild("HumanoidRootPart") then
  204 | 		for _14, v47 in v38.HumanoidRootPart:GetDescendants() do
  205 | 			if (v47:IsA("Weld") or v47:IsA("Motor6D")) and v47.Part0 == v38.HumanoidRootPart then
  206 | 				table.insert(t6, v47)
  207 | 				v47.Part0 = nil
  208 | 			end
  209 | 		end
  210 | 		for _15, v48 in v38.HumanoidRootPart:GetChildren() do
  211 | 			v48.Parent = Folder3
  212 | 			table.insert(t4, v48)
  213 | 		end
  214 | 		v38.HumanoidRootPart:Destroy()
  215 | 	end
  216 | 	local t7 = {}
  217 | 	local t8 = {}
  218 | 	for _16, v49 in v38:GetChildren() do
  219 | 		if v49:IsA("Accessory") or v49:IsA("Hat") then
  220 | 			local v50 = v49:FindFirstChildOfClass("Part") or v49:FindFirstChildOfClass("MeshPart")
  221 | 			local Weld3 = v50:FindFirstChildOfClass("Weld")
  222 | 			local RigidConstraint = v50:FindFirstChildOfClass("RigidConstraint")
  223 | 			local v51
  224 | 			if Weld3 then
  225 | 				v51 = Weld3.Part0.Name
  226 | 				if v51 == v50.Name then
  227 | 					v51 = Weld3.Part1.Name
  228 | 				end
  229 | 			else
  230 | 				v51 = nil
  231 | 			end
  232 | 			if RigidConstraint then
  233 | 				v51 = RigidConstraint.Attachment0.Parent.Name
  234 | 				if v51 == v50.Name and (RigidConstraint.Attachment1 and RigidConstraint.Attachment1.Parent) then
  235 | 					v51 = RigidConstraint.Attachment1.Parent.Name
  236 | 				end
  237 | 			end

--- SOURCE LINES 300-524 ---
  300 | 	--[[ line: 325 | upvalues: (copy) t2]]
  301 | 	if p58.Model then
  302 | 		p58.Model:Destroy()
  303 | 	end
  304 | 	if p58.HRPAssetsFolder then
  305 | 		p58.HRPAssetsFolder:Destroy()
  306 | 	end
  307 | 	for v59, v60 in t2 do
  308 | 		if v60 == p58 then
  309 | 			table.remove(t2, v59)
  310 | 			return
  311 | 		end
  312 | 	end
  313 | end
  314 | function RemovePlayer(p61)
  315 | 	--[[ line: 341 | upvalues: (copy) t2]]
  316 | 	for _21, v62 in t2 do
  317 | 		if v62.Name == p61.Name then
  318 | 			ClearCachedRig(v62)
  319 | 			return
  320 | 		end
  321 | 	end
  322 | end
  323 | function t.GetRig(_22, p63, p64, p65, p66, p67)
  324 | 	--[[ line: 350 | upvalues: (copy) ReplicatedStorage, (copy) Players, (copy) Registry, (copy) t2]]
  325 | 	if p63:GetAttribute("AI") and p63.Name ~= "Mimic" then
  326 | 		return CreateCachedRig(ReplicatedStorage.NPCs:FindFirstChild(p63.Name).Variants.Default, nil, nil, nil, p63.Name)
  327 | 	end
  328 | 	if p63.Name == "Mimic" then
  329 | 		local v68 = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
  330 | 		local R6 = Enum.HumanoidRigType.R6
  331 | 		if v68:GetAttribute("RigType") == "R15" then
  332 | 			R6 = Enum.HumanoidRigType.R15
  333 | 		end
  334 | 		local v69 = GetAppearance(v68.Name, R6)
  335 | 		return CreateCachedRig(v69, R6, p65, p66, v68.Name, true, true)
  336 | 	end
  337 | 	local Name = Players:FindFirstChild(p63.Name)
  338 | 	if not Name then
  339 | 		warn("No player found to obtain rig with!")
  340 | 		return
  341 | 	end
  342 | 	local v70 = GetAppearance(Name.Name, p64)
  343 | 	for _23, v71 in p65 do
  344 | 		local Module2 = Registry.GetById(v71).Module
  345 | 		if (require(Module2).CosmeticInfo or {}).Character then
  346 | 			if p64 == Enum.HumanoidRigType.R15 and Module2:FindFirstChild("Character") then
  347 | 				v70 = Module2.Character
  348 | 				p64 = Enum.HumanoidRigType.R15
  349 | 			elseif Module2:FindFirstChild("CharacterClassic") then
  350 | 				v70 = Module2.CharacterClassic
  351 | 				p64 = Enum.HumanoidRigType.R6
  352 | 			elseif Module2:FindFirstChild("Character") then
  353 | 				v70 = Module2.Character
  354 | 				p64 = Enum.HumanoidRigType.R15
  355 | 			end
  356 | 			break
  357 | 		end
  358 | 	end
  359 | 	for _24, v72 in t2 do
  360 | 		if v72.Class == p64 and (v72.Base == v70 and (v72.Name == Name.Name and (v72.Boombox == p67 and AreTablesEqual(v72.Cosmetics, p65)))) and AreTablesEqual(v72.Gear or {}, p66 or {}) then
  361 | 			return v72
  362 | 		end
  363 | 	end
  364 | 	for _25, v73 in t2 do
  365 | 		if v73.Name == Name.Name then
  366 | 			ClearCachedRig(v73)
  367 | 		end
  368 | 	end
  369 | 	return CreateCachedRig(v70, p64, p65, p66, Name.Name, true, true, p67), true
  370 | end
  371 | function t.SetRig(_26, p74, p75, p76, p77, p78)
  372 | 	--[[ line: 402 | upvalues: (copy) t, (copy) Registry, (copy) v_u_2]]
  373 | 	local v79, _27 = t:GetRig(p74, p75, p76, p77, p78)
  374 | 	if v79 then
  375 | 		if p74.PrimaryPart then
  376 | 			v79.Model:SetAttribute("Tag", (p74:GetAttribute("Tag")))
  377 | 			v79.Model.PrimaryPart = nil
  378 | 			if v79.Model:FindFirstChild("Head") then
  379 | 				v79.Model.Head.Anchored = false
  380 | 			end
  381 | 			for _28, v80 in v79.RootJoints do
  382 | 				v80.Part0 = p74.PrimaryPart
  383 | 			end
  384 | 			for _29, v81 in v79.RootWelds do
  385 | 				v81.Part0 = p74.PrimaryPart
  386 | 			end
  387 | 			if v79.Boombox and (v79.Boombox ~= 0 and not v79.BoomboxAsset) then
  388 | 				v79.BoomboxAsset = SetupBoombox(v79.Model, v79.Boombox)
  389 | 				local t13 = {}
  390 | 				for _30, v82 in p76 do
  391 | 					if not t13[v82] then
  392 | 						t13[v82] = true
  393 | 						local v83 = Registry.GetById(v82)
  394 | 						if v83 and table.find(v83.Categories, "RELICSAuras") then
  395 | 							v_u_2(v79.Model, { v82 }, v79.BoomboxAsset:FindFirstChildOfClass("MeshPart") or v79.BoomboxAsset:FindFirstChildOfClass("Part"))
  396 | 						end
  397 | 					end
  398 | 				end
  399 | 			end
  400 | 			for v84, v85 in v79.DefaultJointInfo do
  401 | 				v84.C0 = v85[1]
  402 | 				v84.C1 = v85[2]
  403 | 				if v84:IsA("Motor6D") then
  404 | 					v84.Transform = CFrame.new()
  405 | 				end
  406 | 			end
  407 | 			for _31, v86 in v79.Limbs do
  408 | 				if v86[1]:IsA("BasePart") then
  409 | 					v86[1].CanQuery = true
  410 | 					v86[1].CollisionGroup = "PlayerVis"
  411 | 				end
  412 | 			end
  413 | 			for v87, v88 in v79.DefaultInfo do
  414 | 				for v89, v90 in v88 do
  415 | 					v87[v89] = v90
  416 | 				end
  417 | 			end
  418 | 			local v91 = v79.HRPAssetsFolder:Clone()
  419 | 			local t14 = {}
  420 | 			for _32, v92 in v91:GetDescendants() do
  421 | 				if (v92:IsA("Weld") or v92:IsA("Motor6D")) and (not v92.Part0 or v92.Part0.Name == "HumanoidRootPart") then
  422 | 					v92.Part0 = p74.PrimaryPart
  423 | 				end
  424 | 			end
  425 | 			for _33, v93 in v91:GetChildren() do
  426 | 				if p74.PrimaryPart:FindFirstChild(v93.Name) then
  427 | 					if v93:IsA("Attachment") then
  428 | 						local Name2 = p74.PrimaryPart:FindFirstChild(v93.Name)
  429 | 						for _34, v94 in v93:GetChildren() do
  430 | 							v94.Parent = Name2
  431 | 						end
  432 | 					end
  433 | 				else
  434 | 					table.insert(t14, v93)
  435 | 				end
  436 | 			end
  437 | 			for _35, v95 in t14 do
  438 | 				v95.Parent = p74.PrimaryPart
  439 | 			end
  440 | 			v91:Destroy()
  441 | 			if v79.Model:FindFirstChild("Tool") then
  442 | 				v79.Model.Tool:Destroy()
  443 | 			end
  444 | 			if v79.Model:FindFirstChild("EmoteModel") then
  445 | 				v79.Model.EmoteModel:Destroy()
  446 | 			end
  447 | 			if v79.Model:FindFirstChild("CarryModel") then
  448 | 				v79.Model.CarryModel:Destroy()
  449 | 			end
  450 | 			v79.BoundCharacter = p74
  451 | 			v79.Tag = p74:GetAttribute("Tag")
  452 | 			v79.Bound = true
  453 | 			return v79
  454 | 		end
  455 | 	else
  456 | 		warn("Cache return failed")
  457 | 	end
  458 | end
  459 | function t.UnsetRig(_36, p96)
  460 | 	--[[ line: 495 | upvalues: (copy) t2]]
  461 | 	for _37, v97 in t2 do
  462 | 		if v97.BoundCharacter == p96 or not (v97.BoundCharacter and v97.BoundCharacter.Parent) and v97.Bound then
  463 | 			if v97.Model and (v97.Model.Parent and v97.Model:FindFirstChild("Head")) then
  464 | 				if v97.BoomboxAsset then
  465 | 					v97.BoomboxAsset:Destroy()
  466 | 					v97.BoomboxAsset = nil
  467 | 				end
  468 | 				v97.Bound = false
  469 | 				for _38, v98 in v97.RootJoints do
  470 | 					v98.Part0 = nil
  471 | 				end
  472 | 				for _39, v99 in v97.RootWelds do
  473 | 					v99.Part0 = nil
  474 | 				end
  475 | 				for v100, v101 in v97.DefaultJointInfo do
  476 | 					v100.C0 = v101[1]
  477 | 					v100.C1 = v101[2]
  478 | 					if v100:IsA("Motor6D") then
  479 | 						v100.Transform = CFrame.new()
  480 | 					end
  481 | 				end
  482 | 				if v97.Model:FindFirstChild("Tool") then
  483 | 					v97.Model.Tool:Destroy()
  484 | 				end
  485 | 				if v97.Model:FindFirstChild("EmoteModel") then
  486 | 					v97.Model.EmoteModel:Destroy()
  487 | 				end
  488 | 				if v97.Model:FindFirstChild("CarryModel") then
  489 | 					v97.Model.CarryModel:Destroy()
  490 | 				end
  491 | 				v97.Model.PrimaryPart = v97.Model.Head
  492 | 				v97.Model.PrimaryPart.Anchored = true
  493 | 				v97.Model.PrimaryPart.CFrame = CFrame.new(50000, 50000, 5000)
  494 | 				v97.Tag = nil
  495 | 			else
  496 | 				ClearCachedRig(v97)
  497 | 			end
  498 | 		end
  499 | 	end
  500 | end
  501 | function t.GetRigFromTag(_40, p102)
  502 | 	--[[ line: 537 | upvalues: (copy) t2]]
  503 | 	for _41, v103 in t2 do
  504 | 		if v103.Tag == p102 then
  505 | 			return v103
  506 | 		end
  507 | 	end
  508 | end
  509 | function t.GetCharacterFromRig(_42, p104)
  510 | 	--[[ line: 545 | upvalues: (copy) t2]]
  511 | 	for _43, v105 in t2 do
  512 | 		if v105.Model == p104 and (v105.BoundCharacter and v105.BoundCharacter.Parent) then
  513 | 			return v105.BoundCharacter
  514 | 		end
  515 | 	end
  516 | end
  517 | function t.GetRigFromCharacter(_44, p106)
  518 | 	--[[ line: 553 | upvalues: (copy) t2]]
  519 | 	for _45, v107 in t2 do
  520 | 		if v107.BoundCharacter == p106 then
  521 | 			return v107.Model
  522 | 		end
  523 | 	end
  524 | end


========================================
MATCH #21
PATH: ReplicatedStorage.Services.UI.MenuService
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 4258
========================================

--- SOURCE LINES 1-139 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local t = {
    4 | 	ServerStateRegistry = {}
    5 | }
    6 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
    7 | local RunService = game:GetService("RunService")
    8 | local StarterGui = game:GetService("StarterGui")
    9 | local Services = ReplicatedStorage:WaitForChild("Services")
   10 | local Objects = ReplicatedStorage:WaitForChild("Objects")
   11 | local Assets = ReplicatedStorage:WaitForChild("Assets")
   12 | local Shared = ReplicatedStorage:WaitForChild("Shared")
   13 | local Menu = Assets:WaitForChild("Menu")
   14 | local Menu2 = Objects:WaitForChild("Menu"):WaitForChild("Menu")
   15 | local SetMouseActive = ReplicatedStorage:WaitForChild("Services"):WaitForChild("UI"):WaitForChild("SharedUIService"):WaitForChild("SetMouseActive")
   16 | local Menu3 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Menu")
   17 | local MenuView = Menu:WaitForChild("MenuView")
   18 | local v_u_1 = require((Services:WaitForChild("UI"):WaitForChild("GameUIService")))
   19 | local ClientHooks = Shared:WaitForChild("UserData"):WaitForChild("ClientHooks")
   20 | local v2 = require((ClientHooks:WaitForChild("useCurrency")))
   21 | local v3 = require((ClientHooks:WaitForChild("useLoadout")))
   22 | local v4 = require((ClientHooks:WaitForChild("useSettings")))
   23 | local v5 = require((ClientHooks:WaitForChild("useProgression")))
   24 | local v6 = require((ClientHooks:WaitForChild("useCounters")))
   25 | local v7 = require((ClientHooks:WaitForChild("useInventory")))
   26 | local v8 = require((ClientHooks:WaitForChild("useEvent")))
   27 | if RunService:IsServer() then
   28 | 	return nil
   29 | end
   30 | function t.Insert(_, _2)
   31 | 	--[[ line: 46 | upvalues: (copy) t, (copy) v_u_1, (copy) MenuView, (copy) SetMouseActive, (copy) Menu3, (copy) Menu2, (copy) StarterGui]]
   32 | 	if not t.UI then
   33 | 		v_u_1:Clear()
   34 | 		MenuView.Parent = workspace
   35 | 		SetMouseActive:Fire("Menu", true)
   36 | 		t.UI = Menu3:Clone()
   37 | 		t.UI.Parent = game.Players.LocalPlayer.PlayerGui
   38 | 		t.Inserted = true
   39 | 		t.Menu = require(Menu2).new(t.UI)
   40 | 		t.Menu:Initialize()
   41 | 		for v9, v10 in t.ServerStateRegistry do
   42 | 			t:UpdateServerStateRegistry(v9, v10)
   43 | 		end
   44 | 		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
   45 | 		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
   46 | 		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
   47 | 		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
   48 | 	end
   49 | end
   50 | function t.Destroy(_3)
   51 | 	--[[ line: 69 | upvalues: (copy) t, (copy) MenuView, (copy) StarterGui, (copy) SetMouseActive]]
   52 | 	if t.UI then
   53 | 		t.UI:Destroy()
   54 | 		t.UI = nil
   55 | 	end
   56 | 	if t.Menu then
   57 | 		t.Menu:Destroy()
   58 | 		t.Menu = nil
   59 | 	end
   60 | 	MenuView.Parent = script
   61 | 	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
   62 | 	SetMouseActive:Fire("Menu", nil)
   63 | end
   64 | function t.UpdateServerStateRegistry(_4, p11, p12)
   65 | 	--[[ line: 83 | upvalues: (copy) v_u_1, (copy) t]]
   66 | 	v_u_1.ServerStateRegistry[p11] = p12
   67 | 	if not t.Types then
   68 | 	end
   69 | end
   70 | function t.Set(_5, _6, ...)
   71 | 	--[[ line: 90 | upvalues: none]]
   72 | end
   73 | function t.KeyUsed(_7, ...)
   74 | 	--[[ line: 94 | upvalues: (copy) t]]
   75 | 	if t.Menu then
   76 | 		t.Menu:KeyUsed(...)
   77 | 	end
   78 | end
   79 | ReplicatedStorage.Events.MenuUISetType.OnClientEvent:Connect(function(p13, ...)
   80 | 	--[[ line: 100 | upvalues: (copy) t]]
   81 | 	if p13 == true then
   82 | 		if t.SpawnInserted then
   83 | 			t:Insert()
   84 | 		end
   85 | 	elseif p13 == false then
   86 | 		t:Destroy()
   87 | 	else
   88 | 		t:Set(p13, ...)
   89 | 	end
   90 | end)
   91 | v2.Changed:Connect(function()
   92 | 	--[[ line: 114 | upvalues: (copy) t]]
   93 | 	if t.Menu then
   94 | 		t.Menu:CurrencyUpdated()
   95 | 	end
   96 | end)
   97 | v3.Changed:Connect(function()
   98 | 	--[[ line: 120 | upvalues: (copy) t]]
   99 | 	if t.Menu then
  100 | 		t.Menu:LoadoutUpdated()
  101 | 	end
  102 | end)
  103 | v7.Changed:Connect(function()
  104 | 	--[[ line: 126 | upvalues: (copy) t]]
  105 | 	if t.Menu then
  106 | 		t.Menu:InventoryUpdated()
  107 | 	end
  108 | end)
  109 | v4.Changed:Connect(function()
  110 | 	--[[ line: 132 | upvalues: (copy) t]]
  111 | 	if t.Menu then
  112 | 		t.Menu:SettingsUpdated()
  113 | 	end
  114 | end)
  115 | v5.Changed:Connect(function()
  116 | 	--[[ line: 138 | upvalues: (copy) t]]
  117 | 	if t.Menu then
  118 | 		t.Menu:ProgressionUpdated()
  119 | 	end
  120 | end)
  121 | v6.Changed:Connect(function()
  122 | 	--[[ line: 144 | upvalues: (copy) t]]
  123 | 	if t.Menu then
  124 | 		t.Menu:CounterUpdated()
  125 | 	end
  126 | end)
  127 | v8.Changed:Connect(function()
  128 | 	--[[ line: 150 | upvalues: (copy) t]]
  129 | 	if t.Menu then
  130 | 		t.Menu:EventUpdated()
  131 | 	end
  132 | end)
  133 | RunService.RenderStepped:Connect(function(p14)
  134 | 	--[[ line: 157 | upvalues: (copy) t]]
  135 | 	if t.Menu and (t.UI and t.UI.Parent) then
  136 | 		t.Menu:Update(p14)
  137 | 	end
  138 | end)
  139 | return t


========================================
MATCH #22
PATH: ReplicatedStorage.Services.Items.ClientItemService
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 13925
========================================

--- SOURCE LINES 115-427 ---
  115 | 	return Model
  116 | end
  117 | local function addJoints(p20)
  118 | 	--[[ line: 156 | upvalues: none]]
  119 | 	if p20 then
  120 | 		local Folder = Instance.new("Folder")
  121 | 		Folder.Name = "Joints"
  122 | 		Folder.Parent = p20
  123 | 		for _8, v21 in p20:GetDescendants() do
  124 | 			if v21:IsA("Motor6D") then
  125 | 				v21.Parent = Folder
  126 | 			end
  127 | 		end
  128 | 	end
  129 | end
  130 | function t.SetIDs(_9)
  131 | 	--[[ line: 170 | upvalues: (copy) Registry, (copy) t]]
  132 | 	for _10, v22 in Registry.GetAll() do
  133 | 		t.IDs[v22.Id] = v22.Module
  134 | 		t.Names[v22.Module.Name] = v22.Module
  135 | 	end
  136 | end
  137 | function t.GetItemFromName(_11, p23)
  138 | 	--[[ line: 177 | upvalues: (copy) t]]
  139 | 	return t.Names[p23]
  140 | end
  141 | function t.GetItemFromID(_12, p24)
  142 | 	--[[ line: 181 | upvalues: (copy) t]]
  143 | 	return t.IDs[p24]
  144 | end
  145 | function t.GetItemIDFromName(_13, p25)
  146 | 	--[[ line: 185 | upvalues: (copy) t]]
  147 | 	return t.Names[p25]:GetAttribute("ID")
  148 | end
  149 | function t.GetItemNameFromID(_14, p26)
  150 | 	--[[ line: 189 | upvalues: (copy) t]]
  151 | 	return t.IDs[p26].Name
  152 | end
  153 | function t.IsPlayerR15(_15)
  154 | 	--[[ line: 193 | upvalues: none]]
  155 | 	return false
  156 | end
  157 | function t.OptimizeItem(_16, p27)
  158 | 	--[[ line: 197 | upvalues: (copy) createOptimizedModel, (copy) addJoints]]
  159 | 	local v28 = require(p27)
  160 | 	if v28.CosmeticInfo and v28.CosmeticInfo.Character then
  161 | 		if v28.CosmeticInfo and v28.CosmeticInfo.Character then
  162 | 			addJoints((p27:FindFirstChild("Character")))
  163 | 			addJoints((p27:FindFirstChild("CharacterClassic")))
  164 | 		end
  165 | 		return
  166 | 	else
  167 | 		if p27:FindFirstChild("Character") then
  168 | 			createOptimizedModel(p27.Character).Parent = p27
  169 | 		end
  170 | 		if p27:FindFirstChild("CharacterClassic") then
  171 | 			createOptimizedModel(p27.CharacterClassic).Parent = p27
  172 | 		end
  173 | 	end
  174 | end
  175 | function t.GetItemType(_17, p29)
  176 | 	--[[ line: 216 | upvalues: (copy) Registry]]
  177 | 	local v30 = Registry.GetById((p29:GetAttribute("ID")))
  178 | 	local v31 = require(p29)
  179 | 	if table.find(v30.Categories, "CarryAnimations") then
  180 | 		return "CarryAnimation"
  181 | 	end
  182 | 	if table.find(v30.Categories, "Cosmetics") or table.find(v30.Categories, "Skins") then
  183 | 		return (p29:FindFirstChild("Original") or p29:FindFirstChild("Client")) and "ItemSkin" or (v31.CosmeticInfo and v31.CosmeticInfo.Unusual and "Unusual" or (v31.CosmeticInfo and v31.CosmeticInfo.Character and "Character" or "Cosmetic"))
  184 | 	end
  185 | 	if table.find(v30.Categories, "Emotes") then
  186 | 		return "Emote"
  187 | 	end
  188 | 	if table.find(v30.Categories, "Loadout") then
  189 | 		return v31.ServerInfo and v31.ServerInfo.Deployable and "Deployable" or (p29:FindFirstChild("Headgear") and "Headgear" or "Loadout")
  190 | 	end
  191 | 	if table.find(v30.Categories, "Nametags") then
  192 | 		return "Nametag"
  193 | 	end
  194 | 	if table.find(v30.Categories, "Perks") then
  195 | 		return "Perk"
  196 | 	end
  197 | 	if table.find(v30.Categories, "Boomboxes") then
  198 | 		return "Boombox"
  199 | 	end
  200 | end
  201 | function t.GetName(_18, p32)
  202 | 	--[[ line: 250 | upvalues: none]]
  203 | 	return require(p32).AppearanceInfo.Name
  204 | end
  205 | function t.GetVisualModel(_19, p_u_33, p34)
  206 | 	--[[ line: 253 | upvalues: (copy) t, (copy) ReplicatedStorage, (copy) v_u_1, (copy) attachAura, (copy) v_u_2]]
  207 | 	local v35 = t:GetItemType(p_u_33)
  208 | 	local v_u_36 = nil
  209 | 	if v35 == "Emote" then
  210 | 		if t:IsPlayerR15() then
  211 | 			v_u_36 = ReplicatedStorage.Assets.Items.VisualRigR15Emote:Clone()
  212 | 		else
  213 | 			v_u_36 = ReplicatedStorage.Assets.Items.VisualRigClassic:Clone()
  214 | 		end
  215 | 		if p34 then
  216 | 			task.spawn(function()
  217 | 				--[[ line: 264 | upvalues: (ref) v_u_1, (ref) v_u_36, (copy) p_u_33]]
  218 | 				v_u_1:SetEmote(v_u_36, p_u_33, false, nil, false)
  219 | 			end)
  220 | 		end
  221 | 	elseif v35 == "CarryAnimation" then
  222 | 		if t:IsPlayerR15() then
  223 | 			v_u_36 = p_u_33.Character:Clone()
  224 | 			v_u_36.Carrier.AnimationController:LoadAnimation(p_u_33.Carry):Play(0)
  225 | 			v_u_36.Carried.AnimationController:LoadAnimation(p_u_33.Carried):Play(0)
  226 | 		else
  227 | 			v_u_36 = p_u_33.Classic.Character:Clone()
  228 | 			v_u_36.Carrier.AnimationController:LoadAnimation(p_u_33.Classic.Carry):Play(0)
  229 | 			v_u_36.Carried.AnimationController:LoadAnimation(p_u_33.Classic.Carried):Play(0)
  230 | 		end
  231 | 	elseif v35 == "Headgear" then
  232 | 		v_u_36 = p_u_33.Headgear:Clone()
  233 | 	elseif v35 == "Deployable" or v35 == "ItemSkin" and p_u_33:FindFirstChild("Client") then
  234 | 		v_u_36 = p_u_33.Client:Clone()
  235 | 	elseif v35 == "Cosmetic" or (v35 == "Character" or (v35 == "Unusual" or v35 == "Boombox")) then
  236 | 		local v37 = t:IsPlayerR15()
  237 | 		if p_u_33:FindFirstChild("Aura") then
  238 | 			local v38 = t:GetItemFromID(239)
  239 | 			if t:IsPlayerR15() then
  240 | 				v_u_36 = v38.Character:Clone()
  241 | 			else
  242 | 				v_u_36 = v38.CharacterClassic:Clone()
  243 | 			end
  244 | 			local v39 = attachAura
  245 | 			local Aura = p_u_33.Aura
  246 | 			local v40
  247 | 			if v_u_36:FindFirstChild("Torso") then
  248 | 				v40 = v_u_36.Torso.Boombox
  249 | 			else
  250 | 				v40 = v_u_36.UpperTorso.Boombox
  251 | 			end
  252 | 			v39(Aura, v40)
  253 | 		elseif v37 and p_u_33:FindFirstChild("Character") or p_u_33:FindFirstChild("CharacterClassic") == nil then
  254 | 			v_u_36 = p_u_33.Character:Clone()
  255 | 		else
  256 | 			v_u_36 = p_u_33.CharacterClassic:Clone()
  257 | 		end
  258 | 		if require(p_u_33).AppearanceInfo.CameraType == "Back" then
  259 | 			if v37 then
  260 | 				v_u_36.LowerTorso.Root.C0 = CFrame.Angles(0, 3.141592653589793, 0) * v_u_36.LowerTorso.Root.C0
  261 | 			else
  262 | 				v_u_36.HumanoidRootPart.TorsoRot.C0 = CFrame.Angles(0, 3.141592653589793, 0) * v_u_36.HumanoidRootPart.TorsoRot.C0
  263 | 			end
  264 | 		end
  265 | 		if not v_u_36.PrimaryPart then
  266 | 			v_u_36.PrimaryPart = v_u_36:FindFirstChild("HumanoidRootPart")
  267 | 		end
  268 | 		if v_u_36:FindFirstChild("Humanoid") then
  269 | 			v_u_36.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
  270 | 			v_u_36.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
  271 | 		end
  272 | 	elseif v35 == "Loadout" or v35 == "ItemSkin" then
  273 | 		if p_u_33:FindFirstChild("Headgear") then
  274 | 			return p_u_33.Headgear:Clone()
  275 | 		end
  276 | 		if v35 == "ItemSkin" then
  277 | 			v_u_36 = ReplicatedStorage.Tools[p_u_33:FindFirstChild("Original").Value.Name].Variants[p_u_33.Name].Character.Tool:Clone()
  278 | 		elseif p_u_33:FindFirstChild("Visual") then
  279 | 			v_u_36 = p_u_33.Visual:Clone()
  280 | 		elseif ReplicatedStorage.Tools:FindFirstChild(p_u_33.Name) then
  281 | 			v_u_36 = ReplicatedStorage.Tools[p_u_33.Name].Variants.Default.Character.Tool:Clone()
  282 | 		end
  283 | 		v_u_36.PrimaryPart = v_u_36.Handle
  284 | 		v_u_36:PivotTo(v_u_36.Handle.CFrame)
  285 | 		local v41, v42 = v_u_36:GetBoundingBox()
  286 | 		local Part = Instance.new("Part")
  287 | 		Part.Anchored = true
  288 | 		Part.Transparency = 1
  289 | 		Part.CFrame = v41
  290 | 		Part.Size = v42
  291 | 		Part.Parent = v_u_36
  292 | 		v_u_36.PrimaryPart = Part
  293 | 		local Weld2 = Instance.new("Weld")
  294 | 		Weld2.C0 = Part.CFrame:inverse()
  295 | 		Weld2.C1 = v_u_36.Handle.CFrame:inverse()
  296 | 		Weld2.Part0 = Part
  297 | 		Weld2.Part1 = v_u_36.Handle
  298 | 		Weld2.Parent = v_u_36.Handle
  299 | 	elseif v35 == "Perk" then
  300 | 		if t:IsPlayerR15() then
  301 | 			v_u_36 = p_u_33.Character:Clone()
  302 | 		else
  303 | 			v_u_36 = p_u_33.CharacterClassic:Clone()
  304 | 		end
  305 | 		if not v_u_36.PrimaryPart then
  306 | 			v_u_36.PrimaryPart = v_u_36:FindFirstChild("HumanoidRootPart")
  307 | 		end
  308 | 	elseif v35 == "Nametag" then
  309 | 		local v43 = v_u_2.new({
  310 | 			GlobalTransparency = false,
  311 | 			InitialBind = true,
  312 | 			InitialInstancesEnabled = true,
  313 | 			Module = p_u_33,
  314 | 			ScaleType = v_u_2.ScaleTypes.XY,
  315 | 			ZIndexMode = v_u_2.ZIndexModes.Global
  316 | 		})
  317 | 		v43:Initialize()
  318 | 		v43:SetText(game.Players.LocalPlayer.DisplayName)
  319 | 		v43.Frame.Size = UDim2.new(1, 0, 1, 0)
  320 | 		if p34 then
  321 | 			if t:IsPlayerR15() then
  322 | 				v_u_36 = ReplicatedStorage.Assets.Items.VisualRig:Clone()
  323 | 			else
  324 | 				v_u_36 = ReplicatedStorage.Assets.Items.VisualRigClassic:Clone()
  325 | 			end
  326 | 			local v44 = script.PlayerInfo:Clone()
  327 | 			v44.Parent = v_u_36
  328 | 			v44.Adornee = v_u_36
  329 | 			v44.Enabled = true
  330 | 			v43.Frame.Size = UDim2.new(1, 0, 1, 0)
  331 | 			v43.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
  332 | 			v43.Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
  333 | 			v43.Frame.Parent = v44
  334 | 		else
  335 | 			v43.Frame.ZIndex = 40
  336 | 			v_u_36 = v43
  337 | 		end
  338 | 	end
  339 | 	return v_u_36
  340 | end
  341 | function t.ClearViewport(_20, p45)
  342 | 	--[[ line: 399 | upvalues: none]]
  343 | 	local WorldModel = p45:FindFirstChildOfClass("WorldModel")
  344 | 	if WorldModel then
  345 | 		WorldModel:Destroy()
  346 | 	end
  347 | end
  348 | function t.CreateViewport(_21, p46, p47)
  349 | 	--[[ line: 406 | upvalues: (copy) t, (copy) v_u_1]]
  350 | 	local v48
  351 | 	if p47:FindFirstChildOfClass("WorldModel") then
  352 | 		v48 = p47:FindFirstChildOfClass("WorldModel")
  353 | 		v48:ClearAllChildren()
  354 | 	else
  355 | 		v48 = nil
  356 | 	end
  357 | 	if p47:FindFirstChild("Frame") then
  358 | 		p47.Frame:Destroy()
  359 | 	end
  360 | 	if p46 then
  361 | 		local v49 = v48 or Instance.new("WorldModel")
  362 | 		local Camera = Instance.new("Camera")
  363 | 		local v50 = t:GetItemType(p46)
  364 | 		local v51 = t:GetVisualModel(p46)
  365 | 		local v52 = require(p46)
  366 | 		local v53 = 30
  367 | 		if v51 and typeof(v51) == "Instance" then
  368 | 			if v50 == "Cosmetic" or (v50 == "Boombox" or (v50 == "Character" or v50 == "Unusual")) then
  369 | 				if v52.AppearanceInfo.CameraType == "Head" then
  370 | 					Camera.CFrame = CFrame.new(0, 1.65, 0) * CFrame.new((v51.PrimaryPart.CFrame * CFrame.new(0.85, -0.51, -5.1)).p, v51.PrimaryPart.CFrame.p)
  371 | 				elseif v52.AppearanceInfo.CameraType == "Back" then
  372 | 					Camera.CFrame = CFrame.new(0, 0.34, 0) * CFrame.new((v51.PrimaryPart.CFrame * CFrame.new(4.25, 1.7, 8.5)).p, v51.PrimaryPart.CFrame.p)
  373 | 				else
  374 | 					Camera.CFrame = CFrame.new(0, 0.34, 0) * CFrame.new((v51.PrimaryPart.CFrame * CFrame.new(4.25, 1.7, -8.5)).p, v51.PrimaryPart.CFrame.p)
  375 | 				end
  376 | 			elseif v52.AppearanceInfo.ViewInfo then
  377 | 				Camera.CFrame = v51.PrimaryPart.CFrame * v52.AppearanceInfo.ViewInfo.CFrame
  378 | 				v53 = v52.AppearanceInfo.ViewInfo.FieldOfView
  379 | 			else
  380 | 				Camera.CFrame = CFrame.new(0, 0.34, 0) * CFrame.new((v51.PrimaryPart.CFrame * CFrame.new(4.25, 1.7, -8.5)).p, v51.PrimaryPart.CFrame.p)
  381 | 			end
  382 | 			v51.Parent = v49
  383 | 		elseif v51 and v51.Frame then
  384 | 			v51.Frame.Parent = p47
  385 | 			v51.Frame.Name = "Frame"
  386 | 		end
  387 | 		Camera.FieldOfView = v53
  388 | 		v49.Parent = p47
  389 | 		Camera.Parent = v49
  390 | 		p47.CurrentCamera = Camera
  391 | 		local v54 = t:GetItemType(p46)
  392 | 		if v54 == "Emote" then
  393 | 			v_u_1:SetEmote(v51, p46, true)
  394 | 		elseif v54 == "CarryAnimation" then
  395 | 			local v55 = v51.Carrier:FindFirstChildOfClass("AnimationController") or v51.Carrier:FindFirstChildOfClass("Humanoid")
  396 | 			local v56 = v51.Carried:FindFirstChildOfClass("AnimationController") or v51.Carried:FindFirstChildOfClass("Humanoid")
  397 | 			if v51.Carrier:FindFirstChild("UpperTorso") then
  398 | 				local Carry = v55:LoadAnimation(p46.Carry)
  399 | 				Carry:Play(0)
  400 | 				Carry:AdjustSpeed(0)
  401 | 				local Carried = v56:LoadAnimation(p46.Carried)
  402 | 				Carried:Play(0)
  403 | 				Carried:AdjustSpeed(0)
  404 | 				return
  405 | 			end
  406 | 			local Carry2 = v55:LoadAnimation(p46.Classic.Carry)
  407 | 			Carry2:Play(0)
  408 | 			Carry2:AdjustSpeed(0)
  409 | 			local Carried2 = v56:LoadAnimation(p46.Classic.Carried)
  410 | 			Carried2:Play(0)
  411 | 			Carried2:AdjustSpeed(0)
  412 | 		end
  413 | 	else
  414 | 		return
  415 | 	end
  416 | end
  417 | function t.SetIcon(_22, p57, p58)
  418 | 	--[[ line: 484 | upvalues: none]]
  419 | 	local v59 = require(p57)
  420 | 	if v59.AppearanceInfo and v59.AppearanceInfo.Icon then
  421 | 		p58.Image = "rbxassetid://" .. v59.AppearanceInfo.Icon
  422 | 	else
  423 | 		p58.Image = "rbxassetid://15818765746"
  424 | 	end
  425 | end
  426 | t:SetIDs()
  427 | return t


========================================
MATCH #23
PATH: ReplicatedStorage.Objects.Game.Character.Rig
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 10870
========================================

--- SOURCE LINES 1-256 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
    4 | local LocalPlayer = game:GetService("Players").LocalPlayer
    5 | local Setup = require(ReplicatedStorage.Info.Setup)
    6 | ReplicatedStorage:WaitForChild("NPCs")
    7 | local Services = ReplicatedStorage:WaitForChild("Services")
    8 | local v_u_1 = require((Services:WaitForChild("Items"):WaitForChild("ClientItemService")))
    9 | local Shared = ReplicatedStorage:WaitForChild("Shared")
   10 | local Services2 = ReplicatedStorage:WaitForChild("Services")
   11 | local v_u_2 = require((Shared:WaitForChild("UserData"):WaitForChild("ClientHooks"):WaitForChild("useSettings")))
   12 | local ActionTypes = ReplicatedStorage.Objects.Game.Actions.ActionTypes
   13 | local RigService = require(Services2.Asset.RigService)
   14 | local _ = Setup.MakeR15RigFake
   15 | local t = {}
   16 | t.__index = t
   17 | function t.new(p3)
   18 | 	--[[ line: 29 | upvalues: (copy) t]]
   19 | 	local t2 = {
   20 | 		Parent = p3,
   21 | 		Character = p3.Model,
   22 | 		DataRegistry = p3.DataRegistry,
   23 | 		Joints = {},
   24 | 		Parts = {},
   25 | 		Particles = {},
   26 | 		Overlays = {},
   27 | 		Limbs = {},
   28 | 		CachedData = {}
   29 | 	}
   30 | 	local v4 = t
   31 | 	local v5 = setmetatable(t2, v4)
   32 | 	local v6 = t
   33 | 	return setmetatable(v5, v6)
   34 | end
   35 | function t.Init(p_u_7)
   36 | 	--[[ line: 45 | upvalues: none]]
   37 | 	p_u_7.PrimaryPart = p_u_7.Character:FindFirstChild("HumanoidRootPart")
   38 | 	if p_u_7.PrimaryPart then
   39 | 		p_u_7.PrimaryPart.Transparency = 1
   40 | 	end
   41 | 	p_u_7.Ragdoll = require(script.Ragdoll).new(p_u_7.Character, p_u_7)
   42 | 	p_u_7.Character.ChildAdded:Connect(function(p_u_8)
   43 | 		--[[ line: 51 | upvalues: (copy) p_u_7]]
   44 | 		if p_u_8.Name == "Prop" then
   45 | 			if p_u_8.Value then
   46 | 				p_u_7:ChangeModel(p_u_8.Value)
   47 | 			end
   48 | 			p_u_8:GetPropertyChangedSignal("Value"):Connect(function()
   49 | 				--[[ line: 56 | upvalues: (copy) p_u_8, (ref) p_u_7]]
   50 | 				if p_u_8.Value then
   51 | 					p_u_7:ChangeModel(p_u_8.Value)
   52 | 				end
   53 | 			end)
   54 | 		end
   55 | 	end)
   56 | end
   57 | function t.Destroy(p9)
   58 | 	--[[ line: 65 | upvalues: (copy) RigService]]
   59 | 	if p9.Parent.AI then
   60 | 		local v_u_10 = p9:GetRigModel()
   61 | 		if v_u_10 then
   62 | 			task.spawn(function()
   63 | 				--[[ line: 69 | upvalues: (copy) v_u_10]]
   64 | 				if v_u_10:FindFirstChild("Head") then
   65 | 					task.wait(5)
   66 | 				end
   67 | 				v_u_10:Destroy()
   68 | 			end)
   69 | 		end
   70 | 	else
   71 | 		RigService:UnsetRig(p9.Character)
   72 | 		p9.Ragdoll:Destroy()
   73 | 	end
   74 | end
   75 | function t.Clear(p11)
   76 | 	--[[ line: 82 | upvalues: none]]
   77 | 	for _2, v12 in p11.Character:GetChildren() do
   78 | 		if not v12:IsA("Humanoid") and v12 ~= p11.PrimaryPart then
   79 | 			v12:Destroy()
   80 | 		end
   81 | 	end
   82 | 	p11.Joints = {}
   83 | 	p11.Parts = {}
   84 | 	p11.Limbs = {}
   85 | 	p11.CachedData = {}
   86 | end
   87 | function t.GetParts(p13)
   88 | 	--[[ line: 94 | upvalues: none]]
   89 | 	return p13.Parts
   90 | end
   91 | function t.GetLimbs(p14)
   92 | 	--[[ line: 98 | upvalues: none]]
   93 | 	return not p14.Rig and {} or p14.Rig.Limbs
   94 | end
   95 | function t.GetJoints(p15)
   96 | 	--[[ line: 105 | upvalues: none]]
   97 | 	return p15.Joints
   98 | end
   99 | function t.GetCosmetics(p16)
  100 | 	--[[ line: 109 | upvalues: none]]
  101 | 	return p16.Cosmetics
  102 | end
  103 | function t.GetRigModel(p17)
  104 | 	--[[ line: 113 | upvalues: none]]
  105 | 	if p17.Rig then
  106 | 		return p17.Rig.Model
  107 | 	end
  108 | end
  109 | function t.GetRig(p18)
  110 | 	--[[ line: 119 | upvalues: none]]
  111 | 	return p18.Rig
  112 | end
  113 | function t.GetGear(p19)
  114 | 	--[[ line: 123 | upvalues: (copy) ActionTypes, (copy) v_u_1]]
  115 | 	local t3 = {}
  116 | 	for _3, v20 in p19.Actions do
  117 | 		local v21 = nil
  118 | 		local v22
  119 | 		if v20 == ActionTypes.NightVisionGoggles:GetAttribute("ID") then
  120 | 			v22 = "NightVisionGoggles"
  121 | 		else
  122 | 			v22 = v20 == ActionTypes.Headlamp:GetAttribute("ID") and "Headlamp" or v21
  123 | 		end
  124 | 		local v23 = nil
  125 | 		if v22 then
  126 | 			for _4, v24 in p19.ToolSkins do
  127 | 				local v25 = v_u_1:GetItemFromID(v24)
  128 | 				if v25 and (v25:FindFirstChild("Original") and v25.Original.Value.Name == v22) then
  129 | 					v23 = v25:GetAttribute("ID")
  130 | 				end
  131 | 			end
  132 | 		end
  133 | 		if v23 then
  134 | 			table.insert(t3, v23)
  135 | 		elseif v22 then
  136 | 			local v26 = v_u_1
  137 | 			table.insert(t3, (v26:GetItemIDFromName(v22)))
  138 | 		end
  139 | 	end
  140 | 	return t3
  141 | end
  142 | function t.BuildRig(p27)
  143 | 	--[[ line: 150 | upvalues: (copy) v_u_2, (copy) RigService]]
  144 | 	if p27.Built then
  145 | 		return
  146 | 	elseif p27.Cosmetics and (p27.RigTerm and (p27.Actions and (p27.ToolSkins and p27.Boombox))) then
  147 | 		p27.Built = true
  148 | 		if p27.RigTerm == Enum.HumanoidRigType.R15 and v_u_2.Get("R15Enabled") == false then
  149 | 			p27.RigTerm = Enum.HumanoidRigType.R6
  150 | 		end
  151 | 		p27.Rig = RigService:SetRig(p27.Character, p27.RigTerm or Enum.HumanoidRigType.R6, p27.Cosmetics, p27:GetGear(), p27.Boombox)
  152 | 		if p27.Rig.Model:GetAttribute("Hidden") then
  153 | 			p27.Rig.Model:SetAttribute("Hidden", nil)
  154 | 			for _5, v28 in p27.Rig.Model:GetDescendants() do
  155 | 				if v28:IsA("BasePart") then
  156 | 					v28.LocalTransparencyModifier = 0
  157 | 				elseif v28:IsA("Decal") then
  158 | 					v28.Transparency = v28:GetAttribute("OldTransparency") or 0
  159 | 				end
  160 | 			end
  161 | 		end
  162 | 		if p27.Rig.Model:FindFirstChild("Head") and (p27.Rig.Model.Head:GetAttribute("DontShowFPCharacter") and (p27.DataRegistry and p27.DataRegistry.Set)) then
  163 | 			p27.DataRegistry:Set("DontShowFPCharacter", true)
  164 | 		end
  165 | 		p27.Joints = {}
  166 | 		for _6, v29 in p27.Rig.Model:WaitForChild("Joints"):GetChildren() do
  167 | 			local Joints = p27.Joints
  168 | 			table.insert(Joints, v29)
  169 | 		end
  170 | 		p27.Parts = {}
  171 | 		for _7, v30 in p27.Rig.Model:GetChildren() do
  172 | 			if v30:IsA("BasePart") then
  173 | 				local Parts = p27.Parts
  174 | 				table.insert(Parts, v30)
  175 | 			end
  176 | 		end
  177 | 		if p27.Rig.Humanoid.RigType == Enum.HumanoidRigType.R15 then
  178 | 			p27.R15 = true
  179 | 		else
  180 | 			p27.R15 = false
  181 | 		end
  182 | 		if p27.Parent then
  183 | 			if p27.Parent.Joints then
  184 | 				p27.Parent.Joints:SetJoints()
  185 | 				p27.Parent.Joints:EnableJoints()
  186 | 			end
  187 | 			if p27.Parent.Camera then
  188 | 				p27.Parent.Camera:SetJoints()
  189 | 			end
  190 | 			if p27.Parent.Animations then
  191 | 				p27.Parent.Animations:SetRig(p27.Rig)
  192 | 			end
  193 | 		end
  194 | 	end
  195 | end
  196 | function t.RegistryTermUpdated(p31: {[any]: any}, p32: string)
  197 | 	--[[ line: 210 | upvalues: (copy) LocalPlayer]]
  198 | 	if p32 == "Rig" then
  199 | 		p31.RigTerm = p31.DataRegistry:Get(p32)
  200 | 		p31:BuildRig()
  201 | 		return
  202 | 	end
  203 | 	if p32 == "Cosmetics" then
  204 | 		p31.Cosmetics = p31.DataRegistry:Get("Cosmetics")
  205 | 		p31:BuildRig()
  206 | 		return
  207 | 	end
  208 | 	if p32 == "Actions" then
  209 | 		p31.Actions = p31.DataRegistry:Get("Actions")
  210 | 		p31:BuildRig()
  211 | 		return
  212 | 	end
  213 | 	if p32 == "ToolSkins" then
  214 | 		p31.ToolSkins = p31.DataRegistry:Get("ToolSkins")
  215 | 		p31:BuildRig()
  216 | 		return
  217 | 	end
  218 | 	if p32 == "Boombox" then
  219 | 		p31.Boombox = p31.DataRegistry:Get("Boombox")
  220 | 		p31:BuildRig()
  221 | 		return
  222 | 	end
  223 | 	if p32 == "Nametag" then
  224 | 		if p31.Character then
  225 | 			p31.Character:SetAttribute("Nametag", (p31.DataRegistry:Get("Nametag")))
  226 | 		end
  227 | 	end
  228 | 	if p32 == "Size" then
  229 | 		p31.DataRegistry:Get("Size")
  230 | 		return
  231 | 	end
  232 | 	if p32 == "Highlight" then
  233 | 		if not p31.Rig then
  234 | 			return
  235 | 		end
  236 | 		local Highlight = p31.DataRegistry:Get("Highlight")
  237 | 		if Highlight == 0 and p31.Highlight then
  238 | 			p31.Highlight:Destroy()
  239 | 			p31.Highlight = nil
  240 | 			p31.HighlightTeam = nil
  241 | 			return
  242 | 		end
  243 | 		if not p31.Highlight then
  244 | 			p31.Highlight = Instance.new("Highlight")
  245 | 			p31.Highlight.Enabled = false
  246 | 			p31.Highlight.FillTransparency = 1
  247 | 			p31.Highlight.OutlineTransparency = 0.2
  248 | 			p31.Highlight.Adornee = p31.Rig.Model
  249 | 			p31.Highlight.Parent = p31.Character
  250 | 		end
  251 | 		p31.Highlight.OutlineColor = Highlight.Color or Color3.new(255, 185, 114)
  252 | 		if Highlight.VisibleTo then
  253 | 			p31.HighlightTeam = Highlight.VisibleTo
  254 | 			if LocalPlayer.Character then
  255 | 				p31.LocalPlayerTeam = LocalPlayer.Character:GetAttribute("Team")
  256 | 			end


========================================
MATCH #24
PATH: ReplicatedStorage.Objects.Game.Character.Rig.RigOld
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 10121
========================================

--- SOURCE LINES 48-159 ---
   48 | 	p8.Joints = {}
   49 | 	p8.Parts = {}
   50 | 	p8.Limbs = {}
   51 | 	p8.CachedData = {}
   52 | end
   53 | function t.GetBestRig(p10, p11)
   54 | 	--[[ line: 62 | upvalues: (copy) v_u_1, (copy) v_u_2]]
   55 | 	if p11 == Enum.HumanoidRigType.R15 then
   56 | 		warn("Auto setting rig to R6")
   57 | 		p11 = Enum.HumanoidRigType.R6
   58 | 	end
   59 | 	local v12 = nil
   60 | 	if typeof(p11) ~= "number" then
   61 | 		if not v_u_2.Get("R15Enabled") and p11 == Enum.HumanoidRigType.R15 then
   62 | 			p11 = Enum.HumanoidRigType.R6
   63 | 		end
   64 | 		if not (p10.PlayerReference or p10.Parent.PlayerReference) then
   65 | 			if p10.Parent.Module then
   66 | 				v12 = p10.Parent.Module:WaitForChild("Variants"):WaitForChild(p10.DataRegistry:Get("Variant") or "Default")
   67 | 			end
   68 | 			return v12
   69 | 		end
   70 | 		v13 = workspace.PlayerCache:WaitForChild(p10.Character.Name)
   71 | 		if p11 == Enum.HumanoidRigType.R6 then
   72 | 			return v13.R6
   73 | 		end
   74 | 		return v13.Player
   75 | 	end
   76 | 	local v14 = v_u_1:GetItemFromID(p11)
   77 | 	if not v14 then
   78 | 		if not v_u_2.Get("R15Enabled") and p11 == Enum.HumanoidRigType.R15 then
   79 | 			p11 = Enum.HumanoidRigType.R6
   80 | 		end
   81 | 		if not (p10.PlayerReference or p10.Parent.PlayerReference) then
   82 | 			if p10.Parent.Module then
   83 | 				v12 = p10.Parent.Module:WaitForChild("Variants"):WaitForChild(p10.DataRegistry:Get("Variant") or "Default")
   84 | 			end
   85 | 			return v12
   86 | 		end
   87 | 		v13 = workspace.PlayerCache:WaitForChild(p10.Character.Name)
   88 | 		if p11 == Enum.HumanoidRigType.R6 then
   89 | 			return v13.R6
   90 | 		end
   91 | 		return v13.Player
   92 | 	end
   93 | 	if v14:FindFirstChild("CharacterClassic") then
   94 | 		return v14.CharacterClassic
   95 | 	end
   96 | 	if v14:FindFirstChild("Character") then
   97 | 		return v14.Character
   98 | 	end
   99 | 	if not v_u_2.Get("R15Enabled") and p11 == Enum.HumanoidRigType.R15 then
  100 | 		p11 = Enum.HumanoidRigType.R6
  101 | 	end
  102 | 	if not (p10.PlayerReference or p10.Parent.PlayerReference) then
  103 | 		if p10.Parent.Module then
  104 | 			v12 = p10.Parent.Module:WaitForChild("Variants"):WaitForChild(p10.DataRegistry:Get("Variant") or "Default")
  105 | 		end
  106 | 		return v12
  107 | 	end
  108 | 	local v13 = workspace.PlayerCache:WaitForChild(p10.Character.Name)
  109 | 	if p11 == Enum.HumanoidRigType.R6 then
  110 | 		return v13.R6
  111 | 	end
  112 | 	return v13.Player
  113 | end
  114 | function t.Build(p15, p16)
  115 | 	--[[ line: 102 | upvalues: none]]
  116 | 	p15:BuildFromRig((p15:GetBestRig(p16)))
  117 | end
  118 | function t.GetParts(p17)
  119 | 	--[[ line: 106 | upvalues: none]]
  120 | 	return p17.Parts
  121 | end
  122 | function t.GetLimbs(p18)
  123 | 	--[[ line: 110 | upvalues: none]]
  124 | 	return p18.Limbs
  125 | end
  126 | function t.BuildFromRig(p19, p20)
  127 | 	--[[ line: 114 | upvalues: (copy) MakeR15RigFake]]
  128 | 	p19:Clear()
  129 | 	p19.BuiltRig = true
  130 | 	p19.Humanoid = p19.Character:FindFirstChildWhichIsA("Humanoid")
  131 | 	local v21 = p20:Clone()
  132 | 	local Joints = v21:FindFirstChild("Joints")
  133 | 	Joints.Parent = p19.Character
  134 | 	for _3, v22 in v21:GetChildren() do
  135 | 		if v22:IsA("Humanoid") or (v22.Name == "HumanoidRootPart" or v22:IsA("Motor6D")) then
  136 | 			if v22.Name == "HumanoidRootPart" then
  137 | 				for _4, v23 in v22:GetChildren() do
  138 | 					if not p19.Character.HumanoidRootPart:FindFirstChild(v23.Name) then
  139 | 						v23.Parent = p19.Character.HumanoidRootPart
  140 | 					end
  141 | 				end
  142 | 			end
  143 | 		else
  144 | 			v22.Parent = p19.Character
  145 | 			if v22:IsA("BasePart") then
  146 | 				v22.Anchored = false
  147 | 				local Parts = p19.Parts
  148 | 				table.insert(Parts, v22)
  149 | 			elseif v22:IsA("ParticleEmitter") then
  150 | 				local Particles = p19.Particles
  151 | 				table.insert(Particles, v22)
  152 | 			elseif v22:IsA("Decal") or (v22:IsA("Trail") or (v22:IsA("Texture") or (v22:IsA("SurfaceGui") or v22:IsA("BillboardGui")))) then
  153 | 				local Overlays = p19.Overlays
  154 | 				table.insert(Overlays, v22)
  155 | 			end
  156 | 		end
  157 | 	end
  158 | 	for _5, v24 in pairs((Joints:GetChildren())) do
  159 | 		local Joints2 = p19.Joints

--- SOURCE LINES 209-365 ---
  209 | 		end
  210 | 	end
  211 | 	local Humanoid = v21:FindFirstChildWhichIsA("Humanoid")
  212 | 	if Humanoid.RigType == Enum.HumanoidRigType.R15 and MakeR15RigFake then
  213 | 		p19:CreateFakeHumanoid()
  214 | 	elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
  215 | 		p19.Character.Humanoid.RigType = Enum.HumanoidRigType.R15
  216 | 	end
  217 | 	v21:Destroy()
  218 | 	if p19.Parent then
  219 | 		if p19.Parent.Joints then
  220 | 			p19.Parent.Joints:SetJoints()
  221 | 			p19.Parent.Joints:EnableJoints()
  222 | 		end
  223 | 		if p19.Parent.Camera then
  224 | 			p19.Parent.Camera:SetJoints()
  225 | 		end
  226 | 	end
  227 | end
  228 | function t.GetJoints(p34)
  229 | 	--[[ line: 206 | upvalues: none]]
  230 | 	return p34.Joints
  231 | end
  232 | function t.GetCosmetics(p35)
  233 | 	--[[ line: 210 | upvalues: none]]
  234 | 	return p35.Cosmetics
  235 | end
  236 | function t.CreateFakeHumanoid(p36)
  237 | 	--[[ line: 214 | upvalues: none]]
  238 | 	local v37 = Instance.new("Model", p36.Character)
  239 | 	v37.Name = "R15Visual"
  240 | 	for _12, v38 in p36.Character:GetChildren() do
  241 | 		if not v38:IsA("Humanoid") and (v38 ~= p36.Character.PrimaryPart and v38 ~= v37) then
  242 | 			v38.Parent = v37
  243 | 		end
  244 | 	end
  245 | 	local v39 = script.Visual_Humanoid:Clone()
  246 | 	v39.Parent = v37
  247 | 	p36.Humanoid = v39
  248 | end
  249 | function t.RegistryTermUpdated(p40: {[any]: any}, p41: string)
  250 | 	--[[ line: 229 | upvalues: none]]
  251 | 	if p41 == "Rig" then
  252 | 		p40:Build((p40.DataRegistry:Get(p41)))
  253 | 		if p40.QueuedCosmetics then
  254 | 			p40:AddCosmetics(p40.QueuedCosmetics)
  255 | 			p40.QueuedCosmetics = {}
  256 | 		end
  257 | 	else
  258 | 		if p41 == "Cosmetics" then
  259 | 			if not p40.BuiltRig then
  260 | 				p40.QueuedCosmetics = p40.DataRegistry:Get("Cosmetics")
  261 | 				return
  262 | 			end
  263 | 			p40:AddCosmetics((p40.DataRegistry:Get("Cosmetics")))
  264 | 		end
  265 | 		return
  266 | 	end
  267 | end
  268 | function t.Kill(p42, p43)
  269 | 	--[[ line: 245 | upvalues: none]]
  270 | 	if p43.Instakill then
  271 | 		p42.Ragdoll:Ragdoll(true, p43)
  272 | 	else
  273 | 		p42.Ragdoll:Ragdoll(false, p43)
  274 | 	end
  275 | end
  276 | function t.AddCosmetics(p44, p45)
  277 | 	--[[ line: 254 | upvalues: (copy) v_u_1]]
  278 | 	for _13, v46 in p44.Cosmetics do
  279 | 		for _14, v47 in v46 do
  280 | 			v47:Destroy()
  281 | 		end
  282 | 	end
  283 | 	p44.Cosmetics = {}
  284 | 	for _15, v48 in p44.Limbs do
  285 | 		v48[3] = {}
  286 | 	end
  287 | 	local Character = p44.Character
  288 | 	local v49
  289 | 	if p44.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 or p44.Character:FindFirstChild("R15Visual") then
  290 | 		v49 = true
  291 | 		if p44.Character:FindFirstChild("R15Visual") then
  292 | 			Character = Character.R15Visual
  293 | 		end
  294 | 	else
  295 | 		v49 = false
  296 | 	end
  297 | 	for _16, v50 in p44.Cosmetics do
  298 | 		for _17, v51 in v50.Parts do
  299 | 			v51:Destroy()
  300 | 		end
  301 | 	end
  302 | 	for _18, v52 in p45 do
  303 | 		local v53 = v_u_1:GetItemFromID(v52)
  304 | 		if v53 then
  305 | 			local t4 = {}
  306 | 			if not v53:GetAttribute("Optimized") then
  307 | 				v53:SetAttribute("Optimized", true)
  308 | 				v_u_1:OptimizeItem(v53)
  309 | 			end
  310 | 			local v54
  311 | 			if v49 then
  312 | 				v54 = v53.Character_Optimized:Clone()
  313 | 			else
  314 | 				v54 = v53.CharacterClassic_Optimized:Clone()
  315 | 			end
  316 | 			for _19, v55 in v54:GetChildren() do
  317 | 				local v56 = nil
  318 | 				for _20, v57 in p44.Limbs do
  319 | 					if v57[1].Name == v55.Name then
  320 | 						if not v57[3] then
  321 | 							v57[3] = {}
  322 | 						end
  323 | 						v56 = v57[3]
  324 | 					end
  325 | 				end
  326 | 				local v58
  327 | 				if v55.Name == "HumanoidRootPart" then
  328 | 					v58 = p44.Character.HumanoidRootPart
  329 | 				else
  330 | 					v58 = Character:FindFirstChild(v55.Name)
  331 | 				end
  332 | 				if v58 then
  333 | 					for _21, v59 in v55:GetChildren() do
  334 | 						local v60 = false
  335 | 						if v59:IsA("Attachment") and v58:FindFirstChild(v59.Name) then
  336 | 							local Name = v58:FindFirstChild(v59.Name)
  337 | 							if Name.Position == v59.Position then
  338 | 								v60 = true
  339 | 								for _22, v61 in v59:GetChildren() do
  340 | 									v61.Parent = Name
  341 | 									table.insert(t4, v61)
  342 | 									table.insert(v56, v61)
  343 | 								end
  344 | 							end
  345 | 						end
  346 | 						if not v60 then
  347 | 							v59.Parent = v58
  348 | 							if v59:GetAttribute("Part0") then
  349 | 								v59.Part0 = Character:FindFirstChild((v59:GetAttribute("Part0")))
  350 | 							end
  351 | 							table.insert(t4, v59)
  352 | 							table.insert(v56, v59)
  353 | 							for _23, v62 in v59:GetDescendants() do
  354 | 								table.insert(v56, v62)
  355 | 							end
  356 | 						end
  357 | 					end
  358 | 				end
  359 | 			end
  360 | 			local Cosmetics = p44.Cosmetics
  361 | 			table.insert(Cosmetics, t4)
  362 | 		end
  363 | 	end
  364 | end
  365 | return t


========================================
MATCH #25
PATH: ReplicatedStorage.Objects.Game.Character.Animations
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 18248
========================================

--- SOURCE LINES 4-114 ---
    4 | local Shared = script.Parent:WaitForChild("Shared")
    5 | local v_u_1 = require((Shared:WaitForChild("StateInfo")))
    6 | local Services = game:GetService("ReplicatedStorage"):WaitForChild("Services")
    7 | local v_u_2 = require((Services:WaitForChild("Items"):WaitForChild("EmoteService")))
    8 | local v_u_3 = require((Services:WaitForChild("Items"):WaitForChild("CarryService")))
    9 | local v_u_4 = require((Services:WaitForChild("Items"):WaitForChild("ClientItemService")))
   10 | local v_u_5 = require((Services:WaitForChild("UI"):WaitForChild("GameUIService")))
   11 | local VehicleService = require(Services.Asset.VehicleService)
   12 | local t = {}
   13 | t.__index = t
   14 | function t.new(p6)
   15 | 	--[[ line: 25 | upvalues: (copy) t]]
   16 | 	local t2 = {
   17 | 		Speed = 0,
   18 | 		GlobalFootstepsEnabled = true,
   19 | 		Parent = p6,
   20 | 		Character = p6.Model,
   21 | 		DataRegistry = p6.DataRegistry,
   22 | 		Weights = {},
   23 | 		MoveDirection = Vector3.new()
   24 | 	}
   25 | 	local v7 = t
   26 | 	local v8 = setmetatable(t2, v7)
   27 | 	local v9 = t
   28 | 	return setmetatable(v8, v9)
   29 | end
   30 | function t.Init(p_u_10)
   31 | 	--[[ line: 40 | upvalues: none]]
   32 | 	p_u_10.Animations = {}
   33 | 	p_u_10.Transitions = {}
   34 | 	p_u_10.Footsteps = require((script:WaitForChild("Footsteps"))).new(p_u_10)
   35 | 	p_u_10.Footsteps:Init()
   36 | 	if p_u_10.Parent.ModuleInfo then
   37 | 		p_u_10.GlobalFootstepsEnabled = p_u_10.Parent.ModuleInfo.Footsteps
   38 | 	end
   39 | 	if p_u_10.Parent.Module and p_u_10.Parent.Module:FindFirstChild("AnimationModule") then
   40 | 		task.spawn(function()
   41 | 			--[[ line: 49 | upvalues: (copy) p_u_10]]
   42 | 			repeat
   43 | 				task.wait()
   44 | 			until p_u_10.Humanoid or (p_u_10.Character == nil or p_u_10.Character.Parent == nil)
   45 | 			p_u_10:SetModule(p_u_10.Parent.Module.AnimationModule)
   46 | 		end)
   47 | 	end
   48 | end
   49 | function t.SetRig(p11, p12)
   50 | 	--[[ line: 56 | upvalues: none]]
   51 | 	p11.Humanoid = p12.Model:FindFirstChildOfClass("Humanoid")
   52 | end
   53 | function t.RegistryTermUpdated(p_u_13: {[any]: any}, p14: string)
   54 | 	--[[ line: 60 | upvalues: (copy) v_u_2, (copy) v_u_4, (copy) v_u_5, (copy) v_u_3, (copy) VehicleService]]
   55 | 	if p14 == "AnimationType" and not (p_u_13.Parent.Module and p_u_13.Parent.Module:FindFirstChild("AnimationModule")) then
   56 | 		p_u_13:SetAnimationType((p_u_13.DataRegistry:Get(p14)))
   57 | 		return
   58 | 	end
   59 | 	if p14 == "Emote" then
   60 | 		if p_u_13.Emote then
   61 | 			p_u_13.Emote:Deactivate()
   62 | 			p_u_13.Emote = nil
   63 | 		end
   64 | 		local v15 = p_u_13.DataRegistry:Get(p14)
   65 | 		if v15 == 0 then
   66 | 			return
   67 | 		elseif v15 and v15 ~= 0 then
   68 | 			p_u_13.Emote = v_u_2:SetEmote(p_u_13.Character, v_u_4:GetItemFromID(v15), false, p_u_13, nil, (p_u_13.Parent.Rig:GetRigModel()))
   69 | 			if p_u_13.Parent and p_u_13.Parent.Local then
   70 | 				p_u_13.Parent.ToolProfile:Equip((p_u_13.Parent.ToolProfile:EquipKeyToIndex("Weaponless")))
   71 | 			end
   72 | 		else
   73 | 			return
   74 | 		end
   75 | 	end
   76 | 	if p14 == "State" then
   77 | 		local v16 = p_u_13.DataRegistry:Get("State") or "Inert"
   78 | 		p_u_13:SetState(p_u_13.Emote and "Inert" or v16)
   79 | 		return
   80 | 	end
   81 | 	if p14 == "Carrying" then
   82 | 		if p_u_13.Carry then
   83 | 			p_u_13.Carry:Deactivate()
   84 | 			p_u_13.Carry = nil
   85 | 		end
   86 | 		local Carrying = p_u_13.DataRegistry:Get("Carrying")
   87 | 		if Carrying == 0 then
   88 | 			if p_u_13.Parent.Local then
   89 | 				v_u_5:SetType("Interact", "Carrying", false)
   90 | 			end
   91 | 			return
   92 | 		else
   93 | 			if p_u_13.Parent.Local then
   94 | 				v_u_5:SetType("Interact", "Carrying", true)
   95 | 			end
   96 | 			local CarryItem = p_u_13.DataRegistry:Get("CarryItem")
   97 | 			if CarryItem and CarryItem ~= 0 then
   98 | 				p_u_13.Carry = v_u_3:SetCarry(p_u_13.Character, v_u_4:GetItemFromID(CarryItem), false, p_u_13, Carrying, (p_u_13.Parent.Rig:GetRigModel()))
   99 | 			else
  100 | 				p_u_13.Carry = v_u_3:SetCarry(p_u_13.Character, script.DefaultCarry, false, p_u_13, Carrying, (p_u_13.Parent.Rig:GetRigModel()))
  101 | 			end
  102 | 			if p_u_13.Parent and p_u_13.Parent.Local then
  103 | 				p_u_13.Parent.ToolProfile:Equip((p_u_13.Parent.ToolProfile:EquipKeyToIndex("Weaponless")))
  104 | 			end
  105 | 		end
  106 | 	end
  107 | 	if p14 == "Carried" then
  108 | 		if p_u_13.Carry then
  109 | 			p_u_13.Carry:Deactivate()
  110 | 			local CarryCharacterPrimaryPart = p_u_13.Carry.CarryCharacterPrimaryPart
  111 | 			p_u_13.Carry = nil
  112 | 			for _, v17 in workspace.Players:GetChildren() do
  113 | 				local CarryWeld = v17:FindFirstChild("CarryWeld")
  114 | 				if CarryWeld and CarryWeld.Part1 == p_u_13.Character.PrimaryPart then


========================================
MATCH #26
PATH: ReplicatedStorage.Objects.Menu.Menu.Views.Battlepass
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 19895
========================================

--- SOURCE LINES 297-407 ---
  297 | 			v49.Parent = p_u_24.View.ViewPass.Center.ViewPass.ScrollingFrame.Frame
  298 | 			v49.Name = v46
  299 | 			v49.TextButton.Title.Text = require(v47).AppearanceInfo.NameShortened or require(v47).AppearanceInfo.Name
  300 | 			if (game.Players.LocalPlayer:GetAttribute("AccumulatedTickets") or 0) < (require(v47).PurchaseInfo.AccumulatedPrice or 0) then
  301 | 				v49.TextButton.Accumulated.Visible = true
  302 | 				v49.TextButton.Accumulated.Title.Text = (game.Players.LocalPlayer:GetAttribute("AccumulatedTickets") or 0) .. "/" .. (require(v47).PurchaseInfo.AccumulatedPrice or 0) .. " ACCUMULATED TICKETS"
  303 | 			else
  304 | 				v49.TextButton.Accumulated.Visible = false
  305 | 			end
  306 | 			v49.TextButton.Currency.Cash.Text = commaval(v45.Price)
  307 | 			v49.TextButton.Currency.Cash.TextColor3 = p_u_24.Event.CurrencyInfo.CurrencyColor
  308 | 			v49.TextButton.Currency.Image = p_u_24.Event.CurrencyInfo.CurrencyImage
  309 | 			v49.TextButton.Currency.ImageColor3 = p_u_24.Event.CurrencyInfo.CurrencyImageColor
  310 | 			v44 = v44 + v49.Size.X.Offset
  311 | 			if require(v47).AppearanceInfo.Icon == nil or (require(v47).AppearanceInfo.Icon == 0 or (require(v47).AppearanceInfo.Icon == "0" or require(v47).AppearanceInfo.Icon == "")) then
  312 | 				v49.TextButton.IconIMG.Visible = false
  313 | 				require(script.Parent.Parent.Assets.GridCreator.ViewportIcon)(v49.TextButton.ViewportFrame, v47)
  314 | 			else
  315 | 				v49.TextButton.IconIMG.Image = "rbxassetid://" .. require(v47).AppearanceInfo.Icon
  316 | 				v49.TextButton.IconIMG.Visible = true
  317 | 			end
  318 | 			for _14, v50 in pairs(p_u_24.Data.Items) do
  319 | 				if buffer.readu16(v50, 0) == v46 then
  320 | 					v49.TextButton.Owned.Visible = true
  321 | 				end
  322 | 			end
  323 | 			table.insert(t2, v49)
  324 | 		end
  325 | 	end
  326 | 	p_u_24.View.ViewPass.Center.ViewPass.ScrollingFrame.CanvasSize = UDim2.new(0, v44, 0, 0)
  327 | 	for _15, v_u_51 in pairs(t2) do
  328 | 		v_u_51.TextButton.Activated:Connect(function()
  329 | 			--[[ line: 343 | upvalues: (copy) v_u_51, (copy) p_u_24]]
  330 | 			script.Parent.Parent.Sounds.Click.Default:Play()
  331 | 			if v_u_51.TextButton.Lock.Visible == false and (v_u_51.TextButton.Accumulated.Visible == false and (p_u_24.View.ViewPass.Center.ViewPass.RequiresMore.Visible == false and p_u_24.View.ViewPass.Center.ViewPass.Unlocked.Visible == false)) then
  332 | 				p_u_24:SetPurchase(v_u_51.Name)
  333 | 			end
  334 | 		end)
  335 | 		v_u_51.TextButton.MouseEnter:Connect(function()
  336 | 			--[[ line: 349 | upvalues: (copy) v_u_51, (copy) p_u_24]]
  337 | 			script.Parent.Parent.Sounds.Hover.Default:Play()
  338 | 			v_u_51.TextButton.Frame.UIStroke.Color = Color3.new(1, 1, 1)
  339 | 			local Rig = p_u_24.Rig
  340 | 			local IDs = p_u_24.IDs
  341 | 			local Name = v_u_51.Name
  342 | 			Rig:SetRig(IDs[tonumber(Name)])
  343 | 		end)
  344 | 		v_u_51.TextButton.MouseLeave:Connect(function()
  345 | 			--[[ line: 355 | upvalues: (copy) v_u_51]]
  346 | 			script.Parent.Parent.Sounds.Hover.Default:Play()
  347 | 			v_u_51.TextButton.Frame.UIStroke.Color = Color3.fromRGB(255, 190, 111)
  348 | 		end)
  349 | 	end
  350 | end
  351 | function t.SetPurchase(p52, p53)
  352 | 	--[[ line: 362 | upvalues: none]]
  353 | 	p52.CurrentItem = p53
  354 | 	p52.View.ViewPass.Visible = false
  355 | 	p52.View.Center.Visible = true
  356 | 	p52.View.Center.PassInfo.Visible = true
  357 | 	p52.View.Center.ViewOther.Visible = false
  358 | 	p52.View.Center.PassInfo.Visible = false
  359 | 	p52.View.Center.ShopOption.Visible = true
  360 | 	local v54 = nil
  361 | 	for _16, v55 in pairs((game.ReplicatedStorage.Items:GetChildren())) do
  362 | 		for _17, v56 in pairs((v55:GetChildren())) do
  363 | 			if v56:GetAttribute("ID") == tonumber(p53) then
  364 | 				v54 = require(v56)
  365 | 			end
  366 | 		end
  367 | 	end
  368 | 	if v54 == nil then
  369 | 		return
  370 | 	else
  371 | 		p52.View.Center.ShopOption.Creator.Text = v54.AppearanceInfo.Creator or ""
  372 | 		p52.View.Center.ShopOption.Desc.Text = v54.AppearanceInfo.Desc or ""
  373 | 		p52.View.Center.ShopOption.Overview.Text = v54.AppearanceInfo.Title or v54.AppearanceInfo.Name or ""
  374 | 		local v57 = false
  375 | 		for _18, v58 in pairs(p52.Data.Items) do
  376 | 			if buffer.readu16(v58, 0) == tonumber(p53) and require(shared.IDs[tonumber(p53)]).PurchaseInfo.OwnershipType ~= "Multiple" then
  377 | 				v57 = true
  378 | 			end
  379 | 		end
  380 | 		if (v54.EquipInfo or {}).SlotType == "Light" then
  381 | 			for _19, v59 in pairs(p52.Data.Items) do
  382 | 				if buffer.readu16(v59, 0) == tonumber(p53) then
  383 | 					v57 = true
  384 | 				end
  385 | 			end
  386 | 		else
  387 | 			for _20, v60 in pairs(p52.Data.Items) do
  388 | 				if buffer.readu16(v60, 0) == tonumber(p53) then
  389 | 					local v61
  390 | 					if buffer.len(v60) > 2 then
  391 | 						local v62 = buffer.len(v60) - 2
  392 | 						v61 = buffer.readu16(v60, v62)
  393 | 					else
  394 | 						v61 = 1
  395 | 					end
  396 | 					local _21 = "x" .. v61
  397 | 				end
  398 | 			end
  399 | 		end
  400 | 		p52.View.Center.ShopOption.Amount.Text = ""
  401 | 		local v63 = nil
  402 | 		for _22, v64 in pairs(p52.Event.Rewards[p52.CurrentPage].Items) do
  403 | 			if v64.Name == p52.IDs[tonumber(p53)].Name then
  404 | 				v63 = v64.Price
  405 | 			end
  406 | 		end
  407 | 		p52.View.Center.ShopOption.Buy.Cost.Text = v63 or "N/A"


========================================
MATCH #27
PATH: ReplicatedStorage.Objects.Menu.Menu.Views.Inventory
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 10510
========================================

--- SOURCE LINES 1-300 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
    4 | local _ = game:GetService("Players").LocalPlayer
    5 | local v_u_1 = require((script:WaitForChild("VisibilityTypes")))
    6 | script:WaitForChild("Views")
    7 | local LocalPlayer = game.Players.LocalPlayer
    8 | local v_u_2 = LocalPlayer:GetMouse()
    9 | local Services = ReplicatedStorage:WaitForChild("Services")
   10 | local Views = script:WaitForChild("Views")
   11 | local ClientItemService = require(Services.Items.ClientItemService)
   12 | local RigService = require(Services.Asset.RigService)
   13 | local Shared = ReplicatedStorage:WaitForChild("Shared")
   14 | local Utils = require(Shared.Utils)
   15 | local Assets = script:WaitForChild("Assets")
   16 | local ClientHooks = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("UserData"):WaitForChild("ClientHooks")
   17 | local v_u_3 = require((ClientHooks:WaitForChild("useInventory")))
   18 | local v_u_4 = require((ClientHooks:WaitForChild("useLoadout")))
   19 | local Objects = ReplicatedStorage.Objects
   20 | local Character = Objects.Game.Character
   21 | local CharacterVisuals = require(Objects.Game.ToolProfile.CharacterVisuals)
   22 | local EmoteService = require(Services.Items.EmoteService)
   23 | local Registry = require(ReplicatedStorage.Items.Registry)
   24 | local t = {}
   25 | t.__index = t
   26 | function t.new(p5, p6)
   27 | 	--[[ line: 34 | upvalues: (copy) t]]
   28 | 	local v7 = t
   29 | 	return setmetatable({
   30 | 		View = p5,
   31 | 		Parent = p6,
   32 | 		Views = {}
   33 | 	}, v7)
   34 | end
   35 | function t.Initialize(p8)
   36 | 	--[[ line: 44 | upvalues: (copy) Views]]
   37 | 	p8.Headers = require((script:WaitForChild("Headers"))).new(p8)
   38 | 	p8.Headers:Init()
   39 | 	for _2, v9 in Views:GetChildren() do
   40 | 		local v10 = require(v9).new(p8)
   41 | 		v10:Init()
   42 | 		p8.Views[v9.Name] = v10
   43 | 	end
   44 | end
   45 | function t.Activate(p11)
   46 | 	--[[ line: 54 | upvalues: (copy) v_u_1]]
   47 | 	p11.Active = true
   48 | 	p11.Headers:SetActive(p11.Headers:GetDefaultHeader(), true)
   49 | 	p11:SetHeader((p11.Headers:GetDefaultHeader()))
   50 | 	p11:SetVisible((v_u_1:GetDefault()))
   51 | end
   52 | function t.Deactivate(p12)
   53 | 	--[[ line: 61 | upvalues: none]]
   54 | 	if p12.Emote then
   55 | 		p12.Emote:Deactivate()
   56 | 		p12.Emote = nil
   57 | 	end
   58 | 	p12.Active = false
   59 | 	p12:SetVisualModel()
   60 | 	p12.CurrentCharacterInfo = nil
   61 | end
   62 | function t.SetVisible(p13, p14, p15, ...)
   63 | 	--[[ line: 71 | upvalues: (copy) v_u_1]]
   64 | 	if p14 == "Exit" then
   65 | 		p13.Parent:SetView(p15)
   66 | 	else
   67 | 		local v16 = v_u_1:SetVisible(p13.View, p14)
   68 | 		for v17, v18 in p13.Views do
   69 | 			if table.find(v16, v17) then
   70 | 				v18.Activated = true
   71 | 				if v18.Activate then
   72 | 					v18:Activate(p15, ...)
   73 | 				end
   74 | 			elseif v18.Activated then
   75 | 				v18.Activated = false
   76 | 				if v18.Deactivate then
   77 | 					v18:Deactivate()
   78 | 				end
   79 | 			end
   80 | 		end
   81 | 	end
   82 | end
   83 | function t.SetHeader(p19, p20)
   84 | 	--[[ line: 92 | upvalues: none]]
   85 | 	for _3, v21 in p19.Views do
   86 | 		if v21.SetHeader then
   87 | 			v21:SetHeader(p20)
   88 | 		end
   89 | 	end
   90 | end
   91 | function t.UpdateLoadout(p22)
   92 | 	--[[ line: 100 | upvalues: none]]
   93 | 	for _4, v23 in p22.Views do
   94 | 		if v23.Active and v23.UpdateLoadout then
   95 | 			v23:UpdateLoadout()
   96 | 		end
   97 | 	end
   98 | 	if p22.CurrentCharacterInfo then
   99 | 		p22:SetVisualCharacter(p22.CurrentCharacterInfo.Item)
  100 | 	end
  101 | end
  102 | function t.SetVisualModel(p24: {[any]: any}, p25: userdata?, p26: CFrame?)
  103 | 	--[[ line: 125 | upvalues: (copy) RigService, (copy) ClientItemService]]
  104 | 	local MenuView = workspace.MenuView
  105 | 	if MenuView:FindFirstChild("VisualModel") then
  106 | 		RigService:UnsetRig(MenuView.VisualModel)
  107 | 		MenuView.VisualModel:Destroy()
  108 | 	end
  109 | 	p24.VisualModel = nil
  110 | 	p24.VisualModelCFrame = nil
  111 | 	p24.LastX = nil
  112 | 	p24.VisualCharacter = nil
  113 | 	p24.CurrentCharacterInfo = nil
  114 | 	if p25 then
  115 | 		local v27, _5 = ClientItemService:GetVisualModel(p25, true)
  116 | 		p24.VisualModel = v27
  117 | 		v27.Name = "VisualModel"
  118 | 		v27.PrimaryPart.Anchored = true
  119 | 		local v28 = require(p25)
  120 | 		local Scale = v28.AppearanceInfo.Scale
  121 | 		if v28.AppearanceInfo.ViewInfo then
  122 | 			Scale = v28.AppearanceInfo.ViewInfo.Scale
  123 | 		end
  124 | 		p24.VisualModelCFrame = p26
  125 | 		if Scale then
  126 | 			v27:ScaleTo(Scale)
  127 | 		end
  128 | 		v27.PrimaryPart.CFrame = p24.VisualModelCFrame
  129 | 		p24.VisualModelPrimaryPart = v27.PrimaryPart
  130 | 		v27.Parent = MenuView
  131 | 		p24:SetCFrame(p24.VisualModelCFrame, true)
  132 | 	end
  133 | end
  134 | function getCosmeticsAndRig()
  135 | 	--[[ line: 161 | upvalues: (copy) LocalPlayer, (copy) v_u_4, (copy) Registry, (copy) v_u_3, (copy) ReplicatedStorage]]
  136 | 	local t2 = {}
  137 | 	local v29 = 0
  138 | 	local t3 = {}
  139 | 	local t4 = {}
  140 | 	local v30
  141 | 	if LocalPlayer:GetAttribute("RigType") == "R6" then
  142 | 		v30 = Enum.HumanoidRigType.R6
  143 | 	else
  144 | 		v30 = Enum.HumanoidRigType.R15
  145 | 	end
  146 | 	for v31, v32 in v_u_4.GetEquipped() do
  147 | 		if v31 == "CosmeticSlot_1" or (v31 == "CosmeticSlot_2" or (v31 == "UnusualSlot" or v31 == "CharacterSlot")) then
  148 | 			table.insert(t2, v32)
  149 | 		elseif v31 == "BoomboxSlot" then
  150 | 			v29 = v32
  151 | 		elseif v31 == "LightSlot" then
  152 | 			local v33 = Registry.GetById(v32)
  153 | 			if v33 and v33.Module:FindFirstChild("Headgear") then
  154 | 				local v34 = v_u_3.GetSkin(v32)
  155 | 				if v34 then
  156 | 					table.insert(t4, v34)
  157 | 				end
  158 | 				local Name = ReplicatedStorage.Objects.Game.Actions.ActionTypes:FindFirstChild(v33.Module.Name)
  159 | 				table.insert(t3, (Name:GetAttribute("ID")))
  160 | 			end
  161 | 		end
  162 | 	end
  163 | 	return t2, v30, t3, t4, v29
  164 | end
  165 | function isTablesSame(p35, p36)
  166 | 	--[[ line: 190 | upvalues: none]]
  167 | 	for _6, v37 in p35 do
  168 | 		if not table.find(p36, v37) then
  169 | 			return false
  170 | 		end
  171 | 	end
  172 | 	for _7, v38 in p36 do
  173 | 		if not table.find(p35, v38) then
  174 | 			return false
  175 | 		end
  176 | 	end
  177 | 	return true
  178 | end
  179 | function t.SetVisualCharacter(p39, p_u_40)
  180 | 	--[[ line: 204 | upvalues: (copy) RigService, (copy) Assets, (copy) LocalPlayer, (copy) Character, (copy) Registry, (copy) ReplicatedStorage, (copy) v_u_3, (copy) CharacterVisuals, (copy) EmoteService]]
  181 | 	if p39.Emote then
  182 | 		p39.Emote:Deactivate()
  183 | 		p39.Emote = nil
  184 | 	end
  185 | 	local v_u_41, v_u_42, v_u_43, v_u_44, v_u_45 = getCosmeticsAndRig()
  186 | 	if not p39.CurrentCharacterInfo or (p39.CurrentCharacterInfo.Item ~= p_u_40 or (p39.CurrentCharacterInfo.Rig ~= v_u_42 or (p39.CurrentCharacterInfo.Boombox ~= v_u_45 or not (isTablesSame(v_u_41, p39.CurrentCharacterInfo.Cosmetics) and isTablesSame(v_u_43, p39.CurrentCharacterInfo.Actions))))) then
  187 | 		local MenuView2 = workspace.MenuView
  188 | 		if MenuView2:FindFirstChild("VisualModel") then
  189 | 			RigService:UnsetRig(MenuView2.VisualModel)
  190 | 			MenuView2.VisualModel:Destroy()
  191 | 		end
  192 | 		p39.VisualModel = nil
  193 | 		p39.VisualModelCFrame = nil
  194 | 		p39.LastX = nil
  195 | 		local v46 = Assets.Character:Clone()
  196 | 		v46.Name = LocalPlayer.Name
  197 | 		local t5 = {}
  198 | 		p39.CurrentCharacterInfo = {
  199 | 			Item = p_u_40,
  200 | 			Cosmetics = v_u_41,
  201 | 			Rig = v_u_42,
  202 | 			Actions = v_u_43
  203 | 		}
  204 | 		function t5.Get(_8, p47)
  205 | 			--[[ line: 240 | upvalues: (copy) v_u_41, (copy) v_u_42, (copy) v_u_43, (copy) v_u_44, (copy) v_u_45]]
  206 | 			if p47 == "Cosmetics" then
  207 | 				return v_u_41
  208 | 			end
  209 | 			if p47 == "Rig" then
  210 | 				return v_u_42
  211 | 			end
  212 | 			if p47 == "Actions" then
  213 | 				return v_u_43
  214 | 			end
  215 | 			if p47 == "ToolSkins" then
  216 | 				return v_u_44
  217 | 			end
  218 | 			if p47 == "Boombox" then
  219 | 				return v_u_45
  220 | 			end
  221 | 		end
  222 | 		local t6 = { Model = v46, PlayerReference = LocalPlayer, DataRegistry = t5 }
  223 | 		local v48 = require(Character.Rig).new(t6)
  224 | 		v48:RegistryTermUpdated("Cosmetics")
  225 | 		v48:RegistryTermUpdated("Rig")
  226 | 		v48:RegistryTermUpdated("Actions")
  227 | 		v48:RegistryTermUpdated("ToolSkins")
  228 | 		v48:RegistryTermUpdated("Boombox")
  229 | 		for _9, v49 in v48:GetRigModel().Humanoid:GetPlayingAnimationTracks() do
  230 | 			v49:Stop(0)
  231 | 		end
  232 | 		if p_u_40 then
  233 | 			local v50 = Registry.GetById(p_u_40)
  234 | 			local Module = v50.Module
  235 | 			if table.find(v50.Categories, "Loadout") and ReplicatedStorage.Tools:FindFirstChild(Module.Name) then
  236 | 				local t7 = { Get = function(_10, p51)
  237 | 						--[[ line: 275 | upvalues: (ref) v_u_3, (copy) p_u_40]]
  238 | 						if p51 == "ToolSkins" then
  239 | 							local v52 = v_u_3.GetSkin(p_u_40)
  240 | 							return v52 and { v52 } or {}
  241 | 						end
  242 | 					end }
  243 | 				local v53 = CharacterVisuals.new({ Character = v46, DataRegistry = t7, Rig = v48:GetRig() })
  244 | 				v53:SetTool({ Module = ReplicatedStorage.Tools:FindFirstChild(Module.Name) })
  245 | 				v53:Task("Equip")
  246 | 			elseif table.find(v50.Categories, "Emotes") then
  247 | 				p39.Emote = EmoteService:SetEmote(v46, Module, false, nil, false, (v48:GetRigModel()))
  248 | 			end
  249 | 		end
  250 | 		local v54 = v48:GetRigModel()
  251 | 		if v54 then
  252 | 			if v54.Humanoid.RigType == Enum.HumanoidRigType.R15 then
  253 | 				v54.Humanoid:LoadAnimation(Character.Animations.Types.R15.Default.Animations.Idle.Idle):Play(0)
  254 | 			else
  255 | 				v54.Humanoid:LoadAnimation(Character.Animations.Types.Classic.Default.Animations.Idle.Idle):Play(0)
  256 | 			end
  257 | 		end
  258 | 		p39.VisualModel = v46
  259 | 		p39.VisualModelPrimaryPart = v46.PrimaryPart
  260 | 		v46.Name = "VisualModel"
  261 | 		v46.PrimaryPart.Anchored = true
  262 | 		p39.VisualModelCFrame = MenuView2.Parts.Inventory.CharacterPart.CFrame
  263 | 		v46.PrimaryPart.CFrame = p39.VisualModelCFrame
  264 | 		v46.Parent = MenuView2
  265 | 		p39:SetCFrame(p39.VisualModelCFrame, true)
  266 | 	end
  267 | end
  268 | function t.SetCFrame(p_u_55, p_u_56, p57)
  269 | 	--[[ line: 310 | upvalues: (copy) Utils]]
  270 | 	if p57 == false then
  271 | 		p_u_55.VisualModelCFrame = p_u_56
  272 | 		p_u_55.LastX = nil
  273 | 	else
  274 | 		p_u_55.VisualModelCFrame = nil
  275 | 		p_u_55.LastX = nil
  276 | 		p_u_55.VisualModelPrimaryPart.CFrame = CFrame.new(0, 0.25, 0) * p_u_56
  277 | 		Utils.Tween(p_u_55.VisualModelPrimaryPart, { CFrame = p_u_56 }, 0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, false)
  278 | 		for _11, v58 in pairs((p_u_55.VisualModel:GetDescendants())) do
  279 | 			if v58:IsA("BasePart") then
  280 | 				v58.LocalTransparencyModifier = 1
  281 | 				Utils.Tween(v58, { LocalTransparencyModifier = 0 }, 0.12, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, false)
  282 | 			end
  283 | 		end
  284 | 		local v_u_59 = tick()
  285 | 		p_u_55.lt = v_u_59
  286 | 		task.spawn(function()
  287 | 			--[[ line: 328 | upvalues: (copy) v_u_59, (copy) p_u_55, (copy) p_u_56]]
  288 | 			task.wait(0.12)
  289 | 			if v_u_59 == p_u_55.lt then
  290 | 				p_u_55.VisualModelCFrame = p_u_56
  291 | 			end
  292 | 		end)
  293 | 	end
  294 | end
  295 | function t.Update(p60, _12)
  296 | 	--[[ line: 338 | upvalues: (copy) v_u_2]]
  297 | 	if p60.LastX and (p60.VisualModel and p60.VisualModelCFrame) then
  298 | 		local VisualModelPrimaryPart = p60.VisualModelPrimaryPart
  299 | 		local p = CFrame.new(p60.VisualModelCFrame.p)
  300 | 		local Angles = CFrame.Angles


========================================
MATCH #28
PATH: ReplicatedStorage.Objects.Menu.Menu.Views.Inventory.Views.Slots
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 10047
========================================

--- SOURCE LINES 1-82 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
    4 | local Players = game:GetService("Players")
    5 | local Services = ReplicatedStorage:WaitForChild("Services")
    6 | local v_u_1 = require((Services:WaitForChild("Items"):WaitForChild("ClientItemService")))
    7 | ReplicatedStorage:WaitForChild("Items")
    8 | local Slot = script.Parent.Parent:WaitForChild("Assets"):WaitForChild("Slot")
    9 | local UserOwnsPackage = require(ReplicatedStorage.Shared.Marketplace.UserOwnsPackage)
   10 | require((script.Parent.Parent.Parent.Parent:WaitForChild("SlotBuilder")))
   11 | local ClientHooks = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("UserData"):WaitForChild("ClientHooks")
   12 | local v_u_2 = require((ClientHooks:WaitForChild("useInventory")))
   13 | local v_u_3 = require((ClientHooks:WaitForChild("useLoadout")))
   14 | local InputService = require(ReplicatedStorage.Services.Client.InputService)
   15 | game:GetService("MarketplaceService")
   16 | local t = {
   17 | 	Loadout = {
   18 | 		Left = {
   19 | 			SlotType = "ThreeSpread",
   20 | 			Slots = {
   21 | 				{
   22 | 					Index = 1,
   23 | 					SlotType = "LIGHT SLOT",
   24 | 					Type = "LightSlot",
   25 | 					EquipType = "Light",
   26 | 					StrokeColor = Color3.fromRGB(211, 179, 98)
   27 | 				},
   28 | 				{
   29 | 					Index = 2,
   30 | 					SlotType = "UTILITY SLOT",
   31 | 					Type = "UtilitySlot",
   32 | 					EquipType = "Utility",
   33 | 					StrokeColor = Color3.fromRGB(115, 133, 213)
   34 | 				},
   35 | 				{
   36 | 					Index = 3,
   37 | 					SlotType = "POWER SLOT",
   38 | 					Type = "PowerSlot",
   39 | 					EquipType = "Power",
   40 | 					StrokeColor = Color3.fromRGB(213, 101, 101)
   41 | 				}
   42 | 			}
   43 | 		},
   44 | 		Right = {
   45 | 			SlotType = "Four",
   46 | 			Slots = {
   47 | 				{
   48 | 					Index = 4,
   49 | 					SlotType = "USABLE SLOT",
   50 | 					Type = "ConsumableSlot_1",
   51 | 					EquipType = "Consumable"
   52 | 				},
   53 | 				{
   54 | 					Index = 5,
   55 | 					SlotType = "USABLE SLOT",
   56 | 					Type = "ConsumableSlot_2",
   57 | 					EquipType = "Consumable"
   58 | 				},
   59 | 				{
   60 | 					Index = 6,
   61 | 					SlotType = "USABLE SLOT",
   62 | 					Type = "ConsumableSlot_3",
   63 | 					EquipType = "Consumable"
   64 | 				},
   65 | 				{
   66 | 					Index = 7,
   67 | 					SlotType = "USABLE SLOT",
   68 | 					Type = "ConsumableSlot_4",
   69 | 					EquipType = "Consumable"
   70 | 				}
   71 | 			}
   72 | 		}
   73 | 	},
   74 | 	Character = {
   75 | 		Left = {
   76 | 			SlotType = "ThreeSpread",
   77 | 			Slots = {
   78 | 				{
   79 | 					Index = 1,
   80 | 					SlotType = "PERK SLOT",
   81 | 					Type = "PerkSlot_1",
   82 | 					EquipType = "Perk"

--- SOURCE LINES 94-206 ---
   94 | 			Slots = {
   95 | 				{
   96 | 					Index = 3,
   97 | 					SlotType = "CARRY SLOT",
   98 | 					Type = "CarryAnimationSlot",
   99 | 					EquipType = "CarryAnimation"
  100 | 				},
  101 | 				{
  102 | 					Index = 4,
  103 | 					SlotType = "NAMETAG SLOT",
  104 | 					Type = "NametagSlot",
  105 | 					EquipType = "Nametag"
  106 | 				}
  107 | 			}
  108 | 		}
  109 | 	},
  110 | 	Cosmetics = {
  111 | 		Left = {
  112 | 			SlotType = "ThreeSpread",
  113 | 			Slots = {
  114 | 				{
  115 | 					Index = 1,
  116 | 					SlotType = "COSMETIC SLOT",
  117 | 					Type = "CosmeticSlot_1",
  118 | 					EquipType = "Cosmetic"
  119 | 				},
  120 | 				{
  121 | 					Index = 2,
  122 | 					SlotType = "COSMETIC SLOT",
  123 | 					Type = "CosmeticSlot_2",
  124 | 					EquipType = "Cosmetic"
  125 | 				}
  126 | 			}
  127 | 		},
  128 | 		Right = {
  129 | 			SlotType = "ThreeSpread",
  130 | 			Slots = {
  131 | 				{
  132 | 					Index = 3,
  133 | 					SlotType = "CHARACTER SLOT",
  134 | 					Type = "CharacterSlot",
  135 | 					EquipType = "Character"
  136 | 				},
  137 | 				{
  138 | 					Index = 4,
  139 | 					SlotType = "UNUSUAL SLOT",
  140 | 					Type = "UnusualSlot",
  141 | 					EquipType = "Unusual"
  142 | 				},
  143 | 				{
  144 | 					Index = 5,
  145 | 					SlotType = "BOOMBOX SLOT",
  146 | 					Type = "BoomboxSlot",
  147 | 					Unique = true,
  148 | 					EquipType = "Boombox"
  149 | 				}
  150 | 			}
  151 | 		}
  152 | 	},
  153 | 	Emotes = {
  154 | 		Left = {
  155 | 			SlotType = "ThreeSpread",
  156 | 			Slots = {
  157 | 				{
  158 | 					Index = 1,
  159 | 					SlotType = "EMOTE SLOT",
  160 | 					Type = "EmoteSlot_1",
  161 | 					EquipType = "Emote"
  162 | 				},
  163 | 				{
  164 | 					Index = 2,
  165 | 					SlotType = "EMOTE SLOT",
  166 | 					Type = "EmoteSlot_2",
  167 | 					EquipType = "Emote"
  168 | 				},
  169 | 				{
  170 | 					Index = 3,
  171 | 					SlotType = "EMOTE SLOT",
  172 | 					Type = "EmoteSlot_3",
  173 | 					EquipType = "Emote"
  174 | 				}
  175 | 			}
  176 | 		},
  177 | 		Right = {
  178 | 			SlotType = "ThreeSpread",
  179 | 			Slots = {
  180 | 				{
  181 | 					Index = 4,
  182 | 					SlotType = "EMOTE SLOT",
  183 | 					Type = "EmoteSlot_4",
  184 | 					EquipType = "Emote"
  185 | 				},
  186 | 				{
  187 | 					Index = 5,
  188 | 					SlotType = "EMOTE SLOT",
  189 | 					Type = "EmoteSlot_5",
  190 | 					EquipType = "Emote"
  191 | 				},
  192 | 				{
  193 | 					Index = 6,
  194 | 					SlotType = "EMOTE SLOT",
  195 | 					Type = "EmoteSlot_6",
  196 | 					EquipType = "Emote"
  197 | 				}
  198 | 			}
  199 | 		}
  200 | 	},
  201 | 	MoreEmotes = {
  202 | 		Left = {
  203 | 			SlotType = "Six",
  204 | 			Slots = {
  205 | 				{
  206 | 					Index = 1,

--- SOURCE LINES 358-432 ---
  358 | 	p14.Button.AmtLeft.Visible = false
  359 | 	p14.Button.ItemName.Visible = false
  360 | end
  361 | local t4 = {}
  362 | t4.__index = t4
  363 | t4.VisibilityType = "Slots"
  364 | function t4.new(p19)
  365 | 	--[[ line: 388 | upvalues: (copy) t4]]
  366 | 	return setmetatable({ View = p19.View, Parent = p19 }, t4)
  367 | end
  368 | function t4.Init(p_u_20)
  369 | 	--[[ line: 397 | upvalues: (copy) UserOwnsPackage, (copy) Players]]
  370 | 	task.spawn(function()
  371 | 		--[[ line: 398 | upvalues: (copy) p_u_20, (ref) UserOwnsPackage, (ref) Players]]
  372 | 		p_u_20.MoreEmotes = UserOwnsPackage.Owns(Players.LocalPlayer, "MoreEmotes")
  373 | 	end)
  374 | 	task.spawn(function()
  375 | 		--[[ line: 401 | upvalues: (copy) p_u_20, (ref) UserOwnsPackage, (ref) Players]]
  376 | 		local function v21()
  377 | 			--[[ line: 403 | upvalues: (ref) p_u_20, (ref) UserOwnsPackage, (ref) Players]]
  378 | 			p_u_20.OwnsRelics = UserOwnsPackage.Owns(Players.LocalPlayer, "Boombox")
  379 | 		end
  380 | 		local _3, v22 = pcall(v21)
  381 | 		if v22 then
  382 | 			warn(v22)
  383 | 		end
  384 | 	end)
  385 | end
  386 | function t4.Activate(p23, p24, _4)
  387 | 	--[[ line: 412 | upvalues: (copy) InputService]]
  388 | 	p23.Active = true
  389 | 	InputService:ControllerSelect(p23.View.CharacterView.Slots)
  390 | 	p23.Parent:SetVisualCharacter(p24)
  391 | end
  392 | function t4.Deactivate(p25)
  393 | 	--[[ line: 418 | upvalues: none]]
  394 | 	p25.Active = false
  395 | end
  396 | function t4.SetHeader(p_u_26, p27)
  397 | 	--[[ line: 422 | upvalues: (copy) t, (copy) ClearInstances, (copy) createSlots, (copy) InputService]]
  398 | 	if t[p27] then
  399 | 		if p_u_26.Slots then
  400 | 			ClearInstances(p_u_26.Slots)
  401 | 		end
  402 | 		p_u_26.Slots = createSlots(p27, p_u_26)
  403 | 		p_u_26:UpdateLoadout()
  404 | 		local Slots = p_u_26.Slots
  405 | 		local View = p_u_26.View
  406 | 		for _5, v28 in Slots do
  407 | 			v28.Instance.Parent = View.CharacterView.Slots[v28.Direction][v28.SlotType]
  408 | 		end
  409 | 		for _6, v_u_29 in p_u_26.Slots do
  410 | 			v_u_29.Button.Activated:Connect(function()
  411 | 				--[[ line: 433 | upvalues: (copy) p_u_26, (copy) v_u_29]]
  412 | 				p_u_26.Parent:SetVisible("Select", v_u_29.EquipType, "Slots", nil, v_u_29.Type)
  413 | 			end)
  414 | 		end
  415 | 		InputService:ControllerSelect(p_u_26.View.CharacterView.Slots)
  416 | 	end
  417 | end
  418 | function t4.UpdateLoadout(p30)
  419 | 	--[[ line: 440 | upvalues: (copy) v_u_3, (copy) setSlot]]
  420 | 	local v31 = v_u_3.GetEquipped()
  421 | 	for _7, v32 in p30.Slots do
  422 | 		local v33 = nil
  423 | 		for v34, v35 in v31 do
  424 | 			if v34 == v32.Type then
  425 | 				v33 = v35
  426 | 				break
  427 | 			end
  428 | 		end
  429 | 		setSlot(v32, v33)
  430 | 	end
  431 | end
  432 | return t4


========================================
MATCH #29
PATH: ReplicatedStorage.Objects.Menu.Menu.Views.Inventory.Views.Select
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 4534
========================================

--- SOURCE LINES 1-130 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
    4 | local Services = ReplicatedStorage:WaitForChild("Services")
    5 | local v_u_1 = require((Services:WaitForChild("Items"):WaitForChild("ClientItemService")))
    6 | local Items = ReplicatedStorage:WaitForChild("Items")
    7 | script.Parent.Parent:WaitForChild("Assets"):WaitForChild("Slot")
    8 | local v_u_2 = require((script.Parent.Parent.Parent.Parent:WaitForChild("SlotBuilder")))
    9 | local Registry = require(Items.Registry)
   10 | local ClientHooks = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("UserData"):WaitForChild("ClientHooks")
   11 | local v_u_3 = require((ClientHooks:WaitForChild("useInventory")))
   12 | require((ClientHooks:WaitForChild("useCurrency")))
   13 | local v_u_4 = require((ClientHooks:WaitForChild("useLoadout")))
   14 | local InputService = require(ReplicatedStorage.Services.Client.InputService)
   15 | local function ClearInstances(p5)
   16 | 	--[[ line: 22 | upvalues: none]]
   17 | 	for _, v6 in p5 do
   18 | 		if typeof(v6) == "table" then
   19 | 			v6.Instance:Destroy()
   20 | 		else
   21 | 			v6:Destroy()
   22 | 		end
   23 | 	end
   24 | end
   25 | local t = {}
   26 | t.__index = t
   27 | t.VisibilityType = "Slots"
   28 | function t.new(p7)
   29 | 	--[[ line: 41 | upvalues: (copy) t]]
   30 | 	return setmetatable({ View = p7.View, Parent = p7 }, t)
   31 | end
   32 | function t.Init(p_u_8)
   33 | 	--[[ line: 50 | upvalues: (copy) v_u_2]]
   34 | 	local Select = p_u_8.View.Select
   35 | 	Select.Bottom.Exit.Activated:Connect(function()
   36 | 		--[[ line: 52 | upvalues: (copy) p_u_8]]
   37 | 		p_u_8.Parent:SetVisible(not p_u_8.TopCurrent and "Slots" or p_u_8.TopCurrent)
   38 | 	end)
   39 | 	Select.Center.Frame.Frame.Search.TextBox.FocusLost:Connect(function()
   40 | 		--[[ line: 55 | upvalues: (ref) v_u_2, (copy) Select, (copy) p_u_8]]
   41 | 		v_u_2:FilterSlots(Select.Center.Frame.Frame.Search.TextBox.Text, p_u_8.Assets, p_u_8.Slots)
   42 | 	end)
   43 | end
   44 | function t.KeyUsed(p9, p10)
   45 | 	--[[ line: 60 | upvalues: none]]
   46 | 	local Select2 = p9.View.Select
   47 | 	if p10.Key == "ControllerClose" and Select2.Visible then
   48 | 		p9.Parent:SetVisible(not p9.TopCurrent and "Slots" or p9.TopCurrent)
   49 | 	end
   50 | end
   51 | function t.Activate(p_u_11, p12, p13, p_u_14, p_u_15)
   52 | 	--[[ line: 67 | upvalues: (copy) InputService, (copy) v_u_3, (copy) v_u_1, (copy) v_u_4, (copy) Registry, (copy) ClearInstances, (copy) v_u_2]]
   53 | 	p_u_11.Parent:SetVisualModel()
   54 | 	local Select3 = p_u_11.View.Select
   55 | 	InputService:ControllerSelect(Select3)
   56 | 	Select3.Center.Frame.Frame.Search.TextBox.Text = ""
   57 | 	if InputService:GetInteractType() == "Controller" then
   58 | 		Select3.Bottom.Exit.TextLabel.Text = "Exit [B]"
   59 | 	else
   60 | 		Select3.Bottom.Exit.TextLabel.Text = "Exit"
   61 | 	end
   62 | 	p_u_11.TopCurrent = p13
   63 | 	local t2 = {}
   64 | 	if p_u_14 then
   65 | 		for _2, v16 in v_u_3.OwnedIds() do
   66 | 			local v17 = v_u_1:GetItemFromID(v16)
   67 | 			if v17:FindFirstChild("Original") and v17.Original.Value:GetAttribute("ID") == p_u_14 then
   68 | 				table.insert(t2, v17)
   69 | 			end
   70 | 		end
   71 | 	else
   72 | 		local BoomboxSlot = v_u_4.GetEquippedFromSlot("BoomboxSlot")
   73 | 		if BoomboxSlot == 0 then
   74 | 			BoomboxSlot = nil
   75 | 		end
   76 | 		for _3, v18 in v_u_3.GetOwnedBySlotType(p12) do
   77 | 			if not v_u_4.IsEquipped(v18) then
   78 | 				local Module = Registry.GetById(v18).Module
   79 | 				if not require(Module).RequiresBoombox or BoomboxSlot then
   80 | 					table.insert(t2, Module)
   81 | 				end
   82 | 			end
   83 | 		end
   84 | 	end
   85 | 	if p_u_11.Assets then
   86 | 		ClearInstances(p_u_11.Assets)
   87 | 		p_u_11.Assets = nil
   88 | 	end
   89 | 	local v19, v20 = v_u_2:SetupSlots(Select3.Center.Frame.List.ScrollingFrame, t2, true, true)
   90 | 	p_u_11.Assets = v19
   91 | 	p_u_11.Slots = v20
   92 | 	for _4, v_u_21 in v20 do
   93 | 		v_u_21.Button.MouseEnter:Connect(function()
   94 | 			--[[ line: 116 | upvalues: (ref) v_u_2, (copy) v_u_21]]
   95 | 			v_u_2:SetSlotColor(v_u_21, Color3.new(1, 1, 1))
   96 | 			script.Hover:Play()
   97 | 		end)
   98 | 		v_u_21.Button.Activated:Connect(function()
   99 | 			--[[ line: 120 | upvalues: (ref) v_u_2, (copy) v_u_21, (copy) p_u_11, (ref) v_u_4, (copy) p_u_15, (copy) p_u_14, (ref) v_u_3]]
  100 | 			script.Click:Play()
  101 | 			v_u_2:SetSlotColor(v_u_21, v_u_21.Color)
  102 | 			local v22 = not p_u_11.TopCurrent and "Slots" or p_u_11.TopCurrent
  103 | 			local v23
  104 | 			if v22 == "Slots" or v22 == "ModifyItems" then
  105 | 				v23 = v_u_21.ID
  106 | 			else
  107 | 				v23 = nil
  108 | 			end
  109 | 			if v22 == "Slots" then
  110 | 				v_u_4.TryEquip(p_u_15, v23)
  111 | 			elseif v22 == "ModifyItems" and p_u_14 then
  112 | 				v_u_3.TrySetSkin(p_u_14, v23)
  113 | 			end
  114 | 			p_u_11.Parent:SetVisible(v22, v23)
  115 | 		end)
  116 | 		v_u_21.Button.MouseLeave:Connect(function()
  117 | 			--[[ line: 132 | upvalues: (ref) v_u_2, (copy) v_u_21]]
  118 | 			script.Hover:Play()
  119 | 			v_u_2:SetSlotColor(v_u_21, v_u_21.Color)
  120 | 		end)
  121 | 	end
  122 | end
  123 | function t.Deactivate(p24)
  124 | 	--[[ line: 139 | upvalues: (copy) ClearInstances]]
  125 | 	if p24.Assets then
  126 | 		ClearInstances(p24.Assets)
  127 | 		p24.Assets = nil
  128 | 	end
  129 | end
  130 | return t


========================================
MATCH #30
PATH: ReplicatedStorage.Objects.Menu.Menu.Views.Inventory.Views.ModifyItems
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 5784
========================================

--- SOURCE LINES 1-150 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
    4 | local Services = ReplicatedStorage:WaitForChild("Services")
    5 | local v_u_1 = require((Services:WaitForChild("Items"):WaitForChild("ClientItemService")))
    6 | local v_u_2 = require((ReplicatedStorage:WaitForChild("Items"):WaitForChild("Registry")))
    7 | ReplicatedStorage:WaitForChild("Items")
    8 | script.Parent.Parent:WaitForChild("Assets")
    9 | local v_u_3 = require((script.Parent.Parent.Parent.Parent:WaitForChild("SlotBuilder")))
   10 | local ClientHooks = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("UserData"):WaitForChild("ClientHooks")
   11 | local v_u_4 = require((ClientHooks:WaitForChild("useInventory")))
   12 | require((ClientHooks:WaitForChild("useLoadout")))
   13 | local v_u_5 = require((script:WaitForChild("WorldPos")))
   14 | local InputService = require(ReplicatedStorage.Services.Client.InputService)
   15 | local function ClearInstances(p6)
   16 | 	--[[ line: 21 | upvalues: none]]
   17 | 	for _, v7 in p6 do
   18 | 		if typeof(v7) == "table" then
   19 | 			v7.Instance:Destroy()
   20 | 		else
   21 | 			v7:Destroy()
   22 | 		end
   23 | 	end
   24 | end
   25 | local function setSelection(p8, p9, p10)
   26 | 	--[[ line: 43 | upvalues: (copy) v_u_5, (copy) v_u_2, (copy) v_u_4, (copy) v_u_1]]
   27 | 	local ModifyItems = p9.CharacterView.ModifyItems
   28 | 	local _2 = ModifyItems.Left.InsetAccounted.Frame.Frame.Frame.ScrollingFrame.Frame
   29 | 	local Select = ModifyItems.Right.InsetAccounted.Select
   30 | 	if p10 then
   31 | 		p8.SelectedID = p10:GetAttribute("ID")
   32 | 		Select.Visible = true
   33 | 		local v11 = require(p10)
   34 | 		Select.TextLabel.Text = string.upper(v11.AppearanceInfo.Name)
   35 | 		Select.Desc.Text = v11.AppearanceInfo.Desc
   36 | 		local Desc = Select.Desc
   37 | 		local v12 = Select.Desc.AbsoluteSize.Y / 6 + 0.5
   38 | 		Desc.TextSize = math.floor(v12)
   39 | 		local v13 = v_u_5(game.Players.LocalPlayer.PlayerGui.Menu, p8.View.CharacterView.ModifyItems.Right.InsetAccounted, 9) * CFrame.new(0, -0.4, 0)
   40 | 		local Position = CFrame.new(v13.Position)
   41 | 		local v14 = v_u_2.GetById((p10:GetAttribute("ID")))
   42 | 		if (table.find(v14.Categories, "Cosmetics") and p10:FindFirstChild("Original") or table.find(v14.Categories, "Loadout")) and (p10:FindFirstChild("Headgear") == nil and p10:FindFirstChild("Client") == nil) then
   43 | 			local p = CFrame.new(Position.p)
   44 | 			local v15 = require
   45 | 			local v16
   46 | 			if p10:FindFirstChild("Original") then
   47 | 				v16 = p10.Original.Value
   48 | 			else
   49 | 				v16 = p10
   50 | 			end
   51 | 			Position = p * (((v15(v16).AppearanceInfo or {}).ViewInfo or {}).CFrameOffset or CFrame.new())
   52 | 		end
   53 | 		local v17 = CFrame.new(Position.p) * CFrame.Angles(0, -1.5707963267948966, 0) * (Position - Position.p)
   54 | 		local v18 = v_u_4.GetSkin((p10:GetAttribute("ID")))
   55 | 		if v18 and v18 ~= 0 then
   56 | 			p8.Parent:SetVisualModel(v_u_1:GetItemFromID(v18), v17)
   57 | 		else
   58 | 			p8.Parent:SetVisualModel(p10, v17)
   59 | 		end
   60 | 	else
   61 | 		p8.SelectedID = nil
   62 | 		Select.Visible = false
   63 | 		p8.Parent:SetVisualModel()
   64 | 		return
   65 | 	end
   66 | end
   67 | local t = {}
   68 | t.__index = t
   69 | t.VisibilityType = "ModifyItems"
   70 | function t.new(p19)
   71 | 	--[[ line: 81 | upvalues: (copy) t]]
   72 | 	return setmetatable({ View = p19.View, Parent = p19 }, t)
   73 | end
   74 | function t.Init(p_u_20)
   75 | 	--[[ line: 90 | upvalues: none]]
   76 | 	p_u_20.View.CharacterView.ModifyItems.Right.InsetAccounted.Select.Skins.Activated:Connect(function()
   77 | 		--[[ line: 92 | upvalues: (copy) p_u_20]]
   78 | 		p_u_20.Parent:SetVisible("Select", nil, "ModifyItems", p_u_20.SelectedID)
   79 | 	end)
   80 | end
   81 | function t.Activate(p_u_21, _3, _4)
   82 | 	--[[ line: 97 | upvalues: (copy) InputService, (copy) v_u_4, (copy) v_u_2, (copy) ClearInstances, (copy) v_u_3, (copy) v_u_1, (copy) setSelection]]
   83 | 	local Frame = p_u_21.View.CharacterView.ModifyItems.Left.InsetAccounted.Frame.Frame.Frame.ScrollingFrame.Frame
   84 | 	InputService:ControllerSelect(Frame)
   85 | 	local ModifyItems2 = p_u_21.View.CharacterView.ModifyItems
   86 | 	local _5 = ModifyItems2.Left.InsetAccounted.Frame.Frame.Frame.ScrollingFrame.Frame
   87 | 	local Select2 = ModifyItems2.Right.InsetAccounted.Select
   88 | 	p_u_21.SelectedID = nil
   89 | 	Select2.Visible = false
   90 | 	p_u_21.Parent:SetVisualModel()
   91 | 	local t2 = {}
   92 | 	for _6, v22 in v_u_4.OwnedIds() do
   93 | 		local v23 = v_u_2.GetById(v22)
   94 | 		if v23 and table.find(v23.Categories, "Loadout") then
   95 | 			local Module = v23.Module
   96 | 			table.insert(t2, Module)
   97 | 		end
   98 | 	end
   99 | 	for v24, _7 in v_u_4.Consumables() do
  100 | 		local v25 = v_u_2.GetById(v24)
  101 | 		if v25 and table.find(v25.Categories, "Loadout") then
  102 | 			local Module2 = v25.Module
  103 | 			table.insert(t2, Module2)
  104 | 		end
  105 | 	end
  106 | 	if p_u_21.Assets then
  107 | 		ClearInstances(p_u_21.Assets)
  108 | 	end
  109 | 	local v26, v27 = v_u_3:SetupSlots(Frame, t2, true)
  110 | 	p_u_21.Assets = v26
  111 | 	for _8, v_u_28 in v27 do
  112 | 		local function entered()
  113 | 			--[[ line: 121 | upvalues: (ref) v_u_3, (copy) v_u_28, (ref) v_u_1, (ref) setSelection, (copy) p_u_21]]
  114 | 			v_u_3:SetSlotColor(v_u_28, Color3.new(1, 1, 1))
  115 | 			script.Hover:Play()
  116 | 			local ID = v_u_1:GetItemFromID(v_u_28.ID)
  117 | 			if ID then
  118 | 				setSelection(p_u_21, p_u_21.View, ID)
  119 | 			end
  120 | 		end
  121 | 		v_u_28.Button.MouseEnter:Connect(function()
  122 | 			--[[ line: 130 | upvalues: (copy) entered]]
  123 | 			entered()
  124 | 		end)
  125 | 		v_u_28.Button.SelectionGained:Connect(function()
  126 | 			--[[ line: 133 | upvalues: (copy) entered]]
  127 | 			entered()
  128 | 		end)
  129 | 		v_u_28.Button.Activated:Connect(function()
  130 | 			--[[ line: 137 | upvalues: (ref) v_u_3, (copy) v_u_28, (copy) p_u_21]]
  131 | 			script.Click:Play()
  132 | 			v_u_3:SetSlotColor(v_u_28, Color3.fromRGB(255, 241, 171))
  133 | 			p_u_21.Parent:SetVisible("Select", nil, "ModifyItems", v_u_28.ID)
  134 | 		end)
  135 | 		v_u_28.Button.MouseLeave:Connect(function()
  136 | 			--[[ line: 142 | upvalues: (ref) v_u_3, (copy) v_u_28]]
  137 | 			script.Hover:Play()
  138 | 			v_u_3:SetSlotColor(v_u_28, Color3.fromRGB(255, 241, 171))
  139 | 		end)
  140 | 		v_u_28.Button.SelectionLost:Connect(function()
  141 | 			--[[ line: 146 | upvalues: (ref) v_u_3, (copy) v_u_28]]
  142 | 			script.Hover:Play()
  143 | 			v_u_3:SetSlotColor(v_u_28, Color3.fromRGB(255, 241, 171))
  144 | 		end)
  145 | 	end
  146 | end
  147 | function t.Deactivate(_9)
  148 | 	--[[ line: 154 | upvalues: none]]
  149 | end
  150 | return t


========================================
MATCH #31
PATH: ReplicatedStorage.Shared.UserData.ClientHooks
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 731
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local t = {
    4 | 	useBooster = require(script.useBooster),
    5 | 	useCodes = require(script.useCodes),
    6 | 	useCounters = require(script.useCounters),
    7 | 	useCurrency = require(script.useCurrency),
    8 | 	useDailyLogin = require(script.useDailyLogin),
    9 | 	useDailyShop = require(script.useDailyShop),
   10 | 	useEvent = require(script.useEvent),
   11 | 	useEventShop = require(script.useEventShop),
   12 | 	useInventory = require(script.useInventory),
   13 | 	useLoadout = require(script.useLoadout),
   14 | 	useMissions = require(script.useMissions),
   15 | 	useMultipliers = require(script.useMultipliers),
   16 | 	usePlayWave = require(script.usePlayWave),
   17 | 	useProgression = require(script.useProgression),
   18 | 	useSettings = require(script.useSettings)
   19 | }
   20 | return table.freeze(t)


========================================
MATCH #32
PATH: ReplicatedStorage.Shared.UserData.ClientHooks.useLoadout
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 2181
========================================

--- SOURCE LINES 1-78 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
    4 | local Players = game:GetService("Players")
    5 | local Signal = require(ReplicatedStorage.Shared.Generics.Signal)
    6 | local Config = require(ReplicatedStorage.Shared.UserData.Loadout.Config)
    7 | local Remotes = require(ReplicatedStorage.Shared.UserData.Events.Remotes)
    8 | local UserOwnsPackage = require(ReplicatedStorage.Shared.Marketplace.UserOwnsPackage)
    9 | local Loadout = Remotes.Channels.Loadout
   10 | local Equip = Remotes.Requests.Equip
   11 | local t = { Changed = Signal.new() }
   12 | local t2 = {}
   13 | function t.GetSlotTypeForSlot(p1: string)
   14 | 	--[[ line: 65 | upvalues: (copy) Config]]
   15 | 	return Config.Slots[p1]
   16 | end
   17 | function t.GetSlots()
   18 | 	--[[ line: 75 | upvalues: (copy) Config]]
   19 | 	return Config.Slots
   20 | end
   21 | function t.IsSlotAvailable(p2: string)
   22 | 	--[[ line: 89 | upvalues: (copy) Config, (copy) UserOwnsPackage, (copy) Players]]
   23 | 	if Config.Slots[p2] == nil then
   24 | 		return false
   25 | 	end
   26 | 	return UserOwnsPackage.IsSlotUnlocked(Players.LocalPlayer, p2)
   27 | end
   28 | function t.GetEquippedFromSlot(p3: string)
   29 | 	--[[ line: 107 | upvalues: (ref) t2]]
   30 | 	return t2[p3] or 0
   31 | end
   32 | function t.IsEquipped(p4: number)
   33 | 	--[[ line: 119 | upvalues: (ref) t2]]
   34 | 	for v5, v6 in t2 do
   35 | 		if v6 == p4 then
   36 | 			return true, v5
   37 | 		end
   38 | 	end
   39 | 	return false, nil
   40 | end
   41 | function t.GetEquipped()
   42 | 	--[[ line: 134 | upvalues: (ref) t2]]
   43 | 	return table.freeze(table.clone(t2))
   44 | end
   45 | function t.Observe(p7: (...any) -> ...any)
   46 | 	--[[ line: 145 | upvalues: (copy) t]]
   47 | 	p7()
   48 | 	local v_u_8 = t.Changed:Connect(p7)
   49 | 	return function()
   50 | 		--[[ line: 148 | upvalues: (copy) v_u_8]]
   51 | 		v_u_8:Disconnect()
   52 | 	end
   53 | end
   54 | function t.TryEquip(p9: string, p10: number)
   55 | 	--[[ line: 165 | upvalues: (copy) Equip]]
   56 | 	Equip:FireServer(p9, p10)
   57 | end
   58 | function t.TryUnequip(p11: string)
   59 | 	--[[ line: 175 | upvalues: (copy) Equip]]
   60 | 	Equip:FireServer(p11, nil)
   61 | end
   62 | Loadout.OnClientEvent:Connect(function(p12: string, p13)
   63 | 	--[[ line: 201 | upvalues: (ref) t2, (copy) t]]
   64 | 	if p12 == "sync" then
   65 | 		t2 = p13 or {}
   66 | 		t.Changed:Fire()
   67 | 	elseif p12 == "patch" then
   68 | 		for v14, v15 in p13 do
   69 | 			if v15 == 0 then
   70 | 				t2[v14] = nil
   71 | 			else
   72 | 				t2[v14] = v15
   73 | 			end
   74 | 		end
   75 | 		t.Changed:Fire()
   76 | 	end
   77 | end)
   78 | return table.freeze(t)


========================================
MATCH #33
PATH: ReplicatedStorage.Shared.UserData.Loadout.Config
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 677
========================================

--- SOURCE LINES 1-24 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | local t = {
    4 | 	CosmeticSlot_1 = "Cosmetic",
    5 | 	CosmeticSlot_2 = "Cosmetic",
    6 | 	CharacterSlot = "Character",
    7 | 	UnusualSlot = "Unusual",
    8 | 	NametagSlot = "Nametag",
    9 | 	BoomboxSlot = "Boombox",
   10 | 	CarryAnimationSlot = "CarryAnimation",
   11 | 	PerkSlot_1 = "Perk",
   12 | 	PerkSlot_2 = "Perk",
   13 | 	LightSlot = "Light",
   14 | 	UtilitySlot = "Utility",
   15 | 	PowerSlot = "Power"
   16 | }
   17 | for v1 = 1, 12 do
   18 | 	t[("EmoteSlot_%*"):format(v1)] = "Emote"
   19 | end
   20 | t[("ConsumableSlot_%*"):format(1)] = "Consumable"
   21 | t[("ConsumableSlot_%*"):format(2)] = "Consumable"
   22 | t[("ConsumableSlot_%*"):format(3)] = "Consumable"
   23 | t[("ConsumableSlot_%*"):format(4)] = "Consumable"
   24 | return table.freeze({ Slots = table.freeze(t) })


========================================
MATCH #34
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.WarpAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 826
========================================

--- SOURCE LINES 1-29 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Warp Aura",
    7 | 		Desc = "A glimpse of wind magic before the Fire Nation attacked. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "Auras",
   16 | 		Currency = "ROBUX",
   17 | 		Gamepass = 1859476669,
   18 | 		AssetId = 1039841764,
   19 | 		OwnershipType = "Single",
   20 | 		AssetOwnershipInfo = {
   21 | 			{ Priority = 1, AssetId = 1039841764, InfoType = Enum.InfoType.GamePass },
   22 | 			{ Priority = 2, AssetId = 1859476669, InfoType = Enum.InfoType.GamePass }
   23 | 		},
   24 | 		InfoType = Enum.InfoType.GamePass
   25 | 	},
   26 | 	EquipInfo = { SlotType = "Unusual" },
   27 | 	CosmeticInfo = { Unusual = true },
   28 | 	Features = { RELICS = true }
   29 | }


========================================
MATCH #35
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.TopazAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 774
========================================

--- SOURCE LINES 1-27 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Topaz Aura",
    7 | 		Desc = "A powerful discharge of electricity, capable of powering a city. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "Auras",
   16 | 		Currency = "ROBUX",
   17 | 		Gamepass = 1860058612,
   18 | 		OwnershipType = "Single",
   19 | 		AssetOwnershipInfo = {
   20 | 			{ Priority = 1, AssetId = 1040137292, InfoType = Enum.InfoType.GamePass },
   21 | 			{ Priority = 2, AssetId = 1860058612, InfoType = Enum.InfoType.GamePass }
   22 | 		}
   23 | 	},
   24 | 	EquipInfo = { SlotType = "Unusual" },
   25 | 	CosmeticInfo = { Unusual = true },
   26 | 	Features = { RELICS = true }
   27 | }


========================================
MATCH #36
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.SapphireAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-17 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Sapphire Aura",
    7 | 		Desc = "unused. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = { LevelRequirement = 0, AppearsIn = "None", OwnershipType = "Single" },
   14 | 	EquipInfo = { SlotType = "Unusual" },
   15 | 	CosmeticInfo = { Unusual = true },
   16 | 	Features = { RELICS = true }
   17 | }


========================================
MATCH #37
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.RubyAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-17 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Ruby Aura",
    7 | 		Desc = "Unused. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = { LevelRequirement = 0, AppearsIn = "None", OwnershipType = "Single" },
   14 | 	EquipInfo = { SlotType = "Unusual" },
   15 | 	CosmeticInfo = { Unusual = true },
   16 | 	Features = { RELICS = true }
   17 | }


========================================
MATCH #38
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.GeometricAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 772
========================================

--- SOURCE LINES 1-27 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Geometric Aura",
    7 | 		Desc = "A violent release of electricity from cybernetic implants. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "Auras",
   16 | 		Currency = "ROBUX",
   17 | 		Gamepass = 1862137161,
   18 | 		OwnershipType = "Single",
   19 | 		AssetOwnershipInfo = {
   20 | 			{ Priority = 1, AssetId = 1040584430, InfoType = Enum.InfoType.GamePass },
   21 | 			{ Priority = 2, AssetId = 1862137161, InfoType = Enum.InfoType.GamePass }
   22 | 		}
   23 | 	},
   24 | 	EquipInfo = { SlotType = "Unusual" },
   25 | 	CosmeticInfo = { Unusual = true },
   26 | 	Features = { RELICS = true }
   27 | }


========================================
MATCH #39
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.EmeraldAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 741
========================================

--- SOURCE LINES 1-27 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Emerald Aura",
    7 | 		Desc = "Can be exchanged for 32 dirt. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "Auras",
   16 | 		Currency = "ROBUX",
   17 | 		Gamepass = 1860963604,
   18 | 		OwnershipType = "Single",
   19 | 		AssetOwnershipInfo = {
   20 | 			{ Priority = 1, AssetId = 1040330967, InfoType = Enum.InfoType.GamePass },
   21 | 			{ Priority = 2, AssetId = 1860963604, InfoType = Enum.InfoType.GamePass }
   22 | 		}
   23 | 	},
   24 | 	EquipInfo = { SlotType = "Unusual" },
   25 | 	CosmeticInfo = { Unusual = true },
   26 | 	Features = { RELICS = true }
   27 | }


========================================
MATCH #40
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.DuometricAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 746
========================================

--- SOURCE LINES 1-27 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "EVADE Aura",
    7 | 		Desc = "sigma sigma boy sigma boy sigma boy. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "Auras",
   16 | 		Currency = "ROBUX",
   17 | 		Gamepass = 1863127823,
   18 | 		OwnershipType = "Single",
   19 | 		AssetOwnershipInfo = {
   20 | 			{ Priority = 1, AssetId = 1040416927, InfoType = Enum.InfoType.GamePass },
   21 | 			{ Priority = 2, AssetId = 1863127823, InfoType = Enum.InfoType.GamePass }
   22 | 		}
   23 | 	},
   24 | 	EquipInfo = { SlotType = "Unusual" },
   25 | 	CosmeticInfo = { Unusual = true },
   26 | 	Features = { RELICS = true }
   27 | }


========================================
MATCH #41
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.ChromaticAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 784
========================================

--- SOURCE LINES 1-27 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Chromatic Aura",
    7 | 		Desc = "The refraction of light upon these wings creates a dazzling spectacle. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "Auras",
   16 | 		Currency = "ROBUX",
   17 | 		Gamepass = 1862893998,
   18 | 		OwnershipType = "Single",
   19 | 		AssetOwnershipInfo = {
   20 | 			{ Priority = 1, AssetId = 1039839959, InfoType = Enum.InfoType.GamePass },
   21 | 			{ Priority = 2, AssetId = 1862893998, InfoType = Enum.InfoType.GamePass }
   22 | 		}
   23 | 	},
   24 | 	EquipInfo = { SlotType = "Unusual" },
   25 | 	CosmeticInfo = { Unusual = true },
   26 | 	Features = { RELICS = true }
   27 | }


========================================
MATCH #42
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.AmethystAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 750
========================================

--- SOURCE LINES 1-27 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Amethyst Aura",
    7 | 		Desc = "The universe in the palm of my hands. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "Auras",
   16 | 		Currency = "ROBUX",
   17 | 		Gamepass = 1859740832,
   18 | 		OwnershipType = "Single",
   19 | 		AssetOwnershipInfo = {
   20 | 			{ Priority = 1, AssetId = 1040227211, InfoType = Enum.InfoType.GamePass },
   21 | 			{ Priority = 2, AssetId = 1859740832, InfoType = Enum.InfoType.GamePass }
   22 | 		}
   23 | 	},
   24 | 	EquipInfo = { SlotType = "Unusual" },
   25 | 	CosmeticInfo = { Unusual = true },
   26 | 	Features = { RELICS = true }
   27 | }


========================================
MATCH #43
PATH: ReplicatedStorage.Items.BaseItems.Cosmetics.RELICSAuras.AmberAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 738
========================================

--- SOURCE LINES 1-27 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	RequiresBoombox = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Amber Aura",
    7 | 		Desc = "A portal to the mystic arts. Reacts to boombox\'s volume.",
    8 | 		Creator = "RELICS",
    9 | 		Icon = 0,
   10 | 		CameraType = "Back"
   11 | 	},
   12 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "Auras",
   16 | 		Currency = "ROBUX",
   17 | 		Gamepass = 1860592555,
   18 | 		OwnershipType = "Single",
   19 | 		AssetOwnershipInfo = {
   20 | 			{ AssetId = 1041652464, Priority = 1, InfoType = Enum.InfoType.GamePass },
   21 | 			{ AssetId = 1860592555, Priority = 2, InfoType = Enum.InfoType.GamePass }
   22 | 		}
   23 | 	},
   24 | 	EquipInfo = { SlotType = "Unusual" },
   25 | 	CosmeticInfo = { Unusual = true },
   26 | 	Features = { RELICS = true }
   27 | }


========================================
MATCH #44
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.AviatorCap
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 460
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Aviator Cap",
    6 | 		Desc = "For incase you go airborne.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 20,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #45
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.BackGuitar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 452
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Back Guitar",
    6 | 		Desc = "Gets the girls.",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 30,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #46
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.BlueFadedCape
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 445
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Faded Cape",
    6 | 		Desc = "Stylish.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 20,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #47
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.BlueNeonShades
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 493
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Neon Shades",
    6 | 		Desc = "Actual realistic and pragmatic glasses? That\'s so 2000s.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 25,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #48
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.BoxedBobo
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 514
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Boxed Bobo",
    6 | 		Desc = "Mommy, can I have that cute Bobo plushie? No, sweetie, only losers get that.",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 50,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #49
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.BoxedElectricizer
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 512
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Boxed Electricizer",
    6 | 		Desc = "Hey, isn\'t this that tower from that Tower Defend Simulator game?",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 70,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #50
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.BoxedSlinger
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 490
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Boxed Slinger",
    6 | 		Desc = "Designed to steal the money from chumps like you.",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 50,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #51
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.BoxedVulcan
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 487
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Boxed Vulcan",
    6 | 		Desc = "Doesn\'t come with the emplacement minigun toy.",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 60,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #52
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.Chained
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 447
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Chained",
    6 | 		Desc = "These shackles won\'t keep me down forever!",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #53
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.Chainsaw
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 433
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Chainsaw",
    6 | 		Desc = "Beware the Texas Massacre.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 20,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #54
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.Conductor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 470
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Conductor\'s Cap",
    6 | 		Desc = "Houston, we don\'t have a problem.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 30,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #55
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.DigitalBeeFriends
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Digital Bee Friends",
    6 | 		Desc = "Pretty good replacement for social interaction.",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 35,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #56
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.EggToast
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 434
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Egg on Toast",
    6 | 		Desc = "",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 15,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #57
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.EnergySword
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 454
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Energy Sword",
    6 | 		Desc = "Reality-0438 artifact.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 30,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #58
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.ExoHelmet
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 467
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "ExoHelmet",
    6 | 		Desc = "Reality collapse requires preparation!",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 30,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #59
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.Glyph
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 504
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Glyph",
    6 | 		Desc = "A strange symbol with a pulsating glow. What could this mean? Where is it from? Who knows? Who cares??",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #60
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.GreenFadedCape
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 446
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Green Faded Cape",
    6 | 		Desc = "Stylish.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 20,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #61
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.Headset
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 450
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Headset",
    6 | 		Desc = "Gamer mode activated.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 15,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #62
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.KrustyHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 446
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Krusty Hat",
    6 | 		Desc = "I hate my job.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 10,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #63
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.Milkman
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 468
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Milkman",
    6 | 		Desc = "I am the milkman. My milk is delicious.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 10,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #64
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.OldBarrel
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 438
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Old Barrel",
    6 | 		Desc = "",
    7 | 		Creator = "Aurrous",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 25,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #65
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.OrangeHeadphones
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 470
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Orange Headphones",
    6 | 		Desc = "Can\'t afford those earpods bru",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 25,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #66
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.OrangeSnowboard
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 496
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Orange Snowboard",
    6 | 		Desc = "Doesn\'t help when there aren\'t very many snow maps.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 25,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #67
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.PlaidHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 454
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Plaid Hat",
    6 | 		Desc = "They\'ve gone to plaid?",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 25,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #68
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.PuddingHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Pudding Hat",
    6 | 		Desc = "Scrumptious and delicious toffee pudding.",
    7 | 		Creator = "Aurrous",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 35,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #69
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.PurpleSnowboard
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Purple Snowboard",
    6 | 		Desc = "Too bad there are no snowy mountains.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 25,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #70
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.RedFadedCape
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 444
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Red Faded Cape",
    6 | 		Desc = "Stylish.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 20,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #71
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.RoastedChicken
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 448
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Roasted Chicken",
    6 | 		Desc = "chiken.",
    7 | 		Creator = "Aurrous",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 55,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #72
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.Technician
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Orange Neon Shades",
    6 | 		Desc = "Stylish neon shades accompanied with a tesla backpack.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 35,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #73
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.Wings
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 458
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Purified Wings",
    6 | 		Desc = "Wings of redemption.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Mythical" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 75,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #74
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.BlastPack
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 463
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blast Pack",
    6 | 		Desc = "Doesn\'t grant a jump boost",
    7 | 		Creator = "Tempous",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 40,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #75
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.DemonSword
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 462
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Demon Sword",
    6 | 		Desc = "For slaying demons.",
    7 | 		Creator = "oliwieer4",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Mythical" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 80,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #76
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Normal.TurboThruster
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 468
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Turbo Thruster",
    6 | 		Desc = "Doesn\'t grant a speed boost",
    7 | 		Creator = "Tempous",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "DailyShop",
   15 | 		Currency = "Points",
   16 | 		Price = 40,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #77
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.PrismaticRadiance
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 487
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Prismatic Radiance",
    6 | 		Desc = "Trippy. May induce epileptic shock.",
    7 | 		Creator = "dragon_9086",
    8 | 		Icon = 11371838660
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 320,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #78
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.DarkStar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 513
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dark Star",
    6 | 		Desc = "An uncontrollable neutron star on the brink of collapsing into a black hole.",
    7 | 		Creator = "cuj_o",
    8 | 		Icon = 11371829447
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 300,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #79
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.IgneousGeyser
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 499
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Igneous Geyser",
    6 | 		Desc = "A beautiful red-orange stream of high-energy light beams.",
    7 | 		Creator = "cuj_o",
    8 | 		Icon = 11371841768
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 200,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #80
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.BlueAbduction
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 489
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Abduction",
    6 | 		Desc = "Perhaps the nextbots are the least of your worries.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007448825
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #81
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.AstralNebula
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 493
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Astral Nebula",
    6 | 		Desc = "Intestellar nebulas. Colorful gases and sparkling stars.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007450598
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 300,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #82
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.IrradiatingHalo
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 461
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Irradiating Halo",
    6 | 		Desc = "Mesmerizing.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 11371832975
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 250,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #83
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.ParticulateIridescence
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 491
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Particulate Iridescence",
    6 | 		Desc = "A colorful spectrum of cool colors.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 11371893137
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #84
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.CharmingHearts
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 466
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Charming Heart",
    6 | 		Desc = "Perfect on Valentine\'s Day.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007464164
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 150,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #85
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.EnergizedRed
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 487
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Red Energized",
    6 | 		Desc = "I can feel the power flowing through my veins.",
    7 | 		Creator = "8Deva",
    8 | 		Icon = 11371834157
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 250,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #86
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.RoseateGeyser
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 500
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Roseate Geyser",
    6 | 		Desc = "A beautiful purple-pink stream of high-energy light beams.",
    7 | 		Creator = "cuj_o",
    8 | 		Icon = 11371842314
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 200,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #87
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.CosmicVortex
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 486
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cosmic Vortex",
    6 | 		Desc = "A nebula collapsing into a singularity.",
    7 | 		Creator = "dragon_9086",
    8 | 		Icon = 11371896369
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 300,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #88
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.ThunderingStorm
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 461
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Thundering Storm",
    6 | 		Desc = "A ferocious downpour.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007335671
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 300,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #89
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.NightLights
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 473
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Night Lights",
    6 | 		Desc = "Clear eyes, full hearts, can\'t lose.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007519937
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 250,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #90
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.EnergizedPurple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 490
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Purple Energized",
    6 | 		Desc = "I can feel the power flowing through my veins.",
    7 | 		Creator = "8Deva",
    8 | 		Icon = 11371837893
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 250,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #91
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.ShiningSparkles
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 470
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Shining Sparkles",
    6 | 		Desc = "Glimmering lights in the dark.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007440142
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 200,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #92
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.RedAbduction
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 488
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Red Abduction",
    6 | 		Desc = "Perhaps the nextbots are the least of your worries.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007505404
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #93
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.Voltaic
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 465
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Voltaic",
    6 | 		Desc = "A potent electric current flowing.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007442073
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 350,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #94
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.AutumnLeaves
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 467
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Autumn Leaves",
    6 | 		Desc = "Hi, one pumpkin spice latte please.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007589084
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 150,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #95
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.Haha
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 437
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Haha",
    6 | 		Desc = "HAHA LOL!",
    7 | 		Creator = nil,
    8 | 		Icon = 11007331344
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 150,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #96
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.GreenAbduction
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 490
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Green Abduction",
    6 | 		Desc = "Perhaps the nextbots are the least of your worries.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007491209
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #97
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.FloweringPetals
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 464
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Flowering Petals",
    6 | 		Desc = "Pretty spring flowers...",
    7 | 		Creator = nil,
    8 | 		Icon = 11007333606
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #98
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.FireHorns
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Fire Horns",
    6 | 		Desc = "Forged from the depths beneath this world.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007522362
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 200,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #99
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.Electrified
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Electrified",
    6 | 		Desc = "Were you shocked by me or the unusual effect?",
    7 | 		Creator = nil,
    8 | 		Icon = 11007515712
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 250,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #100
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.CursedHorns
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 487
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cursed Horns",
    6 | 		Desc = "An evil ominous mark, cursed with a bluefire flame.",
    7 | 		Creator = nil,
    8 | 		Icon = 11007502623
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 300,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #101
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.Unusual.PrismaticGeyser
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 501
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Prismatic Geyser",
    6 | 		Desc = "A beautiful blue-green stream of high-energy light beams.",
    7 | 		Creator = "cuj_o",
    8 | 		Icon = 11371836890
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 200,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #102
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.RoaringSingularity
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 490
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Roaring Singularity",
    6 | 		Desc = "Those aren\'t mountains... Those are waves.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 18226793990
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 350,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #103
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.ColossalFlashes
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 548
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Colossal Flashes",
    6 | 		Desc = "Purple beams coarse your head and protect you from headshots.. I forgot, this isn\'t a shooting game",
    7 | 		Creator = "Firefoxblue_YT",
    8 | 		Icon = 15281525354
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 250,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #104
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.DizzyStars
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 523
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dizzy Stars",
    6 | 		Desc = "Cheesing the nextbot by spinning around it really puts a number on your well being.",
    7 | 		Creator = "IMIS_DEADLY",
    8 | 		Icon = 15281525844
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 125,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #105
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.Refractions
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 478
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Refractions",
    6 | 		Desc = "See you on the dark side of the moon.",
    7 | 		Creator = "butterfly723",
    8 | 		Icon = 15281526067
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 275,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #106
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.Timewarp
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 514
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Timewarp",
    6 | 		Desc = "Unusual stereotypes part 1! Whoever wears this definitely owns a duped shovel.",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 15281526251
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 240,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #107
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.ByteFracture
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 466
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Byte Fracture",
    6 | 		Desc = "Back to the future.",
    7 | 		Creator = "Master_LightDark",
    8 | 		Icon = 15281526548
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #108
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.BinaryBeams
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 457
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Binary Beams",
    6 | 		Desc = "01101000 01101001",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 15281524645
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 150,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #109
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.AmethystEnergy
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 455
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Amethyst Energy",
    6 | 		Desc = "Mesmerizing.",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 15281524314
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #110
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.LunarLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 477
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lunar Light",
    6 | 		Desc = "A full moon breaks through the clouds.",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 15281559265
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #111
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.VioletNocturne
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 481
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Violet Nocturne",
    6 | 		Desc = "A full moon breaks through the clouds.",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 15281559486
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #112
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.HowliteMaelstrom
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 460
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Howlite Maelstrom",
    6 | 		Desc = "A neverending storm.",
    7 | 		Creator = "8Deva",
    8 | 		Icon = 15281558802
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 300,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #113
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.ScarletMaelstrom
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 460
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Scarlet Maelstrom",
    6 | 		Desc = "A neverending storm.",
    7 | 		Creator = "8Deva",
    8 | 		Icon = 15281559063
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 300,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #114
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.AzureMaelstrom
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 458
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Azure Maelstrom",
    6 | 		Desc = "A neverending storm.",
    7 | 		Creator = "8Deva",
    8 | 		Icon = 15281558617
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 300,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #115
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.CosmicHalo
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 482
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cosmic Halo",
    6 | 		Desc = "Just don\'t stare at the moon for too long..",
    7 | 		Creator = "Kapurikon",
    8 | 		Icon = 15281525606
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 375,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #116
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.CollapsingSingularity
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 493
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Collapsing Singularity",
    6 | 		Desc = "Those aren\'t waves... Those are mountains.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 18226794493
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 350,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #117
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.EctoplasmicStar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 485
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ectoplasmic Star",
    6 | 		Desc = "Transcending the planes of reality.",
    7 | 		Creator = "minecraftmanic29",
    8 | 		Icon = 15330231393
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 400,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #118
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.AustralisNebula
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Australis Nebula",
    6 | 		Desc = "A celestial nebula, at your feet.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 15332670165
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 450,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #119
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.BorealisNebula
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 479
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Borealis Nebula",
    6 | 		Desc = "A celestial nebula, at your feet.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 15332670525
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 450,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #120
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.ShimmeringParadise
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 468
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Shimmering Paradise",
    6 | 		Desc = "Relaxing on the beach.",
    7 | 		Creator = "Noskademo",
    8 | 		Icon = 15332669124
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #121
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.LavenderUtopia
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 464
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lavender Utopia",
    6 | 		Desc = "Relaxing on the beach.",
    7 | 		Creator = "Noskademo",
    8 | 		Icon = 15332669649
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #122
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.HalleysComet
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 534
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Halley\'s Comet",
    6 | 		Desc = "Refractive crystals from this comet result in a spectacular display of colors and light.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 16381516740
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 350,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #123
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.Bubbly
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 465
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bubbly",
    6 | 		Desc = "helo i am under the water",
    7 | 		Creator = "minecraftmanic29",
    8 | 		Icon = 15330230743
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true }
   20 | }


========================================
MATCH #124
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.TimeKeeper
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 498
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Time Keeper",
    6 | 		Desc = "The universe hangs in a fragile balance between space and time.",
    7 | 		Creator = "NickerManett",
    8 | 		Icon = 138871601023661
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #125
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.PurpleEMP
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 508
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Purple EMP",
    6 | 		Desc = "An electromagnetic pulse, strong enough to permanently damage electronics.",
    7 | 		Creator = "NickerManett",
    8 | 		Icon = 112966779401533
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #126
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.OrangeEMP
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 508
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Orange EMP",
    6 | 		Desc = "An electromagnetic pulse, strong enough to permanently damage electronics.",
    7 | 		Creator = "NickerManett",
    8 | 		Icon = 101243983312796
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 180,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #127
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.MorningButterflies
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 509
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Morning Butterflies",
    6 | 		Desc = "The wings of butterflies glisten in the light of the morning sun.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 135339199382899
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #128
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.MoonlightButterflies
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 504
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Moonlight Butterflies",
    6 | 		Desc = "The wings of butterflies glisten in the light of the moon.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 139303086452755
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #129
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew.EclipseButterflies
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 518
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Butterflies",
    6 | 		Desc = "The wings of butterflies glisten even in the darkness of the solar eclipse.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 76057239086215
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #130
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew2.ShiftingParadigm
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 439
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Shifting Paradigm",
    6 | 		Desc = "",
    7 | 		Creator = "arsonistmz",
    8 | 		Icon = 120583500421161
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #131
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew2.PinkStarEruption
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Pink Star Eruption",
    6 | 		Desc = "",
    7 | 		Creator = "Khexsl",
    8 | 		Icon = 91724644834923
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 160,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #132
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew2.OrangeStarEruption
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 438
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Orange Star Eruption",
    6 | 		Desc = "",
    7 | 		Creator = "Khexsl",
    8 | 		Icon = 111642115077366
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 160,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #133
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew2.HeadphoneResonance
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 441
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Headphone Resonance",
    6 | 		Desc = "",
    7 | 		Creator = "arsonistmz",
    8 | 		Icon = 108135161456588
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 100,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #134
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew2.BlueStarEruption
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Star Eruption",
    6 | 		Desc = "",
    7 | 		Creator = "Khexsl",
    8 | 		Icon = 85662712339382
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 160,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #135
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Cosmetics.UnusualNew2.AbyssalRapture
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 437
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Abyssal Rapture",
    6 | 		Desc = "",
    7 | 		Creator = "arsonistmz",
    8 | 		Icon = 114907099719126
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 220,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #136
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Consumables.Cola.BloxyCola
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 396
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bloxy Cola",
    6 | 		Desc = "It\'s been expired for a long time",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 25,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #137
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Consumables.Cola.HexagonCola
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 505
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hexagon Cola",
    6 | 		Desc = "World renowned cola. Side effects may include but are not limited to; instant death, compulsive urge to play Evade, or worse.",
    7 | 		Creator = "ElectroMeltdown",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 25,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #138
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Consumables.Cola.MelonRamune
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 445
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Melon Ramune",
    6 | 		Desc = "OMG JAPANNN I LOVE JAPAN HAHA SO KAWAII!!! NYAA =^.^= JAPAN SO CUTEEEE",
    7 | 		Creator = "butterfly723",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #139
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Consumables.Cola.MilkCarton
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 382
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Milk Carton",
    6 | 		Desc = "Got milk?",
    7 | 		Creator = "Noskademo",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 25,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #140
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Consumables.Cola.LimeIceCream
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 411
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lime Ice Cream",
    6 | 		Desc = "got a little bit of zest to it",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #141
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Barrier.AzureWall
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 390
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Azure Wall",
    6 | 		Desc = "Made of condensed freon gas.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #142
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Barrier.DropWall
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 383
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Drop Wall",
    6 | 		Desc = "I LUUUUUUV HALO!!!",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 60,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #143
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Barrier.DystopianBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 436
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dystopian Barrier",
    6 | 		Desc = "A barrier from another timeline where the nextbots won the war.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 60,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #144
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Barrier.GoldBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 389
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gold Barrier",
    6 | 		Desc = "Evade death in style.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #145
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Barrier.GreenBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 392
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Green Barrier",
    6 | 		Desc = "Environmentally friendly.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 15,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #146
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Floodlight.BlueFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 403
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Floodlight",
    6 | 		Desc = "Light up the area in a hint of blue.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 20,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #147
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Floodlight.BrassFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 395
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Brass Floodlight",
    6 | 		Desc = "A steampunk era floodlight.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 25,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #148
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Floodlight.DystopianFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 442
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dystopian Floodlight",
    6 | 		Desc = "A floodlight from another timeline where the nextbots won the war.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #149
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Floodlight.GreenFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 405
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Green Floodlight",
    6 | 		Desc = "Light up the area in a hint of green.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 20,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #150
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Floodlight.RedFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 401
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Red Floodlight",
    6 | 		Desc = "Light up the area in a hint of red.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 20,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #151
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Floodlight.FusionCoilLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 385
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Fusion Coil Light",
    6 | 		Desc = "I LUUUV HALO",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 60,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #152
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Landmine.BearTrap
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bear Trap",
    6 | 		Desc = "If it works for bears, why should it not also work for nextbots?",
    7 | 		Creator = "nick200x",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #153
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Landmine.SpikySeaMine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 413
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Spiky Sea Mine",
    6 | 		Desc = "Capable of sinking battleships",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #154
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.SpeedPad.LightSpeedPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 385
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Light Speed Pad",
    6 | 		Desc = "Nice and bright!",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 15,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #155
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.SpeedPad.GoldSpeedPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 389
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gold Speed Pad",
    6 | 		Desc = "A gilded speed pad.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #156
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.SpeedPad.OrientalSpeedpad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 422
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Oriental Speedpad",
    6 | 		Desc = "A promenade amongst the bamboo forests",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #157
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Teleporter.BronzeTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 417
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bronze Teleporter",
    6 | 		Desc = "Not as quite as good as silver, but whatever",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 60,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #158
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Teleporter.EscapeHatch
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 418
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Escape Hatch",
    6 | 		Desc = "Quick! Make a quick escape through that hatch.",
    7 | 		Creator = "Noskademo",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #159
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Teleporter.GoldTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 391
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gold Teleporter",
    6 | 		Desc = "A gilded teleporter.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #160
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Teleporter.HardlightGate
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 640
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hardlight Gate",
    6 | 		Desc = "Uses a primitive version of teleportation - destroys all matter and breaks it down into information, then quantum entangled particles next to the second teleportation gate react to the given set of matter instructions, then the matter is reconstructed in the other \'gate\'.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #161
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Teleporter.HeavensGate
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 426
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Heaven\'s Gate",
    6 | 		Desc = "Has a 10% chance of sending you directly to Hell",
    7 | 		Creator = "EternityDevRe",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #162
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Teleporter.FishingPondTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 409
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Fishing Pond Teleporter",
    6 | 		Desc = "that was reel-y funny",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #163
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.JumpPad.TrampolineJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 388
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Trampoline Jump Pad",
    6 | 		Desc = "boing",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #164
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.JumpPad.WaferCatJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 414
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Wafer Cat Jump Pad",
    6 | 		Desc = "he shall be melted in a smore",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #165
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Beacon.GrillBeacon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 418
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Grill Beacon",
    6 | 		Desc = "Do you like it medium or glowing red?",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #166
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Deployables.Sensor.SubmarineSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 418
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Submarine Sensor",
    6 | 		Desc = "We all live in a yellow submarine",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #167
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.Lantern.BurningAce
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 403
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Burning Ace",
    6 | 		Desc = "I placed down an Ace of Bobo\'s.",
    7 | 		Creator = "Noskademo",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #168
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.Lantern.Lighter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 388
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lighter",
    6 | 		Desc = "Doesn\'t cause wildfires.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #169
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.Lantern.CatMorphLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 419
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cat Morph Lantern",
    6 | 		Desc = "123 for cat  cute/sleepy/baby/friendly",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #170
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.Lantern.OvergrownLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 401
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Overgrown Lantern",
    6 | 		Desc = "Enchanted by druids",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 80,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #171
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.Lantern.StarCatLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 384
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Star Cat Lantern",
    6 | 		Desc = "",
    7 | 		Creator = "CatVovanchik",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #172
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.NightVisionGoggles.CyclopsNightVision
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 406
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cyclops Goggles",
    6 | 		Desc = "Doesn\'t include depth perception.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #173
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.NightVisionGoggles.NightVisionBlue
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 400
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Goggles",
    6 | 		Desc = "Illuminates the world in ocean blue.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #174
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.NightVisionGoggles.NightVisionGold
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 411
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gold Goggles",
    6 | 		Desc = "Illuminates the world in glistening yellow.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #175
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.NightVisionGoggles.NightVisionPurple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 404
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Purple Goggles",
    6 | 		Desc = "Illuminates the world in hazey purple.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #176
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Lights.NightVisionGoggles.NightVisionRed
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 398
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Red Goggles",
    6 | 		Desc = "Illuminates the world in blood red.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #177
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Power.StunBaton.GuitarAxe
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 348
========================================

--- SOURCE LINES 1-14 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = { Name = "Guitar Axe", Desc = "", Creator = "" },
    5 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
    6 | 	PurchaseInfo = {
    7 | 		LevelRequirement = 0,
    8 | 		AppearsIn = "DailyShop",
    9 | 		Currency = "Points",
   10 | 		Price = 500,
   11 | 		OwnershipType = "Single"
   12 | 	},
   13 | 	CosmeticInfo = { Unusual = false }
   14 | }


========================================
MATCH #178
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Compass.Locket
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 436
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Locket",
    6 | 		Desc = "Once used to delve into the endless blue abyss in search of the New World.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #179
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Compass.SharkCompass
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 374
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Shark Compass",
    6 | 		Desc = "",
    7 | 		Creator = "Dardemai",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 25,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #180
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Decoy.CopyClipboard
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 447
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Copy Clipboard",
    6 | 		Desc = "When you teach your boss who makes 10x your salary how to copy and paste.",
    7 | 		Creator = "Noskademo",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #181
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Radar.XR9000
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 399
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "XR9000",
    6 | 		Desc = "I\'ve got a bad feeling about this...",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #182
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Radar.RedRadar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 382
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Red Radar",
    6 | 		Desc = "Rated for DEFCON 1.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 15,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #183
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Radar.GoldRadar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 409
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gold Radar",
    6 | 		Desc = "A prestigious gilded radar, fit for a king.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #184
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Radar.GhostRadar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 379
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ghost Radar",
    6 | 		Desc = "OOOoooooOOooo!!!",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #185
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Radar.BlueRadar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 397
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Radar",
    6 | 		Desc = "Rated for DEFCON 1 (but in blue).",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 15,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #186
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Radar.SharkRadar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 372
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Shark Radar",
    6 | 		Desc = "",
    7 | 		Creator = "Dardemai",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 25,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #187
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Radio.BananaPhone
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 411
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Banana Phone",
    6 | 		Desc = "Ring ring ring ring ring, banana phone!",
    7 | 		Creator = "Noskademo",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #188
PATH: ReplicatedStorage.Items.ItemPacks.Base.DailyShop.Skins.Utilities.Timer.Stopwatch
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 397
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Stopwatch",
    6 | 		Desc = "Keep track of the time in style.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #189
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.Absorption
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 448
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Absorption",
    6 | 		Desc = "unused",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #190
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.BoboVortex
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 448
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Vortex of Bobos",
    6 | 		Desc = "him",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Exclusive" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #191
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.EliteHelmet
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 461
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Elite Helmet",
    6 | 		Desc = "w0rt w0rt w0rt",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Exclusive" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #192
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.Glow
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 444
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Glow",
    6 | 		Desc = "oke",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 100,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 100000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #193
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.GlowSolid
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 450
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Glow Solid",
    6 | 		Desc = "oke",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 100,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 100000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #194
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.Grunt
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 460
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Grunt",
    6 | 		Desc = "unggoy foreva =D",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #195
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.testlol
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 462
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "testlol",
    6 | 		Desc = "why do you have this",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Exclusive" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #196
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.NuclearDoom
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 450
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Nuclear Doom",
    6 | 		Desc = "unused",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #197
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.bobotower
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 471
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "bobo tower",
    6 | 		Desc = "the almighty bobo tower",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 10,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 10000000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #198
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.handtest
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 481
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "handtest",
    6 | 		Desc = "He just wants a friend ;-;",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #199
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.CirclingBeams
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 497
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Circling Beams",
    6 | 		Desc = "All aboard the hate train.",
    7 | 		Creator = "beef",
    8 | 		Icon = 16055904290
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 10000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true, Exotic = true },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #200
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.Nothing
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 464
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Nothing",
    6 | 		Desc = "Does nothing (dummy item)",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true },
   20 | 	OwnershipInfo = { Admin = true }
   21 | }


========================================
MATCH #201
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.Capes.BlackCape
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 439
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Black Cape",
    6 | 		Desc = "",
    7 | 		Creator = "Oster",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 99999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #202
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.Capes.WhiteCape
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 439
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "White Cape",
    6 | 		Desc = "",
    7 | 		Creator = "Oster",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 99999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #203
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.Capes.BlueCape
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 438
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Cape",
    6 | 		Desc = "",
    7 | 		Creator = "Oster",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 99999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #204
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Cosmetics.Capes.RedCape
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 437
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Red Cape",
    6 | 		Desc = "",
    7 | 		Creator = "Oster",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 99999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #205
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Skins.Deployables.Floodlight.Epsilon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 369
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Epsilon Floodlight",
    6 | 		Desc = "E",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #206
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Skins.Deployables.Floodlight.GuiltySpark
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 392
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Guilty Spark",
    6 | 		Desc = "I am 343 Guilty Spark.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #207
PATH: ReplicatedStorage.Items.ItemPacks.Base.Admin.Skins.Deployables.Barrier.AnniversaryBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 403
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Anniversary Barrier",
    6 | 		Desc = "lwidweally epik.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #208
PATH: ReplicatedStorage.Items.ItemPacks.Base.UpperLevel.Cosmetics.LOLCATZ
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 445
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "LOL CATZ",
    6 | 		Desc = "LOLZERZ FOREVAA!!!!!!! XD",
    7 | 		Creator = nil,
    8 | 		Icon = 15426458068
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #209
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.2023Celebration
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 472
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "2023 Celebration",
    6 | 		Desc = "Woohoo! 2023 is definitely going to be my year.",
    7 | 		Creator = nil,
    8 | 		Icon = 11981547226
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 10000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #210
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.OneBillionReward
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 561
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "1B Celebration",
    6 | 		Desc = "I never thought I\'d ever get this successful. I genuinely, wholeheartedly, couldn\'t have done it without you, so please accept this as a reward.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 10000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #211
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.OverhaulHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Overhaul Hat",
    6 | 		Desc = "Patience.",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 10000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #212
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.Party
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 467
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Party",
    6 | 		Desc = "Thanks for playing when the game hit the 100k player milestone!",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 10000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #213
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.AlphaTester
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 502
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Alpha Tester",
    6 | 		Desc = "Burn bright; burn blue. Thank you to those who tested the game in its early stages.",
    7 | 		Creator = nil,
    8 | 		Icon = 83681447045862
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #214
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.CCHaze
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 465
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Content Creator Haze",
    6 | 		Desc = "thanks for being an evade content creator",
    7 | 		Creator = nil,
    8 | 		Icon = 17885254022
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #215
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.Default
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 424
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Default",
    6 | 		Desc = "No added visual changes",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 0,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #216
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.DonationVictorian
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 478
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Donation Victorian",
    6 | 		Desc = "Thanks for wasting thousands of dollars on this game lol",
    7 | 		Creator = nil,
    8 | 		Icon = 17885253007
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #217
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.GlowingHaze
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 474
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Glowing Haze",
    6 | 		Desc = "A colorful haze. Awarded to the most prestigious of members.",
    7 | 		Creator = nil,
    8 | 		Icon = 17885254538
    9 | 	},
   10 | 	UIInfo = { Header = "Admin", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #218
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.LevelVictorian
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 452
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Experienced Victorian",
    6 | 		Desc = "I paused my game to be here",
    7 | 		Creator = nil,
    8 | 		Icon = 17885251312
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #219
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.SurvivalVictorian
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 510
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Survival Victorian",
    6 | 		Desc = "Those who own this shall deserve the highest amount of respect I can muster; a cosmetic.",
    7 | 		Creator = nil,
    8 | 		Icon = 17885252036
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #220
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.TweetReward
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 465
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bird Badge",
    6 | 		Desc = "Thanks for following our official account! @HexagonDCRoblox",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #221
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.BlazingCandle
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 459
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blazing Candle",
    6 | 		Desc = "HAPPY BIRTHDAY!!!. Are you one, are you two.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #222
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.2AnniversaryHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 500
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "2nd Anniversary Hat",
    6 | 		Desc = "Thank you to the community for sticking around for another year!",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 18792905069
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #223
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.CirclingEclipseCola
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 466
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Circling Eclipse Cola",
    6 | 		Desc = "thanks for buying a $30 plushie (if you did)",
    7 | 		Creator = "beef",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #224
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.CirclingCatJard
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 445
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Circling Cat Jard",
    6 | 		Desc = "thanks for buying a $30 plushie",
    7 | 		Creator = "beef",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #225
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Cosmetics.CirclingCatPufferfish
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 428
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Circling Cat Pufferfish",
    6 | 		Desc = "its real",
    7 | 		Creator = "beef",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #226
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Deployables.Barrier.CircusBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 438
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Circus Barrier",
    7 | 		Desc = "Where all the high level Evade players go.",
    8 | 		Creator = "MontiCats",
    9 | 		Icon = 0
   10 | 	},
   11 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = nil,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #227
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Deployables.Landmine.WhoopeeCushionMine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 417
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Whoopeee Cushion Mine",
    7 | 		Desc = "fart lolz.",
    8 | 		Creator = "Electromeltdown",
    9 | 		Icon = 0
   10 | 	},
   11 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = nil,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #228
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Deployables.Landmine.AnniversaryLandmine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 420
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Anniversary Landmine",
    6 | 		Desc = "I baked you a cake. Explosive flavor.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #229
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Deployables.Sensor.PortalTurret
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 385
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Portal Turret",
    6 | 		Desc = "target acquired",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #230
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Deployables.Sensor.BoboTurtleSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 565
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bobo Turtle Sensor",
    6 | 		Desc = "In order to avert a world-ending catastrophe, the Legendary Bobo tamed the ferocious, once-explosive Mine Turtle. Instead, using it for peaceful purposes as a sensor for danger.",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #231
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Deployables.SpeedPad.BananaSplitPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 434
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Banana Split Pad",
    7 | 		Desc = "A little bit of tomfoolery, heh.",
    8 | 		Creator = "Electromeltdown",
    9 | 		Icon = 0
   10 | 	},
   11 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = nil,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #232
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Power.GrappleHook.FireworkLauncher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 424
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Firework Launcher",
    6 | 		Desc = "Does not explode into a mesmerizing firework :(",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 35,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #233
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Lights.Floodlight.BoboJardFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 422
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bobo & Jard Floodlight",
    6 | 		Desc = "ERMAHGERDD... SOOO KAWAII!!!~~ =^-^=",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #234
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Lights.Lantern.JardCatLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 492
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Jard Cat Lantern",
    6 | 		Desc = "AHGshaheOASHVSAO)IJFggbeu.yBHEG JARD CAT!!!!!! JARD CAT!!!!!!!!!!!!! YEAAAAAAAAAA BABYYYYYYYYY!!!!!!!!!!!!!!!!!!!",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #235
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Lights.NightVisionGoggles.VRHeadset
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 405
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "VR Headset",
    6 | 		Desc = "Finally. Evade has become real.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #236
PATH: ReplicatedStorage.Items.ItemPacks.Base.Special.Skins.Lights.NightVisionGoggles.ZombieVision
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 403
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Zombie Vision",
    6 | 		Desc = "Allows zombies to see in the dark",
    7 | 		Creator = "",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #237
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Cosmetics.FallingStar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 457
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Falling Star",
    6 | 		Desc = "Collect all the star bits",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 97846690813225
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 250,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #238
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Cosmetics.FlameWreath
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 448
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Flame Wreath",
    6 | 		Desc = "FIRE FIST!!",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 138212246167996
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 150,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #239
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Cosmetics.SelenesGrace
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 481
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Selene\'s Grace",
    6 | 		Desc = "May the Goddess of the Moon watch over you...",
    7 | 		Creator = "KazaFameZ",
    8 | 		Icon = 137618753380511
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 200,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #240
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Cosmetics.VoidStar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 467
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Void Star",
    6 | 		Desc = "An entry to a corrupted dimension",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 101980586701695
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 100,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #241
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Cosmetics.ButterflyOrchid
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Butterfly Orchid",
    6 | 		Desc = "float like a butterfly, sting like a bee",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 84200247312644
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 160,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #242
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Cosmetics.ButterflyEclipse
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 478
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Butterfly Eclipse",
    6 | 		Desc = "float like a butterfly, sting like a bee",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 111031793665530
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 160,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #243
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Cosmetics.ButterflyCrimson
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 477
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Butterfly Crimson",
    6 | 		Desc = "float like a butterfly, sting like a bee",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 87647249329845
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 160,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #244
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Cosmetics.ButterflyAzure
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Butterfly Azure",
    6 | 		Desc = "float like a butterfly, sting like a bee",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 122727820994212
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 160,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #245
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Cosmetics.BoltSkaters
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 447
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bolt Skaters",
    6 | 		Desc = "im fast as heck boi",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 107453486910454
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 150,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #246
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Deployables.Barrier.TreeBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 423
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Tree Barrier",
    6 | 		Desc = "A magical nature barrier blessed by the Druids",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #247
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Deployables.Beacon.PrototypeBeacon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 430
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Prototype Beacon",
    6 | 		Desc = "beep boop it works the same as any other beacon!!",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #248
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Deployables.Floodlight.MysticalFlowerFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 460
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Mystical Flower Floodlight",
    6 | 		Desc = "These glowing flowers seem to be sentient and aware of your existence",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #249
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Deployables.Floodlight.BellFlowerFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 417
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bell Flower Floodlight",
    6 | 		Desc = "A sprinkle of enchanting magic",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #250
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Deployables.JumpPad.AutumnLeavesJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Autumn Leaves Junp Pad",
    6 | 		Desc = "Make sure to break your fall in a pile of leaves",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #251
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Deployables.Landmine.UFOLandmine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 398
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "UFO Landmine",
    6 | 		Desc = "glorp zeep zorp zeeb?",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #252
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Deployables.Landmine.DuckyLandmine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 394
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ducky Landmine",
    6 | 		Desc = "blub blub quack",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #253
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Deployables.Teleporter.SwordRuneTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 455
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Sword Rune Teleporter",
    6 | 		Desc = "You must be Level 50+ and slay the Goblin King to use this teleporter",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #254
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Consumables.ReviveGrenade.AcornHealingGrenade
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 399
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Acorn Healing Grenade",
    6 | 		Desc = "squirrelz ,3,",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #255
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Lights.Lantern.WispyFlowerLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 418
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Wispy Flower Lantern",
    6 | 		Desc = "From a mystical land beyond Earth",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #256
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Lights.Lantern.GubbyLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 402
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gubby Lantern",
    6 | 		Desc = "RELEASE TEH GUBBIES!!!!!",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #257
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Lights.Lantern.LovelyFrogLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 408
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lovely Frog Lantern",
    6 | 		Desc = "SOOOOO KAWAII!!!!!!!",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #258
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Power.GrappleHook.ButterflyGrapple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 406
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Butterfly Grapple",
    6 | 		Desc = "Flutter like a butterfly",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #259
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Utilities.Decoy.ArtPaletteDecoy
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 411
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Art Palette Decoy",
    6 | 		Desc = "A masterpiece is in the works",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #260
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Utilities.Timer.RunicTimer
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 412
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Runic Timer",
    6 | 		Desc = "The lost city of Atlantis is calling",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 20,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #261
PATH: ReplicatedStorage.Items.ItemPacks.Base.ForsakenCollabUpdate.Skins.Utilities.Timer.ClapboardTimer
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 402
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Clapboard Timer",
    6 | 		Desc = "Ready, Set, Action!",
    7 | 		Creator = "CatVovanchik",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #262
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Deployables.Barrier.EclipseBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 426
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Barrier",
    6 | 		Desc = "A stone monument to praise the sun",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #263
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Deployables.Floodlight.EclipseSwordLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 472
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Sword Light",
    6 | 		Desc = "Once wielded by the Profaned Guardians to maintain order in the depths of hell",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #264
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Deployables.JumpPad.EclipseJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Jump Pad",
    6 | 		Desc = "In the midst of the day, a temporary night takes its hold, worth its weight, in gold.",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #265
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Deployables.Landmine.EclipseLandmine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 429
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Landmine",
    6 | 		Desc = "This thing is about to go SUPERNOVA!!!",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #266
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Deployables.SpeedPad.EclipseSpeedpad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 466
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Speedpad",
    6 | 		Desc = "There is no time to stand idle and gaze at the sun, you must keep on running.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #267
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Deployables.Teleporter.EclipseTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Teleporter",
    6 | 		Desc = "The gravity of the sun collapses space around you, warping through reality in an instant.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #268
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Consumables.SmokeGrenade.EclipseSmokeGrenade
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Smoke Grenade",
    6 | 		Desc = "As the moon overtakes the sun, the clear skies become clouded and covered in darkness.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Summer", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #269
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Consumables.Cola.EclipseElixir
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 485
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Elixir",
    6 | 		Desc = "A puddle of water under an eclipse absorbs its energy, transforming into a invigorating elixir",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #270
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Power.GrappleHook.EclipseGrapple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 465
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Grapple",
    6 | 		Desc = "Go on traveler, traverse to the farthest lands and rekindle the last flame.",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #271
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Power.Breacher.EclipseBreacher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 479
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Breacher",
    6 | 		Desc = "As the light of day briefly extinguishes, ancient relics like these gain unnatural powers.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #272
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Skins.Lights.Lantern.EclipseLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 470
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Lantern",
    6 | 		Desc = "Even as the world is cast in darkness, a glimmer of light can always be found.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #273
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.EclipseSet.Cosmetics.EclipseNova
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 595
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eclipse Nova",
    6 | 		Desc = "A delicate balance must be maintained between the light and darkness. The slightest tipping of the scale shall result in a universe-ending catastrophe.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 119573933912128
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #274
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.DogSet.Cosmetics.DoggoAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 462
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Doggo Aura",
    6 | 		Desc = "Yea i got that dawg in me",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 71000477513248
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #275
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.DogSet.Skins.Deployables.Barrier.FireplaceBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 452
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Fireplace Barrier",
    6 | 		Desc = "The greatest gift of all; receiving dogs in your stockings",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #276
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.DogSet.Skins.Deployables.Floodlight.ReindogLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 462
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Reindog Light",
    6 | 		Desc = "Oh Reindog with your nose so bright, won\'t you guide my sleigh tonight?",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #277
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.DogSet.Skins.Deployables.JumpPad.DoggoJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 426
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Doggo Jump Pad",
    6 | 		Desc = "An impatient gift waits underneath...",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #278
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.DogSet.Skins.Deployables.Landmine.DogtoyTrap
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dogtoy Trap",
    6 | 		Desc = "An irresistable treat that will tempt any Nextbot",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #279
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.DogSet.Skins.Deployables.SpeedPad.DoggoSpeedpad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 417
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Doggo Speedpad",
    6 | 		Desc = "dog treat obtained, +30% speed",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #280
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.DogSet.Skins.Power.Breacher.DogBoneBreacher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 515
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dog Bone Breacher",
    6 | 		Desc = "Latest revelations in dog technology shows that bones are not only good for treats, but also for instantaneous teleportation.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #281
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.DogSet.Skins.Lights.Lantern.DoghouseLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 429
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Doghouse Lantern",
    6 | 		Desc = "The sweetest of homes for the doggos",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #282
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Cosmetics.CatRadiance
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 482
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cat Radiance",
    6 | 		Desc = "Ionizing radiation has never looked cuter!!!",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 113487941303989
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #283
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Skins.Deployables.Barrier.KATBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 409
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "KAT Barrier",
    6 | 		Desc = "WELCOME TO KAT LAND!!",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #284
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Skins.Deployables.Floodlight.CatOvenLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 395
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cat Oven Light",
    6 | 		Desc = "he shall be baked",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #285
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Skins.Deployables.JumpPad.BurgerCatJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 421
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Burger Cat Jump Pad",
    6 | 		Desc = "i asked for no pickles",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #286
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Skins.Deployables.Landmine.RatMine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 450
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Rat Mine",
    6 | 		Desc = "Poor rats captured by cats are turned into traps to lure others",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #287
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Skins.Deployables.SpeedPad.CatSpeedPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cat Speed Pad",
    6 | 		Desc = "Watch your step, sleeping kittens rest here",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #288
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Skins.Lights.Lantern.CatLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cat Lantern",
    6 | 		Desc = "This taxidermied cat proves as a great light source!",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #289
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Skins.Power.GrappleHook.CatPostGrapple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cat Post Grapple",
    6 | 		Desc = "Applies a scratched and bleeding effect",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #290
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Skins.Utilities.Radio.MeowPhone
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 396
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Meow Phone",
    6 | 		Desc = "ring ring :3",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #291
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Cats.Skins.Utilities.Timer.CatTimer
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 427
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cat Timer",
    6 | 		Desc = "Finally these useless kittens have a purpose",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #292
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Skins.Deployables.Barrier.SharkBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 404
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Shark Barrier",
    6 | 		Desc = "nom nom nom >;3",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Gamepass",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #293
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Skins.Deployables.Floodlight.WizardCatFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Wizard Cat Floodlight",
    6 | 		Desc = "The greatest of all wizards, Cattus the Wise offers his support for you.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Gamepass",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #294
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Skins.Deployables.JumpPad.FrogJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 399
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Frog Jump Pad",
    6 | 		Desc = "ribbit ribbit",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #295
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Skins.Deployables.Landmine.SheepMine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 391
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Sheep Mine",
    6 | 		Desc = "baaaa",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Gamepass",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #296
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Skins.Deployables.Sensor.FrogSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 390
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Frog Sensor",
    6 | 		Desc = ":I",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #297
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Skins.Deployables.SpeedPad.SnakeSpeedPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 404
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Snake Speed Pad",
    6 | 		Desc = "SSSssssssSsss",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Gamepass",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #298
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Skins.Consumables.Cola.HoneyJar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 403
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Honey Jar",
    6 | 		Desc = "Nectar of the gods.",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #299
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Skins.Lights.Lantern.AxolotlLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 437
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Axolotl Lantern",
    6 | 		Desc = "There\'s always a bright side to a gloomy day.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Gamepass",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #300
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Skins.Power.Breacher.ToucanBreacher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 419
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Toucan Breacher",
    6 | 		Desc = "The wings don\'t provide flight",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #301
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Animals.Cosmetics.AnimalAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 511
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Animal Aura",
    6 | 		Desc = "axolotl, capybara, duck, frog, shark, the whole team is here :D",
    7 | 		Creator = "abrahamabugri & SnowyClown0",
    8 | 		Icon = 97257795606364
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #302
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Future.Cosmetics.Technotic
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 452
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Technotic",
    6 | 		Desc = "10% part barrier.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 15330230247
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #303
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Future.Skins.Deployables.Barrier.FuturisticBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 544
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Futuristic Barrier",
    6 | 		Desc = "Groundbreaking technology from the future has brought us holographic barriers that can physically interact with objects, quite contradictory to think about it.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 500000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #304
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Future.Skins.Deployables.Landmine.FuturisticLandmine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 455
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Futuristic Landmine",
    6 | 		Desc = "Manages to keep an extremely potent explosive in such a tiny device",
    7 | 		Creator = "",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 500000000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #305
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Future.Skins.Deployables.Sensor.FuturisticSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 440
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Futuristic Sensor",
    6 | 		Desc = "Emits a really annoying synth beep when nextbots are near",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #306
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Future.Skins.Deployables.SpeedPad.FuturisticSpeedPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 428
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Futuristic Speed Pad",
    6 | 		Desc = "It looks really cool that\'s all I can say",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 50000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #307
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Future.Skins.Deployables.Teleporter.FuturisticTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 487
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Futuristic Teleporter",
    6 | 		Desc = "Converts your body matter into nano particles and sends them through the air somehow idk dont ask me",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 50000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #308
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Future.Skins.Deployables.Floodlight.FuturisticFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 394
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Futuristic Floodlight",
    6 | 		Desc = "it spins",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 3500000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #309
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Gems.Cosmetics.PrismaticWhispers
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 513
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Prismastic Whispers",
    6 | 		Desc = "May the stars of the cosmos illuminate your way",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 124588689494430,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = nil,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #310
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Gems.Cosmetics.ChaoticRadiance
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 586
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Chaotic Radiance",
    6 | 		Desc = "Refractions in crystals energized by ionizing particles creates dazzling sparkles of light, its beauty outshines its danger.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 70646476497424,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = nil,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #311
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Gems.Skins.Consumables.Cola.AquamarineFlask
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 491
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Aquamarine Flask",
    6 | 		Desc = "Its luminous glow hints at the powerful secrets it holds, emanating an aura of mystery and tranquility.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #312
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Gems.Skins.Deployables.SpeedPad.StellarSurge
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 496
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Stellar Surge",
    6 | 		Desc = "Each step unleashes a burst of cosmic energy, propelling users forward with the brilliance of the cosmos",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #313
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Gems.Skins.Deployables.Teleporter.RosalineGateway
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 495
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Rosaline Gateway",
    6 | 		Desc = "Each gem pulses with arcane energy, opening a shimmering pathway to distant realms in an instant",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #314
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Gems.Skins.Deployables.Barrier.JadeSentinel
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 453
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Jade Sentinel",
    6 | 		Desc = "Two towers, adorned with jade crystals, forming a steadfast shield.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #315
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Gems.Skins.Deployables.Floodlight.AmethystRadiance
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 482
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Amethyst Radiance",
    6 | 		Desc = "A mystical floodlight adorned with ethereal amethyst crystals, exuding a soft, otherworldly glow.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #316
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Gems.Skins.Lights.Lantern.GemstoneLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 506
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gemstone Lantern",
    6 | 		Desc = "What was once a geode, now serves as a beacon of light, illuminating the area in a mesmerizing spectrum of colors.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #317
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.Gems.Skins.Power.GrappleHook.SapphireGrapple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 485
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Sapphire Grapple",
    6 | 		Desc = "A precision-crafted utility tool, adorned with sapphire crystals, emitting a harsh, blue fire.",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #318
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.LunarNewYearSet.Cosmetics.KoiPond
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 463
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Koi Pond",
    6 | 		Desc = "A portal from the spirit land",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 82752178121149
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Tokens",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #319
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.OldRoblox.Skins.Lights.NightVisionGoggles.OBCVision
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 447
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "OBC Vision",
    6 | 		Desc = "outrageous builders club vision on the gamepass for the rich folks",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 40000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #320
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.KingOfTheNight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 465
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "King Of The Moon",
    6 | 		Desc = "An obsidian crown that absorbs all light.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #321
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.KingOfTheMoon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "King Of The Moon",
    6 | 		Desc = "A silvery crown that gleams in the moonlight.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #322
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.SkullOfFrost
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 477
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Skull Of Frost",
    6 | 		Desc = "An empty skull that seems to echo whispers of a riddle.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #323
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.SkullOfInferno
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 479
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Skull Of Inferno",
    6 | 		Desc = "An empty skull that seems to echo whispers of a riddle.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #324
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.HornsOfToxicity
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 559
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Horns Of Toxicity",
    6 | 		Desc = "Beyond the mountains of the east, a wasteland lies in eternal gloom. These horns are but a fragment of that desolation.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 110110350075471
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #325
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.HornsOfInferno
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 572
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Horns Of Inferno",
    6 | 		Desc = "Deep beneath the mountains lies an expansive cavern of churning lava, the intense heat can only be tamed by the power of these horns.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 113617200475980
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #326
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.HornsOfFrost
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 596
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Horns Of Frost",
    6 | 		Desc = "At the highest peaks of the mountains, a frozen wonderland is cast in the glowing light of the auroras. These horns are an attempt to capture that ethereal awe.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 82004430032231
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #327
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.GildedValkyrie
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 489
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gilded Valkyrie",
    6 | 		Desc = "A gilded, winged helmet, only adorned by the fiercest of warriors.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #328
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.Ghosdeeri
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 488
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ghosdeeri",
    6 | 		Desc = "A grim spirit given form, a pumpkin aflame with an eternal, eerie glow.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #329
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.DualEtherealSwords
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 532
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dual Ethereal Swords",
    6 | 		Desc = "A pair of mythical swords that represents the Moon and the Night, its existence is only heard in fables.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #330
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.SilveryCrown
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 482
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Silvery Crown",
    6 | 		Desc = "When you stare into the abyss, the abyss tends to stare back.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #331
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Unorganized.RetroCosmeticsSet.Cosmetics.FederationCrown
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 515
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Federation Crown",
    6 | 		Desc = "Though this crown has great beauty, it does not compare to the fabled history it once held.",
    7 | 		Creator = "ms_d0ss",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #332
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.StPatricks2023.Cosmetics.CoinEyes
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 438
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Coin Eyes",
    6 | 		Desc = "I\'m on a roll!",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Event" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #333
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.StPatricks2023.Cosmetics.OozingMoney
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 509
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Oozing Money",
    6 | 		Desc = "This item gives a 50% increased chance of spending more money on this game.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 12816281237
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Event" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #334
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.StPatricks2023.Cosmetics.FourCloverPin
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 452
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Four Clover Pin",
    6 | 		Desc = "Found in a cloverfield.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Event" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #335
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.StPatricks2023.Cosmetics.CharmLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 457
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Charm Lantern",
    6 | 		Desc = "Doesn\'t actually emit light.",
    7 | 		Creator = "SoulConvict",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Event" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #336
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Cosmetics.Thermocline
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 471
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Thermocline",
    6 | 		Desc = "Turn yourself into a paranoid android.",
    7 | 		Creator = "cuj_o",
    8 | 		Icon = 12492024449
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #337
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Cosmetics.EncapsulatedBarbedWires
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 481
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Encapsulated Barbed Wires",
    6 | 		Desc = "Makes you immune to the pain.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 12492024319
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #338
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Deployables.Barrier.BarbedWireFence
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 389
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Barbed Wire Fence",
    6 | 		Desc = "",
    7 | 		Creator = "sc6uth",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #339
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Deployables.Beacon.Flare
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 377
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Flare",
    6 | 		Desc = "",
    7 | 		Creator = "sc6uth",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #340
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Deployables.Landmine.Claymore
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 382
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Claymore",
    6 | 		Desc = "",
    7 | 		Creator = "DevChams",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #341
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Deployables.Sensor.MilitaryGradeSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 398
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Military Grade Sensor",
    6 | 		Desc = "",
    7 | 		Creator = "SoulConvict",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #342
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Deployables.SpeedPad.OilDrumSpill
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 424
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Oil Drum Spill",
    6 | 		Desc = "The United States Military has called.",
    7 | 		Creator = "sc6uth",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #343
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Deployables.Teleporter.HeliPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 380
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Heli Pad",
    6 | 		Desc = "",
    7 | 		Creator = "sc6uth",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #344
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Deployables.Floodlight.MilitaryFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 392
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Military Floodlight",
    6 | 		Desc = "",
    7 | 		Creator = "danncie",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #345
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Lights.Flashlight.MilGradeFlashlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 427
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Mil-Grade Flashlight",
    6 | 		Desc = "Don\'t shine it in any eyes.",
    7 | 		Creator = "SoulConvict",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #346
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Lights.Lantern.MilitaryLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 412
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Mil-Grade Lantern",
    6 | 		Desc = "The British are coming!",
    7 | 		Creator = "SoulConvict",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #347
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Lights.NightVisionGoggles.PVS32
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 417
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "PVS-32",
    6 | 		Desc = "See the world in a ghostly white color.",
    7 | 		Creator = "SoulConvict",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #348
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Utilities.Compass.LensaticCompass
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 398
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lensatic Compass",
    6 | 		Desc = "Ol\' reliable.",
    7 | 		Creator = "sc6uth",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #349
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Utilities.Radar.XR8000
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 395
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "XR8000",
    6 | 		Desc = "Computer tech.",
    7 | 		Creator = "SoulConvict",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #350
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Utilities.Timer.MilGradeTimer
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 404
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Mil-Grade Timer",
    6 | 		Desc = "Bit overengineered.",
    7 | 		Creator = "danncie",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #351
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.Legacy.Military.Skins.Utilities.Radio.WalkieTalkie
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 399
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Walkie Talkie",
    6 | 		Desc = "Military classic.",
    7 | 		Creator = "nick200x",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #352
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.BeeSet.Skins.Deployables.Barrier.BeeswaxBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 388
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Beeswax Barrier",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #353
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.BeeSet.Skins.Deployables.Floodlight.HoneyScepterLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 396
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Honey Scepter Light",
    6 | 		Desc = "",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #354
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.BeeSet.Skins.Deployables.JumpPad.BeeswaxJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 389
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Beeswax Jump Pad",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #355
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.BeeSet.Skins.Deployables.SpeedPad.BeeswaxSpeedpad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 389
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Beeswax Speedpad",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #356
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.BeeSet.Skins.Consumables.ReviveGrenade.HealingBee
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 386
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Healing Bee",
    6 | 		Desc = "",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #357
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.BeeSet.Skins.Consumables.Defibrillator.BeeDefibrillator
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 366
========================================

--- SOURCE LINES 1-14 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = { Name = "Bee Defibs", Desc = "", Creator = "SnowyClown0" },
    5 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
    6 | 	PurchaseInfo = {
    7 | 		LevelRequirement = 0,
    8 | 		AppearsIn = "Event",
    9 | 		Currency = "Tickets",
   10 | 		Price = 999999999,
   11 | 		OwnershipType = "Single"
   12 | 	},
   13 | 	CosmeticInfo = { Unusual = false }
   14 | }


========================================
MATCH #358
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.BeeSet.Skins.Power.Breacher.BeezookaBreacher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 394
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Beezooka Breacher",
    6 | 		Desc = "",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #359
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.BeeSet.Skins.Lights.Lantern.HoneyJarLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 394
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Honey Jar Lantern",
    6 | 		Desc = "",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #360
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.BeeSet.Cosmetics.BeeShield
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 437
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bee Shield",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 92583363584950
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #361
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.PoseidonSet.Cosmetics.CapeOfPoseidon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 444
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cape Of Poseidon",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 123342745981242
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = true },
   19 | 	EquipInfo = { SlotType = "Unusual" }
   20 | }


========================================
MATCH #362
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.PoseidonSet.Skins.Deployables.Barrier.AtlantisAegis
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 387
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Atlantis Aegis",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #363
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.PoseidonSet.Skins.Deployables.SpeedPad.NeptuneWaterDash
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 391
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Neptune Water Dash",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #364
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.PoseidonSet.Skins.Deployables.JumpPad.PoseidonJumpad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 392
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Poseidon Jump Pad",
    6 | 		Desc = "",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #365
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.PoseidonSet.Skins.Power.GrappleHook.HippocampusGrapple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 392
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hippocampus Grapple",
    6 | 		Desc = "",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Summer", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #366
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.PoseidonSet.Skins.Power.Breacher.HippocampusBreacher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 397
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hippocampus Breacher",
    6 | 		Desc = "",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #367
PATH: ReplicatedStorage.Items.ItemPacks.Gamepass.2026.PoseidonSet.Skins.Lights.Lantern.PoseidonHeart
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 386
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Poseidon Heart",
    6 | 		Desc = "",
    7 | 		Creator = "Dardemai",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #368
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Cosmetics.AuroranBunnyEars
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 450
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Auroran Bunny Ears",
    6 | 		Desc = "nyam nyam nyam >:3",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 77912379935869
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #369
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Cosmetics.CarrotBunnyEars
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 450
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Carrot Bunny Ears",
    6 | 		Desc = "nyam nyam nyam >:3",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 100915538026509
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #370
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Consumables.Cola.CarrotJuice
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 423
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Carrot Juice",
    6 | 		Desc = "My carrot juice brings all the bunnies to the yard.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #371
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Deployables.Landmine.BunnyLandmine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 414
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bunny Landmine",
    6 | 		Desc = "this is what you get when you mess with us",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #372
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Deployables.JumpPad.SunflowerJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 385
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Sunflower Jump Pad",
    6 | 		Desc = "+25 Sun",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #373
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Deployables.Floodlight.RubyEggFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 458
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ruby Egg Floodlight",
    6 | 		Desc = "The ornate, prized egg of the Bunny Queen. Its vibrant red glow mesmerizes you.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #374
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Deployables.Barrier.EasterBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 385
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Easter Barrier",
    6 | 		Desc = "BUNNEHS :DDDDDD",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #375
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Deployables.Sensor.ChickySensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 381
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Chicky Sensor",
    6 | 		Desc = "bok bok :v",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #376
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Deployables.SpeedPad.TrailSpeedPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 405
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Trail Speed Pad",
    6 | 		Desc = "Perfect for an afternoon promenade",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #377
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Deployables.Teleporter.BunnyHoleTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 453
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bunny Hole Teleporter",
    6 | 		Desc = "Don\'t thank me, thank the bunnies who made this extensive network of holes.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #378
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Lights.Lantern.ChocolateBunnyLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 410
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Chocolate Bunny Lantern",
    6 | 		Desc = "hey pal mind letting me go?",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #379
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Power.GrappleHook.CarrotGrapple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 412
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Carrot Grapple",
    6 | 		Desc = "a great source of nutrition for eyesight",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #380
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Easter.Skins.Utilities.Radar.EggToyRadar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Egg Toy Radar",
    6 | 		Desc = "Bunny technology has definitely come a long way since then.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #381
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.LunarNewYear.Cosmetics.LunarFortune
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 501
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lunar Fortune",
    6 | 		Desc = "I think this is a sign to start gambling",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 106726775566810,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 60000000,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #382
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.LunarNewYear.Cosmetics.MedallionLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 487
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Medallion Lantern",
    6 | 		Desc = "Imbues you with the spirit of the snake",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 300000,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #383
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.LunarNewYear.Skins.Deployables.Barrier.OrientalBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Oriental Barrier",
    6 | 		Desc = "May the year of the snake protect you from bad spirits",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #384
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.LunarNewYear.Skins.Deployables.SpeedPad.OrientalPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 414
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Oriental Pad",
    6 | 		Desc = "It\'s technically a bridge, but whatever",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 55,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #385
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.LunarNewYear.Skins.Deployables.Floodlight.PagodaFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 394
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Pagoda Floodlight",
    6 | 		Desc = "Illuminate a path",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #386
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.LunarNewYear.Skins.Deployables.Landmine.LilypadMine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 422
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lilypad Mine",
    6 | 		Desc = "Sometimes good fortune requires extensive measures",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #387
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.LunarNewYear.Skins.Lights.Lantern.PaperLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 420
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Paper Lantern",
    6 | 		Desc = "Let the lantern guide you on a path of wisdom",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #388
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.LunarNewYear.Skins.Power.GrappleHook.DraconicGrapple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 416
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Draconic Grapple",
    6 | 		Desc = "Roars with the breath of a dragon",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #389
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.LunarNewYear.Skins.Utilities.Decoy.RedEnvelopeDecoy
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 410
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Red Envelope Decoy",
    6 | 		Desc = "Wow I just got a 100 bucks!!",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #390
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.NewYears2024.Cosmetics.NewYearRays
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 470
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "New Year Rays",
    6 | 		Desc = "2025 is definitely going to be my year.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 75041051920569
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 80,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #391
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.NewYears2024.Cosmetics.FireworkPack
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 478
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Firework Pack",
    6 | 		Desc = "May cause first degree burns on your back.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 40,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #392
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.NewYears2024.Skins.Deployables.Floodlight.FireworkLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 411
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Firework Light",
    6 | 		Desc = "Goodbye 2024 Evade, Hello 2025 Evade.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #393
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Cosmetics.SpawnHalo
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 471
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Spawn Halo",
    6 | 		Desc = "Respawning has never felt greater",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 126411772146887
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #394
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Cosmetics.RingOfFireHalo
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 487
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ring of Fire Halo",
    6 | 		Desc = "The spirit of a thousand sword fighters lives within you",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 83016554141159
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 60,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #395
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Cosmetics.Tixsplosion
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 547
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Tixsplosion",
    6 | 		Desc = "i remember inviting all of my friends to play my games to earn tix, to then convert it to robux so i can buy a t-shirt",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 88222779054366
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 80,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #396
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.Barrier.BrickBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 424
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Brick Barrier",
    6 | 		Desc = "The ultimate wall built from trowels",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #397
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.JumpPad.RetroRobloxJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 403
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Retro Roblox Jump Pad",
    6 | 		Desc = "roblocks",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #398
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.Landmine.BombMine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 441
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bomb Mine",
    6 | 		Desc = "they\'re gonna have to glue you back together in hell",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #399
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.Sensor.HQSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 452
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "HQ Sensor",
    6 | 		Desc = "Bringing you live news on the Nextbots whereabouts from the Roblox HQ",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #400
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.SpeedPad.BridgeSpeedPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 441
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bridge Speed Pad",
    6 | 		Desc = "Granting speed boosts to robloxians since 2008",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #401
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.Teleporter.FirebrandGateway
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Firebrand Gateway",
    6 | 		Desc = "Ancient scriptures foretold of a powerful sword amongst the peaks of the heights",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #402
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.Teleporter.SpawnTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 397
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Spawn Teleporter",
    6 | 		Desc = "2008 is calling",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #403
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.Floodlight.TowerFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 426
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Tower Floodlight",
    6 | 		Desc = "Helping illuminate Crossroads, one tower at a time",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #404
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.Floodlight.DoomedspireFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 446
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Doomedspire Floodlight",
    6 | 		Desc = "You were too late trying to defend the base...",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #405
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Deployables.Floodlight.DoomspireFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 454
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Doomspire Floodlight",
    6 | 		Desc = "Warning: Fragile - may collapse from the slightest touch",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #406
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Lights.Lantern.HappyHomeLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 474
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Happy Home Lantern",
    6 | 		Desc = "It was the happiest home in Robloxia, until you converted his house into a lantern",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #407
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Lights.NightVisionGoggles.BCVision
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 430
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "BC Vision",
    6 | 		Desc = "builders club vision on the dailyshop for the poor people",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #408
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Power.GrappleHook.BazookaGrapple
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 430
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bazooka Grapple",
    6 | 		Desc = "Has a 0.0001% chance of firing a rocket",
    7 | 		Creator = "abrahamabugri & MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 35,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #409
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Utilities.Radar.Unorganized.BloxxerRadar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 426
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bloxxer Radar",
    6 | 		Desc = "locate your enemies and DESTROY them",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Gamepasses", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 99999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #410
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.OldRoblox.Skins.Utilities.Radar.Unorganized.RetroToyRadar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 439
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Retro Toy Radar",
    6 | 		Desc = "I MISS THE OLD ROBLOX.. BRUH SO NOSTALGIC.... - Join date 2017",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 25,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #411
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Birthday25.Cosmetics.FieryCandle
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 459
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Fiery Candle",
    6 | 		Desc = "IT\'S TIME TO CELEBRATE",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 92736922434350
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "EventShop",
   14 | 		Currency = "Points",
   15 | 		Price = 60,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #412
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Birthday25.Skins.Consumables.ReviveGrenade.HealingCupcake
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 415
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Healing Cupcake",
    6 | 		Desc = "TAKE A FACE FULL OF CUPCAKES >:O",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "EventShop",
   14 | 		Currency = "Points",
   15 | 		Price = 20,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #413
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Birthday25.Skins.Deployables.JumpPad.CakeJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 399
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cake Jump Pad",
    6 | 		Desc = "LET THEM EAT CAKE!",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "EventShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #414
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Birthday25.Skins.Deployables.Floodlight.CakeFloodlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 415
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cake Floodlight",
    6 | 		Desc = "Happy 3rd anniversary to Evade!!",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "EventShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #415
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Birthday25.Skins.Power.Breacher.SweetBreacher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 412
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Sweet Breacher",
    6 | 		Desc = "A portal to sweet sweet galaxy",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "EventShop",
   14 | 		Currency = "Points",
   15 | 		Price = 60,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #416
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Thanksgiving2025.Skins.Deployables.Floodlight.TurkeyLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 433
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Turkey Light",
    6 | 		Desc = "The warmth of the lantern keeps the nest warm and cozy.",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Event", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 3000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #417
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Thanksgiving2025.Skins.Deployables.Landmine.PieLandmine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 412
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Pie Landmine",
    6 | 		Desc = "They\'re not pies. They\'re bombs.",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Event", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 3000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #418
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Thanksgiving2025.Skins.Lights.Lantern.AcornLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 441
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Acorn Lantern",
    6 | 		Desc = "Revolutions in squrirel technology are soon to surpass ours.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Event", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 3000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #419
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Anniversary26.Cosmetics.AnniversaryFireworks
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Anniversary Fireworks",
    6 | 		Desc = "Happy 4th birthday Evade!!!",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 121533477626515
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "EventShop",
   14 | 		Currency = "Points",
   15 | 		Price = 60,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #420
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Anniversary26.Skins.Deployables.Barrier.PartyBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 379
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Party Barrier",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "EventShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #421
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Anniversary26.Skins.Lights.Lantern.AnniversaryStarLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 390
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Anniversary Star Lantern",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "EventShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #422
PATH: ReplicatedStorage.Items.ItemPacks.EventsDailyShop.Anniversary26.Skins.Power.Breacher.AnniversaryBreacher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 386
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Anniversary Breacher",
    6 | 		Desc = "",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Special", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "EventShop",
   14 | 		Currency = "Points",
   15 | 		Price = 40,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #423
PATH: ReplicatedStorage.Items.ItemPacks.Collab.TowerBlitz.Cosmetics.KugelblitzRing
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 519
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Kugelblitz Ring",
    6 | 		Desc = "A concentration of light so intense that it forms an event horizon. This is no theory, this is reality.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 60,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #424
PATH: ReplicatedStorage.Items.ItemPacks.Collab.TowerBlitz.Cosmetics.KugelblitzHorizon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Kugelblitz Horizon",
    6 | 		Desc = "what the scallop",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 1000000,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #425
PATH: ReplicatedStorage.Items.ItemPacks.Collab.TowerBlitz.Cosmetics.Infection
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 434
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Infection",
    6 | 		Desc = "The truth has been unsealed.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "DailyShop",
   14 | 		Currency = "Points",
   15 | 		Price = 30,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #426
PATH: ReplicatedStorage.Items.ItemPacks.Collab.TowerBlitz.Cosmetics.AvarianStaff
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 453
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Avarian Staff",
    6 | 		Desc = "A blessed staff from Avaria.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Normal", Overview = nil, Rarity = "" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = nil,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #427
PATH: ReplicatedStorage.Items.ItemPacks.Collab.TowerBlitz.Cosmetics.OverlordSet
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 519
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Overlord Set",
    6 | 		Desc = "The staff and crown of the infamous Overlord. Corrupted by his own ambitions, his success became his own downfall.",
    7 | 		Creator = "",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #428
PATH: ReplicatedStorage.Items.ItemPacks.Collab.TowerBlitz.Cosmetics.ArchangelWings
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 520
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Archangel Wings",
    6 | 		Desc = "The delicate, yet glistening wings of The Archangel, the last remaining people of Avaria.",
    7 | 		Creator = "",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #429
PATH: ReplicatedStorage.Items.ItemPacks.Collab.TowerBlitz.Cosmetics.VoidCorruption
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 611
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Void Corruption",
    6 | 		Desc = "It\'s misleading to believe that the void of corruption is a pitch black part of space, when in reality it\'s a dazzling spectacle of bright colors and light. Don\'t stare in it for too long.",
    7 | 		Creator = "",
    8 | 		Icon = 89801516113872
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #430
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier1.Tombstone
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 467
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Tombstone",
    6 | 		Desc = "F. Rest in peace.",
    7 | 		Creator = "clonemace",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #431
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier1.DemonHorns
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 460
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Demon Horns",
    6 | 		Desc = "im so evil.",
    7 | 		Creator = "nick200x",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #432
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier1.Candlehead
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 458
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Candlehead",
    6 | 		Desc = "An ornate candle.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #433
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier1.BatAttack
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 489
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bat Attack",
    6 | 		Desc = "WATCH OUT!!!! A SWARM OF BATS!!! HALP!!",
    7 | 		Creator = "DevChams",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #434
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier1.Baghead
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 504
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Baghead",
    6 | 		Desc = "Who said that using empty bean sacks weren\'t sylish?",
    7 | 		Creator = "FartSquad166",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #435
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier1.CursedEye
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 458
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cursed Eye",
    6 | 		Desc = "Do you wanna have a bad time?",
    7 | 		Creator = nil,
    8 | 		Icon = 11353302964
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #436
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier5.PinkUFOAbduction
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 491
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Pink UFO Abduction",
    6 | 		Desc = "A grand saucer interested in partaking a piece of your body.",
    7 | 		Creator = "omuq",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #437
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier5.Cauldronhead
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 504
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cauldronhead",
    6 | 		Desc = "A mysterious concoction boiling ontop of a head.",
    7 | 		Creator = "FartSquad166",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #438
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier5.BlueUFOAbduction
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 495
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue UFO Abduction",
    6 | 		Desc = "A swarm of saucers interested in partaking a piece of your body.",
    7 | 		Creator = "omuq",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #439
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier5.HauntedIridescence
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 511
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Haunted Iridescence",
    6 | 		Desc = "A colorful spectrum of halloween-themed colors and eerie ghosts.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 11353371106
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #440
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier5.EyeCorruption
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 505
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eye Corruption",
    6 | 		Desc = "Sentient eyes cover your body like a plague. Nope, not an eteiri infection!",
    7 | 		Creator = "Subzeroto",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #441
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier5.HellishGrip
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 452
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hellish Grip",
    6 | 		Desc = "Back to the underworld you go.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #442
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier6.GhostFriend
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ghost Friend",
    6 | 		Desc = "Who said all ghosts were evil? Some just want friends :(",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #443
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier6.DarkTendrils
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 521
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dark Tendrils",
    6 | 		Desc = "These tentacle-like tendrils originate from a portal void from a parallel universe.",
    7 | 		Creator = "danncie",
    8 | 		Icon = 11353368350
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #444
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier6.DragonSkull
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dragon Skull",
    6 | 		Desc = "Dracarys",
    7 | 		Creator = "JerryR0X",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #445
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier6.MechanicalScythe
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 543
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Mechanical Scythe",
    6 | 		Desc = "Perfect for reaping the souls of your enemies, with the most high-tech available reapers.",
    7 | 		Creator = "Taz3r_X",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #446
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.HalloweenExclusive.GoldTicket
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 520
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gold Ticket",
    6 | 		Desc = "Congratulations on unlocking >3000 tickets in the first collaborative event!",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #447
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.HalloweenExclusive.OrangeTicket
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 524
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Orange Ticket",
    6 | 		Desc = "Congratulations on earning more than 1000 Tickets! That is quite the number.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #448
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.HalloweenExclusive.RedTicket
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 491
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Red Ticket",
    6 | 		Desc = "Congratulations on earning more than 300+ Tickets!",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #449
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.HalloweenExclusive.CarvedPumpkinHead
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 524
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Carved Pumpkin Head",
    6 | 		Desc = "Celebrate the spooky Halloween season with this carved pumpkin head.",
    7 | 		Creator = "KoreWaAkaDesu",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Exotic" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 9999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #450
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.HalloweenExclusive.HallowedSpecters
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 460
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hallowed Specters",
    6 | 		Desc = "Thanks for contributing!",
    7 | 		Creator = nil,
    8 | 		Icon = 10642208994
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #451
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier4.AmethystStaff
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 529
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Amethyst Staff",
    6 | 		Desc = "The fabled scepter of Bobo the IV, before his eventual passing at Tudor Manor.",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #452
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier4.PhantomBlades
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 478
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Phantom Blades",
    6 | 		Desc = "GUHHHHHHHHHHHHHHH!!! -Impaled by several ghost weapons..",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #453
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier4.HellfirePortal
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 509
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hellfire Portal",
    6 | 		Desc = "All it takes is 10 obsidian blocks and a flint and steel.",
    7 | 		Creator = "Every1sCircunyation",
    8 | 		Icon = 11353367353
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #454
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier4.BluefirePortal
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 535
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bluefire Portal",
    6 | 		Desc = "All it takes is 10 glowstone blocks and a water bucket. Made by Every1sCircunyation",
    7 | 		Creator = "Every1sCircunyation",
    8 | 		Icon = 11353470385
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #455
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier4.WretchedWings
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 500
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Wretched Wings",
    6 | 		Desc = "Wings of the damned, made from the bones of goblins.",
    7 | 		Creator = "omuq",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #456
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier4.Monoculi
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 443
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Monoculi",
    6 | 		Desc = "seek",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #457
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier4.GhostAbduction
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 453
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ghost Abduction",
    6 | 		Desc = "He just wants a friend ;-;",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #458
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier7.IllusionEyes
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 470
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eye Illusions",
    6 | 		Desc = "Are they real or fake? GET OUT OF MIND!!!!",
    7 | 		Creator = nil,
    8 | 		Icon = 11353472646
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #459
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier7.Frankenstein
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 487
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Frankenstein",
    6 | 		Desc = "An abomination that was created as a result of a mad scientist.",
    7 | 		Creator = "Vrnis",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #460
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier7.ElectrifyingGuitar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 482
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Electrifying Guitar",
    6 | 		Desc = "For all your rockin\' needs.",
    7 | 		Creator = "Vrnis",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #461
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier7.BananaSuit
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 436
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Banana Suit",
    6 | 		Desc = "ba na na.",
    7 | 		Creator = "Vrnis",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #462
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier7.AlchemistBelt
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Alchemist Belt",
    6 | 		Desc = "Drink all of it for free battlepass progress.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #463
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier7.BloodMoon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 537
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blood Moon",
    6 | 		Desc = "An ominous bleeding moon. It radiates a sense of doom and despair as blood rains down from the sky.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 11353372060
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #464
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier3.ToxicInferno
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 535
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Toxic Inferno",
    6 | 		Desc = "A blazing fire of neon green, this probably isn\'t good for your health.",
    7 | 		Creator = "MasonXono",
    8 | 		Icon = 11353407906,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #465
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier3.GreenHallowedFace
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 513
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Green Hallowed Face",
    6 | 		Desc = "A possessed face. Twisted and unnerving in a toxic green color.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #466
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier3.OrangeHallowedFace
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 516
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Orange Hallowed Face",
    6 | 		Desc = "A possessed face. Twisted and unnerving. In a vivid orange color.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #467
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier3.BlueHallowedFace
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 526
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Hallowed Face",
    6 | 		Desc = "A possessed face. Twisted and unnerving. In a hauntingly cold and dark color.",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #468
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier3.FungalOvergrowth
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 634
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Fungal Overgrowth",
    6 | 		Desc = "Exposure to infectious spores can lead to an uncontrollable and rapid growth of fungi and other biological matter. Stalk-like structures of chitin replace muscle and tissue in an extremely painful process.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #469
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier3.DemonWings
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 485
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Demon Wings",
    6 | 		Desc = "Monstrous appendages growing out of your back.",
    7 | 		Creator = "clonemace",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 45,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #470
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier2.OminousDemise
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 496
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ominous Demise",
    6 | 		Desc = "Don\'t let the instrusive thoughts get the best of you.",
    7 | 		Creator = "MasonXono",
    8 | 		Icon = 11353369618
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #471
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier2.DualBoneSwords
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 495
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dual Bone Swords",
    6 | 		Desc = "ARGHHHHH... where be my trusty swords...",
    7 | 		Creator = "clonemace",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #472
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier2.VampireOutfit
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 502
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Vampire Outfit",
    6 | 		Desc = "I stole this fashionable outfit from a coffin from some guy called Dracula.",
    7 | 		Creator = "Hrouko",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #473
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier2.ImpaledHead
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 473
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Impaled Head",
    6 | 		Desc = "Storing your machete in convenient places...",
    7 | 		Creator = "nick200x",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #474
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier2.SpiderInfestation
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 478
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Spider Infestation",
    6 | 		Desc = "People with arachnophobia crawling in their beds rn.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #475
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Halloween2022.Cosmetics.Tier2.WitchHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 518
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Witch Hat",
    6 | 		Desc = "A pointy hat all witches use, excluding the wicked witch of the west.",
    7 | 		Creator = "nick200x",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #476
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier1.MintyExplosion
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 501
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Minty Explosion",
    6 | 		Desc = "Peppermint candy and candy canes. Scrumptious.",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 11916773394
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #477
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier1.SantaHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 524
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Santa Hat",
    6 | 		Desc = "There is no Christmas without the iconic hat everybody knows and loves.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #478
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier1.Snowflakes
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 486
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Snowflakes",
    6 | 		Desc = "Budget cosmetic since you can\'t afford an unusual yet.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #479
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier1.FestiveHeadband
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 459
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Festive Headband",
    6 | 		Desc = "A cute festive headband.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #480
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier1.CozyScarf
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 439
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cozy Scarf",
    6 | 		Desc = "Snug.",
    7 | 		Creator = "clonemace",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #481
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier1.BlizzardyStorm
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 475
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blizzardy Storm",
    6 | 		Desc = "Generic snow unusual",
    7 | 		Creator = "SnailCirculation",
    8 | 		Icon = 11916778459
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #482
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier5.FrostFlame
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 500
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Frost Flame",
    6 | 		Desc = "Frost flame? what kind of contradictory name is that??.",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 11916774023
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #483
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier5.VintageHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 491
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Vintage Hat",
    6 | 		Desc = "For when you want to look like an old guy",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #484
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier5.BackpackGift
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 500
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Backpack Gift",
    6 | 		Desc = "Bring your gifts along with you on your back.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #485
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier6.GlowingTree
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 478
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Glowing Tree",
    6 | 		Desc = "Magic, it\'s the spirit of Christmas!",
    7 | 		Creator = "Ciege",
    8 | 		Icon = 11916769135
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #486
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier6.XMasTreeHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 455
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Xmas Tree Hat",
    6 | 		Desc = "Least tacky xmas cosmetic",
    7 | 		Creator = "omuq",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #487
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier6.CaneDaggers
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 438
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cane Daggers",
    6 | 		Desc = "kill.",
    7 | 		Creator = "sc6uth",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #488
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier6.SnowmanHead
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 481
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Snowman Head",
    6 | 		Desc = "We beheaded Frosty for you to enjoy this.",
    7 | 		Creator = "KoreWaAkaDesu",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #489
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier6.CandyCaneShotgun
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 498
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Candy Cane Shotgun",
    6 | 		Desc = "You\'ve done ho\'d your last ho",
    7 | 		Creator = "KoreWaAkaDesu",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #490
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier6.PortableChimney
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 535
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Portable Chimney",
    6 | 		Desc = "Keep warm this holiday season by directly bringing the warmth with you.",
    7 | 		Creator = "Jaguar4444YT",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #491
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier4.ShimmeringCoronet
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Shimmering Coronet",
    6 | 		Desc = "An elegant intangible crown.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 11916780549
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #492
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier4.SuspendedLights
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 458
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Suspended Lights",
    6 | 		Desc = "pretteh.",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 11916780026
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #493
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier4.FestiveAntlers
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 491
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Festive Antlers",
    6 | 		Desc = "No deers were hurt in the process.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #494
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier4.HangingMistletoe
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 482
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hanging Mistletoe",
    6 | 		Desc = "Hey look, just us two under the mistletoe.",
    7 | 		Creator = "Magikarp",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #495
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier4.BoboSnowmanPal
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 440
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bobo Snowman Pal",
    6 | 		Desc = ":)",
    7 | 		Creator = "Aurrous",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #496
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier7.MelodicalHarp
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 507
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Melodical Harp",
    6 | 		Desc = "The tune of the harpsichord has magical properties.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #497
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier7.JollyScythe
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 515
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Jolly Scythe",
    6 | 		Desc = "Hack at your enemies with the joyous feelings of the holidays!",
    7 | 		Creator = "Z_niy",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #498
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier7.WinterChains
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 508
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Winter Chains",
    6 | 		Desc = "Chained to the icy depths of the winter realm.",
    7 | 		Creator = "HardyAsRock & AllNewL0ws",
    8 | 		Icon = 11916779030
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #499
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier7.GlaciusSet
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Glacius Set",
    6 | 		Desc = "The omnipotent crown and staff of Glacius.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Exotic" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #500
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier7.BackCrank
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 552
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Back Crank",
    6 | 		Desc = "Wind-up toys have always been an integral part of our childhoods. Now it\'s your turn to be the toy.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #501
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier7.AngelicRedemption
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 481
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Angelic Redemption",
    6 | 		Desc = "Ascend to a plane beyond reality.",
    7 | 		Creator = "sc6uth",
    8 | 		Icon = 11916852423
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #502
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier3.FrigidPerception
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 483
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Frigid Perception",
    6 | 		Desc = "See through the eyes of Glacius.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 11916781787
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #503
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier3.SubzeroBurst
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 514
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Subzero Burst",
    6 | 		Desc = "Upon reaching absolute zero, ice molecules will burst at the seams.",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 11916781171
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #504
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier3.GingerbreadGuards
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 483
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gingerbread Guards",
    6 | 		Desc = "Defend the house with all you got.",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #505
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier3.CandyConfetti
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 479
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Candy Confetti",
    6 | 		Desc = "A swirl of delicious candy all around you.",
    7 | 		Creator = "DevChams",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #506
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier3.SockStocking
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 483
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Sock Stocking",
    6 | 		Desc = "All I want for Christmas is someone to love me.",
    7 | 		Creator = "nick200x",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #507
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier2.XmasBurst
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 461
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Xmas Burst",
    6 | 		Desc = "merry xmas.",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 11916771701
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #508
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier2.GlacialOutburst
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 495
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Glacial Outburst",
    6 | 		Desc = "Who knew that glaciers could burst like this?",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 11916865929
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #509
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier2.CarrotNose
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 445
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Carrot Nose",
    6 | 		Desc = "Got your nose!!",
    7 | 		Creator = "omuq",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #510
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier2.SantasSpecter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 520
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Santa\'s Specter",
    6 | 		Desc = "Ho ho ho! Santa has a little gift for you, called DEATH.",
    7 | 		Creator = "Jaguar4444YT",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #511
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier2.OrnamentBandolier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 507
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ornament Bandolier",
    6 | 		Desc = "Quick and easy access to your ornaments to shatter upon your foes.",
    7 | 		Creator = "nick200x",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #512
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier2.CandyFlintlock
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 470
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Candy Flintlock",
    6 | 		Desc = "Shoot the elves who disobey.",
    7 | 		Creator = "FartSquad166",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #513
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier2.BackMenorah
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 484
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Back Menorah",
    6 | 		Desc = "Celebrate Hannukah with this backside menorah.",
    7 | 		Creator = "Kapurikon",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #514
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.XMASExclusive.GiftPair
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 485
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gift Pair",
    6 | 		Desc = "Congratulations on earning 4000+ Gifts!",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #515
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.XMASExclusive.GreenGift
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 486
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Green Gift",
    6 | 		Desc = "Congratulations on earning 1000+ Gifts!",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #516
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.XMASExclusive.GiftStack
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 486
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gift Stack",
    6 | 		Desc = "Congratulations on earning 7000+ Gifts!",
    7 | 		Creator = nil,
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #517
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.XMASExclusive.KhanOfWinter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 480
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Khan of Winter",
    6 | 		Desc = "Thanks for helping us out homie",
    7 | 		Creator = "your mother",
    8 | 		Icon = 11916772337
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #518
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier8.SantaSuit
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 499
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Santa Suit",
    6 | 		Desc = "We stole this from Santa\'s workshop, so you better be content.",
    7 | 		Creator = "KoreWaAkaDesu",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #519
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier8.GiftHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 465
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gift Hat",
    6 | 		Desc = "An exquisite top hat for the season.",
    7 | 		Creator = "Magikarp",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #520
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier8.GiftSack
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 483
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gift Sack",
    6 | 		Desc = "Naughty list? Never of that!",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #521
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier8.AuroraBorealis
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 506
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Aurora Borealis",
    6 | 		Desc = "A captivating and eye-opening experience.",
    7 | 		Creator = "bluirre & SnailCirculation",
    8 | 		Icon = 11916768467
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #522
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier8.PermafrostStaff
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 535
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Permafrost Staff",
    6 | 		Desc = "The many apostles of Glacius used their knowledge of frost to conjure up blizzards using this staff.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #523
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier8.GildedJetpack
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 449
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gilded Jetpack",
    6 | 		Desc = "Take to the skies",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #524
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier8.DualCandyCanes
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 533
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Dual Candy Canes",
    6 | 		Desc = "Prepare for the winter season by equipping yourself with handy candy canes.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #525
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier8.NorthPoleSign
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 489
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "North Pole Sign",
    6 | 		Desc = "We stole this from Santa\'s workshop in the north.",
    7 | 		Creator = "clonemace",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #526
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier9.Wreath
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 467
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Wreath",
    6 | 		Desc = "Wear it around your head or something idk.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #527
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier9.HoverTrain
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 457
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hover Train",
    6 | 		Desc = "The Polar Express in 2062.",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #528
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier9.HollyBerryInfection
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 500
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Holly Berry Infection",
    6 | 		Desc = "He swallowed a holly berry seed and it grew in his stomach.",
    7 | 		Creator = "pokchoy",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #529
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier9.GrinchMask
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 457
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Grinch Mask",
    6 | 		Desc = "Mischevious and devious.",
    7 | 		Creator = "pokchoy",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #530
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier9.GiftSled
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 473
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gift Sled",
    6 | 		Desc = "The naughty list was the least of my worries.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #531
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier10.AuroranStag
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 516
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Auroran Stag",
    7 | 		Desc = "The elegant mystical antlers of the fabled stag.",
    8 | 		Creator = "ShinonArtZ",
    9 | 		Icon = 11916775812
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #532
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier10.VerdantStag
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 516
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Verdant Stag",
    7 | 		Desc = "The elegant mystical antlers of the fabled stag.",
    8 | 		Creator = "ShinonArtZ",
    9 | 		Icon = 11916776667
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #533
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier10.GildedStag
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 515
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Gilded Stag",
    7 | 		Desc = "The elegant mystical antlers of the fabled stag.",
    8 | 		Creator = "ShinonArtZ",
    9 | 		Icon = 11916774995
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #534
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier10.OrnamentHook
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 449
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ornament Hook",
    6 | 		Desc = "Become the ornament.",
    7 | 		Creator = nil,
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #535
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier10.BlueWindbreaker
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 478
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Blue Windbreaker",
    6 | 		Desc = "Excellent for staying warm this season.",
    7 | 		Creator = "vvostrikov",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #536
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier10.CandyCrown
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 541
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Candy Crown",
    6 | 		Desc = "An ornate crown made from a thousand melted candy canes, each from the 7 kingdoms.",
    7 | 		Creator = "Magikarp",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #537
PATH: ReplicatedStorage.Items.ItemPacks.Events.2022.Xmas2022.Cosmetics.Tier10.SatchelOfNoobs
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 474
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Satchel of Noobs",
    6 | 		Desc = "Capture them and feast on their souls.",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #538
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier1.ChainedCoffin
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 518
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Chained Coffin",
    6 | 		Desc = "Here rests those who died waiting for Halloween and Overhaul.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 99999999990,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #539
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier1.ScarletSlash
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 475
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Scarlet Slash",
    6 | 		Desc = "All that for a single drop of blood?",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 15230292120
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #540
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier1.SoulSnatcher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Soul Snatcher",
    6 | 		Desc = "Woops got your soul. Haha",
    7 | 		Creator = "ElectroMeltdown",
    8 | 		Icon = 15230291936
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #541
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier2.SealedBook
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 529
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Sealed Book",
    6 | 		Desc = "Chanting one line within this book will cause the four horsemen of the apocalypse.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 99999999990,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #542
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier3.ClownButcher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 440
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Clown Butcher",
    6 | 		Desc = "clown from ohio",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #543
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier3.DemonHelmet
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 454
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Demon Helmet",
    6 | 		Desc = "One ring to rule them all.",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #544
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier3.SoulExtinguisher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Soul Extinguisher",
    6 | 		Desc = "Vacuum up the dead.",
    7 | 		Creator = "vvostrikov",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 99999999990,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #545
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier3.AzureMistWatcher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 465
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Azure Mist Watcher",
    6 | 		Desc = "Eyes in the fog.",
    7 | 		Creator = "Electromeltdown",
    8 | 		Icon = 15230292790
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #546
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier3.CrimsonMistWatcher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 467
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Crimson Mist Watcher",
    6 | 		Desc = "Eyes in the fog.",
    7 | 		Creator = "Electromeltdown",
    8 | 		Icon = 15230292943
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #547
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier3.NoxiousAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Noxious Aura",
    6 | 		Desc = "Green aura with flies",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 130958590010587
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #548
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier4.PhantomHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 459
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Phantom Hat",
    6 | 		Desc = "if its a ghost then how can u wear it",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #549
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier4.AbyssalEyes
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 479
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Abyssal Eyes",
    6 | 		Desc = "From the deepest parts of the abyss.",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 120842068158373
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #550
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier4.DemonIris
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 482
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Demon Iris",
    6 | 		Desc = "Eye of HIM from the far lands of Mordor.",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 15230308515
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #551
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier4.HexerIris
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 482
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Hexer Iris",
    6 | 		Desc = "Eye of HIM from the far lands of Mordor.",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 15230308685
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #552
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier4.PlaguedIris
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 484
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Plagued Iris",
    6 | 		Desc = "Eye of HIM from the far lands of Mordor.",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 15230308826
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #553
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier5.MechanicalWitchHat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 462
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Mechanical Witch Hat",
    6 | 		Desc = "Is this thing battery powered?",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #554
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier5.SoulRifter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 477
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Soul Rifter",
    6 | 		Desc = "Ascending to a different dimension",
    7 | 		Creator = "Master_LightDark",
    8 | 		Icon = 15230309015
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #555
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier6.CalmingMask
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 446
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Calming Mask",
    6 | 		Desc = "luh calm fit",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #556
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier6.ScarletsStrike
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 449
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Scarlet\'s Strike",
    6 | 		Desc = "\'Tis but a scratch.",
    7 | 		Creator = "wlfguy3",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #557
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier6.HeadlessHorsemanHeadtaker
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 504
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Headless Horseman Headtaker",
    6 | 		Desc = "You fool, what have you done?!",
    7 | 		Creator = "ElectroMeltdown",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 99999999990,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #558
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier6.RuinousArcana
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 473
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ruinous Arcana",
    6 | 		Desc = "The ritual has begun. The end is nigh.",
    7 | 		Creator = "cuj_o",
    8 | 		Icon = 15230309211
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #559
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier6.RunicRitual
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 488
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Runic Ritual",
    6 | 		Desc = "Is it too late to return from the dark side?",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 15230309357
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999990,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #560
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier7.NuclearFuture
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 495
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Nuclear Future",
    7 | 		Desc = "A grim reminder of our future.",
    8 | 		Creator = "abrahamabugri",
    9 | 		Icon = 15230309530
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 99999999990,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #561
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.Tier7.BatwingBasher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 484
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Batwing Basher",
    6 | 		Desc = "Rock\'n\'roll from the grave.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 99999999990,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #562
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Cosmetics.HLWN24EXCLUSIVE.Vortex
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 460
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Paranormal Vortex",
    6 | 		Desc = "Thanks for contributing!",
    7 | 		Creator = nil,
    8 | 		Icon = 15230309704
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #563
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Consumables.Cola.AbyssalEssence
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 464
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Abyssal Essence",
    6 | 		Desc = "This substance has been taken from the Bermuda Triangle during the Witching Hour.",
    7 | 		Creator = "ANUOHM",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #564
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Consumables.Cola.DeathsBeverage
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 514
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Death\'s Beverage",
    6 | 		Desc = "Normally this would kill someone, but because you are an epic skibidi sigma from ohio, it will only make you stronger.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #565
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Consumables.Cola.WitchCola
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 418
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Witch Cola",
    6 | 		Desc = "Not to be confused with Witch\'s Brew",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #566
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Barrier.AutumnBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 404
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Autumn Barrier",
    6 | 		Desc = "Pretty fall leaves",
    7 | 		Creator = "Noskademo",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #567
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Barrier.BarrierOfCatastrophe
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 466
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Barrier of Catastrophe",
    6 | 		Desc = "A forcefield that separates the real world from the Lovecraftian world.",
    7 | 		Creator = "ANUOHM",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #568
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Barrier.Lychgate
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 409
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lychgate",
    6 | 		Desc = "Are you ready for your burial?",
    7 | 		Creator = "VerticoZ",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #569
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Barrier.PylonBarricade
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 407
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Pylon Barricade",
    6 | 		Desc = "scary barrier skin",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #570
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Beacon.KrakensEye
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 415
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Kraken\'s Eye",
    6 | 		Desc = "Awaken the abyssal beast.",
    7 | 		Creator = "ANUOHM",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #571
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Floodlight.AltarOfTheLeviathan
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 423
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Altar of The Leviathan",
    6 | 		Desc = "Let the Kraken light the way.",
    7 | 		Creator = "ANUOHM",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #572
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Floodlight.CandleLamp
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 412
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Candle Lamp",
    6 | 		Desc = "A tried and tested method source of light.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #573
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Floodlight.LavaLamp
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 411
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Lava Lamp",
    6 | 		Desc = "Still no idea what they put in these things",
    7 | 		Creator = "omuq",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #574
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Floodlight.ScorchingScarecrow
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 419
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Scorching Scarecrow",
    6 | 		Desc = "HALP MEHH IM ON FIRE!!!",
    7 | 		Creator = "ElectroMeltdown",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #575
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Floodlight.SkullLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 428
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Skull Light",
    6 | 		Desc = "Hold on let me defile this corpse real quick",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #576
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.JumpPad.CoffinJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 422
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Coffin Jump Pad",
    6 | 		Desc = "Defiling graves is not very cool bro.",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #577
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Landmine.CobwebTrap
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cobweb Trap",
    6 | 		Desc = "Get those sneaky nextbots a taste of justice by getting them temporarily caught in a tangle of webs.",
    7 | 		Creator = "clonemace",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #578
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Landmine.DeadmansDemise
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 453
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Deadmans Demise",
    6 | 		Desc = "They\'re gonna have to glue you back together. IN HELL.",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #579
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Landmine.JackInTheBox
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Jack In The Box",
    6 | 		Desc = "Not to be confused with the fast food chain",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #580
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Landmine.SpiderTrap
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Spider Trap",
    6 | 		Desc = "For people with arachnophobia and fear of robots",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #581
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Sensor.AlienSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 407
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Alien Sensor",
    6 | 		Desc = "Glorp? Zeep? Zorb.",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #582
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Sensor.AngelStatue
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 404
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Angel Statue",
    6 | 		Desc = "Praying won\'t save you",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #583
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Sensor.EvilToyDuck
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 418
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Evil Toy Duck",
    6 | 		Desc = "A dream before Christmas, ruined.",
    7 | 		Creator = "KoreWaAkaDesu",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #584
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Sensor.GhostCatcher
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 483
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ghost Catcher",
    6 | 		Desc = "This device originally intended for catching ghosts emits a small beeping noise in the presence of a nextbot.",
    7 | 		Creator = "Taz3r_X",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #585
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Sensor.SeekingEye
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 408
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Seeking Eye",
    6 | 		Desc = "A lost eye of a wandering monster...",
    7 | 		Creator = "Taz3r_X",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #586
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Sensor.SpiderEye
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 431
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Spider Eye",
    6 | 		Desc = "The all-seeing eye of the spider. Edgy but cool.",
    7 | 		Creator = "4it3dm1",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #587
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.SpeedPad.NuclearSpeed
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 420
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Nuclear Speed",
    6 | 		Desc = "Also alters your genetic code",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #588
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.SpeedPad.PadOfStyx
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 420
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Pad of Styx",
    6 | 		Desc = "Aids you in traversing the wasteland",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #589
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.SpeedPad.SpilledCauldron
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 503
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Spilled Cauldron",
    6 | 		Desc = "A concoction of mysterious and deadly potions resulted in a substance capable of giving the user heightened agility.",
    7 | 		Creator = "LordSilverius",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #590
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Teleporter.Gravesite
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 407
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gravesite",
    6 | 		Desc = "About as dead as this game",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #591
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Teleporter.RingTV
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 405
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ring TV",
    6 | 		Desc = "Don\'t watch the tapes",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #592
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Teleporter.RunicTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 470
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Runic Teleporter",
    6 | 		Desc = "Runes from a bygone age that hold magical powers. Generic trope alert",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #593
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Deployables.Teleporter.Telespell
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 449
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Telespell",
    6 | 		Desc = "Only a master of the dark arts can properly master this unstable spell.",
    7 | 		Creator = "Taz3r_X",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #594
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.Flashlight.CursedFlashlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 428
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cursed Flashlight",
    6 | 		Desc = "Do not look at the operational end of the device.",
    7 | 		Creator = "Megalodon016",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 20,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #595
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.Flashlight.DraconicLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 400
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Draconic Light",
    6 | 		Desc = "Dracarys.",
    7 | 		Creator = "SnowyClown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #596
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.Flashlight.EntropyFlashlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 464
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Entropy Flashlight",
    6 | 		Desc = "Using this item in abundance speeds up the heat death of the universe",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #597
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.Lantern.LeviathanLocket
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 455
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Locket of the Leviathan",
    7 | 		Desc = "I shouldn\'t have used that truffle worm..",
    8 | 		Creator = "ANUOHM",
    9 | 		Icon = 0
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 99999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #598
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.Lantern.OldCandelabra
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 410
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Old Candelabra",
    6 | 		Desc = "It\'s seen better days.",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #599
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.Lantern.SoulLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 426
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Soul Lantern",
    6 | 		Desc = "Read the stories of our past. Made by Kapurikon",
    7 | 		Creator = "Kapurikon",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #600
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.Lantern.TheEnd
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 404
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "The End",
    6 | 		Desc = "Designed for edgelords",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #601
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.Lantern.WardingLantern
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 456
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Warding Lantern",
    6 | 		Desc = "The souls of the damned make for a pretty good light source. Made by danncie",
    7 | 		Creator = "danncie",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #602
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.NightVisionGoggles.BatVision
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 403
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bat Vision",
    6 | 		Desc = "I\'m literally Batman",
    7 | 		Creator = "LordSilverius",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #603
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.NightVisionGoggles.DestroyerOfWorlds
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 406
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Destroyer of Worlds",
    6 | 		Desc = "I am Death.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #604
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.NightVisionGoggles.OneEyedSeeker
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 453
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "One Eyed Seeker",
    6 | 		Desc = "Don\'t listen to its ramblings of a certain \'truth\'...",
    7 | 		Creator = "ElectroMeltdown",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #605
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.NightVisionGoggles.WitchGoggles
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 424
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Witch Goggles",
    6 | 		Desc = "May result in radiation poisoning.",
    7 | 		Creator = "4it3dm1 & ig57",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #606
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Lights.NightVisionGoggles.WrithingEyes
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 422
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Writhing Eyes",
    6 | 		Desc = "These goggles have a mind of its own",
    7 | 		Creator = "misvin",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #607
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Power.GrappleHook.SkeletalGrasp
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 456
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Skeletal Grasp",
    6 | 		Desc = "Always remember to kill the Guardian before entering the dungeon.",
    7 | 		Creator = "ElectroMeltdown",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #608
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Power.GrappleHook.SoulHook
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 449
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Soul Hook",
    7 | 		Desc = "Imbued with ancient lovecraftian cursed energy",
    8 | 		Creator = "ANUOHM",
    9 | 		Icon = 0
   10 | 	},
   11 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 99999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #609
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Power.GrappleHook.ItsGrip
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 395
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Its Grip",
    6 | 		Desc = "Found in a sewer",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #610
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Utilities.Decoy.Necromonicon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 439
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Necromonicon",
    6 | 		Desc = "I\'m gonna give you a bomb head. Go run at that wizard.",
    7 | 		Creator = "BoomBits09",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #611
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Utilities.Decoy.BoboVoodooDoll
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 421
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bobo Voodoo Doll",
    6 | 		Desc = "Don\'t throw this thing in lava",
    7 | 		Creator = "killyan470",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #612
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Utilities.Radar.BPM5000
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 469
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "BPM-5000",
    6 | 		Desc = "Did you know that Nextbots have complete skeletal and muscular systems, like us?",
    7 | 		Creator = "ElectroMeltdown",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #613
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Utilities.Radar.ParasiticRadar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 463
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Parasitic Radar",
    6 | 		Desc = "A grotesque parasitic creature mimics the functions of an ordinary radar",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #614
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Halloween2024.Skins.Utilities.Radio.SpiritBox
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 427
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Spirit Box",
    6 | 		Desc = "Allows for communication with Nextbots (lies).",
    7 | 		Creator = "SAM6670",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Halloween", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #615
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Valentines2024.Cosmetics.AtomicHeart
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 474
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Atomic Heart",
    6 | 		Desc = "My heart burns radioactively just like U-235.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 16371185278
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #616
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Valentines2024.Cosmetics.CupidMirage
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 458
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Cupid Mirage",
    7 | 		Desc = "Do you really love me?",
    8 | 		Creator = "MontiCats",
    9 | 		Icon = 0
   10 | 	},
   11 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #617
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Valentines2024.Cosmetics.EclipseLove
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 479
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Eclipse Love",
    7 | 		Desc = "I wrote about you in my diary.",
    8 | 		Creator = "Snowyclown0",
    9 | 		Icon = 16371186145
   10 | 	},
   11 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #618
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Valentines2024.Cosmetics.PureLove
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Pure Love",
    7 | 		Desc = "I wrote about you in my diary.",
    8 | 		Creator = "Snowyclown0",
    9 | 		Icon = 16371186444
   10 | 	},
   11 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #619
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Valentines2024.Cosmetics.TeddyInfestation
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 467
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Teddy Infestation",
    6 | 		Desc = "3 more months until we all welcome Graduation.",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #620
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Valentines2024.Cosmetics.CupidsArrow
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 516
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Cupids Arrow",
    7 | 		Desc = "A shot directly from a cupid. Strangely enough, it doesn\'t hurt.",
    8 | 		Creator = "abrahamabugri",
    9 | 		Icon = 16371185593
   10 | 	},
   11 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 9999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #621
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER1.ReindeerHood
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 476
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Reindeer Hood",
    6 | 		Desc = "You\'ll go down in history",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #622
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER2.XmasTreeSuit
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 456
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Xmas Tree Suit",
    6 | 		Desc = "You look like a laughing stock",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 100,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Cosmetic" },
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #623
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER2.EtherealSaucer
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 505
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ethereal Saucer",
    6 | 		Desc = "An everflowing cup of the essence of winter.",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 101457882527178,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #624
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER2.OrnamentalHelmet
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 497
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ornamental Helmet",
    6 | 		Desc = "Allows you to shatter into 5 million pieces",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #625
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER3.IceCrown
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 484
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ice Crown",
    6 | 		Desc = "Grants you the ability to go insane.",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #626
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER3.GleamingConstellation
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 553
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Festive Constellation",
    6 | 		Desc = "Can\'t be found in the night sky, but it can be found in this years battlepass.",
    7 | 		Creator = "EncryptedFolder",
    8 | 		Icon = 90341999892074,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #627
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER4.JollyGuitar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 477
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Jolly Guitar",
    6 | 		Desc = "It\'s the best time of the year.",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #628
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER4.Candynado
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 479
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Candynado",
    6 | 		Desc = "The ultimate sugarrush",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 95360634713334,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #629
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER4.Snownado
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 481
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Snownado",
    6 | 		Desc = "The ultimate brainfreeze",
    7 | 		Creator = "AllNewL0ws",
    8 | 		Icon = 118608431351473,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #630
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER5.TatteredCape
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 507
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Tattered Cape",
    6 | 		Desc = "Dedicated to those who served in the battle of the North Pole",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #631
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER5.AuroranTophat
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 482
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Auroran Tophat",
    6 | 		Desc = "Good day chap!",
    7 | 		Creator = "YourDeadlyDesire",
    8 | 		Icon = 79865900380656,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #632
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER5.CandyCaneAura
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 463
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Candy Cane Aura",
    6 | 		Desc = "Anybody got a sweet tooth?",
    7 | 		Creator = "7Macros",
    8 | 		Icon = 80811087061395
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 100,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	EquipInfo = { SlotType = "Unusual" },
   19 | 	CosmeticInfo = { Unusual = true }
   20 | }


========================================
MATCH #633
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER6.JollyCrown
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 517
========================================

--- SOURCE LINES 1-22 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Jolly Crown",
    7 | 		Desc = "All hail the King of the North",
    8 | 		Creator = "YourDeadlyDesire",
    9 | 		Icon = 72135144627200,
   10 | 		CameraType = "Head"
   11 | 	},
   12 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "None",
   16 | 		Currency = "Points",
   17 | 		Price = 100,
   18 | 		OwnershipType = "Single"
   19 | 	},
   20 | 	EquipInfo = { SlotType = "Unusual" },
   21 | 	CosmeticInfo = { Unusual = true }
   22 | }


========================================
MATCH #634
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER6.EclipseCrown
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 521
========================================

--- SOURCE LINES 1-22 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Eclipse Crown",
    7 | 		Desc = "All hail the King of the Shadows",
    8 | 		Creator = "YourDeadlyDesire",
    9 | 		Icon = 80697798579086,
   10 | 		CameraType = "Head"
   11 | 	},
   12 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "None",
   16 | 		Currency = "Points",
   17 | 		Price = 100,
   18 | 		OwnershipType = "Single"
   19 | 	},
   20 | 	EquipInfo = { SlotType = "Unusual" },
   21 | 	CosmeticInfo = { Unusual = true }
   22 | }


========================================
MATCH #635
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER6.FrigidCrown
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 517
========================================

--- SOURCE LINES 1-22 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Jolly Crown",
    7 | 		Desc = "All hail the King of the North",
    8 | 		Creator = "YourDeadlyDesire",
    9 | 		Icon = 75807041743117,
   10 | 		CameraType = "Head"
   11 | 	},
   12 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   13 | 	PurchaseInfo = {
   14 | 		LevelRequirement = 0,
   15 | 		AppearsIn = "None",
   16 | 		Currency = "Points",
   17 | 		Price = 100,
   18 | 		OwnershipType = "Single"
   19 | 	},
   20 | 	EquipInfo = { SlotType = "Unusual" },
   21 | 	CosmeticInfo = { Unusual = true }
   22 | }


========================================
MATCH #636
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER6.SealPal
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 466
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Seal Pal",
    6 | 		Desc = "Es el mejor hora de comer",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #637
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER7.OrbitingSerenade
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 496
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Orbiting Serenade",
    6 | 		Desc = "fa la la la la la, la la la la",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 97988062645095,
    9 | 		CameraType = "Head"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Unusual" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Unusual" },
   20 | 	CosmeticInfo = { Unusual = true }
   21 | }


========================================
MATCH #638
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Cosmetics.TIER8.XmasTreeCookie
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 499
========================================

--- SOURCE LINES 1-21 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Xmas Tree Cookie",
    6 | 		Desc = "Congratulations on reaching 4500 Gingerbreads!",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0,
    9 | 		CameraType = "Back"
   10 | 	},
   11 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "None",
   15 | 		Currency = "Points",
   16 | 		Price = 100,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	EquipInfo = { SlotType = "Cosmetic" },
   20 | 	CosmeticInfo = { Unusual = false }
   21 | }


========================================
MATCH #639
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Consumables.Cola.CranberryCola
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 403
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Cranberry Cola",
    6 | 		Desc = "Want a cola cranberry?",
    7 | 		Creator = "phiphu123",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #640
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Consumables.Cola.Eggnog
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 421
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Eggnog",
    6 | 		Desc = "Be sure not to egg others on into drinking this.",
    7 | 		Creator = "phiphu123",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #641
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Consumables.Cola.FestiveThermos
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 430
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Festive Thermos",
    6 | 		Desc = "Helps keep your drink warm in the cold",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #642
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Consumables.Cola.WhippedCoffee
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 443
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Whipped Coffee",
    6 | 		Desc = "Doesn\'t leave a whipped cream mustache after use :(",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #643
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Consumables.Cola.WinterElixir
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 450
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Winter Elixir",
    6 | 		Desc = "Grants you the ability to see whose been naughty or nice",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #644
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Barrier.CandyCaneBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 436
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Candy Cane Barrier",
    6 | 		Desc = "The power of Santa compels the nextbots to stop.",
    7 | 		Creator = "wlfguy3",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #645
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Barrier.DecoratedGate
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 440
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Decorated Gate",
    6 | 		Desc = "The land of eternal Christmas is right behind these gates.",
    7 | 		Creator = "phiphu123",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #646
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Barrier.NorthPoleBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "North Pole Barrier",
    6 | 		Desc = "All abord the Polar Express!!",
    7 | 		Creator = "omuq & MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #647
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Barrier.OrnamentalBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 433
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ornamental Barrier",
    6 | 		Desc = "Isn\'t as fragile as a real ornament.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #648
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Barrier.StageSet
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 416
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Stage Set",
    6 | 		Desc = "Watch the world-renowned play of Bobo and the Rebels",
    7 | 		Creator = "",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #649
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Barrier.WinterfangBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 418
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Winterfang Barrier",
    6 | 		Desc = "Subzero temperatures",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #650
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Barrier.XmasTreeBarrier
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 430
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Xmas Tree Barrier",
    6 | 		Desc = "\'Tis be the season!",
    7 | 		Creator = "NickerManett & MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #651
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Beacon.MelodicalRudolph
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 412
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Melodical Rudolph",
    6 | 		Desc = "Listen to some Holiday bops with Rudolph",
    7 | 		Creator = "",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #652
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Beacon.OrnamentBeacon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ornamenta Beacon",
    6 | 		Desc = "Now with ionizing radiation!",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #653
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Beacon.ReindeerBeacon
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 439
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Reindeer Beacon",
    6 | 		Desc = "Santa won\'t be having Rudolph lead his reindeers tonight.",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #654
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Beacon.Snowglobe
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 428
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Snowglobe",
    6 | 		Desc = "A family of 4 are locked inside, sealed for eternity.",
    7 | 		Creator = "wlfguy3",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #655
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Floodlight.CatCampfire
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 435
========================================

--- SOURCE LINES 1-20 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	Reintroduced = true,
    5 | 	AppearanceInfo = {
    6 | 		Name = "Cat Campfire",
    7 | 		Desc = "Stay warm this winter with your fellow kittens",
    8 | 		Creator = "",
    9 | 		Icon = 0
   10 | 	},
   11 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   12 | 	PurchaseInfo = {
   13 | 		LevelRequirement = 0,
   14 | 		AppearsIn = "Event",
   15 | 		Currency = "Tickets",
   16 | 		Price = 999999999,
   17 | 		OwnershipType = "Single"
   18 | 	},
   19 | 	CosmeticInfo = { Unusual = false }
   20 | }


========================================
MATCH #656
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Floodlight.FrozenSwordLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 442
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Frozen Sword Light",
    6 | 		Desc = "Once used to defeat the Cruel King centuries ago.",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #657
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Floodlight.NorthPoleLampPost
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 436
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "North Pole Lamp Post",
    6 | 		Desc = "Illuminating the path towards Santa\'s workshop.",
    7 | 		Creator = "phiphu123",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #658
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Floodlight.NorthernStar
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 415
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Northern Star",
    6 | 		Desc = "The guiding north star, Polaris.",
    7 | 		Creator = "danncie",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #659
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Floodlight.ReindeerLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 483
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Reindeer Light",
    6 | 		Desc = "this is not RUDOLPH because he is a copyrighted figure, this is just a generic reindeer, oh well",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #660
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Floodlight.SnowmanLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 405
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Snowman Light",
    6 | 		Desc = "We taxidermied Frosty",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = 50,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #661
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Floodlight.XMASTreeLight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 410
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "XMAS Tree Floodlight",
    6 | 		Desc = "Tis\' be the season!",
    7 | 		Creator = "wlfguy3",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #662
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.JumpPad.BoboJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 415
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bobo Jump Pad",
    6 | 		Desc = "he wishes you a happy holidays",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #663
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.JumpPad.JardJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 418
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Jard Jump Pad",
    6 | 		Desc = "he wishes you a horrible holidays",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #664
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.JumpPad.PresentJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 426
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Present Jump Pad",
    6 | 		Desc = "Bobo\'s long lost cousin, Belf",
    7 | 		Creator = "ElectroMeltdown",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #665
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.JumpPad.SnowflakeJumpPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 430
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Snowflake Jump Pad",
    6 | 		Desc = "May inflict a mild case of frostbite",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "None",
   14 | 		Currency = "Points",
   15 | 		Price = nil,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #666
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.BerryMine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 410
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Berry Mine",
    6 | 		Desc = "Santa has a personal gift for you.",
    7 | 		Creator = "pokchoy",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #667
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.GiftBomb
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gift Bomb",
    6 | 		Desc = "Hey Santa! Here\'s a gift I personally wrapped for you.",
    7 | 		Creator = "phiphu123",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #668
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.MischeviousGingerbread
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 433
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Mischevious Gingerbread",
    6 | 		Desc = "Devious and mischevious gingerbread men.",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #669
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.Ornabomb
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 438
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ornabomb",
    6 | 		Desc = "Definitely hanging this on my Christmas Tree",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #670
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.PresentMimic
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 449
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Present Mimic",
    6 | 		Desc = "Beware of opening your Christmas gifts under the tree tonight.",
    7 | 		Creator = "KoreWaAkaDesu",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #671
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.SantaPuppeteer
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 421
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Santa Puppeteer",
    6 | 		Desc = "Now we all know who was behind Santa\'s operations.",
    7 | 		Creator = "",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #672
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.SantasBag
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 415
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Santa\'s Bag",
    6 | 		Desc = "For naughty nextbots.",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #673
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.SnowmanTrap
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 400
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Snowman Trap",
    6 | 		Desc = "Worse than yellow snow.",
    7 | 		Creator = "Sirdui",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #674
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.SubzeroTripmine
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 432
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Subzero Tripmine",
    6 | 		Desc = "May rip the fabric of space and time",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #675
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Landmine.TeddyTrap
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 398
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Teddy Mine",
    6 | 		Desc = "Looks can be deceiving!",
    7 | 		Creator = "ShinonArtZ",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #676
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Sensor.FrozenBoboSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 411
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Frozen Bobo Sensor",
    6 | 		Desc = "halp... meh...",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #677
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Sensor.GunterSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 421
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gunter Sensor",
    6 | 		Desc = "NO GUNTER DON\'T TOUCH THAT",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #678
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Sensor.MarchingSoldierSensor
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 436
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Marching Soldier Sensor",
    6 | 		Desc = "Tapping of the drums as the nextbot approaches.",
    7 | 		Creator = "pokchoy",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #679
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Sensor.MechanicalCrocodile
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 415
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Mechanical Crocodile",
    6 | 		Desc = "Make sure to wind him up before placing.",
    7 | 		Creator = "",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #680
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Sensor.MeltingSnowman
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 410
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Melting Snowman",
    6 | 		Desc = "HALP MEHHH! IM MELTING!!!",
    7 | 		Creator = "HardyAsRock",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #681
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.SpeedPad.WorkshopConveyer
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 414
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Workshop Conveyer",
    6 | 		Desc = "Extracted straight from Santa\'s workshop.",
    7 | 		Creator = "",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #682
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.SpeedPad.SpilledCocoaPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 419
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Spilled Cocoa Pad",
    6 | 		Desc = "It\'s a floater!",
    7 | 		Creator = "abrahamabugri",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #683
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.SpeedPad.MeltedFrosty
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 471
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Melted Frosty",
    6 | 		Desc = "Would you really step over this poor melted snowman to gain a speed boost? How cruel of you.",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #684
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.SpeedPad.IcePad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 392
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Ice Pad",
    6 | 		Desc = "Near frictionless",
    7 | 		Creator = "phiphu123",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #685
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.SpeedPad.GingerbreadPad
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 419
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Gingerbread Pad",
    6 | 		Desc = "Gives you a sugar rush",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #686
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Teleporter.ChimneyStack
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 444
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Chimney Stack",
    6 | 		Desc = "Magically teleport to another chimney by jumping down this one.",
    7 | 		Creator = "phiphu123",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #687
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Teleporter.GiftsackTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 496
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Giftsack Teleporter",
    6 | 		Desc = "A bottomless pit that contains the gifts for all of the good little robloxians in the world",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #688
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Teleporter.RudolphTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 509
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Rudolph Teleporter",
    6 | 		Desc = "In the year 3053, Rudolph has become a bionic reindeer capable of instantly teleporting individuals. The future of Christmas is now.",
    7 | 		Creator = "",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #689
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Deployables.Teleporter.SnowflakeTeleporter
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 474
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Snowflake Teleporter",
    6 | 		Desc = "Travel through another plane of existence to a new location, with the power of snow.",
    7 | 		Creator = "LeeW011",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Mythical" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 9999999999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #690
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Lights.Flashlight.BellFlashlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 403
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Bell Flashlight",
    6 | 		Desc = "ding dong",
    7 | 		Creator = "MontiCats",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #691
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Lights.Flashlight.ElfFlashlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 429
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Elf Flashlight",
    6 | 		Desc = "Used by elves in Santa\'s workshop",
    7 | 		Creator = "Snowyclown0",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = "Winter Holidays", Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #692
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Lights.Flashlight.LEDFlashlight
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 419
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "LED Flashlight",
    6 | 		Desc = "Reusing LED lights for a better purpose.",
    7 | 		Creator = "clonemace",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Common" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


========================================
MATCH #693
PATH: ReplicatedStorage.Items.ItemPacks.Events.2024.Xmas2024.Skins.Lights.Flashlight.ToyTrain
CLASS: ModuleScript
DECOMPILED SOURCE LENGTH: 402
========================================

--- SOURCE LINES 1-19 ---
    1 | -- decompiled with Opiumware
    2 | 
    3 | return {
    4 | 	AppearanceInfo = {
    5 | 		Name = "Toy Train",
    6 | 		Desc = "Choo choo, here comes the train!",
    7 | 		Creator = "pokchoy",
    8 | 		Icon = 0
    9 | 	},
   10 | 	UIInfo = { Header = nil, Overview = nil, Rarity = "Rare" },
   11 | 	PurchaseInfo = {
   12 | 		LevelRequirement = 0,
   13 | 		AppearsIn = "Event",
   14 | 		Currency = "Tickets",
   15 | 		Price = 99999999,
   16 | 		OwnershipType = "Single"
   17 | 	},
   18 | 	CosmeticInfo = { Unusual = false }
   19 | }


[OUTPUT CAPPED: лимит буфера достигнут; часть совпадений не включена.]
