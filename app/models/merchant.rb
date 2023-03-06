class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :bulk_discounts
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  enum status: [:enabled, :disabled]

  def favorite_customers
    transactions.joins(invoice: :customer)
                .where('result = ?', 1)
                .where("invoices.status = ?", 2)
                .select("customers.*, count('transactions.result') as top_result")
                .group('customers.id')
                .order(top_result: :desc)
                .distinct
                .limit(5)
  end

  def ordered_items_to_ship
    item_ids = InvoiceItem.where("status = 0 OR status = 1").order(:created_at).pluck(:item_id)
    item_ids.map do |id|
      Item.find(id)
    end
  end

  def top_5_items
     items
     .joins(invoices: :transactions)
     .where('transactions.result = 1')
     .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
     .group(:id)
     .order('total_revenue desc')
     .limit(5)
   end

  def self.top_merchants
    joins(invoices: [:invoice_items, :transactions])
    .where('result = ?', 1)
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .group(:id)
    .order('total_revenue DESC')
    .limit(5)
  end

  def best_day
    invoices.where("invoices.status = 2")
            .joins(:invoice_items)
            .select('invoices.created_at, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
            .group("invoices.created_at")
            .order("revenue desc", "invoices.created_at desc")
            .first&.created_at&.to_date
  end

  def total_rev_and_discounts(invoice)
    self.invoice_items.joins(:bulk_discounts)
    .select("invoice_items.*, (invoice_items.quantity * invoice_items.unit_price) AS total_rev, MAX(bulk_discounts.percentage_discount * invoice_items.quantity * invoice_items.unit_price / 100) as max_discount")
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .where("invoice_items.invoice_id = #{invoice.id}")
    .group(:id)
  end

  def merchant_total_revenue(invoice)
    self.total_rev_and_discounts(invoice).sum do |ii|
      ii.total_rev
    end
  end

  def merchant_discounts(invoice)
    self.total_rev_and_discounts(invoice).sum do |ii|
      ii.max_discount
    end
  end
end
