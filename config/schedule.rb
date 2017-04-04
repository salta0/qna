every 1.days, :at => '11:59 pm' do
  runner "DailyDigestJob.perform_later"
end

every 60.minutes do
  rake "ts:index"
end