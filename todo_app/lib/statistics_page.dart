import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:todo_app/main.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String selectedSortBy = ''; // Holds the selected "Sort by" button
  String selectedDisplayBy = 'Week'; // Default
  String selectedGraphStyle = 'Pie'; 

  
  final List<Todo> tasks = [];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final List<Todo> tasks = appState.taskList;
    print(tasks);
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Review'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sort by section
              _buildSortBySection(),
              SizedBox(width: 8),
              // Display by Section
              _buildDisplayBySection(),
              SizedBox(width: 8),
              // Graph Syle Section
              _buildGraphStyleSection(),
              SizedBox(width: 16),
              // Graph display
              Expanded(
                child: _buildGraph(tasks)
              ),
              SizedBox(height: 16.0),
              _buildStatisticsSummary(tasks),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraph(List<Todo> tasks) {
    if (selectedGraphStyle == 'Pie') {
      return PieChart(PieChartData(
        sections: _buildPieChartSections(tasks),
      ));
    } else if (selectedGraphStyle == 'Histogram') {
      return BarChart(
        BarChartData(
          barGroups: _buildStackedBarChartSections(tasks),
          titlesData: FlTitlesData(),
          borderData: FlBorderData(show: false), // Customize borders
          barTouchData: BarTouchData(enabled: true), // Enable interactions
      ));
    } else if (selectedGraphStyle == 'Line') {
      return LineChart(
        LineChartData(
          lineBarsData: _buildLineChartSections(tasks),
          titlesData: FlTitlesData(
            // You can customize axis titles here
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Customize bottom titles if needed
                  return Text(value == 0 ? 'Start' : 'End');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          lineTouchData: LineTouchData(enabled: true),
      ));
    }
    return const Center(child: Text('Select a graph style.'));
  }

  List<PieChartSectionData> _buildPieChartSections(List<Todo> tasks) {
    final completedCount = tasks.where((todo) => todo.isCompleted).length;
    final missedCount = tasks.where((todo) => todo.isMissed).length;
    final pendingCount = tasks.where((todo) => !todo.isCompleted && !todo.isMissed).length;

    final totalCount = tasks.length;
    print('$completedCount, $missedCount, $pendingCount, $totalCount');

    if (totalCount == 0) {
      return [];
    }

    return [
      PieChartSectionData(
        color: Colors.green,
        value: (completedCount / totalCount) * 100,
        title: '${((completedCount / totalCount) * 100).toStringAsFixed(1)}%',
      ),
      PieChartSectionData(
        color: Colors.red,
        value: (missedCount / totalCount) * 100,
        title: '${((missedCount / totalCount) * 100).toStringAsFixed(1)}%',
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: (pendingCount / totalCount) * 100,
        title: '${((pendingCount / totalCount) * 100).toStringAsFixed(1)}%',
      ),
    ];
  }

  List<BarChartGroupData> _buildStackedBarChartSections(List<Todo> tasks) {
    // Calculate counts
    final completedCount = tasks.where((todo) => todo.isCompleted).length;
    final missedCount = tasks.where((todo) => todo.isMissed).length;
    final pendingCount = tasks.where((todo) => !todo.isCompleted && !todo.isMissed).length;

    final totalCount = tasks.length;

    print('$completedCount, $missedCount, $pendingCount, $totalCount');

    if (totalCount == 0) {
      return [];
    }

    // Create a single bar group for the counts
    return [
      BarChartGroupData(
        x: 0, // X-coordinate index for this group
        barRods: [
          BarChartRodData(toY: missedCount.toDouble(), color: Colors.red),
          BarChartRodData(toY: completedCount.toDouble(), color: Colors.green),
          BarChartRodData(toY: pendingCount.toDouble(), color: Colors.blue),
          BarChartRodData(toY: totalCount.toDouble(), color: const Color.fromARGB(255, 82, 33, 243)),
        ],
      ),
    ];
  }

  List<LineChartBarData> _buildLineChartSections(List<Todo> tasks) {
    // Calculate counts
    final completedCount = tasks.where((todo) => todo.isCompleted).length;
    final missedCount = tasks.where((todo) => todo.isMissed).length;
    final pendingCount = tasks.where((todo) => !todo.isCompleted && !todo.isMissed).length;

    final totalCount = tasks.length;

    print('$completedCount, $missedCount, $pendingCount, $totalCount');

    if (totalCount == 0) {
      return [];
    }

    // Create line chart data
    return [
      // Missed tasks line
      LineChartBarData(
        isCurved: true,
        color: Colors.red,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(0, missedCount.toDouble()),
          FlSpot(1, missedCount.toDouble()),
        ],
      ),
      // Completed tasks line
      LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(0, completedCount.toDouble()),
          FlSpot(1, completedCount.toDouble()),
        ],
      ),
      // Pending tasks line
      LineChartBarData(
        isCurved: true,
        color: Colors.blue,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(0, pendingCount.toDouble()),
          FlSpot(1, pendingCount.toDouble()),
        ],
      ),
      // Total tasks line
      LineChartBarData(
        isCurved: true,
        color: const Color.fromARGB(255, 82, 33, 243),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(0, totalCount.toDouble()),
          FlSpot(1, totalCount.toDouble()),
        ],
      ),
    ];
  }

