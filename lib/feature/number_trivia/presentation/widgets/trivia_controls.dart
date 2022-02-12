import 'package:clean_architecture_1/feature/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String? inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            _dispatchConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _dispatchConcrete,
                child: const Text('Search'),
                style: TextButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                    textStyle:
                        TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextButton(
                onPressed: _dispatchRandom,
                child: const Text('Get random trivia'),
                style: TextButton.styleFrom(
                    textStyle:
                        TextStyle(color: Theme.of(context).primaryColor)),
              ),
            )
          ],
        )
      ],
    );
  }

  void _dispatchConcrete() {
    controller.clear();
    if (inputStr != null) {
      BlocProvider.of<NumberTriviaBloc>(context)
          .add(GetTriviaForConcreteNumber(inputStr!));
    }
  }

  void _dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaFromRandomNumber());
  }
}
