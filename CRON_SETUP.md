# Domain Scout Cron Setup Guide

## Quick Setup Commands

### 1. Open your crontab for editing:
```bash
crontab -e
```

### 2. Add one of these lines (choose your preferred frequency):

#### Every 5 minutes:
```
*/5 * * * * /Users/ramin/Desktop/domain_scout/cron_runner.sh
```

#### Every 10 minutes:
```
*/10 * * * * /Users/ramin/Desktop/domain_scout/cron_runner.sh
```

#### Every 15 minutes:
```
*/15 * * * * /Users/ramin/Desktop/domain_scout/cron_runner.sh
```

#### Every hour at minute 0:
```
0 * * * * /Users/ramin/Desktop/domain_scout/cron_runner.sh
```

#### Every 30 minutes:
```
0,30 * * * * /Users/ramin/Desktop/domain_scout/cron_runner.sh
```

### 3. Save and exit the editor (in vim: press Esc, then type :wq and press Enter)

## Cron Format Explanation:
```
* * * * * command
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

## Useful Cron Management Commands:

### View current crontab:
```bash
crontab -l
```

### Remove all cron jobs:
```bash
crontab -r
```

### Check if cron service is running:
```bash
sudo launchctl list | grep cron
```

## Monitoring Your Cron Jobs:

### View recent logs:
```bash
ls -la /Users/ramin/Desktop/domain_scout/logs/
```

### View the latest log:
```bash
tail -f /Users/ramin/Desktop/domain_scout/logs/cron_run_*.log | tail -1
```

### Check for available domains found:
```bash
grep "AVAILABLE" /Users/ramin/Desktop/domain_scout/logs/cron_run_*.log
```

### View results CSV:
```bash
tail -20 /Users/ramin/Desktop/domain_scout/results.csv
```

## Troubleshooting:

### If cron jobs aren't running:
1. Check cron service: `sudo launchctl list | grep cron`
2. Check system logs: `tail -f /var/log/system.log | grep cron`
3. Ensure script has execute permissions: `chmod +x /Users/ramin/Desktop/domain_scout/cron_runner.sh`
4. Test script manually: `cd /Users/ramin/Desktop/domain_scout && ./cron_runner.sh`

### If you want notifications:
Uncomment the osascript line in cron_runner.sh to get macOS notifications when domains are found.

## Recommended Schedule:
- **Every 10 minutes** is a good balance between frequency and API rate limits
- **Every 5 minutes** for aggressive domain hunting (watch API limits)
- **Every 15-30 minutes** for casual monitoring
