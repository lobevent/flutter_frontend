import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

class PickImageWidget extends StatefulWidget {
  const PickImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  _PickImageWidgetState createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormCubit, EventFormState>(
        builder: (context, state) {
            return _ImageButton(context, state);
    
        }
    );
  }
}

Widget _ImageButton(BuildContext context, EventFormState state){
  const RaisedButton(
                onPressed: state.event.id,
                child: Text('Choose Image'),
              );
}
