local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Lighting = game:GetService("Lighting")
local Teams = game:GetService("Teams")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local cloneref = cloneref or function(inst) return inst end
local gethui = gethui or function()
    return (syn and syn.protect_gui and game:GetService("CoreGui")) or game:GetService("CoreGui")
end
local getsynasset = getcustomasset or getsynasset or function() return "" end
local protect_gui = (syn and syn.protect_gui) or function() end

if not getgenv then
    getgenv = function() return _G end
end

if getgenv().UE_LOADED then
    return
end

if not getgenv().Toggles then
    getgenv().Toggles = {}
end
if not getgenv().Options then
    getgenv().Options = {}
end
local Toggles = getgenv().Toggles
local Options = getgenv().Options

local State = {
    lua = {
        listen_for_command = {},
    },
    events = {
        gradient_option_changed = Instance.new("BindableEvent"),
        esp_color_changed = Instance.new("BindableEvent"),
        esp_fill_changed = Instance.new("BindableEvent"),
        esp_effects_changed = Instance.new("BindableEvent"),
        esp_effects_color_changed = Instance.new("BindableEvent"),
    },
    characters = {},
    customization = {
        self = {
            _data = {},
            new = function(self, tag)
                return {
                    create = function(self2, char, val, kind) end,
                    destroy = function(self2, kind) end,
                    update = function(self2, kind) end,
                }
            end,
            change = function(self, char, fn) end,
            restore = function(self, char) end,
            get = function(self, char) return nil end,
        },
    },
    effects = {
        self_effects = {
            new = function(tag)
                return {
                    create = function(self, char, val, kind) end,
                    destroy = function(self, kind) end,
                    update = function(self, kind) end,
                }
            end,
        },
    },
    gradients = {
        healthbar = {},
        fill = {},
        box = {},
        name = {},
        weapon = {},
        distance = {},
        skeleton = {},
    },
    running = {},
}

local BloomEffect = Instance.new("BloomEffect")
BloomEffect.Parent = Lighting
BloomEffect.Enabled = false

local BloomDefaults = {
    Enabled = BloomEffect.Enabled,
    Size = BloomEffect.Size,
    Intensity = BloomEffect.Intensity,
    Threshold = BloomEffect.Threshold,
}

local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
ColorCorrectionEffect.Parent = Lighting
ColorCorrectionEffect.Enabled = false

local AtmosphereEffect = Instance.new("Atmosphere")

local SunRaysEffect = Instance.new("SunRaysEffect")
SunRaysEffect.Parent = Lighting
SunRaysEffect.Enabled = false

local SunRaysDefaults = {
    Enabled = SunRaysEffect.Enabled,
    Spread = SunRaysEffect.Spread,
    Intensity = SunRaysEffect.Intensity,
}

local function make_proxy(initial_value)
    local storage = { [1] = initial_value }
    return { [2] = 1, [3] = storage }
end

local proxy_outline_color = make_proxy("OutlineColor")
local proxy_visibility = make_proxy(false)
local proxy_target = make_proxy(nil)
local proxy_world_to_viewport = make_proxy(function(pos)
    return Camera:WorldToViewportPoint(pos)
end)
local proxy_font_info = make_proxy({
    font = Font.fromEnum(Enum.Font.Code),
    size = 13,
})
local proxy_healthbar_color = make_proxy(ColorSequence.new(Color3.new(0, 1, 0)))
local proxy_frame_type = make_proxy(nil) -- RenderStepped reference
local proxy_esp_enabled = make_proxy(false)

local function world_to_viewport_wrapped(position)
    local screenPos, onScreen = Camera:WorldToViewportPoint(position)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end
proxy_world_to_viewport[3][proxy_world_to_viewport[2]] = world_to_viewport_wrapped

