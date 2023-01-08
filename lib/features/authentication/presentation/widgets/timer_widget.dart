// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stop_watch_timer/stop_watch_timer.dart';
// import 'package:waslny_captain/resources/colors_manager.dart';
// import 'package:waslny_captain/resources/constants_manager.dart';
//
// import '../../cubits/auth_cubit.dart';
//
// class TimerWidget extends StatefulWidget {
//   const TimerWidget({Key? key}) : super(key: key);
//
//   @override
//   State<TimerWidget> createState() => _TimerWidgetState();
// }
//
// class _TimerWidgetState extends State<TimerWidget> {
//   //
//   late StopWatchTimer _stopWatchTimer;
//   //
//   @override
//   void dispose() async {
//     super.dispose();
//     await _stopWatchTimer.dispose();
//   }
//
//   @override
//   void initState() {
//     initTimer();
//     super.initState();
//   }
//
//   initTimer() async {
//     _stopWatchTimer = StopWatchTimer(
//       mode: StopWatchMode.countDown,
//       onStop: () {},
//       onEnded: () {
//         AuthCubit.getIns(context).activeResendButton();
//       },
//     );
//     _stopWatchTimer.setPresetSecondTime(ConstantsManager.smsTimer);
//     _stopWatchTimer.onExecute.add(StopWatchExecute.start);
//   }
//
//   //
//   @override
//   Widget build(BuildContext context) {
//     final showResendButton =
//         BlocProvider.of<AuthCubit>(context, listen: true).showResendButton;
//     return StreamBuilder<int>(
//       stream: _stopWatchTimer.rawTime,
//       initialData: _stopWatchTimer.rawTime.value,
//       builder: (context, snap) {
//         final value = snap.data!;
//         final displayTime = StopWatchTimer.getDisplayTime(
//           value,
//           milliSecond: false,
//           second: true,
//           minute: true,
//           hours: false,
//         );
//         return Text(
//           displayTime,
//           style: !showResendButton
//               ? Theme.of(context).textTheme.subtitle2
//               : Theme.of(context)
//                   .textTheme
//                   .subtitle2!
//                   .copyWith(color: ColorsManager.greyColor),
//         );
//       },
//     );
//   }
// }
