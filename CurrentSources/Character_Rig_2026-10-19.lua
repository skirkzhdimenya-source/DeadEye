-- CURRENT SOURCE REFRESH
-- PATH: ReplicatedStorage.Objects.Game.Character.Rig
-- STATUS: User-provided current decompilation, 2026-10-19. Replaces outdated SOURCE #50 in DeadEye_Sources.txt.
-- PURPOSE: Character rig lifecycle, BuildRig(), RegistryTermUpdated(), Clear(), and RigService:SetRig()/UnsetRig() integration.

-- decompiled with Opiumware

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = require("../../../Config/Game/Rig")
ReplicatedStorage:WaitForChild("NPCs")
local Services = ReplicatedStorage:WaitForChild("Services")
local v_u_2 = require((Services:WaitForChild("Items"):WaitForChild("ClientItemService")))
ReplicatedStorage:WaitForChild("Shared")
local Services2 = ReplicatedStorage:WaitForChild("Services")
local v_u_3 = require((ReplicatedStorage.Client:WaitForChild("Services"):WaitForChild("UserData"):WaitForChild("Settings")))
local ActionTypes = ReplicatedStorage.Objects.Game.Actions.ActionTypes
local RigService = require(Services2.Asset.RigService)
local _ = v1.MakeR15RigFake
local t = {}
t.__index = t
function t.new(p4)
	--[[ line: 29 | upvalues: (copy) t]]
	local t2 = {
		Parent = p4,
		Character = p4.Model,
		DataRegistry = p4.DataRegistry,
		Joints = {},
		Parts = {},
		Particles = {},
		Overlays = {},
		Limbs = {},
		CachedData = {}
	}
	local v5 = t
	local v6 = setmetatable(t2, v5)
	local v7 = t
	return setmetatable(v6, v7)
end
function t.Init(p_u_8)
	--[[ line: 45 | upvalues: none]]
	p_u_8.PrimaryPart = p_u_8.Character:FindFirstChild("HumanoidRootPart")
	if p_u_8.PrimaryPart then
		p_u_8.PrimaryPart.Transparency = 1
	end
	p_u_8.Ragdoll = require(script.Ragdoll).new(p_u_8.Character, p_u_8)
	p_u_8.Character.ChildAdded:Connect(function(p_u_9)
		--[[ line: 51 | upvalues: (copy) p_u_8]]
		if p_u_9.Name == "Prop" then
			if p_u_9.Value then
				p_u_8:ChangeModel(p_u_9.Value)
			end
			p_u_9:GetPropertyChangedSignal("Value"):Connect(function()
				--[[ line: 56 | upvalues: (copy) p_u_9, (ref) p_u_8]]
				if p_u_9.Value then
					p_u_8:ChangeModel(p_u_9.Value)
				end
			end)
		end
	end)
end
function t.Destroy(p10)
	--[[ line: 65 | upvalues: (copy) RigService]]
	if p10.Parent.AI then
		local v_u_11 = p10:GetRigModel()
		if v_u_11 then
			task.spawn(function()
				--[[ line: 69 | upvalues: (copy) v_u_11]]
				if v_u_11:FindFirstChild("Head") then
					task.wait(5)
				end
				v_u_11:Destroy()
			end)
		end
	else
		RigService:UnsetRig(p10.Character)
		p10.Ragdoll:Destroy()
	end
end
function t.Clear(p12)
	--[[ line: 82 | upvalues: none]]
	for _2, v13 in p12.Character:GetChildren() do
		if not v13:IsA("Humanoid") and v13 ~= p12.PrimaryPart then
			v13:Destroy()
		end
	end
	p12.Joints = {}
	p12.Parts = {}
	p12.Limbs = {}
	p12.CachedData = {}
end
function t.GetParts(p14)
	--[[ line: 94 | upvalues: none]]
	return p14.Parts
end
function t.GetLimbs(p15)
	--[[ line: 98 | upvalues: none]]
	return not p15.Rig and {} or p15.Rig.Limbs
end
function t.GetJoints(p16)
	--[[ line: 105 | upvalues: none]]
	return p16.Joints
end
function t.GetCosmetics(p17)
	--[[ line: 109 | upvalues: none]]
	return p17.Cosmetics
end
function t.GetRigModel(p18)
	--[[ line: 113 | upvalues: none]]
	if p18.Rig then
		return p18.Rig.Model
	end
end
function t.GetRig(p19)
	--[[ line: 119 | upvalues: none]]
	return p19.Rig