//   int _getWeekOfMonth(DateTime date) {
//   return ((date.day - 1) ~/ 7) + 1;
// }

  double _getMaxTaskCount(List<Todo> tasks, String selectedDisplayBy) {
  switch (selectedDisplayBy) {
    case 'Week':
      return tasks.length.toDouble(); // Maximum possible tasks in a week
    case 'Month':
      return tasks.length.toDouble(); // Maximum possible tasks in a month
    case 'Year':
      return tasks.length.toDouble(); // Maximum possible tasks in a year
    default:
      return 10; // Default fallback
  }
}

  Widget _buildStatisticsSummary(List<Todo> tasks) {
    final completedCount = tasks.where((todo) => todo.isCompleted).length;
    final missedCount = tasks.where((todo) => todo.isMissed).length;
    final pendingCount = tasks.where((todo) => !todo.isCompleted && !todo.isMissed).length;

    final totalCount = tasks.length;

    // Summarize tasks in a readable format - To uncomment to check list state
    // final tasksummary = tasks.map((todo) => '${todo.title} (${todo.isCompleted ? "Completed" : todo.isMissed ? "Missed" : "Pending"})').join('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('Tasks Summary:\n$tasksummary'), // Un-comment to check list state
        Text('Completed: $completedCount', style: TextStyle(color: Colors.green, fontSize: 16)),
        Text('Missed: $missedCount', style: TextStyle(color: Colors.red, fontSize: 16)),
        Text('Pending: $pendingCount', style: TextStyle(color: Colors.blue, fontSize: 16)),
        Text('Total: $totalCount', style: TextStyle(color: const Color.fromARGB(255, 82, 33, 243))),
      ],
    );
  }

  Widget _buildSortBySection(){
    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sort by',
          style: TextStyle(fontSize: 12), // Smaller font size for the text
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              selectedSortBy = selectedSortBy == 'All tasks' ? '' : 'All tasks';
            });
          },
          icon: Icon(Icons.computer, size: 16),
          label: Text(
            'All tasks',
            style: TextStyle(fontSize: 10),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedSortBy == 'All tasks'
                ? Theme.of(context).colorScheme.primary
                : null,
            foregroundColor: selectedSortBy == 'All tasks'
                ? Theme.of(context).colorScheme.onPrimary // Contrasting text/icon color
                : null,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(50, 30),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              selectedSortBy = selectedSortBy == 'Tag/Competences' ? '' : 'Tag/Competences';
            });
          },
          icon: Icon(Icons.label, size: 16), // Smaller icon
          label: Text(
            'Tag/Competences',
            style: TextStyle(fontSize: 10), // Smaller font size for the button text
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedSortBy == 'Tag/Competences'
                ? Theme.of(context).colorScheme.primary
                : null,
            foregroundColor: selectedSortBy == 'Tag/Competences'
                ? Theme.of(context).colorScheme.onPrimary // Contrasting text/icon color
                : null,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Smaller padding
            minimumSize: Size(50, 30), // Minimum size of the button
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayBySection(){
    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Display by',
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              selectedDisplayBy = selectedDisplayBy == 'Week' ? '' : 'Week';
            });
          },
          icon: Icon(Icons.calendar_view_week, size: 16),
          label: Text(
            'Week',
            style: TextStyle(fontSize: 10),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedDisplayBy == 'Week'
                ? Theme.of(context).colorScheme.primary
                : null,
            foregroundColor: selectedDisplayBy == 'Week'
                ? Theme.of(context).colorScheme.onPrimary // Contrasting text/icon color
                : null,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(50, 30),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              selectedDisplayBy = selectedDisplayBy == 'Month' ? '' : 'Month';
            });
          },
          icon: Icon(Icons.calendar_view_month, size: 16),
          label: Text(
            'Month',
            style: TextStyle(fontSize: 10),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedDisplayBy == 'Month'
                ? Theme.of(context).colorScheme.primary
                : null,
            foregroundColor: selectedDisplayBy == 'Month'
                ? Theme.of(context).colorScheme.onPrimary // Contrasting text/icon color
                : null,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(50, 30),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              selectedDisplayBy = selectedDisplayBy == 'Year' ? '' : 'Year';
            });
          },
          icon: Icon(Icons.calendar_today, size: 16),
          label: Text(
            'Year',
            style: TextStyle(fontSize: 10),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedDisplayBy == 'Year'
                ? Theme.of(context).colorScheme.primary
                : null,
            foregroundColor: selectedDisplayBy == 'Year'
                ? Theme.of(context).colorScheme.onPrimary // Contrasting text/icon color
                : null,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(50, 30),
          ),
        ),
      ],
    );
  }

  Widget _buildGraphStyleSection(){
    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Graph Style',
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              selectedGraphStyle = selectedGraphStyle == 'Pie' ? '' : 'Pie';
            });
          },
          icon: Icon(Icons.pie_chart, size: 16),
          label: Text(
            'Pie',
            style: TextStyle(fontSize: 10),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedGraphStyle == 'Pie'
                ? Theme.of(context).colorScheme.primary
                : null,
            foregroundColor: selectedGraphStyle == 'Pie'
                ? Theme.of(context).colorScheme.onPrimary // Contrasting text/icon color
                : null,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(50, 30),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              selectedGraphStyle = selectedGraphStyle == 'Histogram' ? '' : 'Histogram';
            });
          },
          icon: Icon(Icons.insert_chart, size: 16),
          label: Text(
            'Histogram',
            style: TextStyle(fontSize: 10),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedGraphStyle == 'Histogram'
                ? Theme.of(context).colorScheme.primary
                : null,
            foregroundColor: selectedGraphStyle == 'Histogram'
                ? Theme.of(context).colorScheme.onPrimary // Contrasting text/icon color
                : null,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(50, 30),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              selectedGraphStyle = selectedGraphStyle == 'Line' ? '' : 'Line';
            });
          },
          icon: Icon(Icons.show_chart, size: 16),
          label: Text(
            'Line',
            style: TextStyle(fontSize: 10),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedGraphStyle == 'Line'
                ? Theme.of(context).colorScheme.primary
                : null,
            foregroundColor: selectedGraphStyle == 'Line'
                ? Theme.of(context).colorScheme.onPrimary // Contrasting text/icon color
                : null,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(50, 30),
          ),
        ),
      ],
    );
  }
}