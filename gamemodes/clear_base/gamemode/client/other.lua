local concommand_Remove = concommand.Remove
local timer_Simple = timer.Simple
local hook_Remove = hook.Remove

-- PhysGun
function GM:DrawPhysgunBeam(ply, wep, bOn, target, boneid, pos)
	return true
end

-- Idk what is this
function GM:PostProcessPermitted(str)
	return false
end

timer_Simple(0, function()
	-- Sandbox trash
	hook_Remove("PostReloadToolsMenu", "BuildCleanupUI")
	hook_Remove("PopulateMenuBar", "DisplayOptions_MenuBar")
	hook_Remove("PopulateMenuBar", "NPCOptions_MenuBar")
	hook_Remove("PopulateToolMenu", "PopulateUtilityMenus")
	hook_Remove("AddToolMenuCategories", "CreateUtilitiesCategories")
	hook_Remove("OnGamemodeLoaded", "CreateMenuBar")

	-- Widgets Remove
	hook_Remove("PostDrawEffects", "RenderWidgets")
	hook_Remove("PlayerTick", "TickWidgets")

	-- Remove Spawnmenu Binds
	concommand_Remove("+menu")
	concommand_Remove("-menu")

	concommand_Remove("+menu_context")
	concommand_Remove("-menu_context")

	-- Remove Halos
	hook_Remove("PostDrawEffects", "RenderHalos")

	-- demo_recording.lua
	hook_Remove("Initialize", "DemoRenderInit")
	hook_Remove("RenderScene", "RenderForDemo")

	-- gm_demo.lua
	hook_Remove("PopulateContent", "GameProps")
	hook_Remove("HUDPaint", "DrawRecordingIcon")

	concommand_Remove("gm_demo")

	-- gui/icon_progress.lua
	hook_Remove("SpawniconGenerated", "SpawniconGenerated")

	-- modules/properties.lua
	properties["List"] = {}
	hook_Remove("PreDrawHalos", "PropertiesHover")
	hook_Remove("GUIMousePressed", "PropertiesClick")
	hook_Remove("PreventScreenClicks", "PropertiesPreventClicks")

	-- modules/undo.lua
	net.ReceiveRemove("Undo_Undone")
	net.ReceiveRemove("Undo_AddUndo")
	net.ReceiveRemove("Undo_FireUndo")

	hook_Remove("PostReloadToolsMenu", "BuildUndoUI")

	concommand_Remove("undo")
	concommand_Remove("gmod_undo")
	concommand_Remove("gmod_undonum")

	-- Bloom
	hook_Remove("RenderScreenspaceEffects", "RenderBloom")
	list.Remove("PostProcess", "#bloom_pp")

	-- Bokeh DOF
	hook_Remove("RenderScreenspaceEffects", "RenderBokeh")
	hook_Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")

	-- Color Modify
	hook_Remove("RenderScreenspaceEffects", "RenderColorModify")
	list.Remove("PostProcess", "#colormod_pp")

	-- DOF
	hook_Remove("Think", "DOFThink")
	list.Remove("PostProcess", "#dof_pp")

	-- Blend
	hook_Remove("PostRender", "RenderFrameBlend")
	list.Remove("PostProcess", "#frame_blend_pp")

	-- Motion Blur
	hook_Remove("RenderScreenspaceEffects", "RenderMotionBlur")
	list.Remove("PostProcess", "#motion_blur_pp")

	-- Material Overlay
	hook_Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
	list.Remove("PostProcess", "#overlay_pp")
	list.Remove("OverlayMaterials")

	-- Sharpen
	hook_Remove("RenderScreenspaceEffects", "RenderSharpen")
	list.Remove("PostProcess", "#sharpen_pp")

	-- Sobel
	hook_Remove("RenderScreenspaceEffects", "RenderSobel")
	list.Remove("PostProcess", "#sobel_pp")

	-- Stereoscopy
	hook_Remove("RenderScene", "RenderStereoscopy")
	list.Remove("PostProcess", "#stereoscopy_pp")

	hook_Remove("RenderScreenspaceEffects", "RenderSunbeams")
	list.Remove("PostProcess", "#sunbeams_pp")

	-- Super DoF
	hook_Remove("RenderScene", "RenderSuperDoF")
	hook_Remove("GUIMousePressed", "SuperDOFMouseDown")
	hook_Remove("GUIMouseReleased", "SuperDOFMouseUp")
	hook_Remove("PreventScreenClicks", "SuperDOFPreventClicks")
	concommand_Remove("pp_superdof")
	list.Remove("PostProcess", "#superdof_pp")

	-- Texturize
	hook_Remove("RenderScreenspaceEffects", "RenderTexturize")
	list.Remove("PostProcess", "#texturize_pp")
	list.Remove("TexturizeMaterials")

	-- ToyTown
	hook_Remove("RenderScreenspaceEffects", "RenderToyTown")
	list.Remove("PostProcess", "#toytown_pp")
end)