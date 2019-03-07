class Fees
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

#fields
  field :fees_installment_1, type:Boolean
  field :fees_installment_2, type:Boolean
  field :fees_installment_3, type:Boolean
  field :fees_installment_4, type:Boolean
end
