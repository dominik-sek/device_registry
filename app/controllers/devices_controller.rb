# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]
  def assign
    puts params
    AssignDeviceToUser.new(
      requesting_user: @current_user,
      serial_number: params[:device][:serial_number],
      new_device_owner_id: params[:new_owner_id].to_i
    ).call
    render json: { message: 'Device assigned successfully' }, status: :ok



  rescue RegistrationError::Unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  rescue AssigningError::AlreadyUsedOnUser
    render json: { error: 'You already used this device' }, status: :unprocessable_entity
  rescue AssigningError::AlreadyUsedOnOtherUser
    render json: { error: 'Device is already assigned to another user' }, status: :conflict

  end

  def unassign
    ReturnDeviceFromUser.new(
      user: @current_user,
      serial_number: params[:serial_number],
      from_user: params[:from_user_id]
    )
    render json: { message: 'Device returned successfully' }, status: :ok
  rescue ReturnDeviceError::Unauthorized
    render json: { error: 'Not authorized to return this device' }, status: :forbidden
  rescue ReturnDeviceError::DeviceNeverAssigned
    render json: { error: 'No active assignment found for this device' }, status: :unprocessable_entity
  end

  private

  def device_params
    params.permit(:new_owner_id, :serial_number)
  end
end
