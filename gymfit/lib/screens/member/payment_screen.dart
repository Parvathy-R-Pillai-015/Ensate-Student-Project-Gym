import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';
import 'package:gymfit/models/membership.dart';

class PaymentScreen extends StatefulWidget {
  final MembershipPlan plan;

  const PaymentScreen({super.key, required this.plan});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'online';
  String? _selectedOnlineMethod;
  String? _selectedOfflineMethod;
  bool _isProcessing = false;

  // Form controllers for card payment
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Order Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeConfig.primaryColor,
                          ThemeConfig.primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.receipt_long,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.plan.name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.plan.durationType,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '\$${widget.plan.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Payment Method Selection
                        const Text(
                          'Select Payment Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Online/Offline Toggle
                        Row(
                          children: [
                            Expanded(
                              child: _buildPaymentTypeCard(
                                'Online Payment',
                                Icons.credit_card,
                                'online',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildPaymentTypeCard(
                                'Offline Payment',
                                Icons.store,
                                'offline',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Online Payment Methods
                        if (_paymentMethod == 'online') ...[
                          _buildOnlinePaymentMethods(),
                        ],

                        // Offline Payment Methods
                        if (_paymentMethod == 'offline') ...[
                          _buildOfflinePaymentMethods(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Pay Now Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _paymentMethod == 'online'
                              ? 'Pay \$${widget.plan.price.toStringAsFixed(2)}'
                              : 'Confirm Order',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTypeCard(String title, IconData icon, String type) {
    final isSelected = _paymentMethod == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentMethod = type;
          _selectedOnlineMethod = null;
          _selectedOfflineMethod = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeConfig.primaryColor.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? ThemeConfig.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? ThemeConfig.primaryColor : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? ThemeConfig.primaryColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlinePaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // Credit/Debit Card
        _buildPaymentMethodTile(
          'Credit / Debit Card',
          Icons.credit_card,
          'card',
          'Visa, Mastercard, Amex',
        ),

        // PayPal
        _buildPaymentMethodTile(
          'PayPal',
          Icons.account_balance_wallet,
          'paypal',
          'Pay with your PayPal account',
        ),

        // Google Pay
        _buildPaymentMethodTile(
          'Google Pay',
          Icons.g_mobiledata,
          'gpay',
          'Quick and secure payment',
        ),

        // Apple Pay
        _buildPaymentMethodTile(
          'Apple Pay',
          Icons.apple,
          'applepay',
          'Pay with Apple Pay',
        ),

        const SizedBox(height: 24),

        // Card Details Form (if card is selected)
        if (_selectedOnlineMethod == 'card') _buildCardForm(),
      ],
    );
  }

  Widget _buildOfflinePaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // Cash at Gym
        _buildPaymentMethodTile(
          'Cash at Gym',
          Icons.payments,
          'cash',
          'Pay at the gym reception',
          isOffline: true,
        ),

        // Bank Transfer
        _buildPaymentMethodTile(
          'Bank Transfer',
          Icons.account_balance,
          'bank',
          'Transfer to gym bank account',
          isOffline: true,
        ),

        // Cheque
        _buildPaymentMethodTile(
          'Cheque Payment',
          Icons.receipt,
          'cheque',
          'Pay by cheque at reception',
          isOffline: true,
        ),

        const SizedBox(height: 24),

        // Offline Payment Instructions
        if (_selectedOfflineMethod != null) _buildOfflineInstructions(),
      ],
    );
  }

  Widget _buildPaymentMethodTile(
    String title,
    IconData icon,
    String method,
    String subtitle, {
    bool isOffline = false,
  }) {
    final isSelected = isOffline
        ? _selectedOfflineMethod == method
        : _selectedOnlineMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isOffline) {
            _selectedOfflineMethod = method;
          } else {
            _selectedOnlineMethod = method;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeConfig.primaryColor.withOpacity(0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected ? ThemeConfig.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? ThemeConfig.primaryColor.withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? ThemeConfig.primaryColor : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? ThemeConfig.primaryColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: method,
              groupValue: isOffline ? _selectedOfflineMethod : _selectedOnlineMethod,
              onChanged: (value) {
                setState(() {
                  if (isOffline) {
                    _selectedOfflineMethod = value;
                  } else {
                    _selectedOnlineMethod = value;
                  }
                });
              },
              activeColor: ThemeConfig.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Card Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardHolderController,
              decoration: const InputDecoration(
                labelText: 'Card Holder Name',
                hintText: 'John Doe',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineInstructions() {
    String title = '';
    String instructions = '';
    IconData icon = Icons.info;

    switch (_selectedOfflineMethod) {
      case 'cash':
        title = 'Cash Payment Instructions';
        icon = Icons.store;
        instructions = '''
1. Visit the gym reception desk
2. Inform the staff about your membership plan: ${widget.plan.name}
3. Make the payment of \$${widget.plan.price.toStringAsFixed(2)}
4. Collect your membership card and receipt
5. Your membership will be activated immediately

Reception Hours: Monday - Friday: 6 AM - 10 PM
                Saturday - Sunday: 7 AM - 8 PM
''';
        break;
      case 'bank':
        title = 'Bank Transfer Instructions';
        icon = Icons.account_balance;
        instructions = '''
Please transfer \$${widget.plan.price.toStringAsFixed(2)} to:

Bank Name: GymFit Bank
Account Name: GymFit Fitness Center
Account Number: 1234567890
SWIFT Code: GYMFIT123
Reference: Your Email (${_cardHolderController.text.isEmpty ? "your-email@example.com" : _cardHolderController.text})

After transfer:
1. Send payment confirmation to: payments@gymfit.com
2. Include your full name and phone number
3. Membership will be activated within 24 hours
''';
        break;
      case 'cheque':
        title = 'Cheque Payment Instructions';
        icon = Icons.receipt;
        instructions = '''
1. Make cheque payable to: "GymFit Fitness Center"
2. Amount: \$${widget.plan.price.toStringAsFixed(2)}
3. Submit cheque at gym reception
4. Include your contact details
5. Membership activates after cheque clearance (3-5 business days)

Cheque Details Required:
- Date
- Signature
- Contact number on back
''';
        break;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: ThemeConfig.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                instructions,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    // Validation for online card payment
    if (_paymentMethod == 'online' && _selectedOnlineMethod == 'card') {
      if (_cardNumberController.text.isEmpty ||
          _cardHolderController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all card details'),
            backgroundColor: ThemeConfig.errorColor,
          ),
        );
        return;
      }
    }

    // Validation for method selection
    if (_paymentMethod == 'online' && _selectedOnlineMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an online payment method'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
      return;
    }

    if (_paymentMethod == 'offline' && _selectedOfflineMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an offline payment method'),
          backgroundColor: ThemeConfig.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeConfig.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: ThemeConfig.successColor,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _paymentMethod == 'online'
                  ? 'Payment Successful!'
                  : 'Order Confirmed!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _paymentMethod == 'online'
                  ? 'Your ${widget.plan.name} membership has been activated.'
                  : 'Your order has been confirmed. Please complete the payment as per instructions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to plans
                  Navigator.pop(context); // Go back to home
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
