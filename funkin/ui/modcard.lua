local ModCard = SpriteGroup:extend("ModCard")

function ModCard:new(x, y, mods)
	ModCard.super.new(self, x, y)

	local metadata = Mods.getMetadata(mods)

	self.bg = Graphic(0, 0, 420, 620, {0, 0, 0})
	self.bg.alpha = 0.5
	self.bg.config.round = {8, 8}
	self:add(self.bg)

	self.banner = Sprite(4, 4):loadTexture(Mods.getBanner(mods))
	self.banner:setGraphicSize(412)
	self.banner:updateHitbox()
	self:add(self.banner)

	self.titleBG = Graphic(4, 134, 412, 80, {0, 0, 0})
	self.titleBG.alpha = 0.3
	self.titleBG.config.round = {8, 8}
	self:add(self.titleBG)

	self.titleTxt = Text(6, 136, metadata.name, paths.getFont("phantommuff.ttf", 30),
		{1, 1, 1}, "center", 410)
	self:add(self.titleTxt)

	self.descBG = Graphic(4, 218, 412, 340, {0, 0, 0})
	self.descBG.alpha = 0.5
	self.descBG.config.round = {8, 8}
	self:add(self.descBG)

	self.descTxt = Text(14, 224, metadata.description, love.graphics.newFont(13),
		{1, 1, 1}, "left", 392)
	self:add(self.descTxt)
end

return ModCard
