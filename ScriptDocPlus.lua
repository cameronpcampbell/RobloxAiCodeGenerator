local ScriptDocPlus = {}; ScriptDocPlus.__index = ScriptDocPlus

function ScriptDocPlus:ClampLineNumber(lineNum:number)
	return math.clamp(lineNum, 1, self:GetLineCount())
end

function ScriptDocPlus:Paste(text:string, lineNum:number, fromCurrent:boolean)
	if not fromCurrent then lineNum = self:ClampLineNumber(lineNum or 1) end
	local line, lineNum = self:GetLine(lineNum, fromCurrent)
	self:EditTextAsync(text, lineNum, 1, lineNum, string.len(line)+1)
end

function ScriptDocPlus:GetLine(lineNum:number, fromCurrent:boolean)
	if fromCurrent == true then lineNum = self:GetSelection()+(lineNum or 0) end
	if lineNum ~= nil then lineNum = self:ClampLineNumber(lineNum) end
	return self.document:GetLine(lineNum), lineNum
end

function ScriptDocPlus:WasEnterPressed()
	local changes = self.changes
	if not changes then return warn("please pass in the \"changes\" parameter from the \"TextDocumentDidChange\" function.") end
	if #changes == 0 then return end
	if changes[1].text == "\n" then return true end
end

-- [ DEFAULT FUNCTIONS ] ====================================================================================
function ScriptDocPlus:GetLineCount()
	return self.document:GetLineCount()
end
function ScriptDocPlus:GetScript()
	return self.document:GetScript()
end
function ScriptDocPlus:GetSelectedText()
	return self.document:GetSelectedText()
end
function ScriptDocPlus:GetSelection()
	return self.document:GetSelection()
end
function ScriptDocPlus:GetSelectionEnd()
	return self.document:GetSelectionEnd()
end
function ScriptDocPlus:GetSelectionStart()
	return self.document:GetSelectionStart()
end
function ScriptDocPlus:GetText(startLine:number, startCharacter:number, endLine:number, endCharacter:number)
	return self.document:GetText(startLine, startCharacter, endLine, endCharacter)
end
function ScriptDocPlus:GetViewport()
	return self.document:GetViewport()
end
function ScriptDocPlus:HasSelectedText()
	return self.document:HasSelectedText()
end
function ScriptDocPlus:IsCommandBar()
	return self.document:IsCommandBar()
end
function ScriptDocPlus:CloseAsync()
	return self.document:CloseAsync()
end
function ScriptDocPlus:EditTextAsync(newText:string, startLine:number, startCharacter:number, endLine:number, endCharacter:number)
	return self.document:EditTextAsync(newText, startLine, startCharacter, endLine, endCharacter)
end
function ScriptDocPlus:ForceSetSelectionAsync(cursorLine:number, cursorCharacter:number, anchorLine:number, anchorCharacter:number)
	return self.document:ForceSetSelectionAsync(cursorLine, cursorCharacter, anchorLine, anchorCharacter)
end
function ScriptDocPlus:RequestSetSelectionAsync(cursorLine:number, cursorCharacter:number, anchorLine:number, anchorCharacter:number)
	return self.document:RequestSetSelectionAsync(cursorLine, cursorCharacter, anchorLine, anchorCharacter)
end
-- ==========================================================================================================

return function(document:ScriptDocument, changes:table)
	return setmetatable({
		document=document,
		changes=changes,
		Archivable=document.Archivable,
		ClassName=document.ClassName,
		Name=document.Name,
		Parent=document.Parent
	}, ScriptDocPlus)
end
