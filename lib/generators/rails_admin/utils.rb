module RailsAdmin
  module Generators
    module Utils
      module InstanceMethods
        def display(output, color = :green)
          say("------------  #{output}", color)
        end
    
        def ask_for(wording, default_value, existing_value)
          existing_value.present? ? 
            display("Using [#{existing_value}] for question '#{wording}'") && existing_value : 
            ask("============  #{wording} Press <enter> for [#{default_value}] >", :yellow).presence || default_value
        end
      end
      
      module ClassMethods
        def next_migration_number(dirname)
          if ActiveRecord::Base.timestamped_migrations
            migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
            migration_number += 1
            migration_number.to_s
          else
            "%.3d" % (current_migration_number(dirname) + 1)
          end
        end
      end
    end
  end
end

