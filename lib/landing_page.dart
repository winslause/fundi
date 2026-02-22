import 'package:flutter/material.dart';
import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive adjustments
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.brown.shade50,
              Colors.brown.shade100,
              Colors.orange.shade50,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 500,
                      maxHeight: isSmallScreen ? screenHeight * 0.85 : 600,
                    ),
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.shade300.withOpacity(0.3),
                          blurRadius: 25,
                          offset: const Offset(8, 8),
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 15,
                          offset: const Offset(-4, -4),
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Smaller logo for small screens
                            Container(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.amber.shade700,
                                    Colors.deepOrange.shade800,
                                  ],
                                  stops: const [0.3, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepOrange.shade900.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(4, 4),
                                  ),
                                  BoxShadow(
                                    color: Colors.amber.shade200.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(-2, -2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.build_circle,
                                size: isSmallScreen ? 50 : 60,
                                color: Colors.white,
                              ),
                            ),
                            
                            SizedBox(height: isSmallScreen ? 16 : 20),
                            
                            // Title with reduced size on small screens
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.brown.shade900,
                                  Colors.deepOrange.shade800,
                                  Colors.amber.shade800,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                'FUNDI MARKETPLACE',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 24 : 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                  color: Colors.white,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            
                            SizedBox(height: isSmallScreen ? 8 : 12),
                            
                            // Subtitle
                            Text(
                              'Connect with skilled artisans',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: Colors.brown.shade700,
                                fontWeight: FontWeight.w500,
                                shadows: const [
                                  Shadow(
                                    color: Colors.white,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            SizedBox(height: isSmallScreen ? 20 : 24),
                            
                            // Progress indicators - more compact
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildProgressDot(active: true, isSmall: isSmallScreen),
                                const SizedBox(width: 6),
                                _buildProgressDot(active: false, isSmall: isSmallScreen),
                                const SizedBox(width: 6),
                                _buildProgressDot(active: false, isSmall: isSmallScreen),
                              ],
                            ),
                            
                            SizedBox(height: isSmallScreen ? 24 : 28),
                            
                            // Get Started button - more compact
                            Container(
                              width: double.infinity,
                              height: isSmallScreen ? 48 : 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.amber.shade400,
                                    Colors.deepOrange.shade500,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepOrange.shade800.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(4, 4),
                                  ),
                                  BoxShadow(
                                    color: Colors.amber.shade200.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(-2, -2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;
                                          
                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(tween);
                                          
                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration: const Duration(milliseconds: 500),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'GET STARTED',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isSmallScreen ? 14 : 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            shadows: const [
                                              Shadow(
                                                color: Colors.black26,
                                                offset: Offset(1, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: isSmallScreen ? 16 : 18,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ],
),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Add a tiny bit of bottom padding for very small screens
                            if (isSmallScreen) const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDot({required bool active, required bool isSmall}) {
    return Container(
      width: isSmall ? 10 : 12,
      height: isSmall ? 10 : 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: active
              ? [Colors.amber.shade400, Colors.deepOrange.shade500]
              : [Colors.grey.shade400, Colors.grey.shade600],
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: Colors.deepOrange.shade400.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                ),
              ],
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1,
        ),
      ),
    );
  }
}