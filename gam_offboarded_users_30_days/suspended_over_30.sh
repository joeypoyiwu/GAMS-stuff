#!/bin/bash

gam() { "/Users/joey.wu/bin/gam/gam" "$@" ; }

set -o errexit
set -o nounset
set -o pipefail

clear
gam_report_suspended_30days_users () {
  thirty_days="$(date -v-30d +%Y-%m-%d)"
  today="$(date +%Y-%m-%d)"
  echo "Displaying 30 days before the current date: "$thirty_days
  gam report users filter 'accounts:is_suspended=='True',accounts:last_login_time<'$thirty_days'T00:00:00.000Z' > csv/suspended_users_"$today".csv
  echo "Exporting..."
}


gam_report_suspended_30days_users
python user_export.py
