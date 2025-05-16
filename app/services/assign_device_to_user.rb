# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    raise RegistrationError::Unauthorized unless assign_to_self?

    #create a new device if it doesnt exist
    device = Device.where(serial_number: @serial_number).first_or_create!

    assignment = DeviceAssignment.create(
      user_id: @requesting_user.id,
      device_id: device.id,
      assigned_at: Time.now,
      returned_at: nil
    )

  end

  private
  def assign_to_self?
    @requesting_user.id == @new_device_owner_id
  end
  private

end
