class ExperienciaAgroecologica < ApplicationRecord
  belongs_to :usuario
  belongs_to :local
  belongs_to :tema_experiencia_agroecologica
  has_one :organizacao, through: :local

  extend FriendlyId
  friendly_id :nome, use: :slugged

  validates :nome, presence: true
  validates :local, presence: true
  validates :tema_experiencia_agroecologica, presence: true

  protected
    def should_generate_new_friendly_id?
      nome_changed?
    end
end