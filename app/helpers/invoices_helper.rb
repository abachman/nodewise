module InvoicesHelper
  def overdue_notify_warning invoice
    count = invoice.notifications.where(:cause => Notification::OVERDUE).count

    if count > 0 
      "%i %s already been sent, are you sure you want to send another?" % [
        count,
        count == 1 ? "email has" : "emails have"
      ]
    else
      "Are you sure you want to send an email?"
    end
  end
end
