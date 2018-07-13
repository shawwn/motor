local motor = require("motor")
local buffer = require("buffer")
local function create(fd)
  local ____x = {}
  ____x.fd = fd
  ____x.pos = 0
  ____x.buffer = buffer.create()
  return ____x
end
local function space(s)
  return buffer.space(s.buffer)
end
local function length(s)
  return buffer.length(s.buffer)
end
local function full63(s)
  return buffer.full63(s.buffer)
end
local function extend(s, n)
  return buffer.extend(s.buffer, n)
end
local function read(s)
  return motor.read(s.fd, s.buffer)
end
local function string(s, n)
  return buffer.string(s.buffer, s.pos, n)
end
local function fill(s)
  if full63(s) then
    extend(s)
  end
  return read(s) > 0
end
local function before(s, pat)
  local __n = nil
  while nil63(__n) do
    local __x1 = string(s)
    local __m = search(__x1, pat)
    if nil63(__m) then
      if not fill(s) then
        __n = -1
      end
    else
      __n = __m
    end
  end
  if __n >= 0 then
    local __x2 = string(s, __n)
    s.pos = s.pos + __n
    return __x2
  end
end
local function line(s, pat)
  local __p = pat or "\n"
  local __x3 = before(s, __p)
  s.pos = s.pos + _35(__p)
  return __x3
end
local function take(s, n)
  if space(s) < n then
    extend(s, n)
  end
  while length(s) - s.pos < n do
    if not fill(s) then
      break
    end
  end
  local __x4 = string(s, n)
  s.pos = s.pos + _35(__x4)
  return __x4
end
local function emit(s, b)
  return motor.send(s.fd, b)
end
return {line = line, emit = emit, create = create, take = take}
