module Polymorpheus
  module Interface
    module ValidatesPolymorph
      def validates_polymorph(polymorphic_api, nullable = false)
        validate Proc.new {
          association_names = polymorpheus.associations.map(&:name)
          if nullable
            unless polymorpheus.mutually_exclusive
              errors.add(:base, "You must specify at most one of the following: "\
                                "{#{association_names.join(', ')}}")
            end
          else
            unless polymorpheus.active_association
              errors.add(:base, "You must specify exactly one of the following: "\
                                "{#{association_names.join(', ')}}")
            end
          end
        }
      end
    end
  end
end
