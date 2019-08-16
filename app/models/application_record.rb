# The ApplicationRecord class is the base class for all ActiveRecord models.
# Common methods and config to be inherited by all models can be added here.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
