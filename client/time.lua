local month, DayOfMonth, DayOfWeek, hour, minute, second

--[[    Show Text   ]]
function DrawTxt(text, x, y)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.3, 0.3)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

--[[    Display Time    ]]
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local clock = GetClockHours()
        local day = GetClockDayOfWeek()
        if day >= 1 and day <= 5 then
            if clock >= 9 and clock <=12 then
                DrawTxt("~y~Stock Market ~w~: ~g~Open", 0.7, 0.02)
            else
                DrawTxt("~y~Stock Market ~w~: ~r~Close", 0.7, 0.02)
            end
        else
            DrawTxt("~y~Stock Market ~w~: ~r~Close", 0.7, 0.02)
        end
        DisplayTime()
        DrawTxt(month .." / ".. DayOfMonth .." | ".. hour ..":".. minute .." | ".. DayOfWeek, 0.7, 0.0)
    end
end)

--[[    Hour Minute Second    ]]
function DisplayTime()
	hour = GetClockHours()
    minute = GetClockMinutes()
    second = GetClockSeconds()
    DayOfWeek = GetClockDayOfWeek()
    month = GetClockMonth()
	DayOfMonth = GetClockDayOfMonth()

    -- if hour == 0 or hour == 24 then
    --     hour = 12 
    -- elseif hour >= 13 then
    --     hour = hour - 12 
    -- end

	if hour <= 9 then
		hour = "0" .. hour
	end
	if minute <= 9 then
		minute = "0" .. minute
    end
--[[    Date    ]]
	if DayOfWeek == 1 then
		DayOfWeek = "Monday"
	elseif DayOfWeek == 2 then
		DayOfWeek = "Tuesday"
	elseif DayOfWeek == 3 then
		DayOfWeek = "Wednesday"
	elseif DayOfWeek == 4 then
		DayOfWeek = "Thursday"
	elseif DayOfWeek == 5 then
		DayOfWeek = "Friday"
	elseif DayOfWeek == 6 then
		DayOfWeek = "Saturday"
	else 
		DayOfWeek = "Sunday"
    end
--[[    Year Month Date    ]]
	if month == 0 then
		month = "January"
	elseif month == 1 then
		month = "February"
	elseif month == 2 then
		month = "March"
	elseif month == 3 then
		month = "April"
	elseif month == 4 then
		month = "May"
	elseif month == 5 then
		month = "June"
	elseif month == 6 then
		month = "July"
	elseif month == 7 then
		month = "August"
	elseif month == 8 then
		month = "September"
	elseif month == 9 then
		month = "October"
	elseif month == 10 then
		month = "November"
	elseif month == 11 then
		month = "December"
    end
end