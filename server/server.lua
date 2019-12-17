local serverdata = {}
serverdata.Stocks = {}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[    Send to client    ]]
function refreshclients()
    local data = json.encode(serverdata)
    TriggerClientEvent('esx_stock:currentstocks',-1,data)
end

--[[    Transaction    ]]
RegisterServerEvent('esx_stock:transactionstock')
AddEventHandler('esx_stock:transactionstock', function(name, value, amount, state)
    local cost, mathvalue, mathamount, sum = 0, 0, 0, 0 
    local xPlayer = ESX.GetPlayerFromId(source)
    local assets = xPlayer.getInventoryItem('proof_assets').count
    local purchase = xPlayer.getInventoryItem('proof_purchase').count
    local stock = xPlayer.getInventoryItem('stock').count
    local price = (value * amount) * 100
    cost = xPlayer.getAccount('bank').money
    if assets ~= 1 then
        TriggerClientEvent('esx:showNotification', source, '你~r~未持有~g~資產證明書~w~! 請洽~b~相關單位~w~申請取得')
    elseif state == true then
        if cost < price then
            TriggerClientEvent('esx:showNotification', source, '你的~g~銀行~w~沒有~r~足夠~w~的錢!')
        else
            xPlayer.removeAccountMoney('bank', price)
            if purchase == 0 then
                xPlayer.addInventoryItem('proof_purchase', value)
            elseif purchase < value then
                sum = value - purchase
                xPlayer.addInventoryItem('proof_purchase', sum)
            elseif purchase > value then
                sum = purchase - value
                xPlayer.removeInventoryItem('proof_purchase', sum)
            else
                xPlayer.addInventoryItem('proof_purchase', 0)
            end
            xPlayer.addInventoryItem('stock', amount)
            TriggerClientEvent('chatMessage', -1, '購買通知', {0,255,0}, '你購買了^5名稱: ^7' .. name .. ' 單價 ^2$: ' .. value .. ' ^7張數: ^4' .. amount .. ' ^7總計 ^2$:' .. price)
            sendToDiscord(StockWeb, StockWebName, GetPlayerName(source) .. ' 購買了名稱: ' .. name .. ' 單價 $: ' .. value .. ' 張數: ' .. amount .. ' 總計 $: ' .. price, 32768)           
        end
    elseif state == false then
        if stock == 0 then
            TriggerClientEvent('esx:showNotification', source, '你~r~未持有~w~該股份')
        elseif stock < amount then
            TriggerClientEvent('esx:showNotification', source, '你身上未持有~r~足夠~w~的股票~g~張數')
        else
            xPlayer.addAccountMoney('bank', price)
            TriggerClientEvent('chatMessage', -1, '販售通知', {0,255,0}, '你販售了^5名稱: ^7' .. name .. ' 單價 ^2$: ' .. value .. ' ^7張數: ^4' .. amount .. ' ^7總計 ^2$:' .. price)
            sendToDiscord(StockWeb, StockWebName, GetPlayerName(source) .. ' 購買了名稱: ' .. name .. ' 單價 $: ' .. value .. ' 張數: ' .. amount .. ' 總計 $: ' .. price, 16711680)
            xPlayer.removeInventoryItem('stock', amount)
            xPlayer.removeInventoryItem('proof_purchase', purchase)
        end
    end
end)

-- xPlayer.removeInventoryItem('proof_purchase', 1)
-- xPlayer.addInventoryItem('stock', 1)

--[[    Ramdom stocks value    ]]
function randomstockvalue()
    for i=1, #serverdata.Stocks, 1 do
        local stockchange = 0
        local randomint = math.random(0,2)
        local randomfloat = math.random(0,99) / 100
        local double = randomint + randomfloat
        local stock = serverdata.Stocks[i]
        local stockname = stock.name
        local stockvalue = stock.value

        local randomnum = math.random(1,3)
        if randomnum == 1 then
            stockchange = stockvalue - double
        elseif randomnum == 2 then
            stockchange = stockvalue
        elseif randomnum == 3 then
            stockchange = stockvalue + double
        end
        if stockchange < 0 then
            stockchange = 0
        end
        serverdata.Stocks[i].value = stockchange
        Wait(1)
    end
    refreshclients()
end

Citizen.CreateThread(function()
    serverdata = Config
    while true do
        Citizen.Wait(60*1000)
        local clock = GetClockHours()
        local day = GetClockDayOfWeek()
        if day >= 1 and day <= 5 then
            if clock >= 9 and clock <=12 then
                randomstockvalue()
            end
        end
    end
end)

function sendToDiscord(WebHook, Name, Message, color)
	local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. Name .."**",
            ["description"] = Message,
            ["footer"] = {
                ["text"] = "",
            },
        }
    }
	PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, embeds = connect}), {['Content-Type'] = 'application/json'})
end

--Cmd info
print("####################\n")
print("Have any problem can send message to Discord:Azusakawa *#8628")
print("Have fun !\n")
print("####################")