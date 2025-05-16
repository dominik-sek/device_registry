# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:, from_user:)
    @user = user
    @serial_number = serial_number
    @from_user = from_user
  end

  def call
    device = Device.find_by(serial_number: @serial_number)

    assignment = DeviceAssignment.find_by!(user_id: @from_user, device_id: device.id)
    assignment.update!(
      returned_at: Time.current
    )
  end
end
