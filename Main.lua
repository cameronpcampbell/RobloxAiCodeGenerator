--!strict

-- Services
local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")

-- Modules
local ScriptDocPlus = require(script.Parent.ScriptDocPlus)
local OpenAiWrapper = require(script.Parent.OpenAiWrapper)

-- Variables
local Brief = " You are an extra brain whose job is to assist a programmer (me) on their journey through game development on roblox. Using the datamodel (DATAMODEL), the instruction (INSTRUCTION) and the current script (CURRENT SCRIPT) below you carefully craft code using roblox LUA. The DataModel contains key value pairs, the key is a roblox service and the value contains a nested array of the services children. The services children are formatted as '(childs name, class of child)'. PLEASE REFER TO THE DATAMODEL WHEN ANSWERING THE INSTRUCTION. If the current script is not provided then you can assume that the script is currently empty. You then return the code and ONLY the code. Make the code as condensed and simple to read as possible. Do not add in useless lines of code. If the instruction is not a proper instruction for prompting an answer for roblox LUA code then respond with \"Invalid Instruction\"."

OpenAiWrapper.ApiKey = ""

local Services = {
	"Workspace",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui"
}

local function GetDataModel()
	local DataModelString = ""
	for _,serviceName in Services do
		local service = game:GetService(serviceName)
		local serviceChildren = service:GetChildren()
		if #serviceChildren == 0 then continue end

		local currDataModelString = `"{serviceName}" = (\n`

		for _,child in serviceChildren do
			currDataModelString ..= `    ("{child.Name}", {child.ClassName}),\n`
		end

		currDataModelString ..= "),\n\n"
		DataModelString ..= currDataModelString
	end
end

ScriptEditorService.TextDocumentDidChange:Connect(function(doc, changes)
	local docPlus = ScriptDocPlus(doc, changes)
	if not docPlus:EnterPressed() then return end

	local prevLine = docPlus:GetLine(-1, true)
	local prevLineCommentContent = string.match(prevLine, "%-%-(.+)")
	if not prevLineCommentContent then return end

	local currentLineNum = docPlus:GetSelection()
	local response = OpenAiWrapper:ChatCompletion(
		"gpt-3.5-turbo", 3000,
		{{
			role = "user",
			content = `{Brief}\n\nINSTRUCTION:\n{prevLineCommentContent}\n\nDATAMODEL:\n{GetDataModel()}\n\nACTIVE DOCUMENT SOURCE:\n{doc:GetText()}`
		}}
	)
	local code = response.choices[1].message.content

	docPlus:Paste(code, 0, true)
end)

