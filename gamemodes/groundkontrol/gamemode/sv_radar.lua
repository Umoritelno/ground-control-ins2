util.AddNetworkString("AddRadarMarker")

function GM:AddRadarMarker(data)
    net.Start("AddRadarMarker")
    net.WriteTable(data)
    net.Broadcast()
end