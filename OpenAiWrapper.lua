local OpenAiWrapper = { ApiKey = nil }; OpenAiWrapper.__index = OpenAiWrapper

local HttpService = game:GetService("HttpService")


function OpenAiWrapper:ChatCompletion(model, maxTokens, messages: {{ role:"system"|"user"|"assistant", content: string }})
	local response = HttpService:PostAsync(
		"https://api.openai.com/v1/chat/completions",
		HttpService:JSONEncode {
			model = "gpt-3.5-turbo",
			messages = messages,
			max_tokens = maxTokens
		},
		nil, false,
		{
			Authorization = `Bearer {self.ApiKey}`
		}
	)
	return HttpService:JSONDecode(response)
end

return OpenAiWrapper
