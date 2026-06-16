# xxpcall

A simple retry wrapper for `xpcall` in Luau.
`xxpcall` attempts to execute a function multiple times with an optional cooldown between attempts. If all attempts fail, it optionally calls a callback with the final error message.
The function always yields while retrying (uses `task.wait` for cooldowns).

---

## Installation

Place the module inside `ReplicatedStorage` (or anywhere accessible), then require it:

```Luau
local xxpcall = require("@game/ReplicatedStorage/xxpcall")
```

## Function Signature & Parameters

```Luau
xxpcall(
    RetryAttempts: number,
    Cooldown: number,
    MainFunction: () -> any,
    CallBackFunc: ((string) -> ())?
) -> (boolean, any)
```

`RetryAttempts`
- Type: `number`
- Must be `>= 0`
- Must not be infinite or nan (duh)
- Defines how many times the function will be attempted.
If set to `0`, the function will not run and immediately return failure.

`Cooldown`
- Type: `number`
- Must be `>= 0`
- Must not exceed `10000`
- Must not be infinite or nan
time in seconds to wait between failed attempts.

`MainFunction`
- Type: `function`
- The function to execute.
- Errors are caught using `xpcall` with `debug.traceback`.

`CallBackFunc` (optional)
- Type: `function`
- Called only if all retry attempts fail.
- Receives the final error message as its first argument.

## Return Values

```Luau
success: boolean
result: any
```

- If successful:  
  - `success` is `true`  
  - `result` contains the return value of `MainFunction`

- If all retries fail:  
  - `success` is `false`  
  - `result` contains the final error message (with traceback)

---

## Examples
the module returns the function directly on require so you can call it directly

**Basic Usage**

```Luau
local xxpcall = require(game.ReplicatedStorage.xxpcall)

local success, result = xxpcall(
    3,
    1,
    function()
        return "Hello World"
    end
)

print(success, result)
```

**Retrying a Failing Function**
```Luau
local xxpcall = require(game.ReplicatedStorage.xxpcall)

local success, err = xxpcall(
    3,
    1,
    function()
        game:NonExistingMethod()
    end
)

print(success, err)
```

**Using a Failure Callback**

```Luau
local xxpcall = require(game.ReplicatedStorage.xxpcall)

local success, err = xxpcall(
    3,
    2,
    function()
        error("Something went wrong")
    end,
    function(finalError)
        warn("All attempts failed:")
        warn(finalError)
    end
)
```

### Important Note
Do not call the callback directly when passing it as an argument.

Incorrect:
```Luau
xxpcall(3, 1, fn, warn("Failed"))
```

Correct:
```Luau
xxpcall(3, 1, fn, warn)
```

Or:

```Luau
xxpcall(3, 1, fn, function(err)
    warn("Failed:", err)
end)
```

This module is intended to be a simple, predictable retry utility that behaves similarly to `pcall`, with added retry and cooldown support.
if you want something more powerful/professional just use Roblox [Promise Module](https://github.com/Roblox/roblox-lua-promise)

---

[![License: ](https://img.shields.io/badge/License%3A-MIT-green?style=plastic)](https://github.com/not-mentally-stable/xxpcall/blob/main/LICENSE)

[![Scripting Language: LUAU](https://img.shields.io/badge/Scripting%20Language%3A-LUAU-blue?style=plastic)](https://luau.org)
