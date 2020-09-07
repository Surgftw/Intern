--[[
    GD50
    Breakout Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between the sides
    of the world space, the player's paddle, and the bricks laid out above
    the paddle. The ball can have a skin, which is chosen at random, just
    for visual variety.
]]

Ball = Class{}

ballSizes = {
    -- small
    [1] = 4,
    -- medium
    [2] = 8,
    -- large
    [3] = 12,
  }
  
  defaultBallSize = 2


function Ball:init(skin)
    -- simple positional and dimensional variables
    self.width = 8
    self.height = 8

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0

    self.size = defaultBallSize
    self.width = ballSizes[self.size]
    self.height = ballSizes[self.size]
    
    -- this will effectively be the color of our ball, and we will index
    -- our table of Quads relating to the global block texture using this
    self.skin = skin
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Ball:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function Ball:reset()
    self.x = gameWidth / 2 - 2
    self.y = gameHeight / 2 - 2
    
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- allow ball to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.x >= gameWidth - self.width then
        self.x = gameWidth - self.width
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end
end

function Ball:render()
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin],
      self.x, self.y, 0,
      self.width / ballSizes[defaultBallSize],
      self.height / ballSizes[defaultBallSize]
    )
  end

function Ball:setSize(size)
    local oldCenterX = self.x + self.width / 2
    local oldCenterY = self.y + self.height / 2
    
    self.size = size
    self.width = ballSizes[self.size]
    self.height = ballSizes[self.size]
    self.x = math.max(0, oldCenterX - self.width / 2)
    self.y = math.max(0, oldCenterY - self.height / 2)
  end
  
  function Ball:increaseSize()
    self:setSize(math.min(3, self.size + 1))
  end
  
  function Ball:decreaseSize()
    self:setSize(math.max(1, self.size - 1))
  end