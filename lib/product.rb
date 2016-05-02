require_relative 'udacidata'

class Product < Udacidata
  attr_accessor :id, :price, :brand, :name

  @@id_idx = 0
  @@brand_idx = 1
  @@name_idx = 2
  @@price_idx = 3

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

  def to_s
    "id:" + @id.to_s + " price:" + @price.to_s + "brand: " + @brand.to_s + "name : " + @name.to_s
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

    Product.new( id: data[@@id_idx],
                                  price: data[@@price_idx],
                                  brand: data[@@brand_idx],
                                  name: data[@@name_idx] )

  end

  def self.destroy( id )
    file = File.dirname(__FILE__) + "/../data/data.csv"

    data_base = File.exist?(file) ? CSV.read(file).drop(1) : nil
    if( data_base == nil )
      return nil
    end

    deleted_data = data_base.find{ |item| item[0].to_i == id }
    datas = data_base.select{ |item| item[0].to_i != id }

    #@data_path = File.dirname(__FILE__) + "/../data/data.csv"
    #CSV.open(@data_path, "wb") do |csv|
    #  csv << ["id", "brand", "product", "price"]
    #end

    datas.each do |data|
      create( price: data[@@price_idx],brand: data[@@brand_idx],name: data[@@name_idx] )
    end

    Product.new( id: deleted_data[@@id_idx],
                                  price: deleted_data[@@price_idx],
                                  brand: deleted_data[@@brand_idx],
                                  name: deleted_data[@@name_idx] )
  end

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
      if( options[:name] != nil )
        item[@@name_idx] == options[:name]
      end

      if( options[:brand] != nil )
        item[@@brand_idx] == options[:brand]
      end
    end

    datas.map!{ |d| Product.new( id: d[@@id_idx],price: d[@@price_idx],
                                brand: d[@@brand_idx],name: d[@@name_idx] )}

  end

  def update( options = {} )
    Product.create( options )
=begin
    products = Product.all

    if( options[:price] != nil)
      @price = options[:price]
      products.map! do |product|
        if( product.id == @id )
          product.price = options[:price]
        else
          product = product
        end
      end
    end

    puts "000000"
    puts products
    puts "000000"

    if( options[:brand] != nil )
      @brand = options[:brand]
      products.map! do |product|
        if( product.id == @id )
          product.brand = options[:brand]
        end
      end
    end
=end
  end

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
      puts exsit_data
      return Product.new( id: exsit_data[@@id_idx],
                          price: exsit_data[@@price_idx],
                          brand: exsit_data[@@brand_idx],
                          name: exsit_data[@@name_idx] )
    end

    # If the object's data is not in the database
    # create the object
    # save the data in the database
    # return the object
    product = Product.new(  price: attributes[:price],
                            brand: attributes[:brand],
                            name: attributes[:name] )

    CSV.open(@data_path, "a+") do |csv|
      csv << [ product.id, attributes[:brand], attributes[:name], attributes[:price] ]
    end

    return product

  end

  def initialize(opts={})
    # Get last ID from the database if ID exists
    get_last_id
    # Set the ID if it was passed in, otherwise use last existing ID
    @id = opts[:id] ? opts[:id].to_i : @@count_class_instances
    # Increment ID by 1
    auto_increment if !opts[:id]
    # Set the brand, name, and price normally
    @brand = opts[:brand]
    @name = opts[:name]
    @price = opts[:price]
  end

  private

    # Reads the last line of the data file, and gets the id if one exists
    # If it exists, increment and use this value
    # Otherwise, use 0 as starting ID number
    def get_last_id
      file = File.dirname(__FILE__) + "/../data/data.csv"
      last_id = File.exist?(file) ? CSV.read(file).last[0].to_i + 1 : nil
      @@count_class_instances = last_id || 0
    end

    def auto_increment
      @@count_class_instances += 1
    end

end
