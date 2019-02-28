TOOL.Category = "Metro"
TOOL.Name = "Arcader"
TOOL.Command = nil
TOOL.ConfigName = ""
--[[if SERVER then
	util.AddNetworkString("SupinePandora43_Net_Arcader_To_CL")
end]]
if CLIENT then
	language.Add("Tool.spandora_arcader.name", "Train Arcader Tool")
	language.Add("Tool.spandora_arcader.desc", "Arcade Trains")
	language.Add("Tool.spandora_arcader.0", "Primary: Arcade")
	--[[net.Receive("SupinePandora43_Net_Arcader_To_CL", function(len, ply)
		local ArcadeTrain = net.ReadEntity()
		function ArcadeTrain:InitializeSystems()
			self:LoadSystem("Arcade_Systems")
		end
		print(ArcadeTrain)
	end)]]
end
function TOOL:GetTrain(ent, i)
	local i = i or 0
	if ent.InitializeSystems then return ent end
	if i > 10 then return nil end
	if IsValid(ent:GetParent()) then return self:GetTrain(ent, i + 1) end
end
function TOOL:LeftClick(trace)
	if CLIENT then return true end
	local ply = self:GetOwner()
	if (not ply:IsValid()) then return false end
	if not trace then return false end
	if not IsValid(trace.Entity) then return false end
	if self:GetTrain(trace.Entity) then
		local train = trace.Entity
		local pos = train:GetPos()
		local ang = train:GetAngles()
		local ArcadeTrain = ents.Create(train:GetClass())
		undo.ReplaceEntity(train, ArcadeTrain)
		SafeRemoveEntity(train)
		ArcadeTrain:SetPos(pos - Vector(0, 0, 120))
		ArcadeTrain:SetAngles(ang)
		function ArcadeTrain:InitializeSystems()
			self:LoadSystem("Arcade_Systems")
		end
		--[[timer.Simple(0.1, function()
			net.Start("SupinePandora43_Net_Arcader_To_CL")
			net.WriteEntity(ArcadeTrain)
			net.Broadcast()]]
		
		function ArcadeTrain:Think()
			self.BaseClass.Think(self)
			for k, v in pairs(self.Lights) do
				self:SetLightPower(k, true)
			end
		end
		function ArcadeTrain:TrainSpawnerUpdate() end
		function ArcadeTrain:OnButtonPress(button, ply) end
		function ArcadeTrain:PostInitializeSystems() end
		function ArcadeTrain:OnButtonRelease() end
		function ArcadeTrain:NonSupportTrigger() end
		ArcadeTrain:Spawn()
		ArcadeTrain.Plombs = {}
		ArcadeTrain.KeyMap = {
			[KEY_W] =      "Drive",
			[KEY_S] =      "Brake",
			[KEY_R] =      "Reverse",
			[KEY_L] =      "Horn",
			[KEY_LSHIFT] = "Turbo"
		}
		ArcadeTrain.KeyMap[KEY_RSHIFT] = ArcadeTrain.KeyMap[KEY_LSHIFT] -- навсякий случий
		undo.Create(ArcadeTrain.PrintName.." Arcade")
		undo.AddFunction(function(tab, ArcadeTrain)
			if(not IsValid(ArcadeTrain)) then return end
			local pos = ArcadeTrain:GetPos()
			local ang = ArcadeTrain:GetAngles()
			local train1 = ents.Create(ArcadeTrain:GetClass())
			undo.ReplaceEntity(ArcadeTrain, train1)
			SafeRemoveEntity(ArcadeTrain)
			train1:SetPos(pos-Vector(0, 0, 120))
			train1:SetAngles(ang)
			train1:Spawn()
		end, ArcadeTrain)
		undo.SetPlayer(ply)
		undo.Finish() 
		--end)
	end
end