#!/usr/bin/env ruby
########################################################################
##           smssend.rb  - Script per l'invio di SMS
##                 Copyright (C) 2005  Alessio Caiazza
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##                 (at your option) any later version.
##
##   This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##             GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##     along with this program; if not, write to the Free Software
##            Foundation, Inc., 59 Temple Place - Suite 330,
##                     Boston, MA 02111-1307, USA.
########################################################################
##   Alessio Caiazza <nolith at gmail dot com>
########################################################################



#include tutti i moduli
`ls -1 scripts/*.rb`.split("\n").each { |mod| require mod }
require 'rexml/document'
include REXML

class Config
  def initialize(filepath)
    f= File.open(File.expand_path(filepath))
    @conf = Document.new(f)
    f.close
    ckConf
  end

  def serviceList()
    res = {}
    @conf.elements.each("config/service") do |service| 
      res[service.attributes['name']] = service.attributes['module'] 
    end
    return res
  end

  def getService(name)
    #locate config in XML
    xmlService = @conf.elements["config/service[@name='#{name}']"]
    modName = xmlService.attributes['module']
    #try loading module
    ########MODULE LOADED ON START
    #begin
    #  require "scripts/#{modName}"
    #rescue LoadError
    #  STDERR.print "errore nel caricare il modulo #{modName}\n"
    #  return nil
    #end
    service = nil
    #TODO:replace with a serius allocation system
    begin
      #service = Tim.new if name.eql?('tim')
      #service = Vodafone.new if name.eql?('vodafone')
      service = eval(modName.capitalize).new
    rescue NameError
      STDERR.print "errore nell'istanziare #{modName.capitalize}\n"
      return nil
    end
    return nil unless service

    #retrive config param 
    conf = [];
    xmlService.elements.each { |param| conf |= [param.text] }
    #setting up service
    service.setup(*conf)
    return service
  end
 
  def ckConf    #TODO: complete this check
    #check
  end

  private :ckConf
end      

ConfPath = "~/.smssend.conf"
$conf = nil



def header
  puts "smsend.rb Copyright (c) 2005 Alessio Caiazza - Released under GPL v2"
  puts "smssend.rb comes with ABSOLUTELY NO WARRANTY; for details refer to GPL v2"
  puts "Default confPath is #{ConfPath}"
  puts "---"
  puts ""
  puts ""
end

def help
  puts "l - lista servizi SMS"
  puts "a - aggiungi servizio"
  puts "s - invia SMS"
  puts "? - help"
  puts "e - Esci"
  puts ""
end

def prompt
  header
  help
  print "?>"
  gets
end

def send
  list = $conf.serviceList
  puts "Seleziona il servizio"
  i = 0
  map = []
  list.each_pair do |name, service| 
    puts "#{i})#{name} -> #{service}"
    map[i] = name
  end
  print "--\nServizio?>"
  s = gets
  service = $conf.getService(map[s.to_i])
  if service != nil
    print "A: "
    dest = gets
    print "Da(potrebbe essere ignorato):"
    from = gets
    puts "Msg:"
    msg = gets
    puts "Invio in corso..."
    service.send(msg, dest[(0..(dest.length-2))], from[(0..(from.length-2))])
  else
    puts "Errore nel caricare il servizio"
  end
end

def execute(param)
  case param
    when "l\n"
    list = $conf.serviceList
    list.each_pair { |name, service| puts "#{name} -> #{service}" }
    when "a\n"
    puts "Not Yet Implemented"
    when "s\n"
    send
    when "?\n"
    else
    puts "Opzione non disponibile"
  end
  puts "premi un tasto per continuare"
  gets
end

def main
  msgricarica = "Beta 2, ritardi in Vista
Xbox 360, ecco i titoli retrocompatibili
Micro-sistemi eolici per kit wireless
Tre cerottoni per i player Real
Primo trojan buca-GDI?
Il DRM della nuova telefonia VodafoneBeta 2, ritardi in Vista
Xbox 360, ecco i titoli retrocompatibili
Micro-sistemi eolici per kit wireless
Tre cerottoni per i player Real
Primo trojan buca-GDI?mi eolici per kit wireless
Tre cerottoni per i player Real
Primo trojan buca-GDI?
Il DRM della nuova telefonia Vodafone"
  #t.send(msg, "3405080686", nil)
  #TODO: implementare l'utilizzo di parametri
  
  $conf = Config.new(ConfPath)
  while ( not (r = prompt).eql?("e\n") ) do
    execute(r)
  end
end

main
