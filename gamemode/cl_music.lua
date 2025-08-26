-- Ignore. It's partly broken. May fix it some time.
--[[
MUSIC = {}
MUSIC.Folder = ''

MUSIC.TrackInfos = {}
MUSIC.UseTracks = true
MUSIC.Info = nil
MUSIC.ActiveTracks = {}
MUSIC.TempTracks = {}
MUSIC.Stimulis = {}

MUSIC.TickTasks = {}
MUSIC.Formats = {'.mp3', '.ogg', '.wav'}
MUSIC.PreviousBeat = 0
MUSIC.MaxBeats = 0
MUSIC.Active = false

function MUSIC:Stimulate(Event, Freq) -- Here is where some of the magic happens for different tracks and stuff.
    MUSIC.Stimulis[Event] = MUSIC.Stimulis[Event] + Freq
end

function MUSIC:Think() -- For slower, repetitive processes
    if not MUSIC.Active then
        local danger = MUSIC:CalculateNextBeat()
        print(danger)
        if danger > 0.5 then
            MUSIC.Active = true
            MUSIC:PlayBeat()
        elseif MUSIC.Active and danger <= 0.5 then 
            MUSIC.Active = false 
        end
    end
end

function MUSIC:Tick() -- Every Frame
    for i, v in pairs (MUSIC.TickTasks) do
        if v.Chan and v.Chan:IsValid() then

        local removetask = MUSIC.TickTaskTypes[v.TaskType](v)
        if removetask then
            MUSIC.TickTasks[i] = nil
        end
        else MUSIC.TickTasks[i] = nil end
    end
    local track = MUSIC.ActiveTracks[GetKeyFromIndex(MUSIC.ActiveTracks, 1)]
    if track and not isnumber(track) and track:IsValid() then

        local dur = track:GetLength()
        local t = track:GetTime()

        if t >= dur - MUSIC.Info.BeatCutOff then
            MUSIC:PlayBeat()
        end
    end
end

local function HandleBeatChannel(chan, track)
    local prevchan = MUSIC.ActiveTracks[track]

    

    if prevchan then
        if not isnumber(prevchan) and prevchan:IsValid() then
            MUSIC.ActiveTracks[track]:EnableLooping(false)
        else 
            if MUSIC.PreviousBeat <= 0 then
                print('fadein')
                chan:SetVolume(0)
                MUSIC:AddTask(track .. '_mod', {Chan = chan, TaskType = 'Modulate', FV = 1, IV = chan:GetVolume(), Dur = 2, ST = CurTime()})
            end
        end
        MUSIC.ActiveTracks[track] = chan
        chan:EnableLooping(true)
        chan:Play()
    else
        chan:Play()
        MUSIC.ActiveTracks[track] = chan
        chan:EnableLooping(true)
    end
end

function MUSIC:CalculateNextBeat()
    local totaldanger = 0
    local mindist = 1048576
    for i, v in ipairs(player.GetAll()) do
        local opos = v:GetPos()
        local mypos = LocalPlayer():GetPos()
        local dist = mypos:DistToSqr(opos)
        if dist < mindist then

         totaldanger = totaldanger + (( (1 - (dist/mindist)) / player.GetCount() ) * 100)
        end
    end
    return totaldanger end

function MUSIC:PlayBeat()
    local calclevel = self:CalculateNextBeat()
    local calculatedbeat = math.Approach(MUSIC.PreviousBeat, math.Clamp(math.Round(math.Remap(calclevel, 0, 100, 0, MUSIC.MaxBeats)), 0, MUSIC.MaxBeats), MUSIC.Info.BeatMaxJump)

    if table.IsEmpty(MUSIC.ActiveTracks) then
        local e, r = table.Random(MUSIC.TrackInfos)
        MUSIC:AddTrack('track_piano', 0) -- We have to assign these some value other then nil or else they will cease to exist and no beats will play. When a number is put here, it means its waiting for a channel to use the track and currently none is using it.
        local e, r = table.Random(MUSIC.TrackInfos)
        MUSIC:AddTrack('track_zheng', 0)
        MUSIC:AddTrack('track_drums', 0)
        MUSIC:AddTrack('track_synth', 0)
        MUSIC:AddTrack('track_synthbass', 0)
        PrintTable(MUSIC.ActiveTracks)
        
    end
        for i, v in pairs(MUSIC.ActiveTracks) do
            local tracktbl = self.TrackInfos[i]
            if tracktbl.Beats[calculatedbeat] then
                local beat = tracktbl.Beats[calculatedbeat]
                local fullpath = self.Folder ..'/'..i.. '/' .. beat
                print(self.Folder ..'/'..i.. '/' .. beat)
                sound.PlayFile(fullpath, 'noblock, noplay', function(chan) 
                    HandleBeatChannel(chan, i) 
                    local keys = table.GetKeys(self.TrackInfos)
                    if GetKeyIndexFromTable(self.TrackInfos, i) == #keys then
                        MUSIC.PreviousBeat = calculatedbeat
                    end
                end)
            elseif not isnumber(v) and v:IsValid() then
                MUSIC.ActiveTracks[i]:EnableLooping(false)
            end
        end
end

function MUSIC:AddTrack(trackname, chan)
        local e, r = table.Random(MUSIC.TrackInfos)
        MUSIC.ActiveTracks[trackname] = chan
end

function MUSIC:RegisterInfo()
    local musicinfo = file.Find(self.Folder .. '/info.txt', 'GAME')
    local maxbeats = 0

    if musicinfo then
    local str = file.Read(self.Folder .. '/info.txt', 'GAME')
    self.Info = util.JSONToTable(str)
    end
    local files, dirs = file.Find(self.Folder .. '/*', 'GAME')
    for i, v in pairs(dirs) do
        local info = file.Find(self.Folder ..'/'..v.. '/info.txt', 'GAME')
        if info[1] then

            local infostring = file.Read(self.Folder ..'/'..v.. '/info.txt', 'GAME')
            local infotbl = util.JSONToTable(infostring)
            MUSIC.TrackInfos[v] = infotbl
        end
        local trackinfotbl = MUSIC.TrackInfos[v]
        for index, format in ipairs(MUSIC.Formats) do
            local beats = file.Find(self.Folder ..'/'.. v .. '/*' .. format, 'GAME')

            for n, b in ipairs(beats) do
                local beatnum = tonumber(string.Replace(b, format, '')) -- remove extension

                if trackinfotbl and trackinfotbl.Beats then
                    trackinfotbl['Beats'][beatnum] = b
                    else
                        trackinfotbl['Beats'] = {beatnum = b}
                end

                if beatnum > maxbeats then
                maxbeats = beatnum
                end
            end
        end
    end
    MUSIC.MaxBeats = maxbeats
end

function MUSIC:SetMusic(folder, fade)
    if file.IsDir('sound/retroteamplay/music/' .. folder, 'GAME') then
        MUSIC.Folder = 'sound/retroteamplay/music/' .. folder
        print('MUSIC: NOW PLAYING "'..folder..'"')
        self:RegisterInfo()
        if timer.Exists('Music_Think') then
            timer.Adjust('Music_Think', 2, 0, MUSIC.Think)
        else timer.Create('Music_Think', 2, 0, MUSIC.Think)
        end
    else 
        print('FAILED TO FIND SELECTED MUSIC IN' .. 'sound/retroteamplay/music' .. folder)
    end
end

function MUSIC:AddTask(taskname, data)
    MUSIC.TickTasks[taskname] = data
end


--------------------------------------------------------------------------------------------------------

local function Music_Modulate(data)
    local chan = data.Chan -- Channel
    local InitVol = data.IV
    local FinalVol = data.FV -- Final Volume
    local dur = data.Dur -- Duration
    local st = data.ST -- Start Time

    local diff = FinalVol - InitVol
    if chan and chan:IsValid() then
    chan:SetVolume(math.Clamp(InitVol + (diff * math.Clamp((CurTime() - st) / dur, 0, 1)), 0, 2)) -- Gonna put a clamp on this cause im not risking blowing my fucking ears out.
    else return true end
end

MUSIC.TickTaskTypes = {
    ['Modulate'] = Music_Modulate
}

--]]
