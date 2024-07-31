--Atlantic.oce (First lua what doesnt use Fatality and has everything you can imagine)




































































































if not info.fatality.allow_insecure then
    return error("We need to for load libs properly")
end
tools = require("tools")
file = require("File System")
M = require("HWID")
Images = require("images")
virtual = require("readvirtualfile")
clipboard = require("clipboard")
oop = require("oop_menu")
vmt = require('vmt_hooks')


ffi.cdef([[
    struct c_animstate {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 462 ]; //0x162
        float m_flMaxYaw; //0x334

        float velocity_subtract_x; //0x0330 
        float velocity_subtract_y; //0x0334 
        float velocity_subtract_z; //0x0338 
    };

    typedef void*(__thiscall* get_client_entity_t)(void*, int);

    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, uintptr_t);
]])
loader = {
    ffi.cdef[[
    typedef struct {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
    } AdapterInfo;

    typedef void* (*get_current_adapter_fn)(void*);
    typedef void (*get_adapters_info_fn)(void*, void*, AdapterInfo*);

    typedef bool (*file_exists_t)(void*, const char*, const char*);
    typedef long long (*get_file_time_t)(void*, const char*, const char*);
]],
    --print("your hwid: " .. )
}


local b='ABCDEFGHIJLKMNONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()_+<>~:"?/-={}[];|'
local function enc(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

local function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local function str_to_sub(text, sep)
    local t = {}
    for str in string.gmatch(text, "([^"..sep.."]+)") do
        t[#t + 1] = string.gsub(str, "\n", " ")
    end
    return t
end

local function to_boolean(str)
    if str == "true" or str == "false" then
        return (str == "true")
    else
        return str
    end
end

function drag(var_x, var_y, size_x, size_y)
    local mouse_x, mouse_y = input.get_cursor_pos()

    local drag = false

    if input.is_key_down(0x01) then
        if mouse_x > var_x:get_int() and mouse_y > var_y:get_int() and mouse_x < var_x:get_int() + size_x and mouse_y < var_y:get_int() + size_y then
            drag = true
        end
    else
        drag = false
    end

    if (drag) then
        var_x:set_int(mouse_x - (size_x / 2))
        var_y:set_int(mouse_y - (size_y / 2))
    end

end

local function set_aspect_ratio(multiplier)
    
    
    local screen_width,screen_height = render.get_screen_size()

    local value = (screen_width * multiplier) / screen_height

    if multiplier == 1 then
        value = 0
    end
    r_aspectratio:set_float(value)
end

math.clamp = function(v, min, max)
    if min > max then min, max = max, min end
    if v > max then return max end
    if v < min then return v end
    return v
end

math.angle_diff = function(dest, src)
    local delta = 60.0
    delta = math.fmod(dest - src, 360.0)
    if dest > src then
        if delta >= 180 then delta = delta - 360 end
    else
        if delta <= -180 then delta = delta + 360 end
    end

    return delta
end

math.angle_normalize = function(angle)
    local ang = 0.0
    ang = math.fmod(angle, 360.0)
    if ang < 0.0 then ang = ang + 360 end
    return ang
end

math.anglemod = function(a)
    local num = (360 / 65536) * bit.band(math.floor(a * (65536 / 360.0), 65535))
    return num
end

math.approach_angle = function(target, value, speed)
    target = math.anglemod(target)
    value = math.anglemod(value)
    local delta = target - value
    if speed < 0 then speed = -speed end
    if delta < -180 then
        delta = delta + 360
    elseif delta > 180 then
        delta = delta - 360
    end
    if delta > speed then
        value = value + speed
    elseif delta < -speed then
        value = value - speed
    else
        value = target
    end
    return value
end


local entity_list_ptr = ffi.cast("void***", utils.find_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][3])
local get_client_entity_by_handle_fn = ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][4])
local rawientitylist = utils.find_interface("client.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(ffi.typeof("void***"), rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local entity = {}
entity.get_address = function(idx)
    return get_client_entity_fn(entity_list_ptr, idx)
end
entity.get_animstate = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("struct c_animstate**", addr + 0x9960)[0]
end
entity.get_animlayer = function(idx)
    local addr = entity.get_address(idx)
    if not addr then return end
    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', addr) + 0x9960)[0]
end
entity.get_prop = function(ent, ...)
    if not ent then return end
    return entities.get_entity(ent):get_prop(...)
end
entity.get_local_player = function()
    local lp = engine.get_local_player()
    if not lp then return end
    return entities.get_entity(lp)
end
entity.get_velocity = function(idx)
    local ent = entities.get_entity(idx)
    return math.vec3(ent:get_prop("m_vecVelocity[0]"), ent:get_prop("m_vecVelocity[1]"), ent:get_prop("m_vecVelocity[2]"))
end






































































--.name Atlantic.oce release
--.description Best new Lua Made, Done by Medusa.uno admin Team
--.author Tabihvh
player = engine.get_local_player()
player_info = engine.get_player_info(player)
engine.exec("fps_max 0")
local version = "Alpha"
local build_date = "22.07.2024"
print(string.format("Welcome %s to Atlantic.oce", tools.get_forum_username))
print(" _____________________________________")
print("|     Atlantic.oce has been loaded    |")
print("|_____________________________________|")
print("                                       ")
print("                                       ")
print("                                       ")
print(string.format("Succesfully loaded %s build", version))
print("                                       ")
print("                                       ")
print("                                       ")
print(" _____________________________________")
print("|     Dev: Tabihvh                    |")
print("|If you have any problem dm on discord|")
print("|discord:https://discord.gg/avGyV9bwQR|")
print("|_____________________________________|")
print("                                       ")
print("                                       ")
print("                                       ")
print("                                       ")
print("---------------------------------------")




font = render.create_font("Roboto-Bold.ttf", 13, render.font_flag_shadow)
verdana = render.create_font("calibrib.ttf", 12, render.font_flag_shadow)
medusalogo = render.create_font("Medusa-Regular.ttf", 39)
configs_dir = fs.create_dir("Atlantic/configs")
images_dir = fs.create_dir("Atlantic/images")
lua_dir = "Atlantic/configs"
Find = gui.get_config_item
slider = gui.add_slider
switch = gui.add_checkbox
Show = gui.set_visible
combo = gui.add_combo
list = gui.add_listbox
selectable = gui.add_multi_combo
color_picker = gui.add_colorpicker
pathA = "lua>tab a>"
pathB = "lua>tab b>"
local states = {"Global","Stand", "Move", "Air", "Air-Crouch","Crouch-Move","Crouch","Slow Walk","FakeLag","Fake Duck","FreeStand"}
refereces = {
    Pitch = Find("Rage>Anti-Aim>Angles>Pitch"),
    Yaw_Chck = Find("Rage>Anti-Aim>Angles>Yaw add"),
    Yaw = Find("Rage>Anti-Aim>Angles>Add"),
    Freestand = Find("Rage>Anti-Aim>Angles>Freestand"),
    At_fov_target = Find("Rage>Anti-Aim>Angles>At fov target"),
    jitterrange = Find("rage>anti-aim>angles>jitter range"),
    Desync_Chck = Find("rage>anti-aim>desync>fake"),
    fakeamount = Find("rage>anti-aim>desync>fake amount"),
    mindmg = Find("rage>aimbot>ssg08>scout>override"),
    compensate = Find("rage>anti-aim>desync>compensate angle"),
    fsfake = Find("rage>anti-aim>desync>freestand fake"),
    fakejitter = Find("rage>anti-aim>desync>Flip fake with jitter"),
    slide = Find("misc>movement>slide"),
    jitterRandom = Find("rage>anti-aim>angles>Random"),
    fakelaglimit = Find("rage>anti-aim>fakelag>limit"),
    fakelagmode = Find("rage>anti-aim>fakelag>Mode"),
    dormant_aimbot = Find("rage>aimbot>aimbot>target dormant"),
    AP = Find("Misc>Movement>Peek Assist"),
    FD = Find("Misc>Movement>Fake Duck"),
    DT = Find("Rage>aimbot>aimbot>double tap"),
    OSAA = Find("Rage>aimbot>aimbot>Hide Shot")
}

other = {   
    Update = list("Build Version",pathA,1,false,{build_date}),                         
    Tabs = list("Tabs", pathA, 3, false, {"Home","Rage", "Misc"}),
    Information = list("Information", pathB,9,false,{"Welcome to Atlantic.oce","---------------------------------------------------","Coders: Tabihvh, duskuś ♥","Most Customized Lua","Best Lua Ever Done","With Uniqe Features","Best Anti-Aim","Bautiful Visuals","---------------------------------------------------"}),
    Rage = list("Rage", pathA,2,false, {"Ragebot", "Anti-Aim"}),
    Misc = list("Misc", pathA,2,false,{"Visuals", "Misc"}),
    Anti_Aim = list("Anti-Aim", pathA, 2, false, {"Conditions", "Preset"}),

    Ragebot = {
        Resolver = switch("Resolver",pathB),
        backtrack = switch("Backtrack Exploit",pathB),
        --ping = slider("fake latency amount", pathB, 0,200,0)
    },

  Misc2 = {
        indicators = switch("Indicators", pathB),
        --consolehitlogs = switch("Console Hitlogs", pathB),
        --hitlogs = switch("Hitlogs", pathB),
        consolehitlogs, hitlogs = selectable("Hitlogs Type", "lua>tab b", {"Screen Logs","Console Logs"}),
        consolemisslogs,misslogs = selectable("Misslogs Type", "lua>tab b",{"Sceen Logs", "Console Logs"}),
        --local watermark, keybinds = MultiCombo("Solus UI", "lua>tab b", {"Watermark","Keybinds list"})
        Logstype = combo("Hitlogs Style", pathB, {"Medusa Hitlogs", "Skeet Hitlogs", "Catalyst Hitlog"}),
        colormain = switch("Accent Color", pathB),
        colormaincp = color_picker("lua>tab b>Accent Color", true),
        kys = combo("Killsay", pathB, {"Disable","Medusa.uno", "Atlantic.oce", "Retarded"}),
        ratio = slider("Aspect Ratio Amount", pathB, 0,200,126)
    }
}
local ConditionalStates = {}
local configs = {}
local misc = {}
local cool = {
    name = {"[G] ","[S] ","[M] ","[A] ", "[AC] ","[CM] ","[C]", "[SW] ","[FL] ","[FD] ","[FS] "}
}
ConditionalStates[0] = {
    player_state = list("Conditions", pathA,11,true, states),

}
for i=1,#states do
    ConditionalStates[i] = {
        override = switch(cool.name[i] ..  "Override Global State", pathB),
        pitch = combo(cool.name[i] ..  "Pitch",pathB,{"None","Down","Up","Zero"});
        yaw_check = switch(cool.name[i] .. "Yaw Enable",pathB);
        yaw_type = combo(cool.name[i] .. "Yaw Type",pathB,{"Classic","Manual"});
        yaw_classic = combo(cool.name[i] .. "Classic Yaw",pathB, {"None","Backward","Zero","Random"});
        yaw_mode = combo(cool.name[i] ..  "Yaw",pathB,{"Static","L&R","L&R Delay"});
        yaw_amount_static = slider(cool.name[i] .. "Yaw Amount",pathB,-180,180,0);
        yaw_amount_left = slider(cool.name[i] .. "Yaw Amount Left",pathB,-180,180,0);
        yaw_amount_right = slider(cool.name[i] .. "Yaw Amount Right",pathB,-180,180,0);
        yaw_amount_delay = slider(cool.name[i] .. "Yaw Delay",pathB,0,10,0);
    };
end
local st = 0;
function AntiAim()
    if not engine.is_in_game() then return end
    local isSW = refereces.slide:get_bool()
    local lp = entities.get_entity(engine.get_local_player())
    local local_player = entities.get_entity(engine.get_local_player())
    local inAir = local_player:get_prop("m_hGroundEntity") == -1
    local vel_x = math.floor(local_player:get_prop("m_vecVelocity[0]"))
    local vel_y = math.floor(local_player:get_prop("m_vecVelocity[1]"))
    local speed = math.sqrt(vel_x ^ 2 + vel_y ^ 2)
    local flag = local_player:get_prop("m_fFlags")
    local crouch = bit.band(flag, 4) == 4
    local FD = refereces.FD:get_bool()
    local FS  = refereces.Freestand:get_bool()

    if FS and not inAir and ConditionalStates[10].override:get_bool() == true then st = 10 --FreeStand
        elseif FD and not inAir and ConditionalStates[9].override:get_bool() == true then st = 9 --Fuck duck
        elseif refereces.DT:get_bool() == false and refereces.OSAA:get_bool() == false and ConditionalStates[8].override:get_bool() == true then st = 8 -- FakeLag
        elseif isSW and not inAir and ConditionalStates[7].override:get_bool() == true then st = 7 -- Slow-Walk
        elseif not inAir and speed <= 5 and crouch and ConditionalStates[6].override:get_bool() == true then st = 6 -- crouch
        elseif not inAir and speed > 5 and crouch and ConditionalStates[5].override:get_bool() == true then st = 5 -- crouch-move
        elseif inAir and crouch and ConditionalStates[4].override:get_bool() == true then st = 4 -- air-crouch
        elseif inAir and not crouch and ConditionalStates[3].override:get_bool() == true  then st = 3 -- air
        elseif not isSW and  not inAir and not crouch  and speed > 5 and ConditionalStates[2].override:get_bool() == true  then st = 2 -- move
        elseif flag == 257  and speed <= 5 and ConditionalStates[1].override:get_bool() == true then st = 1 -- stand
        else  st = 0 end


        local function sway(ref,feature,value)
            local value = math.floor(math.abs(math.sin(global_vars.realtime*2) *2) * feature:get_int())
            if value > 200 then
                value = 200
            end
            ref:set_int(-100+(value*2))
        end


                    
                
            

                    --   0        1       2       3         4            5             6          7           8        9          10
    --local states = {"Global","Stand", "Move", "Air", "Air-Crouch","Crouch-Move","Crouch","Slow Walk","FakeLag","Fake Duck","FreeStand"}
    --{"Share", "Stand", "Run", "Crouch", "Air", "Air+C","Slow Walk"} ----------- neverlose
    refereces.Pitch:set_int(ConditionalStates[st].pitch:get_int());

end



function killsay(event)
    if other.Misc2.kys:get_int() == 0 then return end
    local advertisement = {
        "EZ owned by Atlantic.oce",
        "Get better get Atlantic.oce",
        "Bored of using pasted luas? go use Atlantic.oce instead",
        "get 1'ed by Atlantic.oce",
        "unlock your full potential with Atlantic.oce",
        "want to be best version of your self? use Atlantic.oce",
        "Imagine still not using Atlantic.oce",
        "Bro its 2024 and you are not using Atlantic.oce",
        "Tabi Updated Atlantic.oce and made it unhitable",
        "Atlatic.oce Get or Lose",
        "Atlatic.oce best lua ever done",
        "Want to be good like me? use discord.gg/n2wrMQuKFr",
        "Another NN lose to Atlatic.oce"
    }
    
    local medusa_uno = {
        "Be humiliated because you just got 1 by Medusa.uno",
        "OwO, what is this? Medusa.uno just made your kd worse",
        "YOUR DEAD, IMAGINE, GET 1'ED BY MEDUSA.UNO",
        "Get good, sting to death with Medusa.uno",
        "Another no name down by Medusa.uno",
        "UwU stings you to death cutely using Medusa.uno",
        "Medusa.uno just stinged ur ass $$$$$",
        "Just saw something, a 1 in my killfeed caused by Medusa.uno",
        "Why you keep to see 1 caused by Medusa.uno",
        "Knock Knock Who there? Medusa.uno here to take exterminate the no names!",
        "Taking down some no names? How about you get yourself Medusa.uno and rape em >:}",
        "Anotha day, anotha carry by Medusa.uno",
        "Sit the fuck down no name, Medusa.uno will always be superior",
        "WOMP WOMP GET 1'ED BY MEDUSA.UNO",
        "What was that? No namer dying? Womp womp, Medusa.uno is yo feudal leader",
        "^=^ Woo hoo, anotha no named downed by Medusa.uno",
        "Who this? No name dying to Medusa.uno? Womp womp."
    }
    
    local toxic = {
        "Why you are as that EZ",
        "Bro fucking leave, this game is wast of your time",
        "1 Sit nn Dog"
    }
    local attacker = engine.get_player_for_user_id(event:get_int('attacker'));
    local userid = engine.get_player_for_user_id(event:get_int('userid'));
    local userInfo = engine.get_player_info(userid);
    local lp = engine.get_local_player();
    if attacker == lp and userid ~= lp then
        if other.Misc2.kys:get_int() == 1 then
            engine.exec("say " .. medusa_uno[utils.random_int(1, #medusa_uno)])
        end
        if other.Misc2.kys:get_int() == 2 then
            engine.exec("say " .. advertisement[utils.random_int(1, #advertisement)])
        end
        if other.Misc2.kys:get_int() == 3 then
            engine.exec("say " .. toxic[utils.random_int(1, #toxic)])
        end
    end
end

local vec3 = math.vec3
local logger = function(array, font, x, y, alpha, shift)
    local highlight = render.color(255, 255, 255, 255)
    local color = other.Misc2.colormaincp:get_color()
    local size = 0
    local step_size = 0

    for _, v in pairs(array) do -- calc total size
        size = size + render.get_text_size(font, v[1])

        if shift then size = size * (math.min(alpha, 150)/150) end
    end

    for _, v in pairs(array) do
        if v[2] then
            v[2].a = alpha
        end

        render.text(font, x + step_size, y, v[1], v[2] or render.color(255, 255, 255, alpha))

        step_size = step_size + render.get_text_size(font, v[1])
    end
end

local shots = {}
local misses = {}
local hitgroup = {
    [0] = "generic",
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [10] = "gear"
}

local x, y = render.get_screen_size()
local screen_width, screen_height = render.get_screen_size()
local screen_size = {render.get_screen_size()}
local keybinds_x = gui.add_slider("keybinds_x", pathA, 0, screen_size[1], 1)
local keybinds_y = gui.add_slider("keybinds_y", pathA, 0, screen_size[2], 1)
gui.set_visible(pathA.."keybinds_x", false)
gui.set_visible(pathA.."keybinds_y", false)

local animations = {anim_list = {}}

animations.math_clamp = function(value, min, max)
    return math.min(max, math.max(min, value))
end

animations.math_lerp = function(a, b_, t)
    -- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    local t = animations.math_clamp(2/16, 0, 1)

    if type(a) == 'userdata' then
        r, g, b, a = a.r, a.g, a.b, a.a
        e_r, e_g, e_b, e_a = b_.r, b_.g, b_.b, b_.a
        r = animations.math_lerp(r, e_r, t)
        g = animations.math_lerp(g, e_g, t)
        b = animations.math_lerp(b, e_b, t)
        a = animations.math_lerp(a, e_a, t)
        return color(r, g, b, a)
    end

    local d = b_ - a
    d = d * t
    d = d + a

    if b_ == 0 and d < 0.01 and d > -0.01 then
        d = 0
    elseif b_ == 1 and d < 1.01 and d > 0.99 then
        d = 1
    end

    return d
end

animations.vector_lerp = function(vecSource, vecDestination, flPercentage)
    return vecSource + (vecDestination - vecSource) * flPercentage
end

animations.anim_new = function(name, new, remove, speed)
    if not animations.anim_list[name] then
        animations.anim_list[name] = {}
        animations.anim_list[name].color = render.color(0, 0, 0, 0)
        animations.anim_list[name].number = 0
        animations.anim_list[name].call_frame = true
    end

    if remove == nil then
        animations.anim_list[name].call_frame = true
    end

    if speed == nil then
        speed = 0.100
    end

    if type(new) == 'userdata' then
        lerp = animations.math_lerp(animations.anim_list[name].color, new, speed)
        animations.anim_list[name].color = lerp

        return lerp
    end

    lerp = animations.math_lerp(animations.anim_list[name].number, new, speed)
    animations.anim_list[name].number = lerp

    return lerp
end

function animate(value, cond, max, speed, dynamic, clamp)

    -- animation speed
    speed = speed * global_vars.frametime * 20

    -- static animation
    if dynamic == false then
        if cond then
            value = value + speed
        else
            value = value - speed
        end
    
    -- dynamic animation
    else
        if cond then
            value = value + (max - value) * (speed / 100)
        else
            value = value - (0 + value) * (speed / 100)
        end
    end

    -- clamp value
    if clamp then
        if value > max then
            value = max
        elseif value < 0 then
            value = 0
        end
    end

    return value
end

local function concatenateTextParts(parts)
    local concatenatedText = ""
    for _, v in pairs(parts) do
        concatenatedText = concatenatedText .. v[1]
    end
    return concatenatedText
end

function drawtext_size(font, table)
    local size = {}
    size.x = 0
    size.y = 0
    for k, v in pairs(table) do
        local x, y = render.get_text_size(font, v.text)
        size.x = size.x + x
        size.y = size.y + y
    end
    return vec3(size.x, size.y)
end

local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * global_vars.frametime * speed / 1.5
    else 
        return name - (value + name) * global_vars.frametime * speed / 1.5
        
    end
end

function logs(e)
    if e.manual then return end
    local local_player = engine.get_local_player()
    local p = entities.get_entity(e.target)
    local n = p:get_player_info()
    --local attacker = shot:get_int("attacker")
    local highlight = render.color(255, 255, 255, 255)
    local color = other.Misc2.colormaincp:get_color()
    --local userid = (engine.get_player_info(user_id).name)
    local lp = engine.get_local_player()
    local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
    local hitgroup = e.server_hitgroup
    local clienthitgroup = e.client_hitgroup
    reasons = {
        ["hit"] = 'hit',
        ['spread'] = 'Spread',
        ['resolve'] = 'Resolver',
        ["server correction"] = 'Unregister shot',
        ['extrapolation'] = 'Prediction error',
        ['anti-exploit'] = 'Anti-Exploit'
    }

    if userid ~= lp then return end

    if e.result ~= "hit" then
        misses[#misses + 1] = {
        text = {
            {"Atlantic.oce | ", highlight},
            {"Missed ".. n.name},
            {" | In: "},
            {hitgroup_names[hitgroup + 1]},
            {" | To: %s ", reasons[shot.reason]},
        },
        a = 0,
        time = global_vars.realtime + 3
        }
    end
    if e.result == "hit" then
        shots[#shots + 1] = {
            text = {
                {"Atlantic.oce | ", highlight},
                {"Registered shot on ".. n.name},
                {" | In: "},
                {hitgroup[shot:get_int("hitgroup")]},
                {" | Damage: "},
                {("%s hp |"):format(shot:get_int("dmg_health"), shot:get_int("dmg_armor")),},
                {(" BT: %s "):format(shot.backtrack)}
            },
            a = 0,
            time = global_vars.realtime + 3
        }
    end
end


function medusahitlogs()

    if other.Misc2.Logstype:get_int() == 0 then

        local screen_width, screen_height = render.get_screen_size()
        local pos = {screen_width / 2, screen_height / 2}
        local color = other.Misc2.colormaincp:get_color()
        local offset = 0

        for _, v in pairs(shots) do
            if v.a <= 0 and global_vars.realtime > v.time and _ == #shots then
                shots[_] = nil
            end

            v.a = global_vars.realtime < v.time and math.min(v.a + 5, 255) or math.max(v.a - 5, 0)
            local text = concatenateTextParts(v.text)
            local textlogo = "0"
            local text_dimensions = drawtext_size(font, { {text = text} })
            local text_width = text_dimensions.x
            local text_height = text_dimensions.y
            alpha = animate(alpha or 0, true, 1, 0.5, false, true)

            local rect_width = text_width + 20 -- Add padding
            local rect_height = text_height + 10 -- Add padding

            -- Calculate new position based on text width
            local new_pos_x = pos[1] - rect_width / 2
            local new_pos_y = pos[2] + 230 - rect_height / 2 + offset * (rect_height + 15) -- Adjust position with offset
            -- glow
            agan = 65

            -- Render the background rectangles
            if offset <= 8 then
                render.rect_filled(new_pos_x - 20, new_pos_y - 2, new_pos_x + rect_width + 22, new_pos_y + rect_height + 2, render.color(30, 30, 30, v.a))
                render.rect(new_pos_x - 21, new_pos_y - 2, new_pos_x + rect_width + 23, new_pos_y + rect_height + 3, render.color(190, 190, 190, v.a))
                render.line(new_pos_x + 20, new_pos_y - 2, new_pos_x + 20, new_pos_y + rect_height +2, render.color(255, 255, 255, v.a))
                render.text(font, new_pos_x + 32, new_pos_y + 7, text, render.color(255, 255, 255, v.a))
                render.text(medusalogo, new_pos_x - 16, new_pos_y - 5.7, textlogo, render.color(255, 255, 255, v.a))
            end

            if offset >= 8 then
                offset = 0
            end

            offset = offset + 1 -- Ensure offset increments correctly for each entry
        end
    end
end



function skeethitlogs()
    

    local color = other.Misc2.colormaincp:get_color()
    local screen_width, screen_height = render.get_screen_size()
    local pos = {screen_width / 2, screen_height / 2}
    local offset = 0

    for _, v in pairs(shots) do
        if v.a <= 0 and global_vars.realtime > v.time and _ == #shots then
            shots[_] = nil
        end

        v.a = global_vars.realtime < v.time and math.min(v.a + 5, 255) or math.max(v.a - 5, 0)
        local text = concatenateTextParts(v.text)
        local text_width, text_height = render.get_text_size(font, text)

        local rect_width = text_width + 20 -- inaczej bomba jebnie
        local rect_height = text_height + 10 -- inaczej bomba jebnie

            -- zostaw bo 15 hitlogow w 1 zrobisz xDD
            local new_pos_x = pos[1] - rect_width / 2
            local new_pos_y = pos[2] + 230 - rect_height / 2 + offset * (rect_height + 15) -- Adjust position with offset

            -- skrrt
            if offset <= 8 then
            render.rect_filled(new_pos_x - 2, new_pos_y - 2, new_pos_x + rect_width + 4, new_pos_y + rect_height + 2, render.color(0, 0, 0, v.a))
            render.rect_filled(new_pos_x - 1, new_pos_y - 1, new_pos_x + rect_width + 3, new_pos_y + rect_height + 1, render.color(40, 40, 40, v.a))
            render.rect_filled(new_pos_x + 1, new_pos_y + 1, new_pos_x + rect_width + 1, new_pos_y + rect_height - 1, render.color(0, 0, 0, v.a))
            render.rect_filled(new_pos_x + 2, new_pos_y + 2, new_pos_x + rect_width, new_pos_y + rect_height - 2, render.color(16, 16, 16, v.a))
            render.rect_filled_multicolor(new_pos_x + 3, new_pos_y + 3, new_pos_x + rect_width / 2, new_pos_y + 4, render.color(59, 84, 96, v.a), render.color(99, 60, 98, v.a), render.color(99, 60, 98, v.a), render.color(59, 84, 96, v.a))
            render.rect_filled_multicolor(new_pos_x + rect_width / 2, new_pos_y + 3, new_pos_x + rect_width - 1, new_pos_y + 4, render.color(99, 60, 98, v.a), render.color(110, 115, 77, v.a), render.color(110, 115, 77, v.a), render.color(99, 60, 98, v.a))
            render.text(font, new_pos_x + 10, new_pos_y + 8, text, render.color(255, 255, 255, v.a))
           
            offset = offset + 1 -- nie dotykam bo jebnie
            if offset >= 8 then 
            offset = 0

            end
            end
        end
end



local offset_scope = 0
function indicators()  
    if engine.is_in_game() == false then return end
    local slowwalk = refereces.slide:get_bool()
    local localplayer = entities.get_entity(engine.get_local_player())
    local flag = localplayer:get_prop("m_fFlags")
    local air = localplayer:get_prop("m_hGroundEntity") == -1
    local crouch = input.is_key_down(0x11)
    local canDT = info.fatality.can_fastfire
    local l = render.color(150, 200, 30)
    local x, y = render.get_screen_size()
    local spacebar = input.is_key_down(0x20)
    local boolindic = other.Misc2.indicators:get_bool()
    local isSW = refereces.slide:get_bool()
    local lp = entities.get_entity(engine.get_local_player())
    local local_player = entities.get_entity(engine.get_local_player())
    local inAir = local_player:get_prop("m_hGroundEntity") == -1
    local vel_x = math.floor(local_player:get_prop("m_vecVelocity[0]"))
    local vel_y = math.floor(local_player:get_prop("m_vecVelocity[1]"))
    local speed = math.sqrt(vel_x ^ 2 + vel_y ^ 2)
    local crouch = bit.band(flag, 4) == 4
    local FD = refereces.FD:get_bool()
    local FS  = refereces.Freestand:get_bool()
    if not other.Misc2.indicators:get_bool() then return end

    fst = "medusa.lua"
    fst2 = "RECHARGING"
    dtxxz2 = animations.anim_new('basdaxsxda2', info.fatality.can_fastfire and 7 or 0)
    dtxxz3 = animations.anim_new('basdaxsxda3', info.fatality.can_fastfire and 0 or 11)
    local active, activy = render.get_text_size(font, fst:sub(1, dtxxz2))
    local inactive, inactivy = render.get_text_size(font, fst2:sub(1, dtxxz3))/1.3
    local xxx, xxx2 = render.get_text_size(font, "m")
    local xxx2, xxx2XZXZ = render.get_text_size(font, "me")
    local xxx3, xxx2X = render.get_text_size(font, "med")
    local xxx4, xxx2ZZ = render.get_text_size(font, "medu")
    local xxx5, xxx242 = render.get_text_size(font, "medus")
    local xxx6, xxx2Y= render.get_text_size(font, "medusa")
    local xxx7, xxx2ASD = render.get_text_size(font, "medusa.")
    local xxx8, xxx2ASDX = render.get_text_size(font, "medusa.l")
    local xxx9, xxx2ASDXX = render.get_text_size(font, "medusa.lu")
    -- pos x'es

    local rmx = 23
    render.text(font, x / 2-rmx- 2+xxx- 8 , y / 2 + 24, "m", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 80 / 30))), render.align_center)
    render.text(font, x / 2-rmx- 2+xxx , y / 2 + 24, "e", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 75 / 30))), render.align_center)
    render.text(font, x / 2-rmx- 2+xxx2 , y / 2 + 24, "d", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 70 / 30))), render.align_center)
    render.text(font, x / 2-rmx- 2+xxx3 , y / 2 + 24, "u", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 65 / 30))), render.align_center)
    render.text(font, x / 2-rmx- 2+xxx4 , y / 2 + 24, "s", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 60 / 30))), render.align_center)
    render.text(font, x / 2-rmx- 2+xxx5 , y / 2 + 24, "a", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 55 / 30))), render.align_center)
    render.text(font, x / 2-rmx- 2+xxx6-2 , y / 2 + 24, ".", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 50 / 30))), render.align_center)
    render.text(font, x / 2-rmx- 2+xxx7-2 , y / 2 + 24, "l", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 45 / 30))), render.align_center)
    render.text(font, x / 2-rmx- 2+xxx8-1 , y / 2 + 24, "u", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 45 / 30))), render.align_center)
    render.text(font, x / 2-rmx- 2+xxx9-1 , y / 2 + 24, "a", render.color(255, 0 ,0, 255 * math.abs(1 * math.cos(2 * math.pi * global_vars.curtime/2 + 45 / 30))), render.align_center)

    if st == 0 then text_state = "Share"
    elseif st == 1 then text_state = "Stand"
    elseif st == 2 then text_state = "Run"
    elseif st == 3 then text_state = "Air"
    elseif st == 4 then text_state = "Air+C"
    elseif st == 5 then text_state = "Move+C"
    elseif st == 6 then text_state = "Crouch" 
    elseif st == 7 then text_state = "Slow-Walk"
    elseif st == 8 then text_state = "FakeLag"
    elseif st == 9 then text_state = "Fake Duck"
    elseif st == 10 then text_state = "Freestand"end

    render.text(font, x / 2, y / 2 + 36,text_state,other.Misc2.colormaincp:get_color(), render.align_center)

    if refereces.DT:get_bool() and canDT  then 
        render.text(font, x / 2, y / 2 + 47, "Double Tap",render.color("#65eb89"), render.align_center)
    end
    if refereces.DT:get_bool() and not canDT  then 
        render.text(font, x / 2, y / 2 + 47, "Double Tap",render.color("#ff5c5c"), render.align_center)
    end
    if refereces.OSAA:get_bool() and not refereces.DT:get_bool() then 
        render.text(font, x / 2, y / 2 + 48, "Hide Shots",other.Misc2.colormaincp:get_color(), render.align_center)
    end
    if refereces.OSAA:get_bool() and refereces.DT:get_bool() then 
        render.text(font, x / 2, y / 2 + 60, "Hide Shots",other.Misc2.colormaincp:get_color(), render.align_center)
    end

    --[[
        if FS and not inAir and ConditionalStates[10].override:get_bool() == true then st = 10 --FreeStand
        elseif FD and not inAir and ConditionalStates[9].override:get_bool() == true then st = 9 --Fuck duck
        elseif refereces.DT:get_bool() == 0 and refereces.OSAA:get_bool() == 0 and ConditionalStates[8].override:get_bool() == true then st = 8 -- FakeLag
        elseif isSW and not inAir and ConditionalStates[7].override:get_bool() == true then st = 7 -- Slow-Walk
        elseif not inAir and speed <= 5 and crouch and ConditionalStates[6].override:get_bool() == true then st = 6 -- crouch
        elseif not inAir and speed > 5 and crouch and ConditionalStates[5].override:get_bool() == true then st = 5 -- crouch-move
        elseif inAir and crouch and ConditionalStates[4].override:get_bool() == true then st = 4 -- air-crouch
        elseif inAir and not crouch and ConditionalStates[3].override:get_bool() == true then st = 3 -- air
        elseif not isSW and  not inAir and speed > 5 and not crouch and ConditionalStates[2].override:get_bool() == true then st = 2 -- move
        elseif flag == 257  and speed <= 5 and ConditionalStates[1].override:get_bool() == true then st = 1 -- stand
    else st = 0 end]]

