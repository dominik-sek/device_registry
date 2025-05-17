# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  let(:user) { create(:user) }
  let(:serial_number) { '123456' }
  let(:from_user) { user.id }
  let(:new_device_owner_id) { user.id }

  def assign_device
    AssignDeviceToUser.new(
      requesting_user: user,
      serial_number: serial_number,
      new_device_owner_id: new_device_owner_id
    ).call
  end

  def return_device
    described_class.new(
      user: user,
      serial_number: serial_number,
      from_user: from_user
    ).call
  end

  context 'when user returns a device himself' do
    before { assign_device }

    it 'returns the device without error' do
      expect { return_device }.not_to raise_error

      assignment = DeviceAssignment.find_by(user_id: user.id)
      expect(assignment&.returned_at).not_to be_nil
    end
  end

  context 'when user tries to return a device that has already been returned' do
    before do
      assign_device
      return_device
    end

    it 'raises an error' do
      expect { return_device }.to raise_error(ReturnDeviceError::DeviceAlreadyReturned)
    end
  end

  context 'when user tries to return a device that has never been assigned' do
    it 'raises an error' do
      expect do
        described_class.new(
          user: user,
          from_user: user.id,
          serial_number: serial_number
        ).call
      end.to raise_error(ReturnDeviceError::DeviceNotFound)
    end
  end

  context 'when user tries to return a device assigned to another user' do
    let(:other_user) { create(:user) }
    let(:from_user) { other_user.id }

    before do
      AssignDeviceToUser.new(
        requesting_user: other_user,
        serial_number: serial_number,
        new_device_owner_id: other_user.id
      ).call
    end

    it 'raises an unauthorized error' do
      expect do
        described_class.new(
          user: user,
          from_user: other_user.id,
          serial_number: serial_number
        ).call
      end.to raise_error(ReturnDeviceError::Unauthorized)
    end
  end
end
