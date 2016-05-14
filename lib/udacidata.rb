require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
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

  def self.find( id )
    all.find { |obj| obj.id == id }
  end

  def self.create( attributes = nil )

    obj = self.new( attributes )

    if( nil == find( obj.id ) )
      file = File.dirname(__FILE__) + "/../data/data.csv"
      CSV.open( file, "a+" ) do |csv|
        csv << [ obj.id, obj.brand, obj.name, obj.price ]
      end
    end

    obj
  end



  def self.reset_file()
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    CSV.open(@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
    end
  end

  def self.destroy( id )
    del_obj = find( id )

    if( del_obj == nil )
      return
    end

    file = File.dirname(__FILE__) + "/../data/data.csv"
    tbl = CSV.table( file )
    tbl.delete_if do |data|
      data["id"] == id
    end

    CSV.open(@data_path, "wb") do |csv|
      tbl.each do |row|
        csv << row
      end
    end

    del_obj
  end

  def self.find_by_brand( brand )
    file = File.dirname(__FILE__) + "/../data/data.csv"

    data_base = File.exist?(file) ? CSV.read(file).drop(1) : nil
    if( data_base == nil )
      return nil
    end

    data = data_base.find{ |item| item[@@brand_idx] == brand }

    self.new( id: data[@@id_idx],
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

    self.new( id: data[@@id_idx],
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

    datas.map!{ |d| self.new( id: d[@@id_idx],price: d[@@price_idx],
                                brand: d[@@brand_idx],name: d[@@name_idx] )}
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
