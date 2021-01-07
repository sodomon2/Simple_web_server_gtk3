#!/usr/bin/env lua5.1
--[[!
 @package   Simple Web Server gtk3
 @filename  swsgtk3.lua
 @version   2.0
 @autor     Diaz Urbaneja Victor Eduardo Diex    <diaz.victor@openmailbox.org> 2018
 @autor     Díaz Urbaneja Víctor Diex Gamar      <Sirkennov@outlook.com> 2018
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com> 2020-2021
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
local app_run = false

--que hacer cuando le den cerrar a la ventana del login
function ui.window_main:on_destroy()
	Gtk.main_quit()
	os.execute('killall -9 simple_web_server')
end

function ui.compartir:on_clicked()
	condition = true
	numero = 0
	
	print(ui.selec:get_filename(), ui.port.text, ui.input_select:get_active_id())
	local pwd = ui.selec:get_filename()
	if pwd and app_run == false then
		ui.info.label = "Running"
		local cmd = "/usr/bin/simple_web_server -p  ".. ui.port.text .." -r  ".. pwd .."  &"
		os.execute(cmd)
		app_run = true
		
	else
		ui.info.label = "Error"
	end
end

function ui.cancel:on_clicked()
	os.execute('killall -9 simple_web_server')
	ui.info.label = ""
	app_run = false

end  

function ui.about:on_clicked()
	ui.window_about:run()
	ui.window_about:hide()
end

ui.window_main:show_all()
Gtk.main()
