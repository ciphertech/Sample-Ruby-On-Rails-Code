
module ConnectionAdapterClassMethods
  def db_is?(name, t =true , f=false)
    #example
    # Product.db_is?(:SQLite) =>  true or false
    # Product.db_is?(:SQLite,  "LIKE",  "ILIKE") => "LIKE" or "ILIKE"
    (connection.adapter_name == name.to_s) ? t : f
  end
end


module ActiveRecord::ConnectionAdapter
  def self.included(base)
     base.extend(ConnectionAdapterClassMethods)
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::ConnectionAdapter)