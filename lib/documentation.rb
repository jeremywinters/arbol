module Arbol
  class Documentation
    def output_all_documentation
      (self.public_methods - Object.public_methods).sort.each do |m|
        unless [:output_all_documentation, :output_single_doc].include? m.to_sym
          output_single_doc(m) 
        end
      end   
    end
    
    def output_single_doc(func)
      puts(
        self.send(
          func.to_sym
        )
      )
    end
  end
end