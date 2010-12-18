desc "The heroku cron task"
task :cron => [:environment, "db:reset", "data:load"] do 
  Rails.logger.info("------------------------------")
  Rails.logger.info("CRON TASK COMPLETE. DATA WIPED")
  Rails.logger.info("------------------------------")
end
