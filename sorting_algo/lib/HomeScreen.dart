// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api

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
      case 'Insertion Sort':
        _insertionSort();
        break;
      case 'Quick Sort':
        _quickSort(0, _array.length - 1);
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

  void _insertionSort() {
    int n = _array.length;
    int i = 1;
    int j = 1;
    int key = _array[1];
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (i < n) {
          _stillIterations(i, j, key, n);
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _stillIterations(int i, int j, int key, int n) {
    _currentIndex = j;
    _nextIndex = j - 1;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (low <= high - 1) {
          _currentIndex = low;
          _nextIndex = high;
          if (_array[low] < pivot) {
            i++;
            int temp = _array[i];
            _array[i] = _array[low];
            _array[low] = temp;
          }
          low++;
          _iterations++;
        } else {
          int temp = _array[i + 1];
          _array[i + 1] = _array[high];
          _array[high] = temp;
          timer.cancel();
        }
      });
    });
    return (i + 1);
  }

  void resetIteration(String? newValue) {
    setState(() {
      _selectedAlgorithm = newValue!;
      _iterations = 0; // Reset iterations on algorithm change
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
            'Insertion Sort',
            'Quick Sort'
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
                            ? Colors.yellow
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
