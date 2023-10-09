-- Converted By Fellynn
function create()
	self:setFrames(paths.getSparrowAtlas('characters/monsterChristmas'))

	self:addAnimByPrefix('idle', 'monster idle', 24, false)
	self:addAnimByPrefix('singUP', 'monster up note', 24, false)
	self:addAnimByPrefix('singLEFT', 'Monster left note', 24, false)
	self:addAnimByPrefix('singRIGHT', 'Monster Right note', 24, false)
	self:addAnimByPrefix('singDOWN', 'monster down', 24, false)
	self:addAnimByIndices('singUP-loop', 'monster up note', {21, 22, 23}, 24, true)
	self:addAnimByIndices('singDOWN-loop', 'monster down', {27, 28, 29}, 24, true)
	self:addAnimByIndices('singRIGHT-loop', 'Monster Right note', {12, 13, 14}, 24, true)
	self:addAnimByIndices('singLEFT-loop', 'Monster left note', {17, 18, 19}, 24, true)
	self:addAnimByIndices('idle-loop', 'monster idle', {12, 13, 14}, 24, true)

	self:addOffset('idle', 1, 0)
	self:addOffset('singUP', -20, 50)
	self:addOffset('singLEFT', -30, 0)
	self:addOffset('singRIGHT', -51, 0)
	self:addOffset('singDOWN', -40, -94)
	self:addOffset('singUP-loop', -20, 50)
	self:addOffset('singDOWN-loop', -40, -94)
	self:addOffset('singRIGHT-loop', -51, 0)
	self:addOffset('singLEFT-loop', -30, 0)
	self:addOffset('idle-loop', 1, 0)

	self.y = self.y + 130
	self.icon = "monster"
end