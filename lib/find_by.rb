class Module
	def create_finder_methods(*attributes)
		attributes.each do |attribute|
			find_by = %Q{
				def self.find_by_#{attribute}(argument)
					Product.all.find{ |data| data.#{attribute} == argument }
				end
			}
			class_eval(find_by)
		end
	end
end
