#!/usr/bin/env ruby
#
# This file is gererated by ruby-glade-create-template 1.1.1.
#
require 'libglade2'

# Support L10n (Requires RAA:Ruby-GetText-Package)
begin
  require 'gettext'
rescue LoadError
  unless defined? GetText
    module GetText
      module_function
      def _(msgid); msgid; end
      def N_(msgid); msgid; end
      def n_(msgid, msgid_plural, n)
	msgid
      end
      def s_(msgid, div = '|')
	if index = msgid.rindex(div)
	  msgid = msgid[(index + 1)..-1]
	else
	  msgid
	end
      end
      def bindtextdomain(domainname, path = nil, locale = nil, charset = nil)
      end
    end
  end
end

class SmssendGlade
  include GetText
  
  def initialize(path_or_data, root = nil, domain = nil, localedir = nil, flag = GladeXML::FILE)
    GetText.bindtextdomain(domain, localedir, nil, "UTF-8")
    @glade = GladeXML.new(path_or_data, root, domain, localedir, flag) {|handler| method(handler)}
    
    require 'services/vodafone.rb'
    @vodafone = Vodafone.new
    @vodafone.setup({"user"=>"nolith", "pass"=>"vampir0"})
  end
  
  def on_btSend_clicked(widget)
    puts "on_btSend_clicked() is not implemented yet."
    #bt = @glade.get_widget("btSend")
    #puts @glade.widget_names
    puts @vodafone.send(@glade.get_widget('msg').buffer.text,@glade.get_widget('to').text, nil) 
  end
  def on_btAnnulla_clicked(widget)
    puts "on_btAnnulla_clicked() is not implemented yet."
  end
  def quit(widget)
    Gtk.main_quit
  end
  def delete_event(widget, arg0)
    false
  end
  def destroy(widget)
    Gtk.main_quit
  end
  def notImplemented(widget)
    puts "notImplemented() is not implemented yet."
  end
end

# Main program
if __FILE__ == $0
  # Set values as your own application. 
  PROG_PATH = "smssend.glade"
  PROG_NAME = "SMS Send"
  Gtk.init
  SmssendGlade.new(PROG_PATH, nil, PROG_NAME)
  Gtk.main
end
