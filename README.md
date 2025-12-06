# xxpcall Enhanced Safe Function Executor for Roblox (Luau)

`xxpcall` is a powerful wrapper around Luau’s native `pcall`, providing built-in retry logic, cooldown intervals, and callback support for better error handling and fault tolerance in Roblox development.

This utility helps you safely execute functions that might fail intermittently (e.g., network or API-dependent code) without cluttering your scripts with repetitive error handling.

---

## 🚀 Features

- 🔁 **Automatic Retries** — Retry a failed function multiple times before giving up.  
- ⏱️ **Cooldowns Between Retries** — Optional delay between retry attempts.  
- 🧩 **Error Callback** — Define a function to handle final failure cases.  
- ⚙️ **Yield or Async Mode** — Choose whether the function should yield (`task.wait`) or not (`task.delay` / `task.spawn`).  
- 🛡️ **Strict Type Safety** — Enforced with Luau’s strict mode (`--!strict`).

---

## 📦 Installation

Simply drop the `xxpcall.luau` file into your Roblox project (e.g., `ServerScriptService/xxpcall`), the script will automatically put the function in [_G.](https://devforum.roblox.com/t/how-do-i-use-g-in-roblox-scripting/2116907)

```Luau
-- you can call the funtion in any script without require just type
_G.xxpcall()
```

# DOCS
**Function Signature:**
```Luau
_G.xxpcall(
	RetryAttempts: number,
	CooldownBetweenRetrys: number,
	MainFunction: () -> any,
	CallBackFunc: ((string) -> ())?, -- optional
	ShouldYield: boolean? -- optional (defaults to true)
): (boolean, any)
```

**Simple Examples**
```Luau
_G.xxpcall(3, 1, function()
	print("Trying risky operation...")
	error("Something went wrong!")
end)
--[[ output:
> Trying risky operation...
> Trying risky operation...
> Trying risky operation...
> All retries failed. Error: Something went wrong!
]]--
```

**With CallBack function**
```Luau
_G.xxpcall(5, 2, function()
	-- Simulated failing function
	error("Server not responding")
end, function(err)
	warn("All retries failed. Error:", err)
end)
```

**Non-Yielding**
```Luau
_G.xxpcall(3, 0.5, function()
	error("Test async failure")
end, function(err)
	print("Handled asynchronously:", err)
end, false)
print("yay i didn't have to wait")
```
>[!WARNING]
>BY DEFAULT IT YIELDS!

# Misc...
[![License: ](https://img.shields.io/badge/License%3A-MIT-green?style=plastic)](https://github.com/not-mentally-stable/xxpcall/blob/main/LICENSE)

[![Scripting Language: LUAU](https://img.shields.io/badge/Scripting%20Language%3A-LUAU-blue?style=plastic)](https://github.com/luau-lang/luau)
