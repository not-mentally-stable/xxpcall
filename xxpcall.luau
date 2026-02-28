local xxpcall = {}

local asrt, isit = assert, type

local function xxpcall_run(RetryAttempts, Cooldown, MainFunction, CallBackFunc)
    --// if your not an idiot you can remove this enitre check
	asrt(isit(RetryAttempts) == "number", "RetryAttempts must be a number")
	asrt(RetryAttempts >= 0, "RetryAttempts must not be lower than 0")
	asrt(not math.isinf(RetryAttempts), "RetryAttempts cannot be infinite")

	asrt(isit(Cooldown) == "number", "Cooldown must be a number")
	asrt(Cooldown >= 0, "Cooldown must not be lower than 0")
	asrt(Cooldown <= 10000, "Cooldown must not exceed 10000")
	asrt(not math.isinf(Cooldown), "Cooldown cannot be infinite")

	asrt(isit(MainFunction) == "function", "MainFunction must be a function")

	if CallBackFunc ~= nil then
		asrt(isit(CallBackFunc) == "function", "CallBackFunc must be a function or nil")
	end


	local lastError = "Unknown error"

	for attempt = 1, RetryAttempts do
		local success, result = xpcall(MainFunction, debug.traceback)

		if success then
			return true, result
		end

		lastError = tostring(result)

		if attempt < RetryAttempts and Cooldown > 0 then
			task.wait(Cooldown)
		end
	end

	if CallBackFunc then
		CallBackFunc(lastError)
	end

	return false, lastError
end

return setmetatable(xxpcall, {
	__call = function(_, ...)
		return xxpcall_run(...)
	end
})
