local RunService: RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SourceURL = 'https://github.com/depthso/Roblox-ImGUI/raw/main/ImGui.lua'
ImGui = loadstring(game:HttpGet(SourceURL))()

local Window = ImGui:CreateWindow({
	Title = "GL Service @rbxscripting",
	Size = UDim2.new(0, 300, 0, 200),
	Position = UDim2.new(0.5, 0, 0, 70)
})
Window:Center()

local ConsoleTab = Window:CreateTab({ Name = "Join | Leave" })

local Console = ConsoleTab:Console({
	Text = "Console initialized.",
	ReadOnly = true,
	LineNumbers = false,
	Border = false,
	Fill = true,
	Enabled = true,
	AutoScroll = true,
	RichText = true,
	MaxLines = 100
})

local ChatTab = Window:CreateTab({ Name = "Chat Spy" })

local ChatConsole = ChatTab:Console({
	Text = "Chat spy started.",
	ReadOnly = true,
	LineNumbers = false,
	Border = false,
	Fill = true,
	Enabled = true,
	AutoScroll = true,
	RichText = true,
	MaxLines = 100
})

local function getTimestamp()
	local now = DateTime.now()
	return now:FormatLocalTime("HH:mm:ss", "en-us")
end

local function logPlayer(playerName: string, joined: boolean)
	local color = joined and "rgb(0, 255, 0)" or "rgb(255, 0, 0)"
	local action = joined and "Joined." or "Left."
	local timestamp = getTimestamp()

	Console:AppendText(
		`<font color="{color}">[{timestamp}]</font> {playerName} {action}`
	)
end

local function logChatMessage(playerName: string, message: string)
	local timestamp = getTimestamp()
	local timeColor = "rgb(0, 170, 255)"

	ChatConsole:AppendText(
		`<font color="{timeColor}">[{timestamp}]</font> All {playerName}: {message}`
	)
end

local function hookChatForPlayer(player)
	if player == Players.LocalPlayer then return end

	player.Chatted:Connect(function(message)
		logChatMessage(player.Name, message)
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	if player ~= Players.LocalPlayer then
		logPlayer(player.Name, true)
		hookChatForPlayer(player)
	end
end

Players.PlayerAdded:Connect(function(player)
	logPlayer(player.Name, true)
	hookChatForPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
	logPlayer(player.Name, false)
end)