end

function hitpaint()
    if other.Misc2.Logstype:get_int() == 2 then

    local highlight = render.color(255, 255, 255, 255)
    local color = other.Misc2.colormaincp:get_color()
    local offset = 0
    local size = 0

    for _, v in pairs(shots) do
        if v.a <= 0 and global_vars.realtime > v.time and _ == #shots then
            shots[_] = nil
        end

        v.a = global_vars.realtime < v.time and math.min(v.a + 5, 255) or math.max(v.a - 5, 0)
        adxx = 19

        if offset <= 5 then
            render.rect_filled(1116, 874 + 25 * offset, 1118, 891 + 25 * offset, color)
            render.rect_filled_multicolor(1118, 875 + 25 * offset, 1418, 890 + 25 * offset, render.color(0,0,0,v.a-122), render.color(0,0,0,0), render.color(0,0,0,0), render.color(0,0,0,v.a-122))
            logger(v.text, font, 1121, 876 + 25 * offset,v.a)
        end

        offset = offset + math.min(v.a/40, 1)
    end
    end
end
function misspaint()
    if not other.Misc2.hitlogs:get_bool() then return end
    if other.Misc2.Logstype:get_int() == 2 then

    local highlight = render.color(255, 255, 255, 255)
    local color = other.Misc2.colormaincp:get_color()
    local offset = 0
    local size = 0

    for _, v in pairs(misses) do
        if v.a <= 0 and global_vars.realtime > v.time and _ == #misses then
            misses[_] = nil
        end

        v.a = global_vars.realtime < v.time and math.min(v.a + 5, 255) or math.max(v.a - 5, 0)
        adxx = 19

        if offset <= 5 then
            render.rect_filled(1116, 874 + 25 * offset, 1118, 891 + 25 * offset, color)
            render.rect_filled_multicolor(1118, 875 + 25 * offset, 1418, 890 + 25 * offset, render.color(0,0,0,v.a-122), render.color(0,0,0,0), render.color(0,0,0,0), render.color(0,0,0,v.a-122))
            logger(v.text, font, 1121, 876 + 25 * offset,v.a)
        end

        offset = offset + math.min(v.a/40, 1)
    end
    end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

