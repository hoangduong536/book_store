

import 'package:book_store/base/base_bloc.dart';
import 'package:book_store/base/base_event.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BlocListener<T extends BaseBloc> extends StatefulWidget {
  final Widget child;
  final Function(BaseEvent event) listener;

  BlocListener({
    @required this.child,
    @required this.listener,
  });

  @override
  _BlocListenerState createState() => _BlocListenerState<T>();

}

class _BlocListenerState<T> extends State<BlocListener> {


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("BlocListener - didChangeDependencies ======================");


    var bloc = Provider.of<T>(context) as BaseBloc;
    bloc.processEventStream.listen(
          (event) {
        print("BlocListener - didChangeDependencies processEventStream.listen ======================");
        widget.listener(event);

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("BlocListener - StatefulWidget - build ======================");
    return StreamProvider<BaseEvent>.value(
      value: (Provider.of<T>(context) as BaseBloc).processEventStream,
      initialData: null,
      updateShouldNotify: (prev, current) {
        return false;
      },
      child: Consumer<BaseEvent>(
        builder: (context, event, child) {

          return Container(
            child: widget.child,
          );
        },
      ),
    );
  }
}
