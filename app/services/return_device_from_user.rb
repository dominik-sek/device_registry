# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:, from_user:)
    @user = user
    @serial_number = serial_number
    @from_user = from_user
  end

  def call
    device = find_device!
    assignment = find_assignment!(device)
    authorize_user!(assignment)
    device_already_returned!(assignment)

    assignment.update!(returned_at: Time.current)
  end

  private
  def find_device!
    Device.find_by(serial_number: @serial_number) || raise(ReturnDeviceError::DeviceNotFound)
  end

  def find_assignment!(device)
    device.device_assignments.find_by(user_id: @from_user, device_id: device.id) || raise(ReturnDeviceError::DeviceNeverAssigned)
  end

  def authorize_user!(assignment)
    raise ReturnDeviceError::Unauthorized unless assignment.user_id == @user.id
  end

  def device_already_returned!(assignment)
    raise ReturnDeviceError::DeviceAlreadyReturned unless assignment.returned_at.nil?
  end

end
