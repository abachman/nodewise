desc "The heroku cron task"
task :cron => [:environment] do 
  puts "Run CRON TASK #{ DateTime.now }"
  # only in demo
  if Rails.env == "demo"
    Rake::Task["seed"].invoke
    puts("------------------------------")
    puts("DEMO TASK COMPLETE. DATA WIPED")
    puts("------------------------------")
  else
    puts "Sending email reminders"
    Invoice.send_reminders
  end
end
