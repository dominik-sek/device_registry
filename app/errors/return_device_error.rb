module ReturnDeviceError
  class DeviceNeverAssigned < StandardError; end
  class DeviceAlreadyReturned < StandardError; end
  class Unauthorized < StandardError; end
end