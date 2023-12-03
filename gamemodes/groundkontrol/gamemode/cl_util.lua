function util.genericObjectiveMarkerAlphaScaler(x1, y1, x2, y2)
	return math.max(0.1, math.min(1, math.Dist(x1, y1, x2, y2) / _S(250)) ^ 2)
end