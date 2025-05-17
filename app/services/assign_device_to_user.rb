# frozen_string_literal: true
class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    raise RegistrationError::Unauthorized unless assign_to_self?

    device = Device.find_or_create_by!(serial_number: @serial_number)
    raise AssigningError::AlreadyUsedOnOtherUser if device_already_assigned?(device)
    raise AssigningError::AlreadyUsedOnUser if device_previously_assigned_to_user?(device)

    create_assignment(device)

  end

  private
  def assign_to_self?
    @requesting_user.id == @new_device_owner_id
  end
  def device_already_assigned?(device)
    device.device_assignments.where(returned_at: nil).exists?
  end

  def device_previously_assigned_to_user?(device)
    device.device_assignments.where(user_id: @new_device_owner_id).exists?
  end

  def create_assignment(device)
    DeviceAssignment.create!(
      user_id: @new_device_owner_id,
      device_id: device.id,
      assigned_at: Time.current,
      returned_at: nil
    )
  end
end
