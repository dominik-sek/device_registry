# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    puts "requesting user id #{@requesting_user.id} to #{@new_device_owner_id}"

    raise RegistrationError::Unauthorized unless assign_to_self?
    puts "Assigning: user #{@requesting_user.id} to #{@new_device_owner_id}"

    device = Device.find_or_create_by!(serial_number: @serial_number)
    is_assigned = DeviceAssignment.where(device_id: device.id).where(returned_at: nil).exists?

    if is_assigned
      raise AssigningError::AlreadyUsedOnOtherUser
    end

    previous_assignment_exists = DeviceAssignment.where(
      user_id: @new_device_owner_id,
      device_id: device.id
    ).exists?

    if previous_assignment_exists
      raise AssigningError::AlreadyUsedOnUser
    end

    DeviceAssignment.create!(
      user_id: @new_device_owner_id,
      device_id: device.id,
      assigned_at: Time.current,
      returned_at: nil
    )
  end

  private
  def assign_to_self?
    @requesting_user.id == @new_device_owner_id
  end
end
