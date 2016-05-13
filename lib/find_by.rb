class Module
	def self.create_finder_methods(*attributes)
		attributes.each do |attribute|
			find_by = %Q{
				def self.find_by_#{attribute}(argument)
					data_path = File.dirname(__FILE__) + "/../data/data.csv"
					CSV.foreach(data_path,headers:true) do |row|
						if row["#{attribute}"] == argument
							return Udacidata.create(id: row[0], brand: row[1], name: row[2], price: row[3])
						end
					end
				end
			}
			class_eval(find_by)
		end
	end

	Module.create_finder_methods( "brand", "id" )
	#Module.create_finder_methods( "name", "brand" )
end

=begin

class Module
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    attributes.each do |attribute|
      method = %Q{
        def find_by_#{attribute}( arg )
          file = File.dirname(__FILE__) + "/../data/data.csv"

          CSV.foreach( file, headers: true ) |item|
          end
        end
      }
      class_eval( method )
    end

  end

  create_finder_methods( :name, :brand )
end
=end
=begin




            if( item["#{attribute}"] == arg )
              Udacidata.create( item )

            else
              raise ProductNotFoundError, "Cannot find this item"
            end
          end


=end
