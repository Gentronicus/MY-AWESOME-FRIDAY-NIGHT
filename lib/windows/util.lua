local ffi = require "ffi"
local dwmapi = ffi.load("dwmapi")

local Util = {}
ffi.cdef [[
	typedef int BOOL;
	typedef long LONG;
	typedef uint32_t UINT;
	typedef int HRESULT;
	typedef unsigned int DWORD;
	typedef const void* PVOID;
	typedef const void* LPCVOID;
	typedef const char* LPCSTR;
	typedef DWORD HMENU;
	typedef struct HWND HWND;
	typedef void* HANDLE;
    typedef HANDLE HCURSOR;

	typedef struct tagRECT {
		union{
			struct{
				LONG left;
				LONG top;
				LONG right;
				LONG bottom;
			};
			struct{
				LONG x1;
				LONG y1;
				LONG x2;
				LONG y2;
			};
			struct{
				LONG x;
				LONG y;
			};
		};
	} RECT, *PRECT,  *NPRECT,  *LPRECT;

	HWND FindWindowA(LPCSTR lpClassName, LPCSTR lpWindowName);
	HWND FindWindowExA(HWND hwndParent, HWND hwndChildAfter, LPCSTR lpszClass, LPCSTR lpszWindow);
	HWND GetActiveWindow(void);
	BOOL SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, UINT uFlags);
	LONG GetWindowLongA(HWND hWnd, int nIndex);
	LONG SetWindowLongA(HWND hWnd, int nIndex, LONG dwNewLong);
	BOOL ShowWindow(HWND hWnd, int nCmdShow);
	BOOL UpdateWindow(HWND hWnd);
	HMENU GetMenu(HWND hWnd);
	BOOL AdjustWindowRectEx(LPRECT lpRect, DWORD dwStyle, BOOL bMenu, DWORD dwExStyle);

	HRESULT DwmGetWindowAttribute(HWND hwnd, DWORD dwAttribute, PVOID pvAttribute, DWORD cbAttribute);
	HRESULT DwmSetWindowAttribute(HWND hwnd, DWORD dwAttribute, LPCVOID pvAttribute, DWORD cbAttribute);
	HRESULT DwmFlush();

	HCURSOR LoadCursorA(HANDLE hInstance, const char* lpCursorName);
    HCURSOR SetCursor(HCURSOR hCursor);
]]

local Rect = ffi.metatype("RECT", {})

local function toInt(v) return v and 1 or 0 end
local function ffiNew(type, v)
	v = ffi.new(type, v); return v, ffi.sizeof(v)
end

local function getWindowHandle(title)
	local window = ffi.C.FindWindowA(nil, title)
	if window == nil then
		window = ffi.C.GetActiveWindow()
		window = ffi.C.FindWindowExA(window, nil, nil, title)
	end
	return window
end

local function getMainWindowHandle()
	return ffi.C.GetActiveWindow() or getWindowHandle(love.window.getTitle())
end

function Util.setDarkMode(enable)
	local window = getMainWindowHandle()

	local darkMode, size = ffiNew("int[1]", toInt(enable))
	local result = dwmapi.DwmSetWindowAttribute(window, 19, darkMode, size)
	if result ~= 0 then
		dwmapi.DwmSetWindowAttribute(window, 20, darkMode, size)
	end
	--ffi.C.SetWindowPos(window, nil, 0, 0, 0, 0, bit.bxor(0x0020, 0x0002, 0x0001))
	--ffi.C.UpdateWindow(window)
end

function Util.setWindowPosition(x, y, w, h, ...)
	local window, flags = getMainWindowHandle(), bit.bxor(0x0100, 0x0010, 0x0400)
	if w == nil then flags = bit.bxor(flags, 0x0001) end

	local w2, h2, data = love.window.getMode()
	x, y, w, h = x or data.x, y or data.y, w or w2, h or h2

	local style = ffi.C.GetWindowLongA(window, -16)
	local menu = bit.bnot(bit.band(style, 0x40000000)) >= 0 and (ffi.C.GetMenu(window) and true) or false

	local rect = Rect(0, 0, w, h)
	if bit.band(style, 0x00C00000) >= 0 then
		ffi.C.AdjustWindowRectEx(rect, style, menu, 0)
	end

	ffi.C.SetWindowPos(window, nil,
		x + rect.x, y + rect.y,
		rect.right - rect.left, rect.bottom - rect.top,
		bit.bxor(flags, ...)
	)
	rect = nil
	love.window.getMode()
end

local currentCursor = "ARROW"
local CursorType = {
	ARROW = 32512,
	IBEAM = 32513,
	WAIT = 32514,
	CROSS = 32515,
	UPARROW = 32516,
	SIZENWSE = 32642,
	SIZENESW = 32643,
	SIZEWE = 32644,
	SIZENS = 32645,
	SIZEALL = 32646,
	NO = 32648,
	HAND = 32649,
	APPSTARTING = 32650,
	HELP = 32651,
	PIN = 32671,
	PERSON = 32672
}

---@param type string
function Util.setCursor(type)
	local selectedType = CursorType[type:upper()]
	if selectedType then
		local systemCursor = ffi.C.LoadCursorA(nil, ffi.cast("const char*", selectedType))
    	ffi.C.SetCursor(systemCursor)
	end
end

return Util
