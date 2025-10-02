local toolbar = plugin:CreateToolbar("RS")
local menuButton = toolbar:CreateButton("Open Menu", "Open RS Plugin Menu", "rbxassetid://85336764608981")

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Left, true, false, 300, 400, 150, 200
)

local dockWidget = plugin:CreateDockWidgetPluginGui("RSMenu", widgetInfo)
dockWidget.Title = "[[ MULTICORE LABS DEMO ]]"
dockWidget.Enabled = false

local TweenService = game:GetService("TweenService")
local function applyUICorner(instance, radius)
	local uic = Instance.new("UICorner")
	uic.CornerRadius = radius or UDim.new(0.25, 0)
	uic.Parent = instance
	return uic
end

local windowBarColor = Color3.fromRGB(34, 35, 40)
local mainBgColor = Color3.fromRGB(24, 25, 30)

local ui = Instance.new("Frame")
ui.Size = UDim2.new(1, 0, 1, 0)
ui.Position = UDim2.new(0,0,0,0)
ui.BackgroundColor3 = mainBgColor
ui.BorderSizePixel = 0
ui.Parent = dockWidget
ui.BackgroundTransparency = 1
ui.Visible = false

local header = Instance.new("Frame")
header.Size = UDim2.new(1, -32, 0, 64)
header.Position = UDim2.new(0, 16, 0, 16)
header.BackgroundColor3 = Color3.fromRGB(41, 41, 46)
header.BorderSizePixel = 0
header.Parent = ui
applyUICorner(header, UDim.new(0, 16))

local profileImg = Instance.new("ImageLabel")
profileImg.Size = UDim2.new(0, 48, 0, 48)
profileImg.Position = UDim2.new(0, 12, 0.5, -24)
profileImg.BackgroundTransparency = 1
profileImg.Image = "rbxassetid://135566934725161"
profileImg.ScaleType = Enum.ScaleType.Fit
profileImg.Parent = header
applyUICorner(profileImg, UDim.new(1,0))

local username = Instance.new("TextLabel")
username.Size = UDim2.new(1, -70, 1, 0)
username.Position = UDim2.new(0, 70, 0, 0)
username.BackgroundTransparency = 1
username.Text = "<i><b>Multicore Labs</b></i>"
username.RichText = true
username.TextSize = 28
username.TextColor3 = Color3.new(1,1,1)
username.FontFace = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.Bold, Enum.FontStyle.Italic)
username.TextXAlignment = Enum.TextXAlignment.Left
username.TextYAlignment = Enum.TextYAlignment.Center
username.Parent = header

local categories = {
	{
		name = "Revolver Showdown",
		buttons = {
			{
				text = "Insert Kit",
				callback = function()
					local kit = script.Garbage.kit:Clone()
					kit.Parent = game.Workspace
					if game:GetService("Selection") then
						game:GetService("Selection"):Set({kit})
					end
				end
			},
			{
				text = "Insert Textures",
				callback = function()
					local texture = script.Garbage.texture:Clone()
					texture.Parent = game.Workspace
					if game:GetService("Selection") then
						game:GetService("Selection"):Set({texture})
					end
				end
			},
			{
				text = "Insert Dummy",
				callback = function()
					local dum = script.Garbage.Dummy:Clone()
					dum.Parent = game.Workspace
					if game:GetService("Selection") then
						game:GetService("Selection"):Set({dum})
					end
				end
			},
		}
	},
}

local CATEGORY_HEIGHT = 48
local BUTTON_HEIGHT = 40
local SPACING = 12
local TOP_PAD = 96

local container = Instance.new("Frame")
container.Position = UDim2.new(0, 0, 0, TOP_PAD)
container.Size = UDim2.new(1, 0, 1, -TOP_PAD)
container.BackgroundTransparency = 1
container.Parent = ui

local function makeButton(parent, text, posY, height, font, textSize, color, bgcolor)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -32, 0, height)
	btn.Position = UDim2.new(0, 16, 0, posY)
	btn.BackgroundColor3 = bgcolor
	btn.TextColor3 = color
	btn.FontFace = font
	btn.TextSize = textSize
	btn.Text = text
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true
	btn.AnchorPoint = Vector2.new(0, 0)
	btn.Parent = parent
	applyUICorner(btn, UDim.new(0, 8))
	return btn
