module ActiveWarehouse #:nodoc:
  # Responsible for migrating ActiveWarehouse tables which are automatically created.
  class Migrator < ActiveRecord::Migrator
    class << self
      def schema_info_table_name #:nodoc:
        ActiveRecord::Base.table_name_prefix + 'activewarehouse_schema_migrations' + ActiveRecord::Base.table_name_suffix
      end
      
      def current_version #:nodoc:
        result = ActiveRecord::Base.connection.select_one("SELECT max(version) FROM #{schema_migrations_table_name}")
        if result
          result['version'].to_i
        else
          # There probably isn't an entry for this plugin in the migration info table.
          # We need to create that entry, and set the version to 0
          ActiveRecord::Base.connection.execute("INSERT INTO #{schema_migrations_table_name} (version) VALUES (0)")      
          0
        end
      end    
    end
    
    def set_schema_version(version)
      ActiveRecord::Base.connection.update("UPDATE #{self.class.schema_migrations_table_name} SET version = #{down? ? version.to_i - 1 : version.to_i}")
    end
  end
end
