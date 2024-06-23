local plr1_pos=0.5
local plr2_pos=0.5
local plr1_score=0
local plr2_score=0

local ball_pos={x=0.5,y=0.5}
local ball_def_winkel=math.rad(35+180)
local ball_winkel=ball_def_winkel
local ball_v=0.55
local ball_scale=0.025

local zeit_zwischen_toren=0.5

local plr_len=0.25
local plr_with=0.025
local function limit (v,min,max)
    return math.min(math.max(v,min),max)
end
local font=love.graphics.newFont(32)
function love.load(arg,arg2)
    love.window.setMode(750, 750,{vsync=false})
    love.graphics.setFont(font)
end
local lb="none"

local tor_zeit=os.time()
function love.update(dt)
    if love.keyboard.isDown("s") then
       plr1_pos=plr1_pos+dt*0.5
    end
    if love.keyboard.isDown("w") then
        plr1_pos=plr1_pos-dt*0.5
    end
    if love.keyboard.isDown("down") then
        plr2_pos=plr2_pos+dt*0.5
     end
     if love.keyboard.isDown("up") then
         plr2_pos=plr2_pos-dt*0.5
     end
     plr1_pos=limit(plr1_pos,0,1-plr_len)
     plr2_pos=limit(plr2_pos,0,1-plr_len)

    --oben und unten kollision
    if (ball_pos.y-ball_scale*0.5)<=0 or (ball_pos.y+ball_scale*0.5)>=1 then
        ball_winkel=ball_winkel+math.rad(180)-(ball_winkel-math.rad(90))*2
    end
    --spieler1 kollision
    if (ball_pos.x-ball_scale*0.5)<=plr_with and lb~="plr1"then
        local check_botton=((ball_pos.y+ball_scale*0.5)<=plr1_pos+plr_len and (ball_pos.y+ball_scale*0.5)>=plr1_pos)
        local check_top=((ball_pos.y-ball_scale*0.5)<=plr1_pos+plr_len and (ball_pos.y-ball_scale*0.5)>=plr1_pos)
        if check_botton==true or check_top==true then
            ball_winkel=ball_winkel+math.rad(180)-(ball_winkel-math.rad(0))*2
            lb="plr1"
        end
    end
    --spieler2 kollision
    if (ball_pos.x+ball_scale*0.5)>=1-plr_with and lb~="plr2"then
        local check_botton=((ball_pos.y+ball_scale*0.5)<=plr2_pos+plr_len and (ball_pos.y+ball_scale*0.5)>=plr2_pos)
        local check_top=((ball_pos.y-ball_scale*0.5)<=plr2_pos+plr_len and (ball_pos.y-ball_scale*0.5)>=plr2_pos)
        if check_botton==true or check_top==true then
            ball_winkel=ball_winkel+math.rad(180)-(ball_winkel-math.rad(0))*2
            lb="plr2"
        end
    end

    --winkel limieren
    if ball_winkel>2*math.pi then
        ball_winkel=ball_winkel-2*math.pi
    elseif ball_winkel<0 then
        ball_winkel=ball_winkel+2*math.pi
    end

    --ball update
    if os.time()-tor_zeit>=zeit_zwischen_toren then
        ball_pos.x=ball_pos.x+ball_v*dt*math.cos(-ball_winkel)
        ball_pos.y=ball_pos.y+ball_v*dt*math.sin(-ball_winkel)
    end
    --scoring
    if ball_pos.x-ball_scale*0.5<0 then
        plr2_score=plr2_score+1
        ball_pos.x=0.5
        ball_pos.y=0.5
        ball_winkel=ball_def_winkel+math.rad(180)
        tor_zeit=os.time()
        lb="none"
    elseif ball_pos.x+ball_scale*0.5>1 then
        plr1_score=plr1_score+9
        ball_pos.x=0.5
        ball_pos.y=0.5
        ball_winkel=ball_def_winkel
        tor_zeit=os.time()
        lb="none"
    end
end

function love.draw(dt)
    love.graphics.clear()
    local screenX,screenY=love.graphics.getWidth(),love.graphics.getHeight()
    --draw ball
    love.graphics.rectangle("fill",ball_pos.x*screenX-(screenX*ball_scale*0.5),ball_pos.y*screenY-(screenY*ball_scale*0.5),screenX*ball_scale,screenY*ball_scale)

    --draw spieler
    love.graphics.rectangle("fill",0,plr1_pos*screenY,screenX*plr_with,plr_len*screenY)
    love.graphics.rectangle("fill",screenX-(screenX*plr_with),plr2_pos*screenY,screenX*plr_with,plr_len*screenY)

    --draw spieler scores + fps
    love.graphics.printf(plr1_score,0.1*screenX,0.1*screenY,font:getWidth(plr1_score),"left",0,1,1)
    love.graphics.printf(plr2_score,0.9*screenX,0.1*screenY,font:getWidth(plr2_score),"right",0,1,1)
    love.graphics.print("fps:"..love.timer.getFPS(),0.45*screenX,0.1*screenY)
end