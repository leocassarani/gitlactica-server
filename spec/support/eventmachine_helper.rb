module EventMachineHelper
  def fail_after(interval, msg)
    EM.add_timer(interval) do
      yield if block_given?
      fail msg
    end
  end
end
