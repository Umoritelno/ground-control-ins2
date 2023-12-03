-- This file needs for changing dynamic blood server stuff like util.lua line 54 tried to use NULL entity(first function below)
local ENT = FindMetaTable("Entity")

if !ENT.RealisticBlood_MakeBoneFollower then return end 


function ENT:RealisticBlood_MakeBoneFollower( pos, normal, offset, ang_offset, lifetime, visible )
    --[[local bone = self.RealisticBlood_HitBone
    if !bone then return end

    local bone_pos, bone_ang = self:GetBonePosition(bone)

    local _, localang2 = WorldToLocal( pos, normal:Angle(), bone_pos, bone_ang )

    normal = ( ang_offset && (normal:Angle()+ang_offset):Forward() ) or normal
    local localpos, localang = WorldToLocal( pos, normal:Angle(), bone_pos, bone_ang )

    local bone_follower = ents.Create("base_gmodentity")
    bone_follower:SetModel("models/hunter/plates/plate.mdl")
    if !visible then bone_follower:SetModelScale(0) end
    bone_follower:DrawShadow(false)
    bone_follower:FollowBone(self, bone)
    bone_follower:SetLocalPos( (offset && (localpos - (localang2:Forward()*offset) ) ) or localpos )
    bone_follower:SetLocalAngles(-localang)
    bone_follower:SetOwner(self)
    bone_follower:AddEFlags(EFL_DONTBLOCKLOS)
    bone_follower:Spawn()
    SafeRemoveEntityDelayed(bone_follower, lifetime)

    local dist = bone_pos:DistToSqr(bone_follower:GetPos())

    if dist > 144 then
        --print("bone follower too far away! ("..dist..")")
        bone_follower:SetPos( bone_pos )
    end

    if !self.RealisticBlood_BoneFollowers then self.RealisticBlood_BoneFollowers = {} end
    table.insert(self.RealisticBlood_BoneFollowers, bone_follower)

    return bone_follower --]]
end