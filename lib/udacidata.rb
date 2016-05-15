require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  create_finder_methods( "name", "brand" )
  # Your code goes here!
  @@id_idx = 0
  @@brand_idx = 1
  @@name_idx = 2
  @@price_idx = 3

  def self.all
    obj_array = Array.new

    data_path = File.dirname(__FILE__) + "/../data/data.csv"
    CSV.foreach( data_path, headers: true ) do |data|
      obj_array << self.new( id: data["id"], price: data["price"],
                                 brand: data["brand"], name: data["product"] )
    end

    obj_array
  end

  def self.first( num = nil)
    num ? all.first(num) : all.first
  end

  def self.last( num = nil )
    num ? all.last(num) : all.last
  end

  def self.exist?( id )
    all.find { |obj| obj.id == id } != nil
  end

  def self.find( id )
    result = all.find { |obj| obj.id == id }

    if( result == nil )
      raise ProductNotFoundError, "Cannot find this item"
    end

    result
  end

  def self.create( attributes = nil )

    obj = self.new( attributes )

    if( false == exist?( obj.id ) )
      file = File.dirname(__FILE__) + "/../data/data.csv"
      CSV.open( file, "a+" ) do |csv|
        csv << [ obj.id, obj.brand, obj.name, obj.price ]
      end
    end

    obj
  end


  def self.destroy( id )
    del_obj = find( id )

    if( del_obj == nil )
      return
    end

    file = File.dirname(__FILE__) + "/../data/data.csv"
    tbl = CSV.table( file )

    tbl.delete_if do |data|
      data[:id] == id
    end

    reset_file()
    CSV.open(file, "a+") do |csv|
      tbl.each do |row|
        csv << row
      end
    end

    del_obj
  end



  def self.reset_file()
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    CSV.open(@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
    end
  end

  def self.where( options={} )
    if( options == nil )
      return nil
    end

    objs = []
    all.each do |obj|

      found = true

      options.each do |k,v|
        if( obj.send(k) != v )
          found = false;
        end
      end

      if( found )
        objs << obj
      end
    end
      objs
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
