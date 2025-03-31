class User < ApplicationRecord
  has_many :report_configs, dependent: :destroy
end
