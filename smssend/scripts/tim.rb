########################################################################
##           tim.rb  - Script per l'invio di SMS tramite www.tim.it
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
require 'http-access2'
require 'uri'

class Tim 

  def initialize
    @setup = false
    @user = ""
    @pass = ""

    proxy = ENV['HTTP_PROXY']
    @clnt = HTTPAccess2::Client.new(proxy)
    @clnt.set_cookie_store("cookie.dat")
  end

  def setup(user, pass)
    @user = user
    @pass = pass
    @setup = true
  end

  
  def send(msg, to, from)
    return "Eseguire setup" if @setup == false
    target = "http://webmail.posta.tim.it/login"
    header = { "User-agent" => "Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)" }
    
    #pagine iniziale (per login)
    header["Referer"] = "http://webmail.posta.tim.it/login?servizio=SMS"
    
  
    #effettuare login
    login = { "servizio" => "mail", 
      "sottoservizio" => "mail" ,
      "useWhiteList" => "0",
      "msisdn" => @user,
      "password" => @pass }
    
    @clnt.post("http://webmail.posta.tim.it/login", login, header )  
    
    header["Referer"] = "ttp://webmail.posta.tim.it/ewsms/jsp/it_IT-TIM-UM/mainSMS.jsp?tipo=extended&locale=it_IT-TIM-UM"
    @clnt.get("http://webmail.posta.tim.it/ews/jsp/it_IT-TIM-UM/jsp/SMS/composerSMS.jsp?msisdn=#{@user}&locale=it_IT-TIM-UM", header)
  
    from = "" unless from
    header["Referer"] = "http://webmail.posta.tim.it/ews/jsp/it_IT-TIM-UM/jsp/SMS/composerSMS.jsp?msisdn=#{@user}&locale=it_IT-TIM-UM HTTP/1.1"


    req =  @clnt.post("http://webmail.posta.tim.it/ews/jsp/it_IT-TIM-UM/jsp/SMS/sendSMS2.jsp", { "msisdn" => @user, "DEST" => to, "SENDER" => "", "chr" => "25" , "SHORT_MESSAGE" => URI.encode(msg)}, header)

    res = "Impossibile stabilire l'esito"

    #f = File.open("out.html","w")
    #f.write(req.content)
    #f.close
    idx = req.content =~ /<font face=Verdana size=1 color=#0a256a><b>/

    if (idx != nil)
      stop = req.content[idx+43,50] =~ /<\/b>/
      stop = 30 unless stop     #test x evitare la corruzione
      res = req.content[idx+43,stop]
    end

    @clnt.reset(target)

    @clnt.save_cookie_store
    
    return res 
  end

  def remain
    #TENTATIVO DI IMPLEMENTAZIONE FALLITO
    #remainpath = /var smsRimasti = \d+/
    #composer = login().content
    #p composer
    #where = composer =~ remainpath
    #return nil if where == nil
    #return composer[where+17,3].to_i
    false
  end

end



