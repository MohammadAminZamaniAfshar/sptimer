import 'package:get/get.dart';
import 'package:pomotimer/data/models/pomodoro_timer_model.dart';
import 'package:pomotimer/data/pomodoro_timer/pomodoro_timer.dart';
import 'package:pomotimer/ui/screens/home/home_screen_controller.dart';
import 'package:pomotimer/ui/widgets/widgets.dart';

class UiController {
  final CustomSliderController _sliderController = Get.find();
  final CountdownTimerController _countdownTimerController = Get.find();
  final HomeScreenController _homeScreenController = Get.find();
  final CircleAnimatedButtonController _circleAnimatedButtonController = Get.find();

  late PomodoroTimer _pomodoroTimer;

  PomodoroTimerModel get data => _pomodoroTimer.data;

  bool get isStarted => _pomodoroTimer.isStarted;

  void init(PomodoroTimerModel? data) {
    _pomodoroTimer = PomodoroTimer(
      data: data,
      onRestartTimer: onPomodoroTimerRestart,
      onFinish: onPomodoroTimerFinish,
    );
    _countdownTimerController.maxDuration = _pomodoroTimer.maxDuration;
    _countdownTimerController.remainingDuration = _pomodoroTimer.remainingDuration;
    if (data != null) {
      _pomodoroTimer.start();
      _countdownTimerController.start();
      _sliderController.sliderValue = _pomodoroTimer.maxRound!.toDouble();
      _sliderController.deactivate();
      _circleAnimatedButtonController.startAnimation();
    }
  }

  void onStart() {
    _countdownTimerController.start();
    _pomodoroTimer.start(_sliderController.sliderValue.toInt());
    _homeScreenController.showGradiantColor(true);
    _sliderController.deactivate();
  }

  void onPause() {
    _countdownTimerController.pause();
    _pomodoroTimer.stop();
  }

  void onResume() {
    _countdownTimerController.resume();
    _pomodoroTimer.start();
  }

  void onCancel() {
    _pomodoroTimer.cancel();
    _countdownTimerController.maxDuration = _pomodoroTimer.maxDuration;
    _countdownTimerController.cancel();
    _homeScreenController.showGradiantColor(false);
    _sliderController.activate();
  }

  void onPomodoroTimerFinish() {
    _countdownTimerController.maxDuration = _pomodoroTimer.maxDuration;
    _countdownTimerController.cancel();
    _circleAnimatedButtonController.finishAnimation();
    _homeScreenController.showGradiantColor(false);
    _sliderController.activate();
  }

  Future<void> onPomodoroTimerRestart() async {
    _countdownTimerController.maxDuration = _pomodoroTimer.maxDuration;
    await _countdownTimerController.restart();
  }
}
