class HelloWorldJob < ApplicationJob
  queue_as :default

  def perform(transaction_id)
    transaction = Transaction.find transaction_id
    transaction.update(description: "Actualizado desde Job")
    # Simulates a long, time-consuming task
    sleep 5
    # Will display current time, milliseconds included
    p "########################################################################"
    p "Holaaaaa #{Time.now().strftime('%F - %H:%M:%S.%L')}"
    p "########################################################################"

  end

end