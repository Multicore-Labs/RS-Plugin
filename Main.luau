local toolbar = plugin:CreateToolbar("RS")

local inskit = toolbar:CreateButton("Insert Kit", "insert the rs kit into workspace", "rbxassetid://85336764608981")

local texinsert = toolbar:CreateButton("Insert Textures", "random textures lol", "rbxassetid://133971267007402")

local duminsert = toolbar:CreateButton("Insert Dummy", "inserts a dummy", "rbxassetid://113497500053931")

inskit.Click:Connect(function()
	local kit = script.Garbage.kit:Clone()
	kit.Parent = game.Workspace

    if game:GetService("Selection") then
        game:GetService("Selection"):Set({kit})
    end
end)

texinsert.Click:Connect(function()
	local texture = script.Garbage.texture:Clone()
	texture.Parent = game.Workspace
	
	if game:GetService("Selection") then
		game:GetService("Selection"):Set({texture})
	end
end)

duminsert.Click:Connect(function()
	local dum = script.Garbage.Dummy:Clone()
	dum.Parent = game.Workspace

	if game:GetService("Selection") then
		game:GetService("Selection"):Set({dum})
	end
end)