local x = function(R)
		local T = R[5]
		local q = R[2]
		local g = R[4]
		local l = R[9]
		local m = R[10]
		local d = R[0]
		local Z = R[7]
		local F = R[8]
		local A = R[1]
		local _ = R[3]
		local n = R[6]
		return function()
			local R = _.Modes or { "Always", "Toggle", "Hold" }
			local v = A:AddContextMenu(T)
			local J = {}
			for s, s in R do
				local R
				R = v:AddOption(s, function()
					d.Mode = s
					R.TextColor3 = A.AccentColor
					for G, a in J do
						if (a ~= R) then
							a.TextColor3 = G == d.Mode and A.AccentColor or A.FontColor
						end
					end
					A:AttemptSave()
				end)
				R:GetPropertyChangedSignal("TextColor3"):Connect(function()
					if (s == d.Mode) then
						R.TextColor3 = A.AccentColor
					else
						R.TextColor3 = A.FontColor
					end
				end)
				J[s] = R
			end
			if A.FlagCopying then
				v:AddOption("Copy Flag", function()
					pcall(setclipboard, d.Idx)
					task.wait()
					A:Notify("Copied flag to clipboard!", 2)
					v:Hide()
				end)
			end
			for R, v in J do
				v.TextColor3 = R == d.Mode and A.AccentColor or A.FontColor
			end
			local R = function(v)
				local s = d.Mode
				s = s ~= "Always" and d.Override and "Override" or s
				g.Text = string.format("[%s] %s (%s)", d.Value, _.Text, s)
				g.Visible = true
				g.TextColor3 = v and A.AccentColor or A.FontColor
				A.RegistryMap[g].Properties.TextColor3 = v and "AccentColor" or "FontColor"
			end
			function d:Update()
				if not d.NoUI then
					local _ = A.KeypickerListMode
					local v = d:GetState()
					if (_ == "Active" and d.Parent.Type == "Toggle" and (not v or not d.Parent.Value)) then
						g.Visible = false
					elseif (_ == "Toggled" and d.Parent.Type == "Toggle" and not d.Parent.Value) then
						g.Visible = false
					else
						R(v)
					end
				else
					g.Visible = false
				end
				local R = 0
				local _ = 0
				for v, v in next, A.KeybindContainer:GetChildren() do
					if v:IsA("TextLabel") and v.Visible then
						R = R + 18
						if (v.TextBounds.X > _) then
							_ = v.TextBounds.X
						end
					end
				end
				A.KeybindFrame.Size = UDim2.new(0, math.max(_ + 10, 210), 0, R + 23)
				A.KeybindFrame.Visible = A.KeypickerListVisible and (R ~= 0)
			end
			function d:OverrideState(R)
				if (self.Override == R) then
					return
				end
				self.Override = R
				d.Toggled = false
				d:Update()
			end
			local R, _ = n.IsMouseButtonPressed, n.IsKeyDown
			local v, s = Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2
			local G = Enum.KeyCode
			function d:GetState()
				local a = d.Mode
				if a == "Always" then
					return true
				end
				local H = d.Value
				if (H == "...") then
					return true
				end
				local Y = nil
				if (a == "Hold") then
					if (H == "MB1" or H == "MB2") then
						Y = H == "MB1" and R(n, v) or H == "MB2" and R(n, s)
					else
						Y = _(n, G[H])
					end
				else
					Y = d.Toggled
				end
				if (Y and self.Override) then
					d:OverrideState(false)
				end
				return Y or self.Override
			end
			function d:SetValue(R)
				local _, v = R[1], R[2]
				q.Text = _
				d.Value, d.Mode = _, v
				for R, _ in J do
					_.TextColor3 = R == d.Mode and A.AccentColor or A.FontColor
				end
				d:Update()
			end
			function d:OnClick(R)
				d.Clicked = R
			end
			function d:OnChanged(R)
				d.Changed = R
				R(d.Value)
			end
			if m.Addons then
				table.insert(m.Addons, d)
			end
			function d:DoClick()
				if d.Override then
					d.Override = false
					d.Toggled = false
				end
				if m.Type == "Toggle" and d.SyncToggleState then
					m:SetValue(not m.Value)
				end
				A:SafeCallback(d.Callback, d.Toggled)
				A:SafeCallback(d.Clicked, d.Toggled)
			end
			function d:SetupConnection(R)
				table.insert(self.Connections, R)
				A:GiveSignal(R)
			end
			function d:Remove()
				l[F] = nil
				for R, R in d.Connections do
					R:Disconnect()
				end
				table.clear(d)
				T:Destroy()
				g:Destroy()
			end
			function d:SetModePickerVisibility(R)
				Z.Visible = R
			end
			function d:GetModePickerVisibility()
				return Z.Visible
			end
			local R = false
			local g = { [Enum.KeyCode.Escape] = true, [Enum.KeyCode.Backspace] = true }
			T.InputBegan:Connect(function(T)
				if not R and T.UserInputType == Enum.UserInputType.MouseButton1 and not A:MouseIsOverOpenedFrame() then
					R = true
					q.Text = ""
					local T
					local m = ""
					task.spawn(function()
						while not T do
							if m == "..." then
								m = ""
							end
							m = m .. "."
							q.Text = m
							wait(0.4)
						end
					end)
					wait(0.2)
					local m
					m = n.InputBegan:Connect(function(Z)
						local _
						if Z.UserInputType == Enum.UserInputType.Keyboard then
							_ = g[Z.KeyCode] and "..." or Z.KeyCode.Name
						elseif Z.UserInputType == Enum.UserInputType.MouseButton1 then
							_ = "MB1"
						elseif Z.UserInputType == Enum.UserInputType.MouseButton2 then
							_ = "MB2"
						end
						T = true
						R = false
						q.Text = _
						d.Value = _
						A:SafeCallback(d.ChangedCallback, Z.KeyCode or Z.UserInputType)
						A:SafeCallback(d.Changed, Z.KeyCode or Z.UserInputType)
						A:AttemptSave()
						m:Disconnect()
					end)
				end
			end)
			d:SetupConnection(n.InputBegan:Connect(function(T, q)
				if (not R and not q) then
					if d.Mode == "Toggle" then
						local q = d.Value
						if q == "MB1" or q == "MB2" then
							if
								q == "MB1" and T.UserInputType == Enum.UserInputType.MouseButton1
								or q == "MB2" and T.UserInputType == Enum.UserInputType.MouseButton2
							then
								d.Toggled = not d.Toggled
								d:DoClick()
							end
						elseif T.UserInputType == Enum.UserInputType.Keyboard then
							if T.KeyCode.Name == q then
								d.Toggled = not d.Toggled
								d:DoClick()
							end
						end
					end
					d:Update()
				end
			end))
			d:SetupConnection(n.InputEnded:Connect(function(T)
				if not R then
					d:Update()
				end
			end))
			d:Update()
			l[F] = d
		end
	end

local t = function(R)
		local T = R[4]
		local q = R[0]
		local g = R[2]
		local l = R[5]
		local m = R[1]
		local d = R[3]
		return function()
			function q:Resize()
				local R = 0
				for Z, Z in next, q.Container:GetChildren() do
					if (not Z:IsA("UIListLayout")) and Z.Visible then
						R = R + Z.Size.Y.Offset
					end
				end
				m.Size = UDim2.new(1, 0, 0, 20 + R + 2 + 2)
			end
			local R = g.Groupboxes
			function q:Remove()
				table.clear(self)
				m:Destroy()
				R[d.Name] = nil
			end
			q.Container = T
			setmetatable(q, l)
			q:AddBlank(3)
			q:Resize()
			R[d.Name] = q
		end
	end

