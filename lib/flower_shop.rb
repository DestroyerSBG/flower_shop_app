require 'products'
require 'order_filler'

class FlowerShop
  attr_reader   :products
  attr_accessor :display

  def initialize
    @display  = file_upload_instructions
    @products = Products.all
  end

  def run
    puts 'Welcome to the Flower Shop App.'
    puts display # display instructions
    order_filler = OrderFiller.fill(self)
    self.display = order_filler.message # breakdown or error message
    puts display # display response from order filler
  end

  private

  def file_upload_instructions
    "Please save Order CSV file into the 'uploads' folder then enter"\
      " '1' to calculate costs and bundle breakdown, or '2' to exit."
  end
end
