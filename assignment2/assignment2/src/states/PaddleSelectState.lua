--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Breakout" in large text, as well as a message to press
    Enter to begin.
]]

PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter(params)
    self.highScores = params.highScores
end

function PaddleSelectState:init()
    -- the paddle we're highlighting; will be passed to the ServeState
    -- when we press Enter
    self.currentPaddle = 1
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.currentPaddle == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.currentPaddle == 4 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    end

    -- select paddle and move on to the serve state, passing in the selection
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gSounds['confirm']:play()

        gStateMachine:change('serve', {
            paddle = Paddle(self.currentPaddle),
            bricks = LevelMaker.createMap(32),
            health = 3,
            score = 0,
            highScores = self.highScores,
            level = 32,
            recoverPoints = 5000
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your paddle with left and right!", 0, gameHeight / 4,
      gameWidth, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("(Press Enter to continue!)", 0, gameHeight / 3,
      gameWidth, 'center')
      
        
    -- left arrow; should render normally if we're higher than 1, else
    -- in a shadowy form to let us know we're as far left as we can go
    if self.currentPaddle == 1 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], gameWidth / 4 - 24,
    gameHeight - gameHeight / 3)
   
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go
    if self.currentPaddle == 4 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], gameWidth - gameWidth / 4,
    gameHeight - gameHeight / 3)
    
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    -- draw the paddle itself, based on which we have selected
    love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.currentPaddle - 1)],
    gameWidth / 2 - 32, gameHeight - gameHeight / 3)
end