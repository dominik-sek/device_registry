# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]
  def assign
    AssignDeviceToUser.new(
      requesting_user: @current_user,
      serial_number: assign_params[:serial_number],
      new_device_owner_id: assign_params[:new_owner_id]
    ).call
    render json: { message: 'Device assigned successfully' }, status: :ok
  rescue StandardError => error
    render ErrorHandler.handle(error)

  end

  def unassign
    ReturnDeviceFromUser.new(
      user: @current_user,
      serial_number: unassign_params[:serial_number],
      from_user: unassign_params[:from_user]
    ).call
    render json: { message: 'Device returned successfully' }, status: :ok
  rescue StandardError => error
    render ErrorHandler.handle(error)

  end

  private

  def assign_params
    params.require(:device).permit(:serial_number).merge(
      new_owner_id: params[:new_owner_id].to_i
    )
  end

  def unassign_params
    params.require(:device).permit(:serial_number).merge(
      from_user: params[:from_user].to_i
    )
  end
end
