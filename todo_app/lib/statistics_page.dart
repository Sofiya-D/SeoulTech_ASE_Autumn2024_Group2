import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String selectedSortBy = ''; // Holds the selected "Sort by" button
  String selectedDisplayBy = ''; // Holds the selected "Display by" button
  
  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        Positioned(
          top: 16, // Distance from the top
          right: 16, // Distance from the right
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Aligns children to the right
            children: [
              // "Sort by" Section
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sort by',
                    style: TextStyle(fontSize: 12), // Smaller font size for the text
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedSortBy = selectedSortBy == 'Tag/Label' ? '' : 'Tag/Label';
                      });
                    },
                    icon: Icon(Icons.label, size: 16), // Smaller icon
                    label: Text(
                      'Tag/Label',
                      style: TextStyle(fontSize: 10), // Smaller font size for the button text
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSortBy == 'Tag/Label'
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Smaller padding
                      minimumSize: Size(50, 30), // Minimum size of the button
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedSortBy = selectedSortBy == 'Competences' ? '' : 'Competences';
                      });
                    },
                    icon: Icon(Icons.computer, size: 16),
                    label: Text(
                      'Competences',
                      style: TextStyle(fontSize: 10),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSortBy == 'Competences'
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size(50, 30),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16), // Space between the two sections

              // "Display by" Section
              Row(
                mainAxisSize: MainAxisSize.min,
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
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size(50, 30),
                    ),
                  ),
                ],
              ),

              // Display Selected Options
              Text(
                'Selected Options:',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                'Sort by: ${selectedSortBy.isEmpty ? "None" : selectedSortBy}, '
                'Display by: ${selectedDisplayBy.isEmpty ? "None" : selectedDisplayBy}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

