class AddIndexToDeviceAssignmentUsersDevices < ActiveRecord::Migration[7.1]
  def change
    add_index :device_assignments, [:device_id, :user_id]
    add_index :device_assignments, [:device_id, :returned_at]
    add_index :device_assignments, [:device_id, :assigned_at]
  end
end
