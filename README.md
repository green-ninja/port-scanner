## Port scanner

Port scanner to detect and keep track of changes in infrastructure.

### Install
#### Prerequisites
- nmap
- ndiff (sometimes packaged with nmap)
- sudo/root privileges

#### Installation
##### 1. Download scan.sh
##### 2. Create a CronJob
    1. crontab -e
    2. 0 6 * * * /path/to/scan.sh > /var/port-scanner/scan_output.log 2>&1
        - Runs daily at 06:00
