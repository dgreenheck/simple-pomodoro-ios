# SimplePomodoro

## Introduction
While I was preparing for iOS Developer interviews, I realized I wasn't taking as many breaks as I needed to stand up and stretch. That gave me the idea to create a simple Pomoodoro timer app. There's a billion of these on the app store already (for that reason I won't be able to publish it), but I thought it would be a fun, simple project to add to my portfolio. Plus, it will keep me sane and healthy during my study sessions!

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

## Architecture

### CountdownTimer
This is the fundamental building block of the application. It is a simple countdown timer object with the following methods

- start()
- stop()
- pause()

The timerTick(currentTime:) and timerFinished() events are exposed via the delegate design pattern.

### PomodoroTimer
While I could have stuffed everything into a single timer object, I thought it would be a bit cleaner to abstract out the fundamental CountdownTimer object, then have a second abstraction layer to handle the "Pomodoro" behavior.

The PomodoroTimer class handles the transition between the "focus" timer and the "rest" timer. Events corresponding to the start and end of each period are passed on to the delegate to initiate UI actions such as displaying message boxes or playing alerts.

## Skills Demonstrated
- **Animation**: One of my goals in this project was producing something that mimicked an Apple app. When you click on the focus time or the break time, a hidden table view cell is expanded to reveal a time picker.
- **Delegation**: Messages from the CountdownTimer/PomodoroTimer objects are passed to the view controller via the delegation design pattern.
- **Custom UI Controls**: The buttons have a custom draw() function to have the same appearance as the Start/Pause/Stop buttons on the iOS built-in timer app.
- **TableView**: Timer settings are presented to as a scrollable UITableView
- **Timer**: In a timer app, you need to use timers! To get the countdown time to continually update I scheduled a timer that would trigger every second. I maintained the current countdown time in a separate staet.
- **Unit Testing**: All core classes are unit tested, achieving > 93% code coverage.
- **UI Testing**: Several functional tests are performed to verify the UI responds accordingly to user actions.

## Future Work
- Push notifications for timer events while app is running in the background
- Select the alarm sound
