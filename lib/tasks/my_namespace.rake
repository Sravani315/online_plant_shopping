namespace :my_namespace do
  desc "TODO"
  task html_parse: :environment do
    require 'nokogiri'
    require 'open-uri'

    def create_product(sub_category_data,url)
      sub_category_data.css('.product-box').each do |product|
        product_obj = Product.new
        product_data = Nokogiri::HTML(open(url+product.css('a')[0]['href']))
        product_obj.image = product_data.css('#image-box img')[0]['src']
        product_obj.name = product_data.css('h2')&.text
        product_obj.cost = product_data.css('h4')[2]&.text&.sub!("â\u0082¹", "")
        product_obj.about_product = product_data.css('p span')[0]&.children&.map(&:text)&.reject(&:empty?)&.
                        map{|l| l.gsub("â\u0080\u0093","-")}
        product_obj.benifits = product_data.css('li span')&.map(&:text)&.reject(&:empty?)
        product_obj.category_id = @category_obj.id
        product_obj.product_type_id = @product_type.id
        product_obj.save! 
      end
    end

    url = 'https://www.planaplant.com'
    doc = Nokogiri::HTML(open(url))
    # product_types = doc.css('ul.nav.navbar-nav').css('li.dropdown a.dropdown-toggle').map(&:text)
    # binding.pry
    data = doc.css('ul.nav.navbar-nav').
      css('li.dropdown').map{ |list| 
        [ list.css('a.dropdown-toggle').text, 
          list.css('ul.dropdown-menu').css('li').map{|link| [link.text, link.css('a')[0]['href']]}#, 
          #list.css('ul.dropdown-menu').css('li a').map{ |link| link['href']} 
        ]
      }.select{|d| [d[0], d[1].shift] }
    # data=[["Plants",[["Air Plants", "/categories/air-plants"]]]]
    data.each do |category|
      @product_type = ProductType.create!(name: category[0])
      category[1].each do |sub_category|
        @category_obj = Category.create!(name: sub_category[0], product_type_id: @product_type.id)
        pagination_data =  Nokogiri::HTML(open(url+sub_category[1])) 
        if pagination_data.css('ul.pagination li a').present? 
          pagination_data.css('ul.pagination li a').map{|link| link['href']}.uniq.each do |link|
            sub_category_data =  link == '#' ? pagination_data : Nokogiri::HTML(open(url+link))
            create_product(sub_category_data,url)
          end
        else
          create_product(pagination_data,url)
        end
      end
    end
  end
end

