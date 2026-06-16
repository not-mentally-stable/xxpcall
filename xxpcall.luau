return function(
	RetryAttempts: number, 
	Cooldown: number, 
	MainFunction: () -> any, 
	CallBackFunc: ((err: string) -> ())?
): (boolean, any)
	assert(math.isfinite(RetryAttempts), "RetryAttempts must not be nan or infinite")
	assert(math.isfinite(Cooldown), "Cooldown must not be nan or infinite")
	
	RetryAttempts = math.clamp(RetryAttempts, 0, 10000)
	Cooldown = math.clamp(Cooldown, 0, 10000)
	
	local LastError: string = "UnknownError"
	
	for attempt = 1, RetryAttempts do
		local success, result = xpcall(MainFunction, function(err)
			return debug.traceback(tostring(err))
		end)
		
		if success then
			return true, result
		end
		
		LastError = tostring(result)
		
		if attempt < RetryAttempts and Cooldown > 0 then
			task.wait(Cooldown)
		end
	end
	
	if CallBackFunc then
		CallBackFunc(LastError)
	end
	
	return false, LastError
end
