import 'package:flutter/material.dart';

class SessionSchedulePage extends StatefulWidget {
  const SessionSchedulePage({super.key});

  @override
  State<SessionSchedulePage> createState() => _SessionSchedulePageState();
}

class _SessionSchedulePageState extends State<SessionSchedulePage> {
  DateTime? selectedDate;
  String? selectedTime;
  
  final List<String> availableTimeSlots = [
    '9:00',
    '10:00',
    '13:00',
    '14:00',
    '16:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      appBar: AppBar(
        title: const Text('Schedule Session'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Select Date and Time Section
            const Text(
              'Select Date and Time',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Date Selection
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Color(0xFFE91E63)),
                title: Text(
                  selectedDate != null 
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Select Date',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFFE91E63), // Pink color
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 30),

            // Available Time Slots
            const Text(
              'Available time slots',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),

            // Time Slot Buttons
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: availableTimeSlots.map((timeSlot) {
                final isSelected = selectedTime == timeSlot;
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedTime = timeSlot;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected 
                      ? const Color(0xFFE91E63) // Pink when selected
                      : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected 
                          ? const Color(0xFFE91E63)
                          : Colors.grey[300]!,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    timeSlot,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 50),

            // Confirm Button
            ElevatedButton(
              onPressed: (selectedDate != null && selectedTime != null) 
                ? () {
                    // TODO: Implement session confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Session scheduled for ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at $selectedTime',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63), // Pink button
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 