local y = function(R)
		local T = R[4]
		local q = R[1]
		local g = R[3]
		local l = R[2]
		local m = R[0]
		return function(R, d)
			local Z = l
			local l, F
			for A, _ in d do
				if (T[A] or q[3][q[2]][A]) then
					continue
				elseif (m(_) ~= "Instance" or _.ClassName ~= "MeshPart") then
					continue
				end
				local T = g[3][g[2]](_.Position)
				local q = (T - R).Magnitude
				if (q < Z) then
					Z, l = q, _
					F = T
				end
			end
			return l, F
		end
	end

local q = function(R)
		local T = R[1]
		local q = R[0]
		return function()
			local R = Toggles.bloom_enabled.Value
			if R then
				q.Enabled = true
				q.Size = Options.bloom_size.Value
				q.Intensity = Options.bloom_intensity.Value
				q.Threshold = Options.bloom_threshold.Value
			else
				for R, g in T do
					q[R] = g
				end
			end
		end
	end

local z = function(R)
		local T = R[3]
		local q = R[0]
		local g = R[2]
		local l = R[4]
		local m = R[1]
		return function()
			local R = ColorSequence.new
			local d = ColorSequenceKeypoint.new
			local Z = Color3.fromHSV
			local F = 3
			local A, _ = {}, {}
			local n = 0
			local v, J = 0, 0.25
			local s, G, a = Options.esp_healthbar_type, Toggles.esp_healthbar_moving, Options.esp_healthbar_speed
			local H, Y, N = s.Value, G.Value, a.Value
			local U = T.gradients.healthbar
			local T = function(i, L, c)
				local y = {}
				if (c == "rainbow") then
					for O = 0, 19 do
						local t = O / 19
						local O = t
						if L then
							O = O + n
							if (O > 1) then
								O = O - 1
							end
						end
						y[#y + 1] = d(t, Z(O, 0.5, 1))
					end
				elseif (c == "gradient") then
					local Z = F - 1
					local c = v / J
					for O = 0, Z do
						local t = #y + 1
						local B = _[t]
						local f = i[B]
						if L then
							local L = _[t - 1] or _[F]
							f = f:Lerp(i[L], c)
						end
						y[t] = d(O / Z, f)
					end
				else
					y = i[1]
				end
				return y
			end
			local d = function()
				m[3][m[2]] = R(T(A, Y, H))
				for Z, Z in U do
					Z.Color = m[3][m[2]]
				end
			end
			g.events.gradient_option_changed.Event:Connect(function(Z)
				table.clear(_)
				F = Z * 3
				for i, L in
					{
						[A] = {
							Options.esp_healthbar_color_start,
							Options.esp_healthbar_color_middle,
							Options.esp_healthbar_color_end,
						},
					}
				do
					table.clear(i)
					for c, c in L do
						for L = 1, Z do
							table.insert(i, c.Value)
						end
					end
				end
				for Z = 1, F do
					table.insert(_, Z)
				end
				d()
			end)
			s:OnChanged(function(d)
				H = d
				g.events.gradient_option_changed:Fire(Options.esp_healthbar_slices.Value)
			end)
			G:OnChanged(function(d)
				Y = d
				g.events.gradient_option_changed:Fire(Options.esp_healthbar_slices.Value)
			end)
			a:OnChanged(function(d)
				N = d
				g.events.gradient_option_changed:Fire(Options.esp_healthbar_slices.Value)
			end)
			g.events.gradient_option_changed:Fire(Options.esp_healthbar_slices.Value)
			l.RenderStepped:Connect(function(g)
				if (not Y or not q[3][q[2]]) then
					return
				end
				g = g * F / 3 * N
				n = n + g
				v = v + g
				if (n > 1) then
					n = 0
				end
				if (v > J) then
					v = 0
					local g = table.clone(_)
					if Y then
						_[1] = g[F]
						for l = 2, F do
							_[l] = g[l - 1]
						end
					else
						for g = 1, F do
							_[g] = g
						end
					end
				end
				if q[3][q[2]] then
					local q = R(T(A, N, H))
					m[3][m[2]] = q
					for R, R in U do
						R.Color = q
					end
				end
			end)
		end
	end

local J = function(R)
		local T = R[0]
		local q = R[1]
		return function()
			if T[3][T[2]] then
				local R = q.Humanoid
				return R and R.Health > 0
			end
		end
	end

local V = function(R)
		local T = R[0]
		return function()
			T.Enabled = Toggles.color_correction_enabled.Value
			if not T.Enabled then
				return
			end
			T.TintColor = Options.color_correction_tint.Value
			T.Saturation = Options.color_correction_saturation.Value
			T.Contrast = Options.color_correction_contrast.Value
			T.Brightness = Options.color_correction_brightness.Value
		end
	end

local B = function(R)
		local T = R[0]
		local q = R[1]
		return function()
			do
				local R = T.lua.listen_for_command
				local T = function(g, l)
					local m = R[l] or R[l:split(" ")[1]]
					if m then
						for R, R in m do
							local m = l:split(" ")
							task.spawn(R, g, unpack(m, 2, #m))
						end
					end
				end
				game:GetService("TextChatService").MessageReceived:Connect(function(R)
					local g = R.TextSource
					if not g then
						return
					end
					local l = q:GetPlayerByUserId(g.UserId)
					if not l then
						return
					end
					T(l, R.Text)
				end)
			end
		end
	end

local P = function(R)
		local T = R[13]
		local q = R[5]
		local g = R[7]
		local l = R[3]
		local m = R[4]
		local d = R[2]
		local Z = R[15]
		local F = R[14]
		local A = R[9]
		local _ = R[0]
		local n = R[10]
		local v = R[1]
		local J = R[12]
		local s = R[6]
		local G = R[11]
		local a = R[8]
		return function(R, H)
			if not s[3][s[2]] then
				return
			end
			local s = g.Value
			local g, Y = F.Value, G.Value
			local F = Z.Value
			local Z = J(a(H * d.Value) * l.Value)
			local l
			if (s > 0) then
				l = _((H * 360 * s) % 360)
			else
				l = _(F)
			end
			v[3][v[2]] = v[3][v[2]]:Lerp(R, A.Value)
			for R, d in m do
				local m, F = d[1], d[2]
				local d = l + q * (R - 1)
				local R = n(a(d), T(d))
				local T = Y + Z
				local q = g
				m.To = v[3][v[2]] + (R * T)
				m.From = v[3][v[2]] + (R * T) + (R * q)
				if F then
					T, q = T - 1, q + 2
					F.To = v[3][v[2]] + (R * T)
					F.From = v[3][v[2]] + (R * T) + (R * q)
				end
			end
		end
	end

local b = function(R)
		local T = R[7]
		local q = R[1]
		local g = R[10]
		local l = R[13]
		local m = R[4]
		local d = R[8]
		local Z = R[5]
		local F = R[2]
		local A = R[15]
		local _ = R[9]
		local n = R[0]
		local v = R[6]
		local J = R[12]
		local s = R[14]
		local G = R[3]
		local a = R[11]
		return function()
			if not l[3][l[2]][T] then
				d.Enabled = false
				return
			end
			d.Enabled = true
			d.Size = a[3][a[2]]
			if _[3][_[2]] then
				F.Visible = true
				F.Text = v((s.CFrame.Position - A:GetPivot().Position).Magnitude) .. "s"
				F.TextColor3 = g[3][g[2]]
				F.FontFace, F.TextSize = n[3][n[2]].font, n[3][n[2]].size
			else
				F.Visible = false
			end
			if J[3][J[2]] then
				q.Visible = true
				q.TextColor3 = m[3][m[2]]
				q.FontFace, q.TextSize = n[3][n[2]].font, n[3][n[2]].size
			else
				q.Visible = false
			end
			if G[3][G[2]] then
				Z.Visible = true
			else
				Z.Visible = false
			end
		end
	end

local M = function(R)
		local T = R[0]
		return function()
			T.Parent = Toggles.atmosphere_enabled.Value and game:GetService("Lighting") or nil
			if not T.Parent then
				return
			end
			T.Color = Options.atmosphere_color.Value
			T.Decay = Options.atmosphere_decay.Value
			T.Glare = Options.atmosphere_glare.Value
			T.Haze = Options.atmosphere_haze.Value
			T.Density = Options.atmosphere_density.Value
			T.Offset = Options.atmosphere_offset.Value
		end
	end

local K = function(R)
		local T = R[1]
		local q = R[8]
		local g = R[4]
		local l = R[5]
		local m = R[10]
		local d = R[3]
		local Z = R[7]
		local F = R[2]
		local A = R[0]
		local _ = R[6]
		local n = R[9]
		return function()
			function F:SetValue(R)
				if Z.MaxLength and #R > Z.MaxLength then
					R = R:sub(1, Z.MaxLength)
				end
				if F.Numeric then
					if (not tonumber(R)) and R:len() > 0 then
						R = F.Value
					end
				end
				F.Value = R
				A.Text = R
				l:SafeCallback(F.Callback, F.Value)
				l:SafeCallback(F.Changed, F.Value)
			end
			function F:Remove()
				for R, R in g do
					R:Destroy()
				end
				d[T] = nil
				n:Destroy()
				table.clear(F)
				_:Resize()
			end
			if F.Finished then
				A.FocusLost:Connect(function(R)
					if not R then
						return
					end
					F:SetValue(A.Text)
					l:AttemptSave()
				end)
			else
				A:GetPropertyChangedSignal("Text"):Connect(function()
					F:SetValue(A.Text)
					l:AttemptSave()
				end)
			end
			local function R()
				local Z = 2
				local v = q.AbsoluteSize.X
				if not A:IsFocused() or A.TextBounds.X <= v - 2 * Z then
					A.Position = UDim2.new(0, Z, 0, 0)
				else
					local q = A.CursorPosition
					if q ~= -1 then
						local J = string.sub(A.Text, 1, q - 1)
						local q = m:GetTextSize(J, A.TextSize, A.Font, Vector2.new(math.huge, math.huge)).X
						local m = A.Position.X.Offset + q
						if m < Z then
							A.Position = UDim2.fromOffset(Z - q, 0)
						elseif m > v - Z - 1 then
							A.Position = UDim2.fromOffset(v - q - Z - 1, 0)
						end
					end
				end
			end
			task.spawn(R)
			A:GetPropertyChangedSignal("Text"):Connect(R)
			A:GetPropertyChangedSignal("CursorPosition"):Connect(R)
			A.FocusLost:Connect(R)
			A.Focused:Connect(R)
			if l.FlagCopying then
				local R = l:AddContextMenu(n)
				R:AddOption("Copy Flag", function()
					pcall(setclipboard, F.Idx)
					task.wait()
					l:Notify("Copied flag to clipboard!", 2)
					R:Hide()
				end)
			end
			l:AddToRegistry(A, { TextColor3 = "FontColor" })
			function F:OnChanged(R)
				F.Changed = R
				R(F.Value)
			end
			table.insert(g, _:AddBlank(5))
			_:Resize()
			d[T] = F
		end
	end

local U = function(R)
		local T = R[1]
		local q = R[2]
		local g = R[0]
		local l = R[3]
		return function()
			function T:SetSize(R)
				g.Size = UDim2.new(1, -4, 0, R)
			end
			function T:GetOuter()
				return g
			end
			function T:GetInner()
				return l
			end
			function T:GetSize()
				return l.AbsoluteSize
			end
			local R = {}
			table.insert(R, q:AddBlank(5))
			q:Resize()
		end
	end

local I = function(R)
		local T = R[3]
		local q = R[4]
		local g = R[8]
		local l = R[2]
		local m = R[10]
		local d = R[0]
		local Z = R[11]
		local F = R[1]
		local A = R[9]
		local _ = R[7]
		local n = R[6]
		local v = R[5]
		return function()
			local R = {}
			local R = false
			local J = false
			function q:Toggle()
				if J then
					return
				end
				R = not R
				q.Toggled = R
				l[3][l[2]] = R
				q:FireEvent("VisibilityChanged", l[3][l[2]])
				F.Modal = R
				if R then
					_.Visible = true
					local l = game:GetService("GuiService")
					task.spawn(function()
						local F = v.MouseIconEnabled
						local J = Instance.new("ImageLabel", A)
						J.Image = "http://www.roblox.com/asset/?id=4292970642"
						J.BackgroundTransparency = 1
						J.ZIndex = 125
						local s = Instance.new("ImageLabel", A)
						s.Image = "http://www.roblox.com/asset/?id=4292970642"
						s.ImageColor3 = Color3.new()
						s.BackgroundTransparency = 1
						s.ZIndex = 124
						J.Size, s.Size = UDim2.fromOffset(17, 17), UDim2.fromOffset(19, 19)
						J.Rotation, s.Rotation = -45, -45
						while R and A.Parent do
							v.MouseIconEnabled = false
							local A = v:GetMouseLocation()
							local G = UDim2.fromOffset(A.X, A.Y - l:GetGuiInset().Y - 1)
							J.ImageColor3 = q.AccentColor
							J.Position, s.Position = G, G - UDim2.fromOffset(1, 1)
							Z:Wait()
						end
						v.MouseIconEnabled = F
						J:Destroy()
						s:Destroy()
					end)
				end
				for l, l in d do
					task.spawn(function()
						if l.Type == "Dropdown" then
							l:CloseDropdown()
						elseif l.Type == "KeyPicker" then
							l:SetModePickerVisibility(false)
						elseif l.Type == "ColorPicker" then
							l:Hide()
						end
					end)
				end
				if R and q.BlockInput then
					n:BindAction("Freeze", function()
						return Enum.ContextActionResult.Sink
					end, false, table.unpack(Enum.PlayerActions:GetEnumItems()))
				else
					n:UnbindAction("Freeze")
				end
				g.Enabled = R
				T.Enabled = R
				m.Enabled = R
				_.Visible = R
			end
			q:GiveSignal(v.InputBegan:Connect(function(R, T)
				if typeof(q.ToggleKeybind) == "table" and q.ToggleKeybind.Type == "KeyPicker" then
					if R.UserInputType == Enum.UserInputType.Keyboard and R.KeyCode.Name == q.ToggleKeybind.Value then
						task.spawn(q.Toggle)
					end
				elseif R.KeyCode == Enum.KeyCode.RightControl or (R.KeyCode == Enum.KeyCode.Insert and not T) then
					task.spawn(q.Toggle)
				end
			end))
		end
	end

local S = function(R)
		local T = R[1]
		local q = R[0]
		return function()
			local R = Toggles.sunrays_enabled.Value
			if R then
				q.Enabled = true
				q.Spread = Options.sunrays_spread.Value
				q.Intensity = Options.sunrays_intensity.Value
			else
				for R, g in T do
					q[R] = g
				end
			end
		end
	end

local G = function(R)
		local T = R[10]
		local q = R[9]
		local g = R[15]
		local l = R[12]
		local m = R[20]
		local d = R[13]
		local Z = R[5]
		local F = R[14]
		local A = R[0]
		local _ = R[2]
		local n = R[11]
		local v = R[19]
		local J = R[8]
		local s = R[21]
		local G = R[18]
		local a = R[6]
		local H = R[16]
		local Y = R[17]
		local N = R[4]
		local U = R[3]
		local i = R[1]
		local L = R[7]
		return function()
			local R, c = Toggles.esp_name.Value, Toggles.esp_distance.Value
			local y = Toggles.esp_weapon.Value
			local O, t = Toggles.esp_box.Value, Toggles.esp_fill.Value
			local B = Toggles.esp_skeleton.Value
			local f, Q = Toggles.esp_skeleton_outline.Value, Options.esp_skeleton_thickness.Value
			local z, j = Toggles.esp_healthbar_resize.Value, Options.esp_healthbar_health_lerp.Value
			local S = Options.esp_bounds_type.Value == "dynamic"
			local u = Options.esp_bounds_width_scale.Value / 100
			local w = Toggles.esp_show_team.Value
			local x = false
			local o = function()
				x = (L[3][L[2]] or R or c or y or O or t or B)
			end
			o()
			do
				Toggles.esp_healthbar:OnChanged(function(V)
					L[3][L[2]] = V
					o()
				end)
				Toggles.esp_name:OnChanged(function(V)
					R = V
					o()
				end)
				Toggles.esp_distance:OnChanged(function(V)
					c = V
					o()
				end)
				Toggles.esp_weapon:OnChanged(function(V)
					y = V
					o()
				end)
				Toggles.esp_box:OnChanged(function(V)
					O = V
					o()
				end)
				Toggles.esp_fill:OnChanged(function(V)
					t = V
					o()
				end)
				Toggles.esp_skeleton:OnChanged(function(V)
					B = V
					o()
				end)
				Toggles.esp_show_team:OnChanged(function(o)
					w = o
					J.events.esp_color_changed:Fire()
					J.events.esp_effects_changed:Fire()
				end)
				Options.esp_bounds_width_scale:OnChanged(function(o)
					u = o / 100
				end)
				Options.esp_bounds_type:OnChanged(function(o)
					S = o == "dynamic"
				end)
				Options.esp_skeleton_thickness:OnChanged(function(o)
					Q = o
				end)
				Toggles.esp_skeleton_outline:OnChanged(function(o)
					f = o
				end)
				Toggles.esp_healthbar_resize:OnChanged(function(o)
					z = o
				end)
				Options.esp_healthbar_health_lerp:OnChanged(function(o)
					j = o
				end)
			end
			local o, V = Z.CFrame.UpVector, Z.CFrame.Position
			local X = tick
			do
				local I = {}
				local r = function(b, C, M)
					if (not C or not M) then
						return
					end
					local E, W = C.Value, M.Value
					C:OnChanged(function(C)
						E = C
					end)
					M:OnChanged(function(C)
						W = C
					end)
					local C = _.gradients[b]
					table.insert(I, function(b)
						if E then
							local M = (b * 360 * W) % 360
							for b, b in pairs(C) do
								b.Rotation = M
							end
						end
					end)
				end
				for b in _.gradients do
					if (b ~= "healthbar") then
						r(b, Toggles["esp_" .. b .. "_moving"], Options["esp_" .. b .. "_rotation_speed"])
					end
				end
				local r, r = _.gradients.fill, _.gradients.box
				local r = pairs
				Y.RenderStepped:Connect(function()
					local b = Z.CFrame
					V, o = b.Position, b.UpVector
					local Z = X()
					for X, X in r(I) do
						X(Z)
					end
				end)
			end
			local Z = {
				"RightHand",
				"LeftLowerArm",
				"RightLowerArm",
				"LeftUpperArm",
				"RightUpperArm",
				"LowerTorso",
				"LeftLowerLeg",
				"LeftUpperLeg",
				"LeftFoot",
				"RightFoot",
				"RightLowerLeg",
				"RightUpperLeg",
				"UpperTorso",
				"LeftHand",
				"Head",
			}
			local X = {}
			return function(I, r)
				local b =
					{ connections = {}, gradients = {}, functions = {}, drawings = {}, squares = {}, text = {}, lines = {} }
				if _.running[I] then
					return H(I, "attempted to initialize twice")
				end
				local H = I.Character
				local C = H and H:FindFirstChild("Humanoid")
				local M = H and H:FindFirstChild("HumanoidRootPart")
				if not I.Parent then
					return
				end
				local E = J.effects.self_effects.new("esp")
				local W, W = U(0, 2.5, 0), U(0, 3.5, 0)
				local W = A(5, q[Options.esp_font.Value].size - 2)
				local e = Vector2.zero.Floor
				local k, P = pairs, {}
				local D = function()
					local p, p = g[3][g[2]](M.Position)
					if not p then
						return
					end
					local p, h = i, i
					local K, RT = -i, -i
					local TT = false
					for qT, qT in k(P) do
						local gT, lT = qT.CFrame, qT.Size * 0.5
						local qT, mT, dT = lT.X, lT.Y, lT.Z
						for lT, lT in
							{
								gT * a(-qT, -mT, -dT),
								gT * a(-qT, -mT, dT),
								gT * a(-qT, mT, -dT),
								gT * a(-qT, mT, dT),
								gT * a(qT, -mT, -dT),
								gT * a(qT, -mT, dT),
								gT * a(qT, mT, -dT),
								gT * a(qT, mT, dT),
							}
						do
							local a, qT = g[3][g[2]](lT.Position)
							if not qT then
								continue
							end
							TT = true
							local qT, gT = a.X, a.Y
							p, h = v(p, qT), v(h, gT)
							K, RT = T(K, qT), T(RT, gT)
						end
					end
					if not TT then
						return
					end
					local v = T(10, K - p)
					local a = T(10, RT - h)
					local K = e(A(v, a))
					local v = e(A(p + K.X / 2, h))
					return K, v, M.Position
				end
				local v = function()
					if S then
						return D()
					end
					local a = M.Position
					local S = a + o * 2.5
					local D, p = g[3][g[2]](S)
					if not p then
						return
					end
					if ((a - V).Magnitude > 600) then
						return W, e(D), a
					end
					local S = a - o * 3.5
					local o, p = g[3][g[2]](S)
					if not p then
						return
					end
					local S = T(10, n(o.Y - D.Y))
					return e(A(S * u, S)), e(D), a
				end
				local n, a = C and C.Health or 0, C and C.MaxHealth or 100
				local S = function(u)
					H = u
					M = u:WaitForChild("HumanoidRootPart", math.huge)
					C = u:WaitForChild("Humanoid", math.huge)
					table.insert(
						b.connections,
						C:GetPropertyChangedSignal("Health"):Connect(function()
							n = C.Health
						end)
					)
					table.insert(
						b.connections,
						C:GetPropertyChangedSignal("MaxHealth"):Connect(function()
							a = C.MaxHealth
						end)
					)
					n, a = C.Health, C.MaxHealth
					for o, o in Z do
						P[o] = u:WaitForChild(o, i)
					end
					if (not w and r._is_ally) then
						return
					end
					local i = function()
						local o = u.Parent
						if (o ~= d) then
							task.wait()
							if (u.Parent ~= nil) then
								u.Parent = d
							end
						end
					end
					task.wait()
					pcall(i)
					local i = P.Head
					while (task.wait(1) and i.Parent and i.Transparency > 0.5) do
					end
					if ((not w and r._is_ally) or not i.Parent) then
						return
					end
					if (H and Toggles.esp_override_appearance.Value) then
						J.customization.self:change(H, function()
							local i = Options.esp_body_disables.Value
							return Toggles.esp_body_color.Value and Options.esp_body_color_value.Value,
								1 - (Options.esp_body_transparency.Value / 100),
								Toggles.esp_material.Value and Enum.Material[Options.esp_material_value.Value],
								i["decals"],
								i["clothing"]
						end)
					end
					for i, i in { "aura", "particle" } do
						if (H and Toggles["esp_effects_" .. i].Value) then
							E:create(H, Options["esp_effects_" .. i .. "_value"].Value, i)
						else
							E:destroy(i)
						end
					end
				end
				local i = function(u, o)
					local e = X[u]
					local D, p
					if not e then
						D, p = {}, 0
						while true do
							local h = (Options[u .. (p + 1)] or Options[u])
							if not h then
								break
							end
							p = p + 1
							table.insert(D, h)
						end
						X[u] = { D, p }
					else
						D, p = unpack(e)
					end
					local u = {}
					local X, e =
						(o and NumberSequenceKeypoint or ColorSequenceKeypoint).new, o and "Transparency" or "Value"
					for h, K in D do
						table.insert(u, X((h - 1) / (p - 1), K[e] or 0))
					end
					return (o and NumberSequence or ColorSequence).new(u)
				end
				local u = function(o, X)
					table.insert(_.gradients[o], X)
					b.gradients[o] = X
					return X
				end
				do
					for o = 1, 7 do
						b.squares[o] = l("Square", { Visible = false, Outline = true }, b.drawings)
					end
					do
						for o = 1, 26 do
							local X = (o > 13)
							table.insert(
								b.lines,
								l(
									"Line",
									{
										Visible = false,
										ZIndex = not X and 2 or nil,
										Thickness = Q + (X and 2 or 0),
										Color = X and Color3.new() or Color3.new(1, 1, 1),
									},
									b.drawings
								)
							)
						end
						do
							local o = {
								ColorSequence.new(Options.esp_skeleton_color2.Value, Options.esp_skeleton_color3.Value),
								ColorSequence.new(Options.esp_skeleton_color1.Value, Options.esp_skeleton_color2.Value),
								ColorSequence.new(Options.esp_skeleton_color1.Value),
							}
							for X = 1, 13 do
								local e = Instance.new("UIGradient", b.lines[X]._frame)
								local D = ((X - 1) % 3) + 1
								if (X == 13) then
									e.Color = ColorSequence.new(Options.esp_skeleton_color3.Value)
								else
									e.Color = o[D]
								end
							end
						end
					end
					local o = q[Options.esp_font.Value]
					for X = 1, 3 do
						local e = l(
							"Text",
							{ Outline = true, Visible = false, Color = Color3.new(1, 1, 1), Middle = true, Center = true, Size = 12 },
							b.drawings
						)
						e._frame.FontFace, e.Size = o.font, o.size
						b.text[X] = e
					end
					b.squares[1].Thickness = 3
					b.squares[2].ZIndex = 2
					b.squares[2].Color = Color3.new(1, 1, 1)
					b.squares[3].ZIndex = 2
					b.squares[3].Color = Color3.new(1, 1, 1)
					b.squares[4].Color = Color3.new(0, 0, 0)
					b.squares[3].Filled = true
					b.squares[4].Filled = true
					b.squares[3].Color = Color3.new(1, 1, 1)
					b.squares[5].ZIndex = 2
					b.squares[5].Color = Color3.new(1, 1, 1)
					b.squares[6].Color = Color3.new(0, 0, 0)
					b.squares[5].Filled = true
					b.squares[6].Filled = true
					b.squares[5].Color = Color3.new(1, 1, 1)
					local l = rawget(r, "ClientFighter")
					l = l and rawget(l, "EquippedItem")
					b.text[2].Text = l and l.Name or "none"
					b.text[1].Text = Options.esp_name_type.Value == "Name" and I.Name or I.DisplayName
					b.text[1]._frame.RichText = true
					for l, o in { "esp_name_", "esp_weapon_", "esp_distance_" } do
						local X = b.text[l]._frame
						local l = Instance.new("UIGradient", X)
						X.AnchorPoint, X.AutomaticSize = A(0.5, 0), Enum.AutomaticSize.XY
						l.Color, l.Rotation = i(o .. "color"), Options[o .. "rotation"].Value
						u(o:split("_")[2], l)
					end
					do
						local l = u("box", Instance.new("UIGradient", b.squares[2]._frame._stroke))
						l.Rotation = Options.esp_box_rotation.Value
						b.squares[2]._frame._stroke.UIGradient.Color = i("esp_box_color")
					end
					b.squares[7].Color = Color3.new(1, 1, 1)
					b.squares[7].Filled = true
				end
				local l = N[Options.esp_font.Value] or A(2, -1)
				do
					local o, X = b.squares[1], b.squares[2]
					local e, D = A(2, 2), A(1, 1)
					b.functions.box = function(p, h)
						if O then
							local O = h - A(p.X / 2, 0)
							X.Size = p
							o.Size = p + e
							X.Position = O
							o.Position = O - D
							X.Visible = true
							o.Visible = true
						else
							X.Visible = false
							o.Visible = false
						end
					end
				end
				do
					local O = b.squares[7]
					local o = u("fill", Instance.new("UIGradient", O._frame))
					do
						o.Color, o.Transparency, o.Rotation =
							i("esp_fill_color"), i("esp_fill_color", true), Options.esp_fill_rotation.Value
						O._frame._stroke:Destroy()
					end
					local X = A(2, 2)
					b.functions.fill = function(e, D, p)
						if t then
							local t = D - A(e.X / 2 - 1, -1)
							O.Size = e - X
							O.Position = t
							O.Visible = true
						else
							O.Visible = false
						end
					end
					table.insert(
						b.connections,
						J.events.esp_fill_changed.Event:Connect(function(...)
							o.Color, o.Transparency, o.Rotation =
								i("esp_fill_color"), i("esp_fill_color", true), Options.esp_fill_rotation.Value
						end)
					)
				end
				do
					local O = b.text[1]
					O._frame.AnchorPoint = A(0.5, 1)
					local t = A(0, 2)
					b.functions.name = function(o, o)
						if R then
							O.Position = o - t
							O.Visible = true
						else
							O.Visible = false
						end
					end
				end
				do
					local R = b.text[2]
					b.functions.weapon = function(O, t)
						if y then
							R.Position = t + A(0, O.Y + 1)
							R.Visible = true
						else
							R.Visible = false
						end
					end
					m(R, r)
				end
				do
					local R, m = b.text[3], b.text[2]
					b.functions.distance = function(y, O, t)
						if c then
							R.Position = O + A(0, (m.Visible and (y.Y + R.TextBounds.Y) or y.Y) + 2)
							R.Visible = true
							R.Text = "[" .. G((V - t).Magnitude) .. "]"
						else
							R.Visible = false
						end
					end
				end
				do
					local R = {
						{ "LeftUpperArm", "UpperTorso" },
						{ "LeftLowerArm", "LeftUpperArm" },
						{ "LeftLowerArm", "LeftHand" },
						{ "RightUpperArm", "UpperTorso" },
						{ "RightLowerArm", "RightUpperArm" },
						{ "RightHand", "RightLowerArm" },
						{ "LeftUpperLeg", "LowerTorso" },
						{ "LeftLowerLeg", "LeftUpperLeg" },
						{ "LeftFoot", "LeftLowerLeg" },
						{ "RightUpperLeg", "LowerTorso" },
						{ "RightLowerLeg", "RightUpperLeg" },
						{ "RightFoot", "RightLowerLeg" },
						{ "LowerTorso", "UpperTorso" },
					}
					local m = b.lines
					local G = m[1]
					local G = false
					local c = function()
						if G then
							return
						end
						G = true
						for y, y in m do
							y.Visible = false
						end
					end
					local y = #Z
					local Z = function()
						local O = {}
						local t = 0
						for o, V in k(P) do
							t = t + 1
							O[o] = g[3][g[2]](o ~= "UpperTorso" and V.Position or (V.Position + U(0, V.Size.Y / 3, 0)))
						end
						if (t ~= y) then
							return
						end
						return O
					end
					b.functions.skeleton = function()
						if not B then
							return c()
						end
						local g = Z()
						if not g then
							return c()
						end
						G = false
						for Z, G in R do
							local R, U = m[Z], m[Z + 13]
							local m, Z = g[G[1]], g[G[2]]
							local g = (m - Z).Unit
							R.From, R.To = m + g, Z - g
							if f then
								local G = g * 2
								U.From, U.To = m + G, Z - G
								U.Visible = true
							else
								U.Visible = false
							end
							R.Visible = true
						end
					end
				end
				do
					local R = u("healthbar", Instance.new("UIGradient", b.squares[3]._frame._stroke))
					R.Color = s[3][s[2]]
					R.Rotation = 90
					local g, m = b.squares[3], b.squares[4]
					g._frame.AnchorPoint = A(0, 1)
					m._frame.AnchorPoint = A(0, 1)
					local Z, Z = 0, 0
					local s = math.lerp
					local G = Options.esp_healthbar_health_lerp
					local G, U = A(0, 1), A(0, 2)
					local c = A(5, 0)
					local c = A(-1, 2)
					local y = A(1, -1)
					local y = A(1, -1)
					table.insert(
						b.connections,
						I.CharacterAdded:Connect(function()
							Z = 0
						end)
					)
					b.functions.healthbar = function(O, t, B)
						if L[3][L[2]] then
							t = t - G
							O = O + U
							local G = t - A(O.X / 2 + 6, -O.Y + 1) - c
							if L[3][L[2]] then
								local U = n / a
								Z = s(Z, U, j)
								local s = A(2, T(2, (O.Y - 2) * Z))
								g.Size = s
								g.Position = G
								R.Offset = A(0, (Z - 1))
								if z then
									m.Size = A(4, s.Y + 2)
									m.Position = G - y
								else
									m.Size = A(4, O.Y)
									m.Position = G - y
								end
								m.Visible = true
								g.Visible = true
							else
								m.Visible, g.Visible = false, false
							end
						else
							m.Visible, g.Visible = false, false
						end
					end
				end
				local R = false
				local T = function()
					if R then
						return
					end
					R = true
					for g, g in b.drawings do
						g.Visible = false
					end
				end
				table.insert(b.connections, I.CharacterAdded:Connect(S))
				table.insert(
					b.connections,
					I.CharacterRemoving:Connect(function(g)
						if (H == g) then
							H = nil
							M = nil
							C = nil
							n = 0
							b.text[2].Text = "none"
							table.clear(P)
						end
					end)
				)
				local g
				table.insert(
					b.connections,
					J.events.esp_color_changed.Event:Connect(function()
						for m, Z in { "esp_name_", "esp_weapon_", "esp_distance_" } do
							local s = b.text[m]._frame.UIGradient
							s.Color, s.Rotation = i(Z ..
