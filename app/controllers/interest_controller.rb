require 'vpim/vcard'

class InterestController < ApplicationController
  def index; end
  def curriculum; end
  def employer; end

  def vcard
    card = Vpim::Vcard::Maker.make2 do |maker|
      maker.name do |name|
        name.given = 'Klaus Peter'
        name.family = 'Schröder'
      end
      maker.add_addr do |addr|
        addr.street = 'Tigerstr. 32'
        addr.postalcode = '22525'
        addr.locality = 'Hamburg'
        addr.country = 'Deutschland'
      end
      maker.nickname = "phoet"
      maker.birthday = Date.new(1980, 8, 27)
      maker.add_photo { |photo| photo.link = 'http://www.gravatar.com/avatar/056c32203f8017f075ac060069823b66.png' }
      maker.add_tel('+491781391035')
      maker.add_email('ps@nofail.de')
    end

    send_data card.to_s, filename: 'peter_schroeder.vcf'
  end
end
