// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MainUI extends StatefulWidget {
  @override
  _MainUIState createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  List<int> _array = List<int>.generate(10, (_) => Random().nextInt(100));
  String _selectedAlgorithm = 'Bubble Sort';
  int _iterations = 0;
  Timer? _timer;
  int _currentIndex = -1;
  int _nextIndex = -1;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _shuffleArray() {
    setState(() {
      _array = List<int>.generate(10, (_) => Random().nextInt(100));
      _iterations = 0;
      _currentIndex = -1;
      _nextIndex = -1;
      _timer?.cancel();
    });
  }

  void _startSorting() {
    _timer?.cancel();
    setState(() {
      _iterations = 0;
    });
    switch (_selectedAlgorithm) {
      case 'Bubble Sort':
        _bubbleSort();
        break;
      case 'Selection Sort':
        _selectionSort();
        break;
      case 'Heap Sort':
        _heapSort();
        break;
      case 'Shell Sort':
        _shellSort();
        break;
    }
  }

  void _stopSorting() {
    _timer?.cancel();
  }

  void _bubbleSort() {
    int n = _array.length;
    int i = 0;
    int j = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (i < n) {
          if (j < n - i - 1) {
            _currentIndex = j;
            _nextIndex = j + 1;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (i < n - 1) {
          if (j < n) {
            _currentIndex = i;
            _nextIndex = j;
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

  void _heapSort() {
    int n = _array.length;

    for (int i = n ~/ 2 - 1; i >= 0; i--) _heapify(n, i);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (n > 1) {
          int temp = _array[0];
          _array[0] = _array[n - 1];
          _array[n - 1] = temp;

          n--;
          _heapify(n, 0);
        } else {
          timer.cancel();
        }
        _iterations++;
      });
    });
  }

  void _heapify(int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && _array[left] > _array[largest]) largest = left;

    if (right < n && _array[right] > _array[largest]) largest = right;

    if (largest != i) {
      int swap = _array[i];
      _array[i] = _array[largest];
      _array[largest] = swap;

      _heapify(n, largest);
    }
  }

  void _shellSort() {
    int n = _array.length;
    for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
      for (int i = gap; i < n; i++) {
        int temp = _array[i];
        int j;
        for (j = i; j >= gap && _array[j - gap] > temp; j -= gap) {
          _array[j] = _array[j - gap];
          _iterations++;
        }
        _array[j] = temp;
      }
    }
  }

  void resetIteration(String? newValue) {
    setState(() {
      _selectedAlgorithm = newValue!;
      _iterations = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buttonsPart(),
          ),
          const SizedBox(height: 20),
          Text('Iterations: $_iterations'),
          _arrayPart(),
        ],
      ),
    );
  }

  Row _buttonsPart() {
    return Row(
      children: [
        DropdownButton<String>(
          value: _selectedAlgorithm,
          onChanged: (String? newValue) {
            resetIteration(newValue);
          },
          items: <String>[
            'Bubble Sort',
            'Selection Sort',
            'Heap Sort',
            'Shell Sort',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _startSorting,
          child: const Text('Start Sorting'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _shuffleArray,
          child: const Text('Shuffle Array'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _stopSorting,
          child: const Text('Stop Sorting'),
        ),
      ],
    );
  }

  Row _arrayPart() {
    return Row(
      children: [
        Column(
          children: _array
              .asMap()
              .map((index, value) => MapEntry(
                    index,
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == _currentIndex || index == _nextIndex
                            ? const Color.fromARGB(255, 87, 153, 240)
                            : Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(value.toString()),
                    ),
                  ))
              .values
              .toList(),
        ),
      ],
    );
  }
}
