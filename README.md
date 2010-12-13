# Nodewise

Nodewise is a web-application for managing [Baltimore
Node](http://baltimorenode.org) and other organizations like it. We are a
self-organizing collection of tech oriented folks whose interests have aligned
long enough to collect a membership fee, rent a work shop, and vote on things.

See our door project notes at:
[http://wiki.baltimorenode.org/index.php?title=RFID_door_lock](http://wiki.baltimorenode.org/index.php?title=RFID_door_lock).

This project is inspired in part by [the Open Door
Hackathon](http://opendoor.eventbrite.com/), but is not intended as serious
competion.

## Vision

A hackerspace membership system should present the members as the most important
part of the organization. The space comes second and third are all the
administrative details. Things like money, inventory, and schedule may be
considered part of the space but are probably administrative details.

### I. Members

* Information they want to make public, stuff that's okay to be connected to the
outside world. Outward facing: as little or as much as the member decides.
* Inward facing: control of their membership, information about their dues,
access to basic contact info for other members.
* Dues Information System - organizing information about schedules and status so
financial officer can tell who's overdue and members can check on their own
payment history.
* Voting Management System - we do a lot of voting on the mailing list these
days, it makes sense to bring it into this application since we'll have a better
handle on history and be able to better control the process. Plus, maybe we can
play with some totally sweet voting algorithms.


### II. The Space

* Workshop control: access control (as it concerns the space) and environment (lights,
temperature).
* Workshop information: Pachube feeds, X10, webcam, etc.

### III. Administrivia

* This is mostly money focused.
* This is the secure inner functionality, the stuff no one on the outside should
have access to. 
* Only the treasurer should have the ability to modify the money area.
* This area could also include living membership documents such as:
bylaws, meeting notes, calendars, and a web-based storefront.

This stuff is relegated to third place since this area of the application seems
open-ended enough to provide a lot of "you know what you should do..." and
"somebody should..." moments. Anything that could be considered feature bloat
should be shoved under the heading of administrivia and ignored until the urge
passes.

## Other Stuff

### Hacking

You'll need ruby, at least 1.8.7. I'd also highly recommend [rvm](rvm.beginrescueend.com). 

Once you've downloaded the source, run `bundle install` and `cp
config/database.local.yml config/database.yml`.

Once those are finished, you should be able to run the tests and a local server.

### License

[Just Use It](http://sam.zoy.org/wtfpl/)
