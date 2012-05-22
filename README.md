# at-random

    at-random [--random-seed seed] [--from HH[:MM]] [--to HH[:MM]] [at-args]

Picks some time
between `--from` and `--to`
(in 24-hour format)
uniformly at random.
Passes the remaining args
(namely `[-q queue] [-f file] [-m]`)
along with standard input
to `at(1)` to run
at that time.

If `--from` is in the past,
`at-random` will re-roll times
until it gets one in the future.
If `--to` is in the past,
it will print an error message
and exit nonzero.

If `--random-seed` is passed,
it will be used to seed the PRNG.


This script can be used to implement random job start times in `cron(8)` with
`crontab(5)` lines like the following:

    # m h dom month dow command
      0 0 0   *     0   at-random --from 12:00 --to 17:00 -f /home/bob/reflect

which runs `at-random` at midnight every Sunday to tell `at(1)` to execute the
contents of `/home/bob/reflect` some time between noon and five PM.
