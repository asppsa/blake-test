# This incorportates functionality common to both {Student}s and {Teacher}s;
# namely handling of name validation
module Person
  # @!attribute name
  #   @return [String] the (full) name.  This can be set to any string
  #     containing alphabetic characters, hypens and spaces, up to 200
  #     characters.  It cannot be blank, and any leading or trailing whitespace
  #     will be stripped.

  # This calls the relevant ActiveRecord methods to apply {#name} validation.
  def self.included(mod)
    mod.validates :name,
                  presence: true,
                  format: /\A[[:alpha:] -]+\z/,
                  length: { maximum: 200 }

    # Make sure no trailing whitespace on names
    mod.before_save { self.name = name.strip }
  end
end
