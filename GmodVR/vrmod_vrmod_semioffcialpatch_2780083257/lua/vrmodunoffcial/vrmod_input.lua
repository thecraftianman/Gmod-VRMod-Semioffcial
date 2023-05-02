local cl_bothkey = CreateClientConVar("vrmod_vehicle_bothkeymode","0",true,FCVAR_ARCHIVE)
local cl_pickupdisable = CreateClientConVar("vr_pickup_disable_client","0",true,FCVAR_ARCHIVE)
local cl_lefthand = CreateClientConVar("vrmod_LeftHand", "0") 
local cl_lefthandfire = CreateClientConVar("vrmod_lefthandleftfire", "0") 
local retry = CreateClientConVar("vrmod_pickup_retry","1",true,FCVAR_ARCHIVE,"",0,1)


if CLIENT then


	hook.Add("VRMod_EnterVehicle","vrmod_switchactionset",function()
		if cl_bothkey:GetBool() then
			LocalPlayer():ConCommand("vrmod_keymode_both")
			LocalPlayer():ConCommand("vrmod_")
		else
			VRMOD_SetActiveActionSets( "/actions/base","/actions/driving")	
		end
	end)
	
	hook.Add("VRMod_ExitVehicle","vrmod_switchactionset",function()
		VRMOD_SetActiveActionSets("/actions/base", "/actions/main")
	end)
	

	hook.Add("VRMod_Input","vrutil_hook_defaultinput",function( action, pressed )

		if hook.Call("VRMod_AllowDefaultAction", nil, action) == false then return end
		
		if (action == "boolean_primaryfire" or action == "boolean_turret") and not g_VR.menuFocus then
			LocalPlayer():ConCommand(pressed and "+attack" or "-attack")
			return
		end
		
		if action == "boolean_secondaryfire" then
			LocalPlayer():ConCommand(pressed and "+attack2" or "-attack2")
			return
		end
		
		if action == "boolean_left_pickup" then
			vrmod.Pickup(true, not pressed)
			return
		end
		
		if action == "boolean_right_pickup" then
			vrmod.Pickup(false, not pressed)
			return
		end
		
		if action == "boolean_use" or action == "boolean_exit" then
			if pressed then
				LocalPlayer():ConCommand("+use")
				local wep = LocalPlayer():GetActiveWeapon()
				if IsValid(wep) and wep:GetClass() == "weapon_physgun" then
					hook.Add("CreateMove", "vrutil_hook_cmphysguncontrol", function(cmd)
						if  g_VR.input.vector2_walkdirection.y > 0.9 then
							cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_FORWARD))
						elseif g_VR.input.vector2_walkdirection.y < -0.9 then
							cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_BACK))
						else
							cmd:SetMouseX(g_VR.input.vector2_walkdirection.x*50)
							cmd:SetMouseY(g_VR.input.vector2_walkdirection.y*-50)
						end
					end)
				end
			else
				LocalPlayer():ConCommand("-use")
				hook.Remove("CreateMove", "vrutil_hook_cmphysguncontrol")
			end
			return
		end
		
		if action == "boolean_changeweapon" then
			if pressed then
				VRUtilWeaponMenuOpen()
			else
				VRUtilWeaponMenuClose()
			end
			return
		end
		
		if action == "boolean_flashlight" and pressed then
			LocalPlayer():ConCommand("impulse 100")
			return
		end
		
		if action == "boolean_reload" then
			LocalPlayer():ConCommand(pressed and "+reload" or "-reload")
			return
		end
		
		if action == "boolean_undo" then
			if pressed then
				LocalPlayer():ConCommand("gmod_undo")
			end
			return
		end
		
		if action == "boolean_spawnmenu" then
			if pressed then
				g_VR.MenuOpen()
			else
				g_VR.MenuClose()
			end
			return
		end
		
		for i = 1,#g_VR.CustomActions do
			if action == g_VR.CustomActions[i][1] then
				local commands = string.Explode(";",g_VR.CustomActions[i][pressed and 2 or 3],false)
				for j = 1,#commands do
					local args = string.Explode(" ",commands[j],false)
					RunConsoleCommand(args[1],unpack(args,2))
				end
			end
		end
		
	end)

	hook.Add("VRMod_Input","vrutil_hook_addinput",function( action, pressed )

		if action == "boolean_chat" then
			LocalPlayer():ConCommand(pressed and "+zoom" or "-zoom")
				return
		end
	
		if action == "boolean_left_pickup" then
			if cl_pickupdisable:GetBool() then return end
			if retry:GetBool() then
				vrmod.PickupPlus(true, not pressed)
			end
		end

		if action == "boolean_right_pickup" then
			if cl_pickupdisable:GetBool() then return end
			if retry:GetBool() then
				vrmod.PickupPlus(false, not pressed)
			end
		end

			
		if action == "boolean_walkkey" then
			LocalPlayer():ConCommand(pressed and "+walk" or "-walk")
			return
		end

		if action == "boolean_menucontext" then
			LocalPlayer():ConCommand(pressed and "+menu_context" or "-menu_context")
			return
		end
		
		if (action == "boolean_left_primaryfire") and not g_VR.menuFocus and cl_lefthand:GetBool() and cl_lefthandfire:GetBool() then
			LocalPlayer():ConCommand(pressed and "+attack" or "-attack")
			return
		end

		if (action == "boolean_left_secondaryfire") and not g_VR.menuFocus and cl_lefthand:GetBool() and cl_lefthandfire:GetBool() then
			LocalPlayer():ConCommand(pressed and "+attack2" or "-attack2")
			return
		end
	
	
	
		if action == "boolean_slot1" then
			if pressed then
				LocalPlayer():ConCommand("slot1")
			end
			return
		end
		
		if action == "boolean_slot2" then
			if pressed then
				LocalPlayer():ConCommand("slot2")
			end
			return
		end

		if action == "boolean_slot3" then
			if pressed then
				LocalPlayer():ConCommand("slot3")
			end
			return
		end

		if action == "boolean_slot4" then
			if pressed then
				LocalPlayer():ConCommand("slot4")
			end
			return
		end

		if action == "boolean_slot5" then
			if pressed then
				LocalPlayer():ConCommand("slot5")
			end
			return
		end

		if action == "boolean_slot6" then
			if pressed then
				LocalPlayer():ConCommand("slot6")
			end
			return
		end
	
	
	
	end)

end