end

local function makeCategoryButton(parent, text, posY)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -8, 0, CATEGORY_HEIGHT)
	frame.Position = UDim2.new(0, 4, 0, posY)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local btn = Instance.new("TextButton")
	btn.Name = "CategoryButton"
	btn.Size = UDim2.new(1, -60, 1, 0)
	btn.Position = UDim2.new(0, 0, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(100,100,150)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.FontFace = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	btn.TextSize = 26
	btn.Text = text
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.TextXAlignment = Enum.TextXAlignment.Center
	btn.Parent = frame
	applyUICorner(btn, UDim.new(0, 16))

	local arrow = Instance.new("TextButton")
	arrow.Name = "Arrow"
	arrow.Size = UDim2.new(0, 48, 1, 0)
	arrow.Position = UDim2.new(1, -48, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.FontFace = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	arrow.TextSize = 34
	arrow.TextColor3 = Color3.new(1,1,1)
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.TextYAlignment = Enum.TextYAlignment.Center
	arrow.Parent = frame

	return frame, btn, arrow
end

local dropdowns = {}
local function rebuildDropdowns()
	for _, v in pairs(container:GetChildren()) do v:Destroy() end
	dropdowns = {}
	local y = 0
	for i, cat in ipairs(categories) do
		local catFrame, catBtn, arrow = makeCategoryButton(container, cat.name, y)
		catFrame.BackgroundTransparency = 1

		local btnFrame = Instance.new("Frame")
		btnFrame.Size = UDim2.new(1, 0, 0, #cat.buttons * (BUTTON_HEIGHT + SPACING))
		btnFrame.Position = UDim2.new(0, 0, 0, y + CATEGORY_HEIGHT + 12)
		btnFrame.BackgroundTransparency = 1
		btnFrame.ClipsDescendants = true
		btnFrame.Visible = true
		btnFrame.Parent = container

		for j, btnDef in ipairs(cat.buttons) do
			local arimo = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			local btn = makeButton(btnFrame, btnDef.text, (j-1)*(BUTTON_HEIGHT+SPACING), BUTTON_HEIGHT, arimo, 20, Color3.new(1,1,1), Color3.fromRGB(80,80,120))
			btn.MouseButton1Click:Connect(btnDef.callback)
		end

		local expanded = true
		arrow.Text = expanded and "▼" or "▶"
		arrow.MouseButton1Click:Connect(function()
			expanded = not expanded
			btnFrame.Visible = expanded
			arrow.Text = expanded and "▼" or "▶"
			for di, dr in ipairs(dropdowns) do
				if di ~= i then
					dr.btnFrame.Visible = false
					dr.arrow.Text = "▶"
					dr.expanded = false
				end
			end
		end)

		table.insert(dropdowns, {btnFrame = btnFrame, arrow = arrow, expanded = expanded})
		y = y + CATEGORY_HEIGHT + (#cat.buttons)*(BUTTON_HEIGHT+SPACING) + 16
	end
end

rebuildDropdowns()

local spinning = false
local function spinImage()
	if spinning then return end
	spinning = true
	local goal = {Rotation = 360}
	local tween = TweenService:Create(profileImg, TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, false), goal)
	tween:Play()
	tween.Completed:Connect(function()
		profileImg.Rotation = 0
		spinning = false
	end)
end

local function openMenuSmooth()
	ui.Visible = true
	ui.BackgroundTransparency = 1
	local tween = TweenService:Create(ui, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
	tween:Play()
end

local function closeMenuSmooth()
	local tween = TweenService:Create(ui, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
	tween:Play()
	tween.Completed:Once(function()
		ui.Visible = false
	end)
end

menuButton.Click:Connect(function()
	if not dockWidget.Enabled then
		dockWidget.Enabled = true
	else
		dockWidget.Enabled = false
	end
	if not ui.Visible or ui.BackgroundTransparency == 1 then
		openMenuSmooth()
		spinImage()
	else
		closeMenuSmooth()
		spinImage()
	end
	
end)
