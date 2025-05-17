# frozen_string_literal: true
class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    authorize_user!
    device = find_or_create_device
    device_already_assigned!(device)
    device_previously_assigned_to_user?(device)

    create_assignment(device)

  end

  private
  def authorize_user!
    @requesting_user.id == @new_device_owner_id || raise(RegistrationError::Unauthorized)
  end

  def find_or_create_device
    Device.find_or_create_by!(serial_number: @serial_number)
  end

  def device_already_assigned!(device)
    raise AssigningError::AlreadyUsedOnOtherUser if device.device_assignments.where(returned_at: nil).exists?
  end

  def device_previously_assigned_to_user?(device)
    raise AssigningError::AlreadyUsedOnUser if device.device_assignments.where(user_id: @new_device_owner_id).exists?
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
