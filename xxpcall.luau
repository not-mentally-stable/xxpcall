--!strict

--// dont remove the !strict comment
_G.xxpcall = function(
	RetryAttempts: number,
	CooldownBetweenRetrys: number,
	MainFunction: () -> any,
	CallBackFunc: ((string) -> ())?,
	ShouldYield: boolean?
): (boolean, any)
	
	assert(type(RetryAttempts) == "number" and RetryAttempts >= 1, "RetryAttempts must be a positive number")
	assert(type(CooldownBetweenRetrys) == "number" and CooldownBetweenRetrys >= 0, "CooldownBetweenRetrys must be non-negative")
	assert(type(MainFunction) == "function", "MainFunction must be a function")
	if CallBackFunc ~= nil then
		assert(type(CallBackFunc) == "function", "CallBackFunc must be a function or nil")
	end
	if ShouldYield == nil then
		ShouldYield = true
	end

	local attempt = 0
	local success = false
	local result: any
	local lastError: string? = nil

	while attempt < RetryAttempts do
		attempt += 1
		success, result = pcall(MainFunction)
		if success then
			return true, result
		else
			lastError = tostring(result)
			if attempt < RetryAttempts and CooldownBetweenRetrys > 0 then
				if ShouldYield then
					task.wait(CooldownBetweenRetrys)
				else
					task.delay(CooldownBetweenRetrys, function() end)
				end
			end
		end
	end

	if CallBackFunc then
		if ShouldYield then
			CallBackFunc(lastError or "Unknown error")
		else
			task.spawn(CallBackFunc, lastError or "Unknown error")
		end
	end

	return false, lastError
end
