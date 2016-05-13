require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata < Module
  # Your code goes here!
  @@id_idx = 0
  @@brand_idx = 1
  @@name_idx = 2
  @@price_idx = 3

  def self.is_title_data( data )
    data[@@id_idx] == "id"
  end

  def self.create( attributes = nil )
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"

    data_base = CSV.read( @data_path )

    # If the object's data is already in the database
    # create the object
    # return the object
    exsit_data = data_base.find{ |item| item[0] == attributes[:id] }
    if( exsit_data != nil )
      return Product.new( attributes )
    end

    # If the object's data is not in the database
    # create the object
    # save the data in the database
    # return the object
    product = Product.new( attributes )

    CSV.open(@data_path, "a+") do |csv|
      csv << [ product.id, attributes[:brand], attributes[:name], attributes[:price] ]
    end

    return product

  end


  def self.first( num = nil)
    file = File.dirname(__FILE__) + "/../data/data.csv"

    if( num != nil )
      data = File.exist?(file) ? CSV.read(file).drop(1).first(num) : nil

      if( data.empty? )
        return nil
      end

      data.map!{ |d| Product.new( id: d[@@id_idx],price: d[@@price_idx],
                                  brand: d[@@brand_idx],name: d[@@name_idx] )
               }

    else
      data = File.exist?(file) ? CSV.read(file).drop(1).first : nil

      if( data == nil )
        return nil
      end

      Product.new( id: data[@@id_idx],
                                    price: data[@@price_idx],
                                    brand: data[@@brand_idx],
                                    name: data[@@name_idx] )
    end
  end

  def self.last( num = nil)
    file = File.dirname(__FILE__) + "/../data/data.csv"

    if( num != nil )
      data = File.exist?(file) ? CSV.read(file).drop(1).last(num) : nil

      if( data.empty? )
        return nil
      end

      data.map!{ |d| Product.new( id: d[@@id_idx],price: d[@@price_idx],
                                  brand: d[@@brand_idx],name: d[@@name_idx] )
               }

    else
      data = File.exist?(file) ? CSV.read(file).drop(1).last : nil

      if( data == nil )
        return nil
      end

      Product.new( id: data[@@id_idx],
                                    price: data[@@price_idx],
                                    brand: data[@@brand_idx],
                                    name: data[@@name_idx] )
    end
  end

  def self.find( id )
    file = File.dirname(__FILE__) + "/../data/data.csv"
    data = File.exist?(file) ? CSV.read(file).drop(1).find{ |item| item[0].to_i == id } : nil

    if( data == nil )
      raise ProductNotFoundError, "Cannot find this item"
    end
    Product.new( id: data[@@id_idx],
                                  price: data[@@price_idx],
                                  brand: data[@@brand_idx],
                                  name: data[@@name_idx] )

  end

  def self.reset_file()
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    CSV.open(@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
    end
  end

  def self.destroy( id )
    file = File.dirname(__FILE__) + "/../data/data.csv"

    data_base = File.exist?(file) ? CSV.read(file).drop(1) : nil
    if( data_base == nil )
      return nil
    end


    #deleted_data = data_base.find{ |item| item[0].to_i == id }
    #if( deleted_data == nil )
    #  raise ProductNotFoundError, "Cannot find this item"
    #end

    deleted_data = find_by_id( id.to_s )
    datas = data_base.select{ |item| item[0].to_i != id }

    reset_file

    datas.each do |data|
      create( brand: data[@@brand_idx],name: data[@@name_idx] )
    end

    deleted_data
    #Product.new( id: deleted_data[@@id_idx],
    #                              price: deleted_data[@@price_idx],
    #                              brand: deleted_data[@@brand_idx],
    #                              name: deleted_data[@@name_idx] )
  end

=begin
  def self.find_by_brand( brand )
    file = File.dirname(__FILE__) + "/../data/data.csv"

    data_base = File.exist?(file) ? CSV.read(file).drop(1) : nil
    if( data_base == nil )
      return nil
    end

    data = data_base.find{ |item| item[@@brand_idx] == brand }

    Product.new( id: data[@@id_idx],
                                  price: data[@@price_idx],
                                  brand: data[@@brand_idx],
                                  name: data[@@name_idx] )
  end
=end

  def self.find_by_name( name )
    file = File.dirname(__FILE__) + "/../data/data.csv"

    data_base = File.exist?(file) ? CSV.read(file).drop(1) : nil
    if( data_base == nil )
      return nil
    end

    data = data_base.find{ |item| item[@@name_idx] == name }

    Product.new( id: data[@@id_idx],
                                  price: data[@@price_idx],
                                  brand: data[@@brand_idx],
                                  name: data[@@name_idx] )
  end

  def self.where( options={} )
    file = File.dirname(__FILE__) + "/../data/data.csv"

    data_base = File.exist?(file) ? CSV.read(file).drop(1) : nil
    if( data_base == nil )
      return nil
    end

    datas = data_base.find_all do |item|
      if( ( options[:name] != nil ) && ( options[:brand] != nil ) )
        item[@@name_idx] == options[:name]
        item[@@brand_idx] == options[:brand]
      elsif ( options[:name] != nil )
        item[@@name_idx] == options[:name]
      elsif ( options[:brand] != nil )
        item[@@brand_idx] == options[:brand]
      end
    end

    datas.map!{ |d| Product.new( id: d[@@id_idx],price: d[@@price_idx],
                                brand: d[@@brand_idx],name: d[@@name_idx] )}
  end

  def self.all
    product_array = Array.new

    data_path = File.dirname(__FILE__) + "/../data/data.csv"
    data_base = CSV.read( data_path )
    data_base.each do |data|
      if( false == is_title_data(data) )
        product_array << Product.new( id: data[@@id_idx],
                                      price: data[@@price_idx],
                                      brand: data[@@brand_idx],
                                      name: data[@@name_idx] )
      end
    end

    product_array
  end

  def update( options = {} )
  #Product.create( options )
  products = Product.all
  product = products.find { |product| product.id == @id }

  if( product == nil )
    return nil
  end

  if( options[:price] != nil)
    product.price = options[:price]
  end

  if( options[:brand] != nil )
    product.brand = options[:brand]
  end

  Product.reset_file

  products.each do |product|
    Product.create( price: product.price, brand: product.brand, name: product.name )
  end

  product
end

end
