

local BloodSprite = Material( "effects/bloodstream" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
EFFECT.tempVector = Vector(0, 0, 0)
EFFECT.zeroVector = Vector(0, 0, 0)

function EFFECT:Init( data )	
		// Table to hold particles
		self.Particles = {}
		
		self.PlaybackSpeed 	= math.Rand( 2, 5 )
		self.Width 			= math.Rand( 6, 12 )
		self.ParCount		= 8
		self.staticParCount = 0
		
		local Ang = data:GetAngles()
		local Pos = data:GetOrigin()
		
		local Dir = Ang:Forward() * 0.3
		
		local Speed = math.Rand( 2500, 2800 )
		
		local SquirtDelay = math.Rand( 1, 2 )
		
		Dir.z = math.max( Dir.z, Dir.z * -1 )
		
		if (Dir.z > 0.5) then
			Dir.z = Dir.z - 0.3
		end
		
		for i=1, math.random( 6, 8 ) do
		
			local p = {}
			
			p.Pos = Pos + Vector(0,0,-1)
			p.Vel = Dir * (Speed * (i /16))
			p.Delay = (16 - i)  * SquirtDelay
			p.Rest = false
			
			table.insert( self.Particles, p )
		
			-- randomize the direction of the COOM a bit
			self.tempVector.x = math.Rand(-0.03, 0.03)
			self.tempVector.y = math.Rand(-0.03, 0.03)
			Dir:Add(self.tempVector)
		end

		--self.NextThink = CurTime() +  math.Rand( 0, 1 )
	
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/

EFFECT.trace = {mask = MASK_NPCWORLDSTATIC}

function EFFECT:Think( )

	//if ( self.NextThink > CurTime() ) then return true end

	local FrameSpeed = self.PlaybackSpeed * FrameTime()
	local bMoved = false
	
	self.Width = self.Width - 0.7 * FrameSpeed * (math.max(1, self.staticParCount) / self.ParCount)
	
	if ( self.Width < 0 ) then
		return false
	end
	
	if #self.Particles > 0 then
		local gravityVector = Vector( 0, 0, 60 * FrameSpeed)
		
		for k, p in pairs( self.Particles ) do
			if ( p.Rest ) then
			
			// Waiting to be spawned. Some particles have an initial delay 
			// to give a stream effect..
			elseif ( p.Delay > 0 ) then
			
				p.Delay = p.Delay - 100 * FrameSpeed
			
			// Normal movement code. Handling particles in Lua isn't great for 
			// performance but since this is clientside and only happening sometimes
			// for short periods - it should be fine.
			else
				
				// Gravity
				p.Vel:Sub( gravityVector )
				
				// Air resistance
				p.Vel.x = math.Approach( p.Vel.x, 0, 2 * FrameSpeed )
				p.Vel.y = math.Approach( p.Vel.y, 0, 2 * FrameSpeed )
				
				local trace = self.trace
				trace.start 	= p.Pos
				trace.endpos 	= p.Pos + p.Vel * FrameSpeed
				
				local tr = util.TraceLine(trace)

				if (tr.Hit) then
					
					tr.HitPos:Add( tr.HitNormal * 2 )
					
					// If we hit the ceiling just stunt the vertical velocity
					// else enter a rested state
					if ( tr.HitNormal.z < -0.75 ) then
						p.Vel.z = 0
					else
						p.Rest = true
						self.staticParCount = self.staticParCount + 1
						sound.Play("physics/flesh/flesh_bloody_impact_hard1.wav", tr.HitPos, 80, math.random(95, 105), 1)
					end
		
				end
				
				// Add velocity to position
				p.Pos = tr.HitPos
			end
		end
	end
	
	self.ParCount = #self.Particles
	
	-- set the position of the effect to the shoot pos of the player so that it doesn't get culled in a weird manner
	local lp = LocalPlayer()
	self:SetPos(lp:GetShootPos())
	
	
	// Returning false kills the effect
	return (self.ParCount > 0)
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
	render.SetMaterial( BloodSprite )
	
	local LastPos = nil
	
	local color = Color( 255, 255, 255, 255 )
	local parCount = #self.Particles - 2
	
	for k, p in pairs( self.Particles ) do
		local Sin = math.sin( (k / parCount) * math.pi )
		
		if ( LastPos ) then
		
			render.DrawBeam( LastPos, 		
					 p.Pos,
					 self.Width * Sin,					
					 1,					
					 0,				
					 color )
		end
		
		LastPos = p.Pos
	end
	
	
	//render.DrawSprite( self.Entity:GetPos(), 32, 32, color_white )
	
end