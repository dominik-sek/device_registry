# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  let(:api_key) { create(:api_key) }
  let(:user) { api_key.bearer }
  let(:serial_number) { '123456' }


  describe 'POST #assign' do
    subject(:assign) do
      post :assign,
           params: { new_owner_id: new_owner_id, device: { serial_number: serial_number } },
           session: { token: user.api_keys.first.token }
    end
    context 'when the user is authenticated' do
      context 'when user assigns a device to another user' do
        let(:new_owner_id) { create(:user).id }

        it 'returns an unauthorized response' do
          #hit the endpoint
          assign
          #change response.code to response.status, code returns a string + change http code to match the error message
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
        end
      end

      context 'when user assigns a device to self' do
        let(:new_owner_id) { user.id }
        it 'returns a success response' do
          assign
          expect(response).to be_successful
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an unauthorized response' do
        post :assign
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'POST #unassign' do
    subject(:unassign) do
      post :unassign,
           params: { from_user: from_user, device: { serial_number: serial_number } },
           session: { token: user.api_keys.first.token }

    end
    context 'when the user is authenticated' do
      context 'user returns the device from another user' do
        let(:other_user) { create(:user) }
        let(:from_user) { other_user.id }

        before do
          AssignDeviceToUser.new(
            requesting_user: other_user,
            serial_number: serial_number,
            new_device_owner_id: other_user.id
          ).call
        end

        it 'returns an unauthorized response' do

          unassign
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
        end
      end

      context 'when user return the device from self' do
        let(:from_user) { user.id }
        before do
          AssignDeviceToUser.new(
            requesting_user: user,
            serial_number: serial_number,
            new_device_owner_id: user.id
          ).call
        end

        it 'returns a success response' do
          unassign
          expect(response).to be_successful
          expect(JSON.parse(response.body)).to eq({'message' => 'Device returned successfully'})
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an unauthorized response' do
        post :unassign
        expect(response).to be_unauthorized
      end
    end
  end
end
