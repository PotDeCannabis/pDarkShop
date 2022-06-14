ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

-- Liquide

RegisterNetEvent("pDarkShop:achatliquide") 
AddEventHandler("pDarkShop:achatliquide", function(Model, Prix) 
	local joueur = ESX.GetPlayerFromId(source)  
	local argent = joueur.getMoney()

	if argent >= Prix then 
		joueur.removeMoney(Prix) 

		joueur.addInventoryItem(Model, 1) 
		TriggerClientEvent('esx:showNotification', source, "Vous avez acheter un ~y~produit ~s~pour ~y~" ..Prix.. "$~s~.")
	else 
		TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas assez d'argent.")
	end
end)