class Organizacao < ApplicationRecord
  belongs_to :tipo_organizacao
  belongs_to :usuario

  extend FriendlyId
  friendly_id :nome, use: :slugged

  validates :nome, presence: true

  protected
    def should_generate_new_friendly_id?
      nome_changed?
    end

end