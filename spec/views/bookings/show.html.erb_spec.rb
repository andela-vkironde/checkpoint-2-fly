require 'rails_helper'

RSpec.describe "bookings/show", type: :view do
  before(:each) do
    @booking = assign(:booking, Booking.create!(
      :cost => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
  end
end
