# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:, from_user:)
    @user = user
    @serial_number = serial_number
    @from_user = from_user
  end

  def call
    device = Device.find_by(serial_number: @serial_number)
    raise ReturnDeviceError::DeviceNeverAssigned unless device
    assignment = device.device_assignments.find_by!(user_id: @from_user, device_id: device.id)


    raise ReturnDeviceError::Unauthorized unless assignment.user_id == @user.id
    raise ReturnDeviceError::DeviceNeverAssigned unless assignment
    raise ReturnDeviceError::DeviceAlreadyReturned unless assignment.returned_at.nil?

    assignment.update!(
      returned_at: Time.current
    )
  end
end
