class Transaction < ApplicationRecord
  belongs_to :category

  KINDS = { expense: 0, income: 1, transfer: 2 }.freeze

  def self.kinds
    KINDS.transform_keys(&:to_s)
  end

  def kind=(value)
    if value.nil?
      super(nil)
    elsif value.is_a?(String) || value.is_a?(Symbol)
      super(KINDS[value.to_sym])
    else
      super(value)
    end
  end

  validates :amount, presence: true, numericality: true
  validates :kind, presence: true, inclusion: { in: KINDS.values }
  validates :occurred_at, presence: true
end
