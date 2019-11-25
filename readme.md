# .backup

I do not need a complicated backup system.

This script is simple, all it does is:
- checks for, and mounts the external drive
- rsyncs a copy of my home directory
- keeps a log of `rsync -v`
- allows for an `--exlcude-from` file
- allows for multiple hosts
- keeps 7 days worth of backups

It does not:
- error (i.e. fails silently if the external isn't mounted)
- keep fancy historical copies (i.e. one backup from the past year, 3 from the past month, and 7 copies from today)

##### 1. Install

```
$ git clone git@github.com:aaronlord/.backup.git ~/.backup

$ chmod +x ~/.backup/backup.sh
```

##### 2. Find devices UUID

```
# Figure out which disk you want to use (probably /dev/sda)
$ sudo fdisk -l

# Find the UUID for it (e.g. ABCD-1234 -> ../../sda1, where ABCD-1234 is the UUID)
$ ls -lah /dev/disk/by-uuid/
```

##### 3. Excludes (optional)

Exclude any files that you don't want to backup using an [exclude-from](./exclude-from.example) file.

```
$ cp ~/.backup/exclude-from.example ~/.backup/exclude-from
```

##### 4. Run

The exclude-from file path is optional

```
$ sudo ~/.backup/backup.sh $USER {uuid} ~/.backup/exclude-from
```

Once that's run, you should see a new backup on your external drive. i.e. `/media/aaron/Samsung-T5/Backups/xps15/2019-11-25/`


##### 5. Cron (optional)

```
$ sudo crontab -e
```

Add a line to schedule backups as [frequently](https://crontab.guru/#0_*_*_*_*) as you like:

```
# Hourly backups
0 * * * * /home/{user}/.backup/backup.sh {user} {uuid} /home/{user}/.backup/exclude-from
```

##### FAQs

> Why sudo?

Because `rsync -a`.

> I don't understand how the [exclude-from](./exclude-from.example) file works. Help?!

It's just an rsync option. [See this tutorial](https://sites.google.com/site/rsync2u/home/rsync-tutorial/the-exclude-from-option).

> Allows for multiple hosts?

Yeah, I backup mutliple hosts/machines to the same external drive. This script keeps backups for each `$HOST`:

```
$ tree -L 2 /media/aaron/Samsung-T5/Backups/
/media/aaron/Samsung-T5/Backups/
├── rmbp
│   ├── 2017-03-21
│   ├── 2017-03-22
│   └── 2017-05-15
├── xps13
│   ├── 2019-01-19
│   ├── 2019-10-20
│   ├── 2019-10-26
│   ├── 2019-10-27
│   ├── 2019-11-02
│   ├── 2019-11-16
│   ├── 2019-11-23
│   └── 2019-11-24
└── xps15
    ├── 2019-11-14
    ├── 2019-11-15
    ├── 2019-11-18
    ├── 2019-11-19
    ├── 2019-11-20
    ├── 2019-11-21
    ├── 2019-11-22
    └── 2019-11-25
```

> Where's the log?

Within the days backup directory. It's called `backup.log`
