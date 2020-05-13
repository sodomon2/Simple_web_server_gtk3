#!/usr/bin/env lua5.1
--[[!
 @package   Simple Web Server gtk3
 @filename  swsgtk3.lua
 @version   1.3
 @autor     Diaz Urbaneja Victor Eduardo Diex    <diaz.victor@openmailbox.org> 2018
 @autor     Díaz Urbaneja Víctor Diex Gamar      <Sirkennov@outlook.com> 2018
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com> 2020
 @date      29.04.2020 17:55:00 -04
]]--


local lgi     = require 'lgi'               -- La libreria que me permitira usar GTK
local GObject = lgi.GObject                 -- Parte de lgi
local GLib    = lgi.GLib                    -- para el treeview
local Gtk     = lgi.require('Gtk', '3.0')   -- El objeto GTK

local assert  = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file('simple_web_server.ui'))
local ui = builder.objects
local window_main = ui.window_main  --la vetana del main

local app_run = false

--que hacer cuando le den cerrar a la ventana del login
function window_main:on_destroy()
	Gtk.main_quit()
	os.execute('killall -9 simple_web_server')
end

local compartir = builder:get_object('compartir')       -- este seria el boton de compartir
local info      = builder:get_object('info')            -- este seria el label de informacion
local about     = builder:get_object('about')           -- este seria el boton de about
local selec     = builder:get_object('selec')           -- este seria el input de seleccionar directorio
local port      = builder:get_object('port')            -- este seria el input de port

local input_select = builder:get_object('input_select') -- este seria el selector de directorios


function compartir:on_clicked()
	condition = true
	numero = 0
	
	print(selec:get_filename(), port.text, input_select:get_active_id())
	local pwd = selec:get_filename()
	if pwd and app_run == false then
		info.label = "Ejecutando"
		local cmd = "/usr/bin/simple_web_server -p  ".. port.text .." -r  ".. pwd .."  &"
		os.execute(cmd)
		app_run = true
		
	else
		info.label = "Sin ejecutar"
	end
end

local cancel = builder:get_object('cancel') --este seria el boton de cancelar

function cancel:on_clicked()
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
