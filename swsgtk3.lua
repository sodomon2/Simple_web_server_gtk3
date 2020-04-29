#!/usr/bin/env lua5.1
--[[!
 @package   Simple Web Server gtk3
 @filename  main.lua
 @version   1.0
 @autor     Diaz Urbaneja Victor Eduardo Diex <diaz.victor@openmailbox.org>
 @date      16.06.2018 17:55:00 -04
]]--


local lgi = require 'lgi'             -- La libreria que me permitirausar GTK
local GObject = lgi.GObject           -- Parte de lgi
local GLib = lgi.GLib                 -- para el treeview
local Gtk = lgi.require('Gtk', '3.0') -- El objeto GTK

local assert = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file('simple_web_server.ui'))
local ui = builder.objects
local window_main = ui.window_main --la vetana del main

local app_run = false

--que hacer cuando le den cerrar a la ventana del login
function window_main:on_destroy()
	Gtk.main_quit()
	os.execute('killall -9 simple_web_server')
end

local compartir = builder:get_object('compartir') --este seria el boton de compartir
local info = builder:get_object('info')           --este seria el label de informacion
local about = builder:get_object('about')         --este seria el boton de about
local selec = builder:get_object('selec')         --este seria el input de seleccionar directorio
local port = builder:get_object('port')           --este seria el input de port

local input_select = builder:get_object('input_select')

-- for id, text in pairs {
	-- never = "Not visible",
	-- when_active = "Visible when active",
	-- always = "Always visible",
	-- } do
	-- input_select:append(id, text)
-- end

function compartir:on_clicked()
	condition = true
	numero = 0
	
	-- input_select:append(40, 40)
	print(selec:get_filename(), port.text, input_select:get_active_id())
	local pwd = selec:get_filename()
	if pwd and app_run == false then
		info.label = "Ejecutando"
		local cmd = "/usr/bin/simple_web_server -p  ".. port.text .." -r  ".. pwd .."  &"
		os.execute(cmd)
		app_run = true
		
		-- while (condition) do
			-- numero = (numero +1)
			-- os.execute("sleep 1")
			-- print(numero)
			-- if (numero >= 10) then
				-- condition = false
				-- os.execute('killall -9 simple_web_server')
			-- end
		-- end
		
	else
		info.label = "Sin ejecutar"
	end
end

--este seria el boton de cancelar
local cancel = builder:get_object('cancel') 
function cancel:on_clicked()
	-- Gtk.main_quit()
	os.execute('killall -9 simple_web_server')
	info.label = ""
	app_run = false
end  

function about:on_clicked()
	ui.window_about:run()
	ui.window_about:hide()
end  

window_main:show_all()
Gtk.main()
