class ErrorHandler

  ERROR_MAPPINGS = {
    AssigningError::AlreadyUsedOnUser => {status: :unprocessable_entity, error: "You already used this device"},
    AssigningError::AlreadyUsedOnOtherUser => {status: :conflict, error: "Device is already assigned to another user"},
    RegistrationError::Unauthorized => { status: :unauthorized, error: "Unauthorized"},
    ReturnDeviceError::DeviceNeverAssigned =>{ status: :unprocessable_entity, error: "You already used this device"},
    ReturnDeviceError::DeviceAlreadyReturned => {status: :unprocessable_entity, error: "Device already returned"},
    ReturnDeviceError::Unauthorized => { status: :unauthorized, error: "Unauthorized"},
    ReturnDeviceError::DeviceNotFound => { status: :not_found, error: "Device not found"},
  }
  def self.handle(error)
    mapping = ERROR_MAPPINGS[error.class] || unhandled_error_response

    return {
      json: {error: mapping[:error]},
      status: mapping[:status]
    }
  end
  private
  def self.unhandled_error_response
    {status: :internal_server_error, error: "An unexpected error occurred"}
  end
end