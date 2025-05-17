module ReturnDeviceError
  class DeviceNeverAssigned < StandardError; end
  class DeviceAlreadyReturned < StandardError; end
  class DeviceNotFound < StandardError; end
  class Unauthorized < StandardError; end
end