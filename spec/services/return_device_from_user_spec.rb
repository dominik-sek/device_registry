# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  subject(:unassign_device) do
    described_class.new(
      user: user,
      serial_number: serial_number,
      from_user: from_user
    ).call
  end


end