end
function t.GetGear(p20)
	--[[ line: 123 | upvalues: (copy) ActionTypes, (copy) v_u_2]]
	local t3 = {}
	for _3, v21 in p20.Actions do
		local v22 = nil
		local v23
		if v21 == ActionTypes.NightVisionGoggles:GetAttribute("ID") then
			v23 = "NightVisionGoggles"
		else
			v23 = v21 == ActionTypes.Headlamp:GetAttribute("ID") and "Headlamp" or v22
		end
		local v24 = nil
		if v23 then
			for _4, v25 in p20.ToolSkins do
				local v26 = v_u_2:GetItemFromID(v25)
				if v26 and (v26:FindFirstChild("Original") and v26.Original.Value.Name == v23) then
					v24 = v26:GetAttribute("ID")
				end
			end
		end
		if v24 then
			table.insert(t3, v24)
		elseif v23 then
			local v27 = v_u_2
			table.insert(t3, (v27:GetItemIDFromName(v23)))
		end
	end
	return t3
end
function t.BuildRig(p28)
	--[[ line: 150 | upvalues: (copy) v_u_3, (copy) RigService]]
	if p28.Built then
		return
	elseif p28.Cosmetics and (p28.RigTerm and (p28.Actions and (p28.ToolSkins and p28.Boombox))) then
		p28.Built = true
		if p28.RigTerm == Enum.HumanoidRigType.R15 and v_u_3.Get("R15Enabled") == false then
			p28.RigTerm = Enum.HumanoidRigType.R6
		end
		p28.Rig = RigService:SetRig(p28.Character, p28.RigTerm or Enum.HumanoidRigType.R6, p28.Cosmetics, p28:GetGear(), p28.Boombox)
		if p28.Rig.Model:GetAttribute("Hidden") then
			p28.Rig.Model:SetAttribute("Hidden", nil)
			for _5, v29 in p28.Rig.Model:GetDescendants() do
				if v29:IsA("BasePart") then
					v29.LocalTransparencyModifier = 0
				elseif v29:IsA("Decal") then
					v29.Transparency = v29:GetAttribute("OldTransparency") or 0
				end
			end
		end
		if p28.Rig.Model:FindFirstChild("Head") and (p28.Rig.Model.Head:GetAttribute("DontShowFPCharacter") and (p28.DataRegistry and p28.DataRegistry.Set)) then
			p28.DataRegistry:Set("DontShowFPCharacter", true)
		end
		p28.Joints = {}
		for _6, v30 in p28.Rig.Model:WaitForChild("Joints"):GetChildren() do
			local Joints = p28.Joints
			table.insert(Joints, v30)
		end
		p28.Parts = {}
		for _7, v31 in p28.Rig.Model:GetChildren() do
			if v31:IsA("BasePart") then
				local Parts = p28.Parts
				table.insert(Parts, v31)
			end
		end
		if p28.Rig.Humanoid.RigType == Enum.HumanoidRigType.R15 then
			p28.R15 = true
		else
			p28.R15 = false
		end
		if p28.Parent then
			if p28.Parent.Joints then
				p28.Parent.Joints:SetJoints()
				p28.Parent.Joints:EnableJoints()
			end
			if p28.Parent.Camera then
				p28.Parent.Camera:SetJoints()
			end
			if p28.Parent.Animations then
				p28.Parent.Animations:SetRig(p28.Rig)
			end
		end
	end
end
function t.RegistryTermUpdated(p32: {[any]: any}, p33: string)
	--[[ line: 210 | upvalues: (copy) LocalPlayer]]
	if p33 == "Rig" then
		p32.RigTerm = p32.DataRegistry:Get(p33)
		p32:BuildRig()
		return
	end
	if p33 == "Cosmetics" then
		p32.Cosmetics = p32.DataRegistry:Get("Cosmetics")
		p32:BuildRig()
		return
	end
	if p33 == "Actions" then
		p32.Actions = p32.DataRegistry:Get("Actions")
		p32:BuildRig()
		return
	end
	if p33 == "ToolSkins" then
		p32.ToolSkins = p32.DataRegistry:Get("ToolSkins")
		p32:BuildRig()
		return
	end
	if p33 == "Boombox" then
		p32.Boombox = p32.DataRegistry:Get("Boombox")
		p32:BuildRig()
		return
	end
	if p33 == "Nametag" then
		if p32.Character then
			p32.Character:SetAttribute("Nametag", (p32.DataRegistry:Get("Nametag")))
		end
	end
	if p33 == "Size" then
		p32.DataRegistry:Get("Size")
		return
	end
	if p33 == "Highlight" then
		if not p32.Rig then
			return
		end
		local Highlight = p32.DataRegistry:Get("Highlight")
		if Highlight == 0 and p32.Highlight then
			p32.Highlight:Destroy()
			p32.Highlight = nil
			p32.HighlightTeam = nil
			return
		end
		if not p32.Highlight then
			p32.Highlight = Instance.new("Highlight")
			p32.Highlight.Enabled = false
			p32.Highlight.FillTransparency = 1
			p32.Highlight.OutlineTransparency = 0.2
			p32.Highlight.Adornee = p32.Rig.Model
			p32.Highlight.Parent = p32.Character
		end
		p32.Highlight.OutlineColor = Highlight.Color or Color3.new(255, 185, 114)
		if Highlight.VisibleTo then
			p32.HighlightTeam = Highlight.VisibleTo
			if LocalPlayer.Character then
				p32.LocalPlayerTeam = LocalPlayer.Character:GetAttribute("Team")
			end
			if LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Team") == Highlight.VisibleTo then
				p32.Highlight.Enabled = true
			else
				p32.Highlight.Enabled = false
			end
		end
		p32.Highlight.Enabled = true
	end
