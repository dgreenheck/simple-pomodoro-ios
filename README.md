# SimplePomodoro

## Introduction

<pre>
<img src="https://github.com/dgreenheck/SimplePomodoro/blob/master/demo/setup.gif" width="250">
</pre>

While I was preparing for iOS Developer interviews, I realized I wasn't taking as many breaks as I needed to stand up and stretch. That gave me the idea to create a simple Pomodoro timer app. There's a billion of these on the app store already (for that reason I won't be able to publish it), but I thought it would be a fun, simple project to add to my portfolio. Plus, it will keep me sane and healthy during my study sessions!

## What is a Pomodoro Timer?
For those of you not familiar, a Pomodoro timer is a two-stage timer. The first timer is the "focus period", which is typically 20 to 25 minutes. After the focus period ends, there is a short "break period" which typically ranges from 3 to 5 minutes.

## Project Goals/Requirements
1. Select the focus period duration between 1 minute and 23 hours 59 minutes.
2. Select the rest period duration between 1 minute and 23 hours 59 minutes.
3. Display the current time at the top of the screen to a resolution of 1 second
4. Optionally, repeat the timer to allow multiple sessions in one sitting.
5. Optionally, display an alert when the timer is finished.
6. Optionally, play an alarm sound when the timer is finished.
7. The app should abide by the Human Interface Guidelines and look similar to an Apple app.
8. Support Dark Mode for iOS 13 devices.
9. Reasonable unit test coverage

## UI Layout

Since this is a simple app, I wanted everything on one screen rather than hiding the timer settings on a separate view controller.

The primary view controller contains the countdown timer label and the start/stop buttons. The timer settings were implemented as a  UITableViewController embedded in a UIContainerView on the primary view controller.

All colors are managed via a ColorManager class to keep consistency across the application.

## Architecture

### CountdownTimer
This is the fundamental building block of the application. It is a simple countdown timer object that implements start/pause/stop methods. Timer tick and elapsed events are broadcast to a delegate implementing the *CountdownTimerDelegate* protocol.

### PomodoroTimer
While I could have stuffed everything into a single timer object, I thought it would be a bit cleaner to abstract out the fundamental *CountdownTimer* object, then have a second abstraction layer to handle the double-timer behavior of the Pomodoro timer.

The *PomodoroTimer* class handles the transition between the "focus" timer and the "rest" timer. Events corresponding to the start and end of each period are passed on to a delegate implementing the *PomodoroTimerProtocol* to initiate UI actions such as displaying message boxes or playing alerts.

## Skills Demonstrated
- **Animation** - One of my goals in this project was producing something that mimicked an Apple app. When you click on the focus time or the break time, a hidden table view cell is expanded to reveal a time picker. The type of animation can be found when selecting start/stop times for an event in the Calendar app.
- **Delegation** - Messages from the *CountdownTimer*/*PomodoroTimer* objects are passed to the view controller using the delegation design pattern. This creates a nice separation between the model logic and the view.
- **Custom UI Controls** - I defined a custom draw() function for the Start/Stop buttons so they have the same appearance as the Start/Stop buttons on the iOS built-in timer app.
- **TableView** - Timer settings are presented as a scrollable UITableView
- **Timer** - In a timer app, you need to use timers! To get the countdown time to continually update I scheduled a timer that would trigger every second. Upon each firing, the internal countdown time is decremented until it reaches zero.
- **Unit Testing** - All model and view controller classes are unit tested, achieving > 93% test coverage. There's still a few test cases that need to be implemented to achieve full coverage.
- **UI Testing** - Several functional tests are performed to verify the UI responds accordingly to user actions. Once again, could use a few more test cases here.

## Future Work
- Push notifications for timer events while app is running in the background
- Select the alarm sound

## Demo

### Setup
<pre>
<img src="https://github.com/dgreenheck/SimplePomodoro/blob/master/demo/setup.gif" width="250">
</pre>
### Focus Timer Elapsed
<pre>
<img src="https://github.com/dgreenheck/SimplePomodoro/blob/master/demo/focus_timer_done.gif" width="250">
</pre>
### Rest Timer Elapsed
<pre>
<img src="https://github.com/dgreenheck/SimplePomodoro/blob/master/demo/break_timer_done.gif" width="250">
</pre>
