class BookingsController < ApplicationController
  before_action :find_booking_by_code, only: [:manage]
  before_action :find_booking_by_id, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:edit, :update, :destroy]

  def new
    flight = Flight.find_by id: params[:flight]
    if flight
      @booking = flight.bookings.new
      params[:passengers].to_i.times { @booking.passengers.build }
    else
      flash[:danger] = no_flight_selected
      redirect_to root_path
    end
  end

  def create
    flight = Flight.find_by id: booking_params[:flight_id]
    @booking = flight.bookings.new(booking_params)
    if @booking.save
      send_email
      flash[:success] = booking_saved
    else
      set_params
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      send_email
      flash[:success] = booking_updated
    else
      set_params
      render "edit"
    end
  end

  def destroy
    @booking.destroy
    flash[:success] = booking_deleted
    redirect_to bookings_user_path(current_user)
  end

  def manage
    if @booking
      can_edit
    else
      redirect_to find_bookings_path
      flash[:danger] = booking_not_found
    end
  end

  private

  def find_booking_by_id
    @booking = Booking.find(params[:id])
  end

  def find_booking_by_code
    @booking = Booking.find_by(reference: params[:ref].strip)
    @booking || flash[:danger] = booking_not_found
  end

  def can_edit
    user = current_user && current_user.email == @booking.email
    if user
      redirect_to edit_booking_path(@booking)
    else
      redirect_to @booking
      flash[:success] = booking_found
    end
  end

  def booking_params
    params.require(:booking).
      permit(
        :email,
        :departure,
        :flight_id,
        :user_id,
        passengers_attributes: [:id, :name, :passport_number, :phone]
      )
  end

  def send_email
    BookingMailer.booking_confirmation(@booking).deliver_now
    redirect_to @booking
  end

  def set_params
    params[:passengers] = booking_params.to_h[:passengers_attributes].length
    params[:departure] = booking_params[:departure]
  end
end
