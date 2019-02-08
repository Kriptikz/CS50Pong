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

    -- offset along x axis for collision points to be generated
    -- for checking collision between frames
    self.collision_points_offset = 1

    -- last_x and last_y are the x and y from last frame, for use in collision detection
    self.last_x = self.x
    self.last_y = self.y
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles are overlapping or overlapped between frames.
]]
function Ball:collides(paddle)
    --[[ 
        we will use last_x and last_y to generate a set of points we can use to 
        check for collision between last frame and this frame. Each generated point
        will be offset by collision_points_offset from the last point. The amount of 
        point generated will be determined by the distance it travelled between frames.
    ]]


    -- check how far we travelled
    local x_distance_travelled = math.abs(self.x - self.last_x)

    -- if we travelled a distance along x greater than our collision_points_offset 
    -- we could have missed the collision between frames so we need to check
    --if x_distance_travelled > self.collision_points_offset then

        -- how many points we need to check for collisions for from in between frames
        local points_to_generate = x_distance_travelled --math.floor(x_distance_travelled / self.collision_points_offset)

        -- if we travelled far enough to generate more than 1 point,
        -- we need to subtract 1 from that because we are still checking for
        -- collisions from this frame after we check if there was any between frames
        --if points_to_generate > 1 then
        --    points_to_generate = points_to_generate - 1
        --end

        -- We will now start generating the point/s and check it for collision using AABB

        -- create a vector from our last position to the current position
        local last_move_vector_x = self.x - self.last_x
        local last_move_vector_y = self.y - self.last_y

        -- convert it to a unit vector
        local vector_length = math.abs(math.sqrt((last_move_vector_x * last_move_vector_x) + (last_move_vector_y * last_move_vector_y)))

        local unit_vector_x = last_move_vector_x / vector_length
        local unit_vector_y = last_move_vector_y / vector_length

        -- scale our unit vector by our collision_points_offset
        local move_vector_x = unit_vector_x * self.collision_points_offset
        local move_vector_y = unit_vector_y * self.collision_points_offset

        local i = 1
        while (i <= points_to_generate) do

            -- will change to false if there is no possiblity for collision
            local collided_x = true
            local collided_y = true

            -- generate our poing by taking our last position and adding our move_vector to it
            local gen_point_x = self.last_x + move_vector_x
            local gen_point_y = self.last_y + move_vector_y

            -- first, check to see if the left edge of either is farther to the right
            -- than the right edge of the other
            if gen_point_x > paddle.x + paddle.width or paddle.x > gen_point_x + self.width then
                collided_x = false
            end

            -- then check to see if the bottom edge of either is higher than the top
            -- edge of the other
            if gen_point_y > paddle.y + paddle.height or paddle.y > gen_point_y + self.height then
                collided_y = false
            end

            self.last_x = gen_point_x
            self.last_y = gen_point_y

            -- if collided is not false then 
            if (collided_x and collided_y) then
                return true
            end

            i = i + 1
        end
    --end
   
    -- if there was no collision above return false
    return false

    -- We check collisions for current location in this frame here
    --[[
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
    ]]
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.last_x = self.x
    self.last_y = self.y

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end