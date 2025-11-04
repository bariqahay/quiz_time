import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool? _isTimed; // null = belum pilih mode

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _selectMode(bool isTimed) {
    setState(() {
      _isTimed = isTimed;
    });
  }

  void _startQuiz() {
    if (_formKey.currentState!.validate()) {
      if (_isTimed == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Pilih Mode Kuis'),
            content: const Text(
              'Silakan pilih mode Normal atau Timed terlebih dahulu.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              userName: _nameController.text.trim(),
              isTimed: _isTimed!,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final horizontalPadding =
        isTablet ? screenWidth * 0.15 : screenWidth * 0.06;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Theme Toggle
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: widget.toggleTheme,
                      icon: Icon(
                        widget.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        size: isTablet ? 32 : 28,
                      ),
                      tooltip:
                          widget.isDarkMode ? 'Light Mode' : 'Dark Mode',
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Icon/Illustration
                  Container(
                    width: isTablet ? 200 : 150,
                    height: isTablet ? 200 : 150,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo_quiz.png',
                      width: isTablet ? 100 : 80,
                      height: isTablet ? 100 : 80,
                      fit: BoxFit.contain,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Title
                  Text(
                    'Quiz App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 42 : 32,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Subtitle
                  Text(
                    'Uji pengetahuanmu dengan kuis menarik!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      color: theme.colorScheme.onSurface.withAlpha(180),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  // Name Input Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Masukkan Nama Anda',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Nama Lengkap',
                            prefixIcon: Icon(
                              Icons.person,
                              size: isTablet ? 28 : 24,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }
                            if (value.trim().length < 3) {
                              return 'Nama minimal 3 karakter';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).unfocus(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          imagePath: 'assets/icons/icon_list.png',
                          title: '10 Pertanyaan',
                          subtitle: 'Uji kemampuanmu',
                          isTablet: isTablet,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          imagePath: 'assets/icons/icon_timer.png',
                          title: 'Bebas Waktu',
                          subtitle: 'Atur sendiri waktumu',
                          isTablet: isTablet,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Mode Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectMode(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isTimed == false
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            foregroundColor: _isTimed == false
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primary,
                            side: BorderSide(
                                color: theme.colorScheme.primary, width: 1),
                          ),
                          child: const Text('Normal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectMode(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isTimed == true
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            foregroundColor: _isTimed == true
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primary,
                            side: BorderSide(
                                color: theme.colorScheme.primary, width: 1),
                          ),
                          child: const Text('Timed'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Start Button
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 64 : 56,
                    child: ElevatedButton(
                      onPressed: _startQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: Text(
                        'Mulai Kuis',
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool isTablet;

  const _InfoCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: isTablet ? 48 : 36,
              height: isTablet ? 48 : 36,
              fit: BoxFit.contain,
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: isTablet ? 6 : 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: theme.colorScheme.onSurface.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
