import 'package:flutter/material.dart';
import 'models.dart';
import 'data.dart';
import 'components.dart';
import 'modals.dart';

class PaymentPage extends StatefulWidget {
  final Job job;
  final Fundi fundi;
  final Client client;

  const PaymentPage({
    super.key,
    required this.job,
    required this.fundi,
    required this.client,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with TickerProviderStateMixin {
  int _selectedPaymentMethod = 0;
  bool _isProcessing = false;
  bool _termsAccepted = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Payment breakdown
  late double _totalAmount;
  late double _platformFee;
  late double _fundiAmount;
  
  // Form controllers
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _mpesaPhoneController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    // Calculate payment breakdown
    _totalAmount = widget.job.budget;
    _platformFee = _totalAmount * 0.1; // 10% platform fee
    _fundiAmount = _totalAmount - _platformFee; // 90% to fundi
    
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _mpesaPhoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _processPayment() {
    setState(() => _isProcessing = true);
    
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      setState(() => _isProcessing = false);
      
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your payment has been processed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildReceiptRow('Total Paid', MockData.formatCurrency(_totalAmount)),
                    const SizedBox(height: 8),
                    _buildReceiptRow('Platform Fee (10%)', MockData.formatCurrency(_platformFee)),
                    const SizedBox(height: 8),
                    _buildReceiptRow('Fundi Earnings', MockData.formatCurrency(_fundiAmount)),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildReceiptRow(
                      'Transaction ID',
                      'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
                      isBold: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'VIEW RECEIPT',
                    onPressed: () {
                      Navigator.pop(context);
                      _showReceipt();
                    },
                    width: 200,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
  
  Widget _buildReceiptRow(String label, String value, {bool isBold = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? const Color(0xFF2C2C2C) : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
  
  void _showReceipt() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PaymentReceiptModal(
        job: widget.job,
        fundi: widget.fundi,
        client: widget.client,
        totalAmount: _totalAmount,
        platformFee: _platformFee,
        fundiAmount: _fundiAmount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Complete Payment',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Summary Card
                        _buildJobSummary(),
                        
                        const SizedBox(height: 20),
                        
                        // Payment Breakdown Card
                        _buildPaymentBreakdown(),
                        
                        const SizedBox(height: 20),
                        
                        // Payment Methods
                        _buildPaymentMethods(),
                        
                        const SizedBox(height: 20),
                        
                        // Payment Form (based on selected method)
                        if (_selectedPaymentMethod == 0) _buildCardPaymentForm(),
                        if (_selectedPaymentMethod == 1) _buildMpesaPaymentForm(),
                        if (_selectedPaymentMethod == 2) _buildBankPaymentForm(),
                        
                        const SizedBox(height: 20),
                        
                        // Terms and conditions
                        _buildTermsAndConditions(),
                        
                        const SizedBox(height: 24),
                        
                        // Pay button
                        _buildPayButton(),
                        
                        const SizedBox(height: 16),
                        
                        // Security note
                        _buildSecurityNote(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  // ==================== JOB SUMMARY ====================
  
  Widget _buildJobSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt, color: Color(0xFFB87333), size: 20),
              SizedBox(width: 8),
              Text(
                'Job Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              // Job image placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFB87333).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work,
                  color: Color(0xFFB87333),
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Completed on ${MockData.formatDate(DateTime.now())}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          const Divider(),
          
          const SizedBox(height: 12),
          
          // Client and Fundi info
          Row(
            children: [
              Expanded(
                child: _buildPartyInfo(
                  'Client',
                  widget.client.name,
                  widget.client.profileImage,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFB87333).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward, size: 12, color: Color(0xFFB87333)),
                    SizedBox(width: 4),
                    Text(
                      'Payment to',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFB87333),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildPartyInfo(
                  'Fundi',
                  widget.fundi.name,
                  widget.fundi.profileImage,
                  alignRight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPartyInfo(String role, String name, String? imageUrl, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          role,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!alignRight) ...[
              CircleAvatar(
                radius: 14,
                backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                child: imageUrl == null ? const Icon(Icons.person, size: 12) : null,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C2C2C),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (alignRight) ...[
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 14,
                backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                child: imageUrl == null ? const Icon(Icons.person, size: 12) : null,
              ),
            ],
          ],
        ),
      ],
    );
  }
  
  // ==================== PAYMENT BREAKDOWN ====================
  
  Widget _buildPaymentBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.calculate, color: Color(0xFFB87333), size: 20),
              SizedBox(width: 8),
              Text(
                'Payment Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildBreakdownRow(
            'Job Amount',
            MockData.formatCurrency(_totalAmount),
          ),
          const SizedBox(height: 12),
          
          _buildBreakdownRow(
            'Platform Fee (10%)',
            '-${MockData.formatCurrency(_platformFee)}',
            valueColor: Colors.red,
          ),
          const SizedBox(height: 12),
          
          const Divider(),
          const SizedBox(height: 12),
          
          _buildBreakdownRow(
            'Fundi Receives',
            MockData.formatCurrency(_fundiAmount),
            isTotal: true,
            valueColor: Colors.green,
          ),
          
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFB87333).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: const Color(0xFFB87333),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '10% platform fee helps us maintain quality service and support.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBreakdownRow(
    String label,
    String value, {
    bool isTotal = false,
    Color valueColor = const Color(0xFF2C2C2C),
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFF2C2C2C) : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
  
  // ==================== PAYMENT METHODS ====================
  
  Widget _buildPaymentMethods() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payment, color: Color(0xFFB87333), size: 20),
              SizedBox(width: 8),
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildPaymentMethodCard(
                  index: 0,
                  icon: Icons.credit_card,
                  label: 'Card',
                  isSelected: _selectedPaymentMethod == 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPaymentMethodCard(
                  index: 1,
                  icon: Icons.phone_android,
                  label: 'M-PESA',
                  isSelected: _selectedPaymentMethod == 1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPaymentMethodCard(
                  index: 2,
                  icon: Icons.account_balance,
                  label: 'Bank',
                  isSelected: _selectedPaymentMethod == 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaymentMethodCard({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB87333).withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFB87333) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFB87333) : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFB87333) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // ==================== CARD PAYMENT FORM ====================
  
  Widget _buildCardPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C2C2C),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Card number
          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: '1234 5678 9012 3456',
              prefixIcon: const Icon(Icons.credit_card, color: Color(0xFFB87333)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB87333), width: 2),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Card holder name
          TextFormField(
            controller: _cardNameController,
            decoration: InputDecoration(
              labelText: 'Card Holder Name',
              hintText: 'John Doe',
              prefixIcon: const Icon(Icons.person, color: Color(0xFFB87333)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB87333), width: 2),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Expiry and CVV
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  decoration: InputDecoration(
                    labelText: 'Expiry',
                    hintText: 'MM/YY',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Security badges
          Row(
            children: [
              Icon(
                Icons.lock,
                size: 14,
                color: Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                'Secure SSL Encryption',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.verified,
                size: 14,
                color: Colors.blue,
              ),
              const SizedBox(width: 4),
              Text(
                'PCI Compliant',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // ==================== M-PESA PAYMENT FORM ====================
  
  Widget _buildMpesaPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // M-PESA logo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone_android,
              color: Colors.green,
              size: 40,
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'M-PESA Express',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Enter your M-PESA registered phone number',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Phone number
          TextFormField(
            controller: _mpesaPhoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '07XX XXX XXX',
              prefixIcon: const Icon(Icons.phone, color: Color(0xFFB87333)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB87333), width: 2),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Info message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You will receive an STK push prompt on your phone to complete the payment.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // ==================== BANK PAYMENT FORM ====================
  
  Widget _buildBankPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance,
              color: Colors.purple,
              size: 30,
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Bank Transfer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Bank details
          _buildBankDetailRow('Bank', 'Equity Bank'),
          _buildBankDetailRow('Account Name', 'Fundi Marketplace Ltd'),
          _buildBankDetailRow('Account Number', '1234567890'),
          _buildBankDetailRow('Branch', 'Nairobi'),
          _buildBankDetailRow('SWIFT Code', 'EQBLKENA'),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.amber.shade800,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bank transfers may take 1-2 business days to process.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBankDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }
  
  // ==================== TERMS AND CONDITIONS ====================
  
  Widget _buildTermsAndConditions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _termsAccepted,
            onChanged: (value) {
              setState(() {
                _termsAccepted = value ?? false;
              });
            },
            activeColor: const Color(0xFFB87333),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _termsAccepted = !_termsAccepted;
                });
              },
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2C2C2C),
                  ),
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: const TextStyle(
                        color: Color(0xFFB87333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Payment Terms',
                      style: const TextStyle(
                        color: Color(0xFFB87333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // ==================== PAY BUTTON ====================
  
  Widget _buildPayButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB87333), Color(0xFFCD7F32)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB87333).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (_termsAccepted && !_isProcessing) ? _processPayment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isProcessing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Processing...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'PAY ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    MockData.formatCurrency(_totalAmount),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  // ==================== SECURITY NOTE ====================
  
  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.security,
            size: 14,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 8),
          Text(
            'Secured by 256-bit SSL encryption',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== PAYMENT RECEIPT MODAL ====================

class _PaymentReceiptModal extends StatelessWidget {
  final Job job;
  final Fundi fundi;
  final Client client;
  final double totalAmount;
  final double platformFee;
  final double fundiAmount;

  const _PaymentReceiptModal({
    required this.job,
    required this.fundi,
    required this.client,
    required this.totalAmount,
    required this.platformFee,
    required this.fundiAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Success icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long,
              color: Colors.green,
              size: 40,
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Payment Receipt',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'Transaction completed successfully',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Receipt details
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildReceiptRow('Transaction ID', 'TXN${DateTime.now().millisecondsSinceEpoch}'),
                _buildReceiptRow('Date', MockData.formatDate(DateTime.now())),
                _buildReceiptRow('Job', job.title),
                _buildReceiptRow('Client', client.name),
                _buildReceiptRow('Fundi', fundi.name),
                const Divider(height: 24),
                _buildReceiptRow('Subtotal', MockData.formatCurrency(totalAmount)),
                _buildReceiptRow('Platform Fee (10%)', MockData.formatCurrency(platformFee)),
                const Divider(height: 24),
                _buildReceiptRow('Total Paid', MockData.formatCurrency(totalAmount), isBold: true),
                _buildReceiptRow('Fundi Earnings', MockData.formatCurrency(fundiAmount)),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Download button
          OutlineButton(
            text: 'DOWNLOAD RECEIPT',
            onPressed: () {},
            icon: Icons.download,
            width: double.infinity,
          ),
          
          const SizedBox(height: 12),
          
          // Close button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF2C2C2C) : Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? const Color(0xFF2C2C2C) : const Color(0xFFB87333),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension for easy navigation
extension PaymentPageExtensions on BuildContext {
  void goToPaymentPage({
    required Job job,
    required Fundi fundi,
    required Client client,
  }) {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          job: job,
          fundi: fundi,
          client: client,
        ),
      ),
    );
  }
}