r_aspectratio = cvar.r_aspectratio
default_value = r_aspectratio:get_float()
function aspect_ratio2()
    local aspect_ratio = other.Misc2.ratio:get_int() * 0.01
    aspect_ratio = 2 - aspect_ratio
    set_aspect_ratio(aspect_ratio)
end 



function setvisible()
    local Tabs = other.Tabs:get_int()
    local state = ConditionalStates[0].player_state:get_int() + 1
    local Rage = other.Rage:get_int()
    local Anti_Aim = other.Anti_Aim:get_int()
    local misc = other.Misc:get_int()
    --ConditionalStates[0].player_state:get_int() ~= 0
    Show("Lua>tab b>Information", Tabs == 0);
    Show("lua>tab a>Rage", Tabs == 1);
    Show("lua>tab a>Misc", Tabs == 2);
    Show("Lua>tab a>Anti-Aim", Tabs == 1 and Rage == 1);
    Show("Lua>tab a>Conditions", Tabs == 1 and Rage == 1 and Anti_Aim == 0);

    ConditionalStates[1].override:set_bool(true)
    for i=1,#states do
        local state_enabled = ConditionalStates[i].override:get_bool()
        Show("Lua>tab b>"..cool.name[i].."Override Global State", i ~= 1 and Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i);
        Show("Lua>tab b>"..cool.name[i].."Pitch", Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i and state_enabled);
        Show("Lua>tab b>"..cool.name[i].."Yaw Enable", Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i and state_enabled);
        Show("Lua>tab b>"..cool.name[i].."Yaw Type", Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i and ConditionalStates[i].yaw_check:get_bool() and state_enabled);
        Show("Lua>tab b>"..cool.name[i].."Classic Yaw", Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i and ConditionalStates[i].yaw_check:get_bool() and ConditionalStates[i].yaw_type:get_int() == 0 and state_enabled);
        Show("Lua>tab b>"..cool.name[i].."Yaw", Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i and ConditionalStates[i].yaw_check:get_bool() and ConditionalStates[i].yaw_type:get_int() == 1 and state_enabled);
        Show("Lua>tab b>"..cool.name[i].."Yaw Amount", Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i and ConditionalStates[i].yaw_check:get_bool() and ConditionalStates[i].yaw_type:get_int() == 1 and ConditionalStates[i].yaw_mode:get_int() == 0 and state_enabled);
        Show("Lua>tab b>"..cool.name[i].."Yaw Amount Left", Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i and ConditionalStates[i].yaw_check:get_bool() and ConditionalStates[i].yaw_type:get_int() == 1 and ConditionalStates[i].yaw_mode:get_int() ~= 0 and state_enabled);
        Show("Lua>tab b>"..cool.name[i].."Yaw Amount Right", Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i and ConditionalStates[i].yaw_check:get_bool() and ConditionalStates[i].yaw_type:get_int() == 1 and ConditionalStates[i].yaw_mode:get_int() ~= 0 and state_enabled);
        Show("Lua>tab b>"..cool.name[i].."Yaw Delay", Tabs == 1 and Rage == 1 and Anti_Aim == 0 and state == i and ConditionalStates[i].yaw_check:get_bool() and ConditionalStates[i].yaw_type:get_int() == 1 and ConditionalStates[i].yaw_mode:get_int() == 2 and state_enabled);
    end
        --[[        Resolver = switch("Resolver",pathB),
        backtrack = switch("Backtrack Exploit",pathB),]]
        Show("Lua>tab b>Resolver", Tabs == 1 and Rage == 0);
        Show("Lua>tab b>Backtrack Exploit", Tabs == 1 and Rage == 0);
        Show("Lua>tab b>Indicators", Tabs == 2 and misc == 0);
        Show("Lua>tab b>Aspect Ratio Amount", Tabs == 2 and misc == 0);
        --Show("Lua>tab b>Console Hitlogs", Tabs == 2 and misc == 1);
        --Show("Lua>tab b>Hitlogs", Tabs == 2 and misc == 1);
        Show("Lua>tab b>Hitlogs Type", Tabs == 2 and misc == 1);
        Show("Lua>tab b>Misslogs Type", Tabs == 2 and misc == 1);
        Show("Lua>tab b>Hitlogs Style", Tabs == 2 and misc == 1 and other.Misc2.hitlogs:get_bool());
        
        Show("Lua>tab b>Accent Color", Tabs == 0);
        Show("Lua>tab b>Killsay", Tabs == 2 and misc == 1);
end




function on_paint()
    hitpaint()
    skeethitlogs()
    medusahitlogs()
    indicators()
    setvisible()
    misspaint()
    aspect_ratio2()
end

function on_create_move()
    AntiAim()
end

function on_player_death(event)
    killsay(event)
end
function on_shot_registered(e)
    logs(e)
end