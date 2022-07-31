class HelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Simulates a long, time-consuming task
    sleep 5
    # Will display current time, milliseconds included
    p "########################################################################"
    p "Holaaaaa #{Time.now().strftime('%F - %H:%M:%S.%L')}"
    p "########################################################################"

  end

end