module Analyzable
  # Your code goes here!
=begin
  def count_by_brand( products )
    tbl = Hash.new

    products.each do |product|
      brand = product.brand

      if( tbl.has_key?( brand ) )
        tbl[brand] += 1
      else
        tbl[brand] = 1
      end
    end
    tbl
  end

  def count_by_name( products )
    tbl = Hash.new

    products.each do |product|
      name = product.name

      if( tbl.has_key?( name ) )
        tbl[name] += 1
      else
        tbl[name] = 1
      end
    end
    tbl
  end
=end

  def print_report( products )
    tbl_by_brand = count_by_brand( products )
    tbl_by_name = count_by_name( products )

    puts "average Price: $" + average_price( products ).to_s

    puts "Inventory by Brand:"
    #puts tbl_by_brand
    tbl_by_brand.each do |k,v|
      puts k.to_s + ":" + v.to_s
    end

    puts ""

    puts "Inventory by Name:"
    #puts tbl_by_name
    tbl_by_name.each do |k,v|
      puts k.to_s + ":" + v.to_s
    end

    ""
  end

  def average_price( products )
    num = products.length
    total_price = products.inject(0) { |total_price, product| total_price + product.price.to_f }

    ( total_price / num ).round(2)
  end

  ###################################################
  def self.gen_count_methods( *categories )
    categories.each do |category|
      count_method = %Q{
        def count_by_#{category}( products )

          tbl = Hash.new

          products.each do |product|
            #{category} = product.#{category}

            if( tbl.has_key?( #{category} ) )
              tbl[#{category}] += 1
            else
              tbl[#{category}] = 1
            end
          end
          tbl

        end
      }

      module_eval( count_method )
    end
  end
  ###################################################

end

Analyzable.gen_count_methods( "name", "brand" )
