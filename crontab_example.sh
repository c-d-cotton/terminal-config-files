# verify crontab working 1
*/5 * * * * echo "$(/usr/bin/date) started" > ~/.crontab_test_started
# backup code
*/5 * * * * ~/doc/codegen/terminal-config-files/backupcode.sh
# verify crontab working 2
*/5 * * * * echo "$(/usr/bin/date) completed" > ~/.crontab_test_completed

