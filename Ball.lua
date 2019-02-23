--[[
    GD50 2018
    Pong Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0

    -- max x distant the ball can travel before we need to check for collision.
    -- if the ball travels beyond this in one frame we check between frames
    -- using our last_x and last_y
    self.max_travel_x = 6

    -- last_x and last_y are the x and y from last frame, for use in collision detection
    self.last_x = self.x
    self.last_y = self.y
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles are overlapping or overlapped between frames.
]]
function Ball:collides(paddle)

    -- we will first calculate how many collision checks we need to perform from possible missed collisions between frames
    -- including the check for this frame
    local collision_checks = math.abs(self.x - self.last_x) / self.max_travel_x
    
    -- generate our starting x
    local gen_x = self.last_x   

    for i = collision_checks, 0, -1 do

        -- move our gen_x according to travel direction
        if self.dx > 0 then
            gen_x = gen_x + self.max_travel_x

            -- ensure we don't check beyond our current position
            if gen_x > self.x then
                gen_x = self.x
            end
        else
            gen_x = gen_x - self.max_travel_x

            -- ensure we don't check beyond our current position
            if gen_x < self.x then
                gen_x = self.x
            end
        end

        -- generate our y using gen_x and the balls slope
        local gen_y = (self.dy / self.dx) * (gen_x - self.last_x) + self.last_y

        -- if we aren't colliding on both x and y with our generated point then there is no possibility for collision
        local collided_x = true;
        local collided_y = true;

        -- first, check for collision on the x-axis by checking to see if the left edge of either is farther to the right
        -- than the right edge of the other
        if gen_x > paddle.x + paddle.width or paddle.x > gen_x + self.width then
            collided_x = false
        end

        -- check for collision on y-axis by checking to see if the bottom edge 
        -- of either is higher than the top edge of the other
        if gen_y > paddle.y + paddle.height or paddle.y > gen_y + self.height then
            collided_y = false
        end

        -- if we are colliding on both axis then return true, there has been a collision
        if collided_x and collided_y then
            return true
        end

    end

    -- no collisions were detected
    return false
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    self.last_x = self.x
    self.last_y = self.y

    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)

    -- keep our x and y location from this frame before we change them
    self.last_x = self.x
    self.last_y = self.y

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end