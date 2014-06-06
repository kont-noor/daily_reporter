## Daily Reporter

A tool that allows you not to forget to send your daily reports.
Now it allows you to add tasks during the day via the console. It gets the email with the request and responses to it.

### Usage
1. install the gem by ```gem install daily_reporter```
2. init your settings by ```daily_reporter bootstrap```
3. add the task by ```daily_reporter task add 'task description'```
   you can look through the task lists by ```daily_reporter task list```
4. get the email to respond
5. add daily_reporter report to cron:
   ```10 18 * * * daily_reporter report```
   or
   ```rvm cron command "10 18 * * *" "daily_reporter report"``` if you use rvm
   this will run daily_reporter to send the report
   tasks list will be cleaned after report is sent

### TODO:
1. add it to the cron - Done
2. set settings another way
3. add an option that could make report by commits
4. add an option that could make report by Jira Tempo