end
function t.Kill(p34, p35)
	--[[ line: 270 | upvalues: none]]
	local v36 = p34:GetRig()
	local t4 = {}
	local v37 = script.Death:Clone()
	v37.Parent = p34.PrimaryPart:FindFirstChild("SoundPos")
	v37:Play()
	table.insert(t4, v37)
	if p35.Heavy then
		local v38 = script.DeathHeavy:Clone()
		v38.Parent = p34.PrimaryPart:FindFirstChild("SoundPos")
		v38:Play()
		table.insert(t4, v38)
	end
	if p35.Instakill then
		if p34.Parent and p34.Parent.Visibility then
			p34.Parent.Visibility:Destroy()
		end
		p34.Ragdoll:Ragdoll(true, p35, v36)
	else
		p34.Ragdoll:Ragdoll(false, p35, v36)
	end
	task.spawn(function()
		--[[ line: 296 | upvalues: (copy) t4]]
		task.wait(1)
		for _8, v39 in t4 do
			v39:Destroy()
		end
	end)
end
function t.ChangeModel(p40, p41)
	--[[ line: 304 | upvalues: none]]
	local function GetAABB(p42)
		--[[ line: 305 | upvalues: none]]
		local CFrame2 = p42.CFrame
		local Size = p42.Size
		local X = Size.X
		local Y = Size.Y
		local Z = Size.Z
		local _9, _10, _11, v43, v44, v45, v46, v47, v48, v49, v50, v51 = CFrame2:GetComponents()
		local v52 = math.abs(v43) * X + math.abs(v44) * Y + math.abs(v45) * Z
		local v53 = math.abs(v46) * X + math.abs(v47) * Y + math.abs(v48) * Z
		local v54 = math.abs(v49) * X + math.abs(v50) * Y + math.abs(v51) * Z
		return Vector3.new(v52, v53, v54)
	end
	local v55 = p40:GetRigModel()
	v55:SetAttribute("Hidden", true)
	for _12, v56 in v55:GetDescendants() do
		if v56:IsA("BasePart") then
			v56.LocalTransparencyModifier = 1
		elseif v56:IsA("Decal") then
			v56:SetAttribute("OldTransparency", v56.Transparency)
			v56.Transparency = 1
		end
	end
	p40.DataRegistry:Set("Hidden", true)
	if p40.Character:FindFirstChild("CustomModel") then
		p40.Character.CustomModel:Destroy()
	end
	local v57 = p41:Clone()
	v57.Parent = p40.Character
	v57.Name = "CustomModel"
	local v58
	if v57:IsA("BasePart") then
		v58 = Instance.new("Model", p40.Character)
		v58.Name = "CustomModel"
		v57.Parent = v58
	else
		v58 = v57
	end
	v58.PrimaryPart = nil
	local v59, v60 = v58:GetBoundingBox()
	local v61 = Instance.new("Part", v58)
	v61.Anchored = true
	v61.CanCollide = false
	v61.CanQuery = false
	v61.CanTouch = false
	v61.Massless = true
	v61.CFrame = v59
	v61.Size = v60
	v58.PrimaryPart = v61
	for _13, v62 in pairs((v58:GetDescendants())) do
		if v62:IsA("BasePart") and v62 ~= v61 then
			local v63 = Instance.new("Weld", v62)
			v63.C0 = v61.CFrame:inverse()
			v63.C1 = v62.CFrame:inverse()
			v63.Part0 = v61
			v63.Part1 = v62
			v62.Anchored = false
			v62.CanCollide = false
			v62.CanQuery = false
			v62.CanTouch = false
			v62.Massless = true
		end
	end
	v61.CFrame = p40.Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.75 + GetAABB(v61).Y / 2, 0) * (v59 - v59.Position)
	local v64 = Instance.new("Weld", v61)
	v64.C0 = p40.Character.HumanoidRootPart.CFrame:inverse()
	v64.C1 = v61.CFrame:inverse()
	v64.Part0 = p40.Character.HumanoidRootPart
	v64.Part1 = v61
	v61.Transparency = 1
	v61.Anchored = false
end
function t.Update(p65, _14)
	--[[ line: 378 | upvalues: (copy) LocalPlayer]]
	if p65.HighlightTeam and p65.Highlight then
		local Character = LocalPlayer.Character
		if Character then
			Character = LocalPlayer.Character:GetAttribute("Team")
		end
		if p65.LocalPlayerTeam ~= Character then
			p65.LocalPlayerTeam = Character
			if p65.HighlightTeam == p65.LocalPlayerTeam then
				p65.Highlight.Enabled = true
				return
			end
			p65.Highlight.Enabled = false
		end
	end
end
return t
