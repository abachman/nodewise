desc "The heroku cron task"
task :cron => [:environment] do 
  puts
  puts "============================================================="
  puts "Run CRON TASK #{ DateTime.now }"
  # only in demo
  if Rails.env == "demo"
    Rake::Task["seed"].invoke
    puts("DATA WIPED")
  else
    puts("Sending email reminders")
    Invoice.send_reminders
  end

  puts "Generating new dues invoices"
  Rake::Task["generate_dues_invoices"].invoke

    puts("------------------------------")
    puts("TASK COMPLETE. DATA WIPED")
    puts("------------------------------")
end

task :generate_dues_invoices => :environment do 
  Membership.generate_dues_invoices
end
