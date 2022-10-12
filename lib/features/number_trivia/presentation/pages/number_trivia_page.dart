import 'package:clear_architecture_test_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clear_architecture_test_flutter/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clear_architecture_test_flutter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number trivia')),
      body: SingleChildScrollView(child: buildBody()),
    );
  }
}

class buildBody extends StatelessWidget {
  const buildBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              //Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start Searching',
                    );
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.errorMessage,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              //Bottom half
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
