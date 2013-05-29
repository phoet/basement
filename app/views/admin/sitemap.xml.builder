xml.instruct!

xml.urlset :xmlns=>"http://www.sitemaps.org/schemas/sitemap/0.9", :'xmlns:xsi'=>"http://www.w3.org/2001/XMLSchema-instance", :'xsi:schemaLocation'=>"http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" do
  menuitems.each do |sub|
    xml.url do
      xml.loc "http://#{request.host}/#{sub}/"
      xml.changefreq "always"
    end
  end
end