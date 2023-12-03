AddCSLuaFile()

-- clientside cum rendering
-- fixed up by spy

CumSplatController = {}
CumSplatController.maxCum = 70
CumSplatController.activeCum = {}
CumSplatController.durationRange = {2.5, 6}
CumSplatController.stretchSpeed = {0.1, 1}
CumSplatController.alphaInSpeed = 10

function CumSplatController:splat(alphaMod)
	if #self.activeCum >= self.maxCum then
		return
	end
	
	local durRng = self.durationRange
	local rolledRange = math.Rand(durRng[1], durRng[2])
	
	local scrW, scrH = _SCRW, _SCRH
	table.insert(CumSplatController.activeCum, {
		scrW * math.Rand(-0.2, 0.8),
		scrH * math.Rand(-0.2, 0.8),
		scrW * math.Rand(0.3,1),
		scrH * math.Rand(0.3,1),
		rolledRange * alphaMod, -- duration
		rolledRange / alphaMod, -- remaining duration
		-0.5 * math.random()
	})	
end

function CumSplatController:DrawCum()
	local self = CumSplatController
	local idxCnt = #self.activeCum
	
	if idxCnt > 0 then
		local ft = FrameTime()
		local rIdx = 1
		local ft = FrameTime()
		local stretchCfg = self.stretchSpeed
		local stretchTop, stretchBottom = ScreenScale(stretchCfg[1]), ScreenScale(stretchCfg[2])
		local alphaInSpeed = self.alphaInSpeed
		
		for i = 1, #self.activeCum do
			local cumlet = self.activeCum[rIdx]
			cumlet[6] = cumlet[6] - ft
			local delta = cumlet[6] / cumlet[5]
			local stretchSpeed = 0.25 + (1 - delta) * 0.75
			
			surface.SetTexture(surface.GetTextureID("effects/blood_core"))
			surface.SetDrawColor(255, 255, 255, 255 * delta * math.max(0, cumlet[7]))
			surface.DrawTexturedRect(cumlet[1], cumlet[2], cumlet[3], cumlet[4])
			
			cumlet[2] = cumlet[2] + stretchTop * stretchSpeed
			cumlet[4] = cumlet[4] + stretchBottom * stretchSpeed
			cumlet[7] = math.min(1, cumlet[7] + ft * alphaInSpeed)
			
			if cumlet[6] <= 0 then
				table.remove(self.activeCum, rIdx)
			else
				rIdx = rIdx + 1
			end
		end
	else
		hook.Remove("HUDPaint", "GC_CumPaint")
	end
end

function CumSplatController.splatCumNet()
	local cumlets = net.ReadInt(32)
	local alphaMod = LocalPlayer():Alive() and 1 or 0.4
	
	for i = 1, cumlets do
		CumSplatController:splat(alphaMod)
	end
	
	hook.Add("HUDPaint", "GC_CumPaint", CumSplatController.DrawCum)
end

net.Receive("Cumshot", CumSplatController.splatCumNet) 
