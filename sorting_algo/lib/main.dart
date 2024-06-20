import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SortingVisualizerScreen());
  }
}

class SortingVisualizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SortingVisualizerScreen(),
    );
  }
}

class SortingVisualizerScreen extends StatefulWidget {
  @override
  _SortingVisualizerScreenState createState() =>
      _SortingVisualizerScreenState();
}

class _SortingVisualizerScreenState extends State<SortingVisualizerScreen> {
  List<int> _array = List<int>.generate(10, (_) => Random().nextInt(100));
  String _selectedAlgorithm = 'Bubble Sort';
  int _iterations = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _shuffleArray() {
    setState(() {
      _array = List<int>.generate(10, (_) => Random().nextInt(100));
      _iterations = 0;
    });
  }

  void _startSorting() {
    switch (_selectedAlgorithm) {
      case 'Bubble Sort':
        _bubbleSort();
        break;
      case 'Selection Sort':
        _selectionSort();
        break;
      case 'Insertion Sort':
        _insertionSort();
        break;
      case 'Quick Sort':
        _quickSort(0, _array.length - 1);
        break;
    }
  }

  void _bubbleSort() {
    int n = _array.length;
    int i = 0;
    int j = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (i < n) {
          if (j < n - i - 1) {
            if (_array[j] > _array[j + 1]) {
              int temp = _array[j];
              _array[j] = _array[j + 1];
              _array[j + 1] = temp;
            }
            j++;
            _iterations++;
          } else {
            j = 0;
            i++;
          }
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _selectionSort() {
    int n = _array.length;
    int i = 0;
    int j = 0;
    int minIndex = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (i < n - 1) {
          if (j < n) {
            if (_array[j] < _array[minIndex]) {
              minIndex = j;
            }
            j++;
            _iterations++;
          } else {
            int temp = _array[minIndex];
            _array[minIndex] = _array[i];
            _array[i] = temp;
            i++;
            j = i + 1;
            minIndex = i;
          }
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _insertionSort() {
    int n = _array.length;
    int i = 1;
    int j = 1;
    int key = _array[1];
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (i < n) {
          if (j > 0 && _array[j - 1] > key) {
            _array[j] = _array[j - 1];
            j--;
            _iterations++;
          } else {
            _array[j] = key;
            i++;
            if (i < n) {
              j = i;
              key = _array[i];
            }
          }
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _quickSort(int low, int high) {
    if (low < high) {
      int pi = _partition(low, high);
      _quickSort(low, pi - 1);
      _quickSort(pi + 1, high);
    }
  }

  int _partition(int low, int high) {
    int pivot = _array[high];
    int i = (low - 1);
    for (int j = low; j <= high - 1; j++) {
      if (_array[j] < pivot) {
        i++;
        int temp = _array[i];
        _array[i] = _array[j];
        _array[j] = temp;
      }
    }
    int temp = _array[i + 1];
    _array[i + 1] = _array[high];
    _array[high] = temp;
    return (i + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorting Visualizer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedAlgorithm,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAlgorithm = newValue!;
                    });
                  },
                  items: <String>[
                    'Bubble Sort',
                    'Selection Sort',
                    'Insertion Sort',
                    'Quick Sort'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _startSorting,
                  child: Text('Start Sorting'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _shuffleArray,
                  child: Text('Shuffle Array'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Column(
                  children: _array
                      .map((value) => Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(value.toString()),
                          ))
                      .toList(),
                ),
                SizedBox(width: 10),
                Column(
                  children: List.generate(
                      10,
                      (index) => Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(index < _iterations
                                ? (_iterations - index).toString()
                                : ''),
                          )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
