# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorHandler do
  context 'when thrown a known error' do
    it "returns unauthorized for RegistrationError" do
      result = described_class.handle(RegistrationError::Unauthorized.new)

      expect result[:status] == :unauthorized
      expect(result[:json]).to include(error: "Unauthorized")
    end
  end
  context 'when thrown an unexpected error' do
    it "returns internal server error with message" do
      result = described_class.handle(StandardError.new)
      expect result[:status] == :internal_server_error
      expect(result[:json]).to include(error: "An unexpected error occurred")
    end
